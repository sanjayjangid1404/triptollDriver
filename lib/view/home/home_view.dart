import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/Icon_title_subtitle_button.dart';
import 'package:taxi_driver/model/running_order_response.dart';
import 'package:taxi_driver/view/home/unloading_timer.dart';
import 'package:taxi_driver/view/menu/menu_view.dart';
import '../../controller/authController.dart';
import '../../main.dart';
import '../../model/booking_notification_response.dart';
import '../login/document_upload_view.dart';
import 'driver_my_rides_view.dart';
import 'notification_screen.dart';
import 'order/schedule_delivery_list.dart';

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
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }
  }

  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? lang = sharedPreferences.getString("app_language");

    if (lang == null || lang == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      authController.selectedLanguage.value = "English";
    } else if (lang == "தமிழ்" || lang == "Tamil") {
      Get.updateLocale(const Locale('ta', 'IN'));
      authController.selectedLanguage.value = 'தமிழ்';
    }  else if (lang == "हिन्दी" ||lang == "Hindi") {
      Get.updateLocale(const Locale('hi', 'IN'));
      authController.selectedLanguage.value = "Hindi";
    }
    else if (lang == "తెలుగు" || lang == "Telugu") {
      Get.updateLocale(const Locale('te', 'IN'));
      authController.selectedLanguage.value = 'తెలుగు';
    } else if (lang == "বাংলা" || lang == "Bengali") {
      Get.updateLocale(const Locale('bn', 'IN'));
      authController.selectedLanguage.value = 'বাংলা';
    } else {
      Get.updateLocale(const Locale('en', 'US'));
      authController.selectedLanguage.value = "English";
    }
  }

  Stream<Data?> bookingStream() {
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

        print("respnse=>findNewBookings${response.body}");


        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          if (json["status"] == true && json["data"] != null) {
            return Data.fromJson(json["data"][0]);
          }
        }
      } catch (e) {
        print("Error: $e");
      }
      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    print("calling");


    WidgetsBinding.instance.addPostFrameCallback((_) {

      checkLanguage();
      if( Get.find<AuthController>().isShow.value == 0) {
        Get.snackbar(
          "Missed orders".tr,
          "Click here to check your missed orders.".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 10),
          onTap: (snack) {
            Get.to(() => DriverMyRidesView());
          },
        );
      }
      controller = AnimationController(vsync: this);
      Get.find<AuthController>().incomeDriver();
      Get.find<AuthController>().getScheduledOrderFun();
      Get.find<AuthController>().driverOnlineTIme();
      Get.find<AuthController>().driverOnlineTotalTIme();
      Get.find<AuthController>().getDriverFAQ();
      Get.find<AuthController>().driverInfo(context);
      Get.find<AuthController>().isShow.value = 1;
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
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (isDriverOnline) {
        setState(() {});
      }
    });
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


  Timer? _timer;
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
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
  }

  void _handlePaymentSuccess2(PaymentSuccessResponse response) {

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
    // Get.to(ReviewBooking(data: bookingData));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
     Get.snackbar('Error'.tr, 'Payment Fail'.tr);

  }void _handlePaymentError2(PaymentFailureResponse response) {
    Get.snackbar('Error'.tr, 'Payment Fail'.tr);

  }
  AuthController authController  = Get.find<AuthController>();
  void _handleExternalWallet(ExternalWalletResponse response) {
     Get.snackbar('External Wallet'.tr, '${response.walletName}');
  }void _handleExternalWallet2(ExternalWalletResponse response) {
    Get.snackbar('External Wallet'.tr, '${response.walletName}');
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
      'notes': {
        'driver_id': Get.find<AuthController>().getUserID().toString(),
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
        final allOrders =
            Get.find<AuthController>().getMyScheduleOrderModel.value.data;

        final pendingOrders = allOrders
            ?.where((e) => e.orderStatus?.toLowerCase() != "delivered")
            .toList();

        print((int.parse(authController.walletAmount.toString())<= -99) );
        return PopScope(
         canPop: false,
         child: Scaffold(
          body: Stack(
            children: [
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _currentPosition == null
                  ?Text("No Location Get"):
              Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) => mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
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
                  Positioned(
                    bottom: 260,
                    right: 10,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _currentPosition!,
                              zoom: 16,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.my_location, color: Colors.green),
                    ),
                  ),

                ],
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
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isOpen = !isOpen;
                                });
                              },
                              child: Image.asset(
                                isOpen
                                    ? "assets/img/open_btn.png"
                                    : "assets/img/close_btn.png",
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            authController.driverInResponse!=null && authController.driverInResponse?.driverDetails?.loginStatus.toString() != "online" ?
                             Icon(Icons.arrow_upward, color: Colors.red,)   : SizedBox.shrink(),
                            // authController.driverInResponse!=null && authController.driverInResponse!.loginStatus.toString() != "online" ?
                            SizedBox(
                              width: 40,
                            ),
                                // : SizedBox.shrink(),
                            Text(
                              authController.driverInResponse!=null && authController.driverInResponse != null && authController.driverInResponse?.driverDetails?.loginStatus.toString() == "online" ? "You're online".tr : "You're offline".tr,
                              style: TextStyle(
                                  color:authController.driverInResponse!=null && authController.driverInResponse?.driverDetails?.loginStatus.toString() == "online" ?  TColor.primary:TColor.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                            // authController.driverInResponse!=null && authController.driverInResponse!.loginStatus.toString() == "online" ?
                            SizedBox(
                              width: 40,
                            ),
                                // : SizedBox.shrink(),
                            authController.driverInResponse!=null && authController.driverInResponse?.driverDetails?.loginStatus.toString() == "online" ?
                            Icon(Icons.arrow_upward, color: Colors.green,)   : SizedBox.shrink(),
                            const SizedBox(
                              // width: 50,
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
                              // Expanded(
                              //   child: IconTitleSubtitleButton(
                              //       title: "${authController.driverInResponse!=null ? double.parse(authController.driverInResponse?.driverDetails?.totalRating ??"0").toStringAsFixed(2):"0"}",
                              //       subtitle: "Rating",
                              //       icon: "assets/img/rate.png",
                              //       onPressed: () {}),
                              // ),
                              // Container(
                              //   height: 100,
                              //   width: 0.5,
                              //   color: TColor.placeholder.withOpacity(0.5),
                              // ),
                              Expanded(
                                child: IconTitleSubtitleButton(
                                    // title: authController.todayLoginTIme+" H",
                                    title: authController.time.toString(),
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
                          InkWell(
                            onTap: (){
                              context.push(const NotificationScreen());
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.green)
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.notifications_active),
                            ),
                          ),
                          // const SizedBox(
                          //   width: 60,
                          // ),
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
                                        child:
                                            authController.driverInResponse !=
                                                        null &&
                                                    authController.driverInResponse?.driverDetails?.file_name != null &&
                                                    authController
                                                        .driverInResponse!.driverDetails!
                                                        .file_name!
                                                        .isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        "${AppContants.imageURL}uploaded_files/user_img/${authController.driverInResponse!.driverDetails!.file_name!}",
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) {
                                                      return Image.asset(
                                                        "assets/img/u1.png",
                                                        width: 40,
                                                        height: 40,
                                                      );
                                                    },
                                                  )
                                                : Image.asset(
                                                    "assets/img/u1.png",
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {});
                        referralCode = authController.getUserPhone()!;
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

              Positioned(
                top: 150,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() {
                      if(Get.find<AuthController>().refreshInt1.value > 0){}
                      final controller = Get.find<AuthController>();
                      final list = controller.getScheduledOrderModel.value.data;

                      if (list == null || list.isEmpty) {
                        return const SizedBox();
                      }

                      if (!controller.isScheduledBannerVisible.value) {
                        return const SizedBox();
                      }

                      return Dismissible(
                        key: const ValueKey('scheduled_booking_banner'),
                        direction: DismissDirection.horizontal,
                        onDismissed: (_) {
                          controller.isScheduledBannerVisible.value = false;
                        },
                        child: InkWell(
                          onTap: (){
                              Get.to(() => ScheduleDeliveryList(isClick: false,));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "New Available Scheduled Booking",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 18,
                                          minHeight: 18,
                                        ),
                                        child: Text(
                                          "${list.length}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    Get.find<AuthController>().getMyScheduleOrderModel.value.data != null ?
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF0175b0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Text(
                                "Scheduled Delivery",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.to(() => ScheduleDeliveryList(isClick: true,));
                                },
                                child: Text(
                                  "View",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pendingOrders == null
                                ? 0
                                : (pendingOrders.length > 2 ? 2 : pendingOrders.length),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final item = Get.find<AuthController>().getMyScheduleOrderModel.value.data![index];
                              String formattedDate = '';
                              if (item.scheduleDate != null && item.scheduleDate!.isNotEmpty) {
                                DateTime date = DateTime.parse(item.scheduleDate!);
                                formattedDate = DateFormat('dd-MM-yyyy').format(date);
                              }

                              String formattedTime = '';
                              if (item.scheduleTime != null && item.scheduleTime!.isNotEmpty) {
                                DateTime time =
                                DateFormat("HH:mm:ss").parse(item.scheduleTime!);
                                formattedTime = DateFormat('hh:mm a').format(time);
                              }
                              return GestureDetector(
                                onTap: (){
                                  Get.to(() => ScheduleDeliveryList(isClick: true,));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:  Color(0xFFe85900),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                       Text(
                                         formattedTime,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ) :
                    SizedBox.shrink(),
                  ],
                ),
              ) ,
              authController.isPayment() ? authController.isKyc() ?(int.parse(authController.walletAmount.toString())>= -99)?   SizedBox():
              AlertDialog(
                title: Text('Pay Wallet Amount'.tr),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${"Wallet Fee:".tr} ${AppContants.rupessSystem} ${authController.walletAmount}'),
                    SizedBox(height: 10),
                    Text('Please proceed to payment to complete your Wallet fee.'.tr),
                  ],
                ),
                actions: <Widget>[

                  ElevatedButton(
                    child: Text('Pay Now'.tr),
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
                    Text('KYC Pending'.tr),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Triptoll में आपका स्वागत है! ऑर्डर प्राप्त करने के लिए कृपया अपनी KYC डॉक्यूमेंट्स अपलोड करें। KYC पूरी होने के बाद ही आप ऑर्डर ले पाएंगे।'.tr),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(text: 'किसी भी सहायता के लिए हमसे संपर्क करें: '.tr),
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
                        child: Text("Complete Now".tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    )

                  ],
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ):
              AlertDialog(
                title: Text('Pay Registration Fee'.tr),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${"Registration Fee:".tr} ${AppContants.rupessSystem} ${authController.getRegistrationFee()}'),
                    SizedBox(height: 10),
                    Text('Please proceed to payment to complete your registration.'.tr),
                  ],
                ),
                actions: <Widget>[

                  ElevatedButton(
                    child: Text('Pay Now'.tr),
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

              authController.isPayment() && authController.isKyc()  && (int.parse(authController.walletAmount.toString())>= -99) ?
              StreamBuilder<Data?>(
                stream: bookingStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null && !isSheetOpen) {
                    printSavedIds();
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

  Future<void> saveFakeId(String id, dynamic isFake) async {
    final prefs = await SharedPreferences.getInstance();
    final bool shouldSave = isFake == true;

    if (shouldSave) {
      final now = DateTime.now().millisecondsSinceEpoch;
      List<String> savedIds = prefs.getStringList('fake_ids') ?? [];
      Map<String, int> timestamps = _decodeTimestamps(prefs.getString('fake_ids_time'));

      if (!savedIds.contains(id)) {
        savedIds.add(id);
        timestamps[id] = now; // store timestamp
        await prefs.setStringList('fake_ids', savedIds);
        await prefs.setString('fake_ids_time', timestamps.toString());
      }
      Timer(const Duration(minutes: 10), () async {
        await clearExpiredFakeIds();
      });
    }
  }
  Future<void> printSavedIds() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedIds = prefs.getStringList('fake_ids') ?? [];

    if (savedIds.isEmpty) {
      print("No IDs saved in local storage.");
    } else {
      print("Saved IDs in local storage:");
      for (var id in savedIds) {
        print(id);
      }
    }
  }
  Future<void> clearExpiredFakeIds() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedIds = prefs.getStringList('fake_ids') ?? [];
    Map<String, int> timestamps = _decodeTimestamps(prefs.getString('fake_ids_time'));

    final now = DateTime.now().millisecondsSinceEpoch;
    const int expiry = 10 * 60 * 1000; // 10 minutes in ms

    savedIds.removeWhere((id) {
      final ts = timestamps[id];
      return ts == null || now - ts > expiry;
    });
    timestamps.removeWhere((key, value) => !savedIds.contains(key));

    await prefs.setStringList('fake_ids', savedIds);
    await prefs.setString('fake_ids_time', timestamps.toString());
  }

  Map<String, int> _decodeTimestamps(String? data) {
    if (data == null || data.isEmpty) return {};
    // Convert "{id1: 123, id2: 456}" back to Map
    final cleaned = data.replaceAll(RegExp(r'[{} ]'), '');
    final pairs = cleaned.isEmpty ? [] : cleaned.split(',');
    final map = <String, int>{};
    for (var p in pairs) {
      final kv = p.split(':');
      if (kv.length == 2) {
        map[kv[0]] = int.tryParse(kv[1]) ?? 0;
      }
    }
    return map;
  }

  Future<void> showRideDetailsSheet(Data notificationResponse) async{
    final prefs = await SharedPreferences.getInstance();
    List<String> savedIds = prefs.getStringList('fake_ids') ?? [];
    final currentId = notificationResponse.bookingId.toString();
    return !savedIds.contains(currentId) ?
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true, // Allows the sheet to take up more space
      backgroundColor: Colors.transparent, // Makes the rounded corners visible
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 20), // Space for the drag handle
        decoration:  BoxDecoration(
          color: notificationResponse.orderStatus == 'scheduled' ?
             Color(0xFFcfecf7): Colors.white,
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
              child:
              // notificationResponse.isFake == 0 || notificationResponse.isFake == '0' ?
              SingleChildScrollView(
                controller: scrollController,
                child: _buildRideDetailsContent(notificationResponse),
              )
                    // :
              // SingleChildScrollView(
              //   controller: scrollController,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Align(
              //         alignment: Alignment.topRight,
              //         child:   InkWell(
              //           onTap: () {
              //             stopRingtone();
              //             saveFakeId(notificationResponse.id.toString(),notificationResponse.isFake);
              //             Navigator.pop(context);
              //           },
              //           child: Container(
              //
              //             margin: const EdgeInsets.only(left: 20),
              //             padding: const EdgeInsets.all(6),
              //             decoration: BoxDecoration(
              //               color: TColor.red,
              //               shape: BoxShape.circle,
              //
              //             ),
              //             child: Icon(Icons.close,color: Colors.white,),
              //           ),
              //         ),
              //       ).paddingSymmetric(horizontal: 20),
              //       Text('Order already taken.',
              //         style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.red
              //         ),),
              //       Text('Order #${notificationResponse.id.toString()}',
              //         style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.red
              //         ),),
              //       Text('Click fast next time',
              //         style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.black
              //         ),),
              //       LottieScreen()
              //     ],
              //   ),
              // ),
            );
          },
        ),
      ),
    ) : null;
  }

  Future<void> showRideDetailsFakeSheet(Data notificationResponse) async{
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
              child:   SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child:   InkWell(
                        onTap: () {
                          stopRingtone();
                          saveFakeId(notificationResponse.orderId.toString(),notificationResponse.isFake);
                          Navigator.pop(context);
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
                    ).paddingSymmetric(horizontal: 20),
                    Text('Order already taken.'.tr,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.red
                      ),),
                    Text('Click fast next time'.tr,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),),
                    LottieScreen()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  String referralCode = "12345678";
  double? roadDistance;
  _shareReferral() async {
    // Play Store link with referral parameter
    const String packageName = 'service.triptoll.in'; // Apna package name daalein
    final String shareLink = 'https://play.google.com/store/apps/details?id=$packageName&referrer=$referralCode';

    final String shareText = 'Check out this amazing app! Use my referral code: $referralCode\n\n$shareLink';

    // Copy to clipboard


    // Share using device's share dialog
    await Share.share(shareText);
  }
  String formatScheduleDate(String? date) {
    if (date == null || date.isEmpty) return '';
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  String formatScheduleTime(String? date, String? time) {
    if (date == null || time == null) return '';
    DateTime parsedTime = DateTime.parse("$date $time");
    return DateFormat('hh:mm a').format(parsedTime);
  }

  Widget _buildRideDetailsContent(Data bookingResponse) {
    return Column(
      children: [
        // Drag handle indicator
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: bookingResponse.orderStatus == 'scheduled' ?
            Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 15),

        // Your original content with some padding adjustments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
             bookingResponse.orderStatus == 'scheduled' ?
             Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   "Schedule Order",
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 22,
                     fontWeight: FontWeight.w500
                   ),
                 ),
               ],
             ) : SizedBox.shrink(),
              bookingResponse.orderStatus == 'scheduled' ?
                  SizedBox(
                    height: 15,
                  ) : SizedBox.shrink(),
              bookingResponse.orderStatus == 'scheduled' ?
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Schedule Date",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  Text(
                    formatScheduleDate(bookingResponse.scheduleDate),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ) : SizedBox.shrink(),
              bookingResponse.orderStatus == 'scheduled' ?
              SizedBox(
                height: 10,
              ) : SizedBox.shrink(),
              bookingResponse.orderStatus == 'scheduled' ?
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Schedule Time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  Text(
                    formatScheduleTime(
                      bookingResponse.scheduleDate,
                      bookingResponse.scheduleTime,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ) : SizedBox.shrink(),
              bookingResponse.orderStatus == 'scheduled' ?
              SizedBox(
                height: 20,
              ) : SizedBox.shrink(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${AppContants.rupessSystem} ${bookingResponse.amount ?? ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: calculateDropDistancesForBooking(bookingResponse),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Calculating...",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                        } else {
                          final data = snapshot.data!;
                          final km = data['total_distance_km'];
                          final duration = data['total_duration'];

                          return Text(
                            "${km.toStringAsFixed(2)} KM • $duration",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          );
                        }
                      },
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
                        "${bookingResponse.pickup!.address ?? ""}",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: bookingResponse.dropoffs?.length ?? 0,
                itemBuilder: (context, index) {
                  final drop = bookingResponse.dropoffs![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
                            drop.address ?? "",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      stopRingtone();
                      Navigator.pop(context);
                     // Get.find<AuthController>().bookingStatusChange(
                     //      status: "cancel",
                     //      amount: bookingResponse.amount,
                     //      orderID: bookingResponse.orderId,
                     //      cus_id:bookingResponse.cusId,
                     //      value: 0
                     //  );
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
                      onTap: bookingResponse.isFake == false || bookingResponse.isFake == false ?
                          () async {
                        final prefs = await SharedPreferences.getInstance();
                        authController.isLoadingTime = prefs.getBool(AppContants.isLoadingTime)!;
                        print('dsdskdsds${authController.isLoadingTime.toString()}');
                        authController.maxTime = prefs.getString(AppContants.maxTimeVar)!;
                        authController.loadingCharges = prefs.getString(AppContants.loadingCharges)!;
                        authController.checkDriverBooking(context);
                        Navigator.pop(context);
                        Get.find<AuthController>().accpetBooking(
                            orderID: bookingResponse.bookingId,
                            cus_id:bookingResponse.cusId,
                            value: 0
                        );
                      } : (){
                        Get.back();
                        saveFakeId(bookingResponse.bookingId.toString(),bookingResponse.isFake);
                        showRideDetailsFakeSheet(bookingResponse);
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: bookingResponse.orderStatus == 'scheduled' ?
                          Colors.orangeAccent
                              : TColor.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "TAP TO ACCEPT".tr,
                                  style: TextStyle(
                                    color: TColor.primaryTextW,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            // Container(
                            //   height: 40,
                            //   width: 40,
                            //   decoration: BoxDecoration(
                            //     color: Colors.black12,
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   alignment: Alignment.center,
                            //   child: Text(
                            //     "Click".tr,
                            //     style: TextStyle(
                            //       color: TColor.primaryTextW,
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w700,
                            //     ),
                            //   ),
                            // ),
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


  // double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   const R = 6371.0; // Earth's radius in kilometers
  //
  //   // Convert degrees to radians
  //   double dLat = _toRadians(lat2 - lat1);
  //   double dLon = _toRadians(lon2 - lon1);
  //
  //   // Apply Haversine formula
  //   double a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
  //           sin(dLon / 2) * sin(dLon / 2);
  //
  //   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //   double distance = R * c; // Distance in kilometers
  //
  //   return distance;
  // }

  Future<Map<String, dynamic>> calculateDropDistancesForBooking(dynamic booking) async {
    const apiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";

    final url = Uri.parse("https://routes.googleapis.com/directions/v2:computeRoutes");

    final headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask": "routes.distanceMeters,routes.duration"
    };

    final pickup = booking.pickup;
    final dropoffs = booking.dropoffs;

    if (dropoffs == null || dropoffs.isEmpty) {
      return {
        "total_distance_km": 0.0,
        "total_duration": "0m",
        "drops": []
      };
    }

    double currentLat = double.parse(pickup.lat);
    double currentLng = double.parse(pickup.lng);

    double totalDistance = 0;
    int totalSeconds = 0;
    List<Map<String, dynamic>> drops = [];

    for (int i = 0; i < dropoffs.length; i++) {
      final drop = dropoffs[i];

      final body = jsonEncode({
        "origin": {
          "location": {"latLng": {"latitude": currentLat, "longitude": currentLng}}
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": double.parse(drop.lat),
              "longitude": double.parse(drop.lng)
            }
          }
        },
        "travelMode": "DRIVE"
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final route = data["routes"][0];
          final distance = (route["distanceMeters"] ?? 0) as int;
          final durationRaw = (route["duration"] ?? "0s") as String;

          int seconds = int.tryParse(durationRaw.replaceAll("s", "")) ?? 0;
          totalSeconds += seconds;
          totalDistance += distance / 1000.0; // convert to KM

          int hours = seconds ~/ 3600;
          int minutes = (seconds % 3600) ~/ 60;
          String durationText = hours > 0 ? "${hours}h ${minutes}m" : "${minutes}m";

          drops.add({
            "drop_address": drop.address,
            "sequence": drop.sequence,
            "distance_km": (distance / 1000.0).toStringAsFixed(2),
            "duration_text": durationText,
          });

          currentLat = double.parse(drop.lat);
          currentLng = double.parse(drop.lng);
        }
      }
    }

    int totalHours = totalSeconds ~/ 3600;
    int totalMinutes = (totalSeconds % 3600) ~/ 60;
    String totalDuration =
    totalHours > 0 ? "${totalHours}h ${totalMinutes}m" : "${totalMinutes}m";

    return {
      "total_distance_km": totalDistance,
      "total_duration": totalDuration,
      "drops": drops,
    };
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
                      "${AppContants.rupessSystem} ${bookingResponse.amount ?? ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     "${calculateDistance(double.parse(bookingResponse.pickupLat??"0"),double.parse(bookingResponse.pickupLong??"0"),double.parse(bookingResponse.dropLat??"0"),double.parse(bookingResponse.dropLong??"0")).toStringAsFixed(2)}  KM",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: TColor.secondaryText,
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: calculateDropDistancesForBooking(bookingResponse),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Calculating...",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                        } else {
                          final data = snapshot.data!;
                          final km = data['total_distance_km'];
                          final duration = data['total_duration'];

                          return Text(
                            "${km.toStringAsFixed(2)} KM • $duration",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.secondaryText, fontSize: 18),
                          );
                        }
                      },
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
                      "${bookingResponse.pickup!.address ?? ""}",
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
                        "${bookingResponse.dropoffs![0].address ?? ""}",
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
                        amount: bookingResponse.amount,
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
                          amount: bookingResponse.amount,
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

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    Get.find<AuthController>().isLoadingTime =
        prefs.getBool(AppContants.isLoadingTime) ?? false;
    print('dsdskdsds ${Get.find<AuthController>().isLoadingTime}');
  }

  @override
  void initState() {
    super.initState();
    loadStoredData().then((_) {
      _loadPrefs();
      setState(() {
        widget.authController.time = _formatDuration();
      });
    });
    Get.find<AuthController>().getMyScheduledOrderFun();
    _isOnline = widget.authController.driverInResponse?.driverDetails?.loginStatus.toString() == "online";
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.value = _isOnline ? 1.0 : 0.0;
    _thumbPosition = _isOnline ? _maxSlideDistance : 0.0;

    if (_isOnline) {
      widget.authController.onlineStartTime =
          DateTime.now(); // start tracking if already online
    }
    widget.authController.time = _formatDuration();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isOnline) {
        setState(() {
          widget.authController.time = _formatDuration();
        });
      }
    });
    _bookingStream = Stream.periodic(const Duration(seconds: 30)).listen((_) {
      if (!mounted) return;
      widget.authController.checkDriverBooking(context);
    });
  }
  late StreamSubscription _bookingStream;
  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    _bookingStream.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final seconds = prefs.getInt('online_seconds') ?? 0;
    final startMillis = prefs.getInt('online_startTime');
    final lastSavedDate = prefs.getString('last_saved_date');

    final today = DateTime.now().toIso8601String().split("T").first;

    if (lastSavedDate != today) {
      // ✅ नया दिन → reset
      await prefs.setInt('online_seconds', 0);
      await prefs.setString('last_saved_date', today);

      setState(() {
        widget.authController.totalOnlineDuration = Duration.zero;
        widget.authController.onlineStartTime = null;
        widget.authController.time = "0 h 0 m";
      });
    } else {
      // ✅ पुराना दिन → continue
      setState(() {
        widget.authController.totalOnlineDuration = Duration(seconds: seconds);
        if (startMillis != null) {
          widget.authController.onlineStartTime =
              DateTime.fromMillisecondsSinceEpoch(startMillis);
        }
        widget.authController.time = _formatDuration();
      });
    }
  }

  Future<void> saveStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'online_seconds', widget.authController.totalOnlineDuration.inSeconds);

    if (widget.authController.onlineStartTime != null) {
      await prefs.setInt('online_startTime',
          widget.authController.onlineStartTime!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('online_startTime');
    }
    await prefs.setString(
        'last_saved_date', DateTime.now().toIso8601String().split("T").first);
  }

  // 🔥 CHANGED: simplified toggle logic
  void _toggleStatus(bool newStatus) async {
    setState(() {
      _isOnline = newStatus;

      if (newStatus) {
        _animationController.forward();
        _thumbPosition = _maxSlideDistance;
        widget.authController.onlineStartTime = DateTime.now();
        saveStoredData();
      } else {
        if (widget.authController.onlineStartTime != null) {
          final session = DateTime.now()
              .difference(widget.authController.onlineStartTime!);
          widget.authController.totalOnlineDuration += session;
        }
        widget.authController.onlineStartTime = null;
        saveStoredData();
        _animationController.reverse();
        _thumbPosition = 0.0;
      }

      widget.authController.changeLoginStatus(
        status: newStatus ? "online" : "offline",
        context: context,
      );
    });
  }

  String _formatDuration() {
    Duration total = widget.authController.totalOnlineDuration;

    if (_isOnline && widget.authController.onlineStartTime != null) {
      total += DateTime.now().difference(widget.authController.onlineStartTime!);
    }

    final hours = total.inHours;
    final minutes = total.inMinutes.remainder(60);
    return "$hours h $minutes m";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxSlideDistance = constraints.maxWidth - 160; // 🔥 CHANGED: smoother thumb range

        return GestureDetector(
          behavior: HitTestBehavior.translucent,

          // 🔥 CHANGED: simplified gestures
          onTap: () {
            _toggleStatus(!_isOnline); // Tap se toggle ho jaaye
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
              _toggleStatus(true); // Right slide → Online
            } else if (details.primaryVelocity != null &&
                details.primaryVelocity! < 0) {
              _toggleStatus(false); // Left slide → Offline
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
                Center(
                  child: Text(
                    "${"Swipe To".tr} ${_isOnline ? "Offline".tr : "Online".tr}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
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
                            _isOnline ? "ON".tr : "OFF".tr,
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
