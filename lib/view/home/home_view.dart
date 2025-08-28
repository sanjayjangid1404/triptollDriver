import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as ls;
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/location_helper.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common/socket_manager.dart';
import 'package:taxi_driver/common_widget/Icon_title_subtitle_button.dart';
import 'package:taxi_driver/model/running_order_response.dart';
import 'package:taxi_driver/view/home/run_ride_view.dart';
import 'package:taxi_driver/view/home/tip_request_view.dart';
import 'package:taxi_driver/view/menu/menu_view.dart';

import '../../controller/authController.dart';
import '../../main.dart';
import '../../model/booking_notification_response.dart';
import '../login/document_upload_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>with TickerProviderStateMixin {
  bool isOpen = true;

  bool isDriverOnline = false;
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  late Razorpay _razorpay;
  late Razorpay _razorpay2;
  bool isSheetOpen = false;
   AnimationController? controller;



  Future<void> _getCurrentLocation() async {
    // Check location permission
    final status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Move camera to current position
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }
  }



  Stream<BookingNotificationResponse?> bookingStream() {
    return Stream.periodic(const Duration(seconds: 5)).asyncMap((_) async {
      try {
        print({
          "driver_id":Get.find<AuthController>().getUserID()
        });
        final response = await http.post(
          Uri.parse("https://triptoll.in/app-admin/api/Booking/findNewBookings"),
          body: jsonEncode({
            "driver_id":Get.find<AuthController>().getUserID()
          })
        );

        print("respnse=>${response.body}");


        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          if (json["status"] == true && json["bookings"] != null) {
            return BookingNotificationResponse.fromJson(json["bookings"][0]);
          }
        }
      } catch (e) {
        print("Error: $e");
      }
      return null; // no new booking
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  //  apiHome();
    print("calling");


    WidgetsBinding.instance.addPostFrameCallback((_) {


      controller = AnimationController(vsync: this);
      // configureBackgroundGeolocation();
      Get.find<AuthController>().incomeDriver();
      Get.find<AuthController>().driverOnlineTIme();
      Get.find<AuthController>().driverOnlineTotalTIme();
      Get.find<AuthController>().getDriverFAQ();

      Get.find<AuthController>().driverInfo(context);
     // Get.find<AuthController>().getBookingNotification();
      _getCurrentLocation();
      _razorpay = Razorpay();
      _razorpay2 = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay2.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess2);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay2.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError2);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      _razorpay2.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet2);


      setState(() {

      });

    });
    isDriverOnline = Globs.udValueBool("is_online");

    // if (ServiceCall.userType == 2) {
    //   LocationHelper.shared().startInit();
    //
    //   // Received Message In Socket On Event
    //   SocketManager.shared.socket?.on("new_ride_request", (data) async {
    //     print("new_ride_request socket get :${data.toString()} ");
    //     if (data[KKey.status] == "1") {
    //       var bArr = data[KKey.payload] as List? ?? [];
    //
    //
    //       if(mounted && bArr.isNotEmpty){
    //        await  context.push( TipRequestView(bObj: bArr[0]) );
    //        // apiHome();
    //       }
    //     }
    //   });
    //
    // }
  }



  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    // Payment success logic
    //Get.snackbar('Success', 'Payment ID: ${response.paymentId}');
    print("✅ Payment Successful!");
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    print("Signature: ${response.signature}");

    var body = {
      "driver_id":Get.find<AuthController>().getUserID().toString(),
      "amount":Get.find<AuthController>().getRegistrationFee().toString(),
      "transaction_id":response.paymentId.toString(),
      "payment_status":"success",
      "type":"registration",
    };

    Get.find<AuthController>().updateDriverPaymentStatus(body);

    // Navigate to success screen or process booking
    // Get.to(ReviewBooking(data: bookingData));
  }

  void _handlePaymentSuccess2(PaymentSuccessResponse response) {

    // Payment success logic
    //Get.snackbar('Success', 'Payment ID: ${response.paymentId}');
    print("✅ Payment Successful!");
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    print("Signature: ${response.signature}");

    var body = {
      "driver_id":Get.find<AuthController>().getUserID().toString(),
      "amount":Get.find<AuthController>().walletAmount.toString(),
      "transaction_id":response.paymentId.toString(),
      "payment_status":"success",
      "type":"wallet",
    };

    Get.find<AuthController>().updateDriverPaymentStatus(body);

    // Navigate to success screen or process booking
    // Get.to(ReviewBooking(data: bookingData));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failure logic
      Get.snackbar('Error', 'Payment Fail');

  }void _handlePaymentError2(PaymentFailureResponse response) {
    // Payment failure logic
      Get.snackbar('Error', 'Payment Fail');

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet logic
    Get.snackbar('External Wallet', '${response.walletName}');
  }void _handleExternalWallet2(ExternalWalletResponse response) {
    // External wallet logic
    Get.snackbar('External Wallet', '${response.walletName}');
  }

  String generateOrderId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var random = Random();
    String randomString = List.generate(14, (index) => chars[random.nextInt(chars.length)]).join();

    return "order_$randomString";
  }

  void _openRazorpayPayment(String id,amount) {
    String customOrderId = generateOrderId();
    print(customOrderId);
    print(Get.find<AuthController>().getRegistrationFee()??"0");
    var options = {
      'key': 'rzp_live_RAJBCQWCkgqpEb',
      'amount': (double.parse((Get.find<AuthController>().getRegistrationFee()??"0").toString()) * 100).round(), // Convert to paise
      'name': 'Triptoll',
      'description': 'Booking Payment',
     'order_id': id, // custom 8 digit order id
      'prefill': {
        'contact': '${Get.find<AuthController>().getUserPhone().toString()}',
        'email': 'tritoll@gmail.com'
      },
      'theme': {
        'color': '#FF6B6B' // Your app theme color
      }
    };
    print(options);

    try {
      _razorpay.open(options);

    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _openRazorpayWallet(String id,amount) {
    String customOrderId = generateOrderId();
    print(customOrderId);
    print(Get.find<AuthController>().getRegistrationFee()??"0");
    var options = {
      'key': 'rzp_live_RAJBCQWCkgqpEb',
      'amount': (double.parse((calculateRequiredPayment(Get.find<AuthController>().walletAmount)??"0").toString()) * 100).round(), // Convert to paise
      'name': 'Triptoll',
      'description': 'Booking Payment',
      'order_id': id, // custom 8 digit order id
      'prefill': {
        'contact': '${Get.find<AuthController>().getUserPhone().toString()}',
        'email': 'tritoll@gmail.com'
      },
      'theme': {
        'color': '#FF6B6B' // Your app theme color
      }
    };

    try {
      _razorpay2.open(options);

    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<String?> createRazorpayOrderId({required int amount}) async {
    const String keyId = 'rzp_live_RAJBCQWCkgqpEb';      // 🔑 Your Key ID
    const String keySecret = 'DfWgvxPob2CSxM147onlshnF';  // 🔒 Your Key Secret (⚠️ sensitive!)

    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));

    final url = Uri.parse('https://api.razorpay.com/v1/orders');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth,
      },
      body: jsonEncode({
        "amount": amount,     // amount in paise (₹500 = 50000)
        "currency": "INR",
        "receipt": "receipt_${DateTime.now().millisecondsSinceEpoch}"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("data=>$data");

      if(data["id"]!=null){
        _openRazorpayPayment(data['id'].toString(),amount);
      }
      return data['id']; // <-- This is the order_id
    } else {
      print("Failed to create order: ${response.statusCode} ${response.body}");
      return null;
    }
  }

  Future<String?> createWalletOrderID({required int amount}) async {
    const String keyId = 'rzp_live_RAJBCQWCkgqpEb';      // 🔑 Your Key ID
    const String keySecret = 'DfWgvxPob2CSxM147onlshnF';  // 🔒 Your Key Secret (⚠️ sensitive!)

    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));

    final url = Uri.parse('https://api.razorpay.com/v1/orders');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth,
      },
      body: jsonEncode({
        "amount": amount,     // amount in paise (₹500 = 50000)
        "currency": "INR",
        "receipt": "receipt_${DateTime.now().millisecondsSinceEpoch}"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print(data);

      if(data["id"]!=null){
        _openRazorpayWallet(data['id'].toString(),amount);
      }
      return data['id']; // <-- This is the order_id
    } else {
      print("Failed to create order: ${response.statusCode} ${response.body}");
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (AuthController authController) {
        print((int.parse(authController.walletAmount.toString())<= -99) );


        // if(authController.runningOrderResponse!=null && authController.runningOrderResponse!.data!=null){
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     showRunningDetailsSheet(
        //         authController.runningOrderResponse!.data!,
        //         authController
        //     );
        //   });
        // }
        // else if (authController.notificationResponse.isNotEmpty &&
        //     authController.notificationResponse[0].bookingFound! &&
        //     authController.notificationResponse[0].status.toString() == "pending" &&
        //     !authController.hasShownSheet) {  // Add this condition
        //
        //   authController.hasShownSheet = true;
        //   authController.update(); // Update the controller state
        //
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     showRideDetailsSheet(
        //         authController.notificationResponse[0],
        //         authController
        //     );
        //   });
        // }

        return
       PopScope(
         canPop: false,

         child: Scaffold(
          body: Stack(
            children: [
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _currentPosition == null
                  ?Text("No Location Get"):
              GoogleMap(
                onMapCreated: (controller) => mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,

                zoomControlsEnabled: true,
                markers: {
                  if (_currentPosition != null)
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: _currentPosition!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                },
              ),



              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  authController.driverInResponse!=null && authController.isPayment() && authController.isKyc()  && (int.parse(authController.walletAmount.toString())>= -99) ?   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FullWidthDriverStatusSwitch(authController: authController),
                  ):SizedBox(),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isOpen = !isOpen;
                                });
                              },
                              icon: Image.asset(
                                isOpen
                                    ? "assets/img/open_btn.png"
                                    : "assets/img/close_btn.png",
                                width: 15,
                                height: 15,
                              ),
                            ),
                            Text(
                              authController.driverInResponse!=null && authController.driverInResponse!.loginStatus.toString() == "online" ? "You're online" : "You're offline",
                              style: TextStyle(
                                  color:authController.driverInResponse!=null && authController.driverInResponse!.loginStatus.toString() == "online" ?  TColor.primary:TColor.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        if (isOpen)
                          Container(
                            height: 0.5,
                            width: double.maxFinite,
                            color: TColor.placeholder.withOpacity(0.5),
                          ),
                        if (isOpen)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: IconTitleSubtitleButton(
                                    title: authController.totalLoginTIme+" H",
                                    subtitle: "Total Online",
                                    icon: "assets/img/acceptance.png",
                                    onPressed: () {}),
                              ),
                              Container(
                                height: 100,
                                width: 0.5,
                                color: TColor.placeholder.withOpacity(0.5),
                              ),
                              Expanded(
                                child: IconTitleSubtitleButton(
                                    title: "${authController.driverInResponse!=null ? double.parse(authController.driverInResponse!.totalRating??"0").toStringAsFixed(2):"0"}",
                                    subtitle: "Rating",
                                    icon: "assets/img/rate.png",
                                    onPressed: () {}),
                              ),
                              Container(
                                height: 100,
                                width: 0.5,
                                color: TColor.placeholder.withOpacity(0.5),
                              ),
                              Expanded(
                                child: IconTitleSubtitleButton(
                                    title: authController.todayLoginTIme+" H",
                                    subtitle: "Today Online",
                                    icon: "assets/img/cancelleation.png",
                                    onPressed: () {}),
                              ),
                            ],
                          ),
                      ],
                    ),
                  )
                ],
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 60,
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 25),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                    ),
                                  ]),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "${AppContants.rupessSystem}"+authController.walletAmount,
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              )),
                          SizedBox(
                            width: 60,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context.push(const MenuView());
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child:authController.driverInResponse!=null && authController.driverInResponse!.file_name!=null && authController.driverInResponse!.file_name!.isNotEmpty ? 
                                      Image.network("${AppContants.imageURL}uploaded_files/user_img/${authController.driverInResponse!.file_name!}", width: 40,
                                        height: 40,fit: BoxFit.cover,):
                                      Image.asset(
                                        "assets/img/u1.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 8, vertical: 1),
                                //   decoration: BoxDecoration(
                                //     color: Colors.red,
                                //     borderRadius: BorderRadius.circular(30),
                                //   ),
                                //   constraints: const BoxConstraints(minWidth: 15),
                                //   child: const Text(
                                //     "3",
                                //     style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 10,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        _shareReferral();
                      },
                      child: Container(

                        margin: EdgeInsets.symmetric(horizontal: 15),

                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(15),


                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset("assets/img/refergif.gif"),
                        )

                        /*Row(
                          children: [
                            Expanded(
                              child: ls.Lottie.asset(
                                'assets/lottie/success.json',
                                controller: controller,
                                onLoaded: (comp) {
                                  // कुल ड्यूरेशन सेट करके एक बार चलाएँ (या repeat भी कर सकते हैं)
                                  controller!
                                    ..duration = comp.duration
                                    ..forward(); // एक बार प्ले
                                   controller!.repeat();  // अगर लगातार चलाना हो
                                },
                                // साइज कंट्रोल
                                width: 80,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text("Refer And\nEarn",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.w800),textAlign: TextAlign.center,)
                          ],
                        ),*/
                      ),
                    ),

                  //  Text(authController.todayLoginTIme+" Hour Today Login Time",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.bold),)
                  ],
                ),
              ),

              authController.isPayment() ? authController.isKyc() ?(int.parse(authController.walletAmount.toString())>= -99)?   SizedBox():
              AlertDialog(
                title: Text('Pay Wallet Amount'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallet Fee: ${AppContants.rupessSystem} ${authController.walletAmount}'),
                    SizedBox(height: 10),
                    Text('Please proceed to payment to complete your Wallet fee.'),
                  ],
                ),
                actions: <Widget>[

                  ElevatedButton(
                    child: Text('Pay Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                    ),
                    onPressed: () {

                      createWalletOrderID(amount: (double.parse((calculateRequiredPayment(Get.find<AuthController>().walletAmount)??"0").toString()) * 100).round());
                      // Handle payment logic here
                     // _openRazorpayWallet();

                    },
                  ),
                ],
              ): AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 10),
                    Text('KYC Pending'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Triptoll में आपका स्वागत है! ऑर्डर प्राप्त करने के लिए कृपया अपनी KYC डॉक्यूमेंट्स अपलोड करें। KYC पूरी होने के बाद ही आप ऑर्डर ले पाएंगे।'),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(text: 'किसी भी सहायता के लिए हमसे संपर्क करें: '),
                          TextSpan(
                            text: '📞 8818003344',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => AppContants.makePhoneCall('8818003344'),
                          ),
                          TextSpan(text: ' | '),
                          TextSpan(
                            text: '011-69269598',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => AppContants.makePhoneCall('01169269598'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: (){
                        context.push(
                            DocumentUploadView(title: "Personal Document",id: authController.getUserID()??"",isEdit: true,));
                      },
                      child: Container(
                        height: 30,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),color: TColor.primary
                        ),
                        child: Text("Complete Now",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    )

                  ],
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ):
              AlertDialog(
                title: Text('Pay Registration Fee'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Registration Fee: ${AppContants.rupessSystem} ${authController.getRegistrationFee()}'),
                    SizedBox(height: 10),
                    Text('Please proceed to payment to complete your registration.'),
                  ],
                ),
                actions: <Widget>[

                  ElevatedButton(
                    child: Text('Pay Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                    ),
                    onPressed: () {


                      // Handle payment logic here
                      createRazorpayOrderId(amount: (double.parse((Get.find<AuthController>().getRegistrationFee()??"0").toString()) * 100).round());


                    },
                  ),
                ],
              ),

              authController.isPayment() && authController.isKyc()  && (int.parse(authController.walletAmount.toString())>= -99) ?   StreamBuilder<BookingNotificationResponse?>(
                stream: bookingStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      !isSheetOpen) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      isSheetOpen = true;
                      showRideDetailsSheet(snapshot.data!).then((_) {
                        // reset so agle booking pe dobara open ho jaye
                        isSheetOpen = false;
                      });
                    });
                  }
                  return const SizedBox.shrink();
                },
              ):SizedBox(),
            ],
          ),
               ),
       );},
    );
  }

  int calculateRequiredPayment(String? walletAmountStr) {
    // null या invalid string handle करने के लिए
    int walletAmount = int.tryParse(walletAmountStr ?? "0") ?? 0;

    // अगर negative balance है तो उसका absolute value payment करना होगा
    if (walletAmount < 0) {
      return walletAmount.abs();
    } else {
      return 0; // positive या zero balance पर payment की जरूरत नहीं
    }
  }

  Future<void> showRideDetailsSheet(BookingNotificationResponse notificationResponse) async{
   return  showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true, // Allows the sheet to take up more space
      backgroundColor: Colors.transparent, // Makes the rounded corners visible
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 20), // Space for the drag handle
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          shouldCloseOnMinExtent: false,
          initialChildSize: 0.5, // Initial height (40% of screen)
          minChildSize: 0.3, // Minimum height when dragged down
          maxChildSize: 0.7, // Maximum height when dragged up
          builder: (context, scrollController) {
            return  WillPopScope(
              onWillPop: () async {
                // ❌ back button से बंद नहीं होने देना
                return false;
              },
              child: SingleChildScrollView(
                controller: scrollController,
                child: _buildRideDetailsContent(notificationResponse),
              ),
            );
          },
        ),
      ),
    );
  }

  String referralCode = "12345678";

  _shareReferral() async {
    // Play Store link with referral parameter
    const String packageName = 'service.triptoll.in'; // Apna package name daalein
    final String shareLink = 'https://play.google.com/store/apps/details?id=$packageName&referrer=$referralCode';

    final String shareText = 'Check out this amazing app! Use my referral code: $referralCode\n\n$shareLink';

    // Copy to clipboard


    // Share using device's share dialog
    await Share.share(shareText);
  }
  Widget _buildRideDetailsContent(BookingNotificationResponse bookingResponse) {
    return Column(
      children: [
        // Drag handle indicator
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 15),

        // Your original content with some padding adjustments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${AppContants.rupessSystem} ${bookingResponse.totalAmount ?? ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${calculateDistance(double.parse(bookingResponse.pickupLat??"0"),double.parse(bookingResponse.pickupLong??"0"),double.parse(bookingResponse.dropLat??"0"),double.parse(bookingResponse.dropLong??"0")).toStringAsFixed(2)}  KM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: TColor.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${bookingResponse.pickupAddress ?? ""}",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: TColor.primary),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${bookingResponse.dropAddress ?? ""}",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      stopRingtone();
                      // Navigator.pop(context); // Close the bottom sheet
                     Get.find<AuthController>().bookingStatusChange(
                          status: "cancel",
                          amount: bookingResponse.totalAmount,
                          orderID: bookingResponse.orderId,
                          cus_id:bookingResponse.cusId,
                          value: 0
                      );
                    },
                    child: Container(

                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: TColor.red,
                        shape: BoxShape.circle,

                      ),
                      child: Icon(Icons.close,color: Colors.white,),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet
                        Get.find<AuthController>(). accpetBooking(

                            orderID: bookingResponse.id,
                            cus_id:bookingResponse.cusId,
                            value: 0
                        );
                      },
                      child: Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "TAP TO ACCEPT",
                                  style: TextStyle(
                                    color: TColor.primaryTextW,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "15",
                                style: TextStyle(
                                  color: TColor.primaryTextW,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }


  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth's radius in kilometers

    // Convert degrees to radians
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    // Apply Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c; // Distance in kilometers

    return distance;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }
  // In your parent widget where you want to show the bottom sheet

  void showRunningDetailsSheet(Orders notificationResponse,AuthController authController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      backgroundColor: Colors.transparent, // Makes the rounded corners visible
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 20), // Space for the drag handle
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3, // Initial height (40% of screen)
          minChildSize: 0.3, // Minimum height when dragged down
          maxChildSize: 0.7, // Maximum height when dragged up
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: _buildRunningDetailsContent(notificationResponse,authController),
            );
          },
        ),
      ),
    );
  }



// The content of your bottom sheet (your original Column widget with slight modifications)

  Widget _buildRunningDetailsContent(Orders bookingResponse,AuthController authController) {
    return Column(
      children: [
        // Drag handle indicator
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 15),

        // Your original content with some padding adjustments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${AppContants.rupessSystem} ${bookingResponse.totalAmount ?? ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${calculateDistance(double.parse(bookingResponse.pickupLat??"0"),double.parse(bookingResponse.pickupLong??"0"),double.parse(bookingResponse.dropLat??"0"),double.parse(bookingResponse.dropLong??"0")).toStringAsFixed(2)}  KM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/img/rate_tip.png",
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "5",
                            style: TextStyle(
                              color: TColor.secondaryText,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                  Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: TColor.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "${bookingResponse.pickupAddress ?? ""}",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: TColor.primary),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${bookingResponse.dropAddress ?? ""}",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                      authController.bookingStatusChange(
                        status: "cancel",
                        amount: bookingResponse.totalAmount,
                        orderID: bookingResponse.orderId,
                        cus_id:bookingResponse.cusId,
                      );
                    },
                    child: Container(

                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: TColor.red,
                        shape: BoxShape.circle,

                      ),
                      child: Icon(Icons.directions_outlined,color: Colors.white,),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet

                        if(bookingResponse.startTrip.toString().toLowerCase() == "yes" ){

                        }
                        authController.bookingStatusChange(
                          status: "accept",
                          amount: bookingResponse.totalAmount,
                          orderID: bookingResponse.orderId,
                          cus_id:bookingResponse.cusId,
                        );
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bookingResponse.startTrip.toString().toLowerCase() == "yes"  ? "Delivered":"Pick Up",
                                  style: TextStyle(
                                    color: TColor.primaryTextW,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }

  //MARK: ApiCalling
  void apiGoOnline() {
    Globs.showHUD();
    ServiceCall.post(
        {"is_online": isDriverOnline ? "1" : "0"}, SVKey.svDriverGoOnline,
        isTokenApi: true, withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        Globs.udBoolSet(isDriverOnline, "is_online");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(responseObj[KKey.message] as String? ?? MSG.success)));

        if (mounted) {
          setState(() {});
        }
      } else {
         isDriverOnline = !isDriverOnline;
        mdShowAlert(
            "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (error) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, error.toString(), () {});
    });
  }

  // void apiHome() {
  //   Globs.showHUD();
  //   ServiceCall.post(
  //       {}, SVKey.svHome,
  //       isTokenApi: true, withSuccess: (responseObj) async {
  //     Globs.hideHUD();
  //
  //     if (responseObj[KKey.status] == "1") {
  //         var rObj = (responseObj[KKey.payload] as Map? ?? {})["running"] as Map? ?? {};
  //
  //         if(rObj.keys.isNotEmpty) {
  //           context.push(RunRideView(rObj: rObj));
  //         }
  //
  //
  //     } else {
  //       mdShowAlert(
  //           "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
  //     }
  //   }, failure: (error) async {
  //     Globs.hideHUD();
  //     mdShowAlert(Globs.appName, error.toString(), () {});
  //   });
  // }
}
class FullWidthDriverStatusSwitch extends StatefulWidget {
  final AuthController authController;

  const FullWidthDriverStatusSwitch({super.key, required this.authController});

  @override
  State<FullWidthDriverStatusSwitch> createState() => _FullWidthDriverStatusSwitchState();
}

class _FullWidthDriverStatusSwitchState extends State<FullWidthDriverStatusSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isOnline = false;
  double _thumbPosition = 0.0;
  double _maxSlideDistance = 0.0;

  double _dragStartX = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _isOnline = widget.authController.driverInResponse?.loginStatus.toString() == "online";
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.value = _isOnline ? 1.0 : 0.0;
    _thumbPosition = _isOnline ? _maxSlideDistance : 0.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleStatus(bool newStatus) {
    setState(() {
      _isOnline = newStatus;
      if (newStatus) {
        _animationController.forward();
        _thumbPosition = _maxSlideDistance;
      } else {
        _animationController.reverse();
        _thumbPosition = 0.0;
      }
      widget.authController.changeLoginStatus(
        status: newStatus ? "online" : "offline",
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxSlideDistance = constraints.maxWidth - 160; // 60 is thumb width

        return GestureDetector(

          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (details) {
            _dragStartX = details.globalPosition.dx;
            _isDragging = false;
          },
          onHorizontalDragUpdate: (details) {
            // अगर movement threshold cross हो जाए तभी drag माने
            if ((details.globalPosition.dx - _dragStartX).abs() > 5) {
              _isDragging = true;
              setState(() {
                _thumbPosition = (_thumbPosition + details.primaryDelta!)
                    .clamp(0.0, _maxSlideDistance);
                _animationController.value =
                    _thumbPosition / _maxSlideDistance;
              });
            }
          },
          onHorizontalDragEnd: (details) {
            if (!_isDragging) {
              // Tap ignore
              return;
            }

            if (_isOnline) {
              // Online से Offline सिर्फ तब जब पूरी तरह बाएं पहुँचे
              if (_thumbPosition <= 0) {
                _toggleStatus(false);
              } else {
                _animationController.animateTo(1.0,
                    duration: Duration(milliseconds: 200));
                setState(() => _thumbPosition = _maxSlideDistance);
              }
            } else {
              // Offline से Online सिर्फ तब जब पूरी तरह दाएं पहुँचे
              if (_thumbPosition >= _maxSlideDistance) {
                _toggleStatus(true);
              } else {
                _animationController.animateTo(0.0,
                    duration: Duration(milliseconds: 200));
                setState(() => _thumbPosition = 0.0);
              }
            }
          },
          child: Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: _isOnline ? TColor.primary : TColor.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Label
                Center(
                  child: Text(
                    "Swipe To ${_isOnline ? "Offline" : "Online"}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Thumb
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      left: _animationController.value * _maxSlideDistance,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isOnline ? "ON" : "OFF",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isOnline ? TColor.primary : TColor.red,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
