import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_driver/common/custom_snackbar.dart';
import '../../common/appContants.dart';
import '../../common/color_extension.dart';
import '../../controller/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/show_timer.dart';
import '../home/support/faq.dart';
import '../home/unloading_timer.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RunningOrderScreen extends StatefulWidget {
  @override
  State<RunningOrderScreen> createState() => _RunningOrderScreenState();
}

class _RunningOrderScreenState extends State<RunningOrderScreen> {

  GoogleMapController? _mapController;
  TextEditingController otpController = TextEditingController();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _allPoints = [];
  final String googleApiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";
  void _handleStatus(String status) {
    final s = status.trim().toLowerCase();
    final controller = Get.find<AuthController>();

    print('function call $s');

    if (s == "loading") {
      controller.startLoadingTimer();
      controller.stopUnLoadingTimer();
      return;
    }

    if (s == "unloading") {
      controller.startUnLoadingTimer();
      controller.stopLoadingTimer();
      return;
    }
  }


  @override
  void initState() {
    super.initState();
    final AuthController controller = Get.find<AuthController>();

    _handleStatus(controller.runningOrderStatus.value);

    ever(controller.runningOrderStatus, (status) {
      _handleStatus(status.toString());
    });
    Future.delayed(Duration(milliseconds: 300), () {
      _prepareMapData();
    });
  }

  Future<void> _prepareMapData() async {
    final order = Get.find<AuthController>()
        .runningOrderResponse!
        .orders![0];

    LatLng pickup = LatLng(
      double.parse(order.pickup!.lat!),
      double.parse(order.pickup!.lng!),
    );

    LatLng drop = LatLng(
      double.parse(order.dropoffs![0].lat!),
      double.parse(order.dropoffs![0].lng!),
    );

    _allPoints = [pickup, drop];

    _addMarkers(pickup, drop);
    await _drawRouteUsingDirections(pickup, drop);
    _moveCameraToBounds();

    setState(() {});
  }

  void _addMarkers(LatLng pickup, LatLng drop) {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId("pickup"),
        position: pickup,
        infoWindow: const InfoWindow(title: "Pickup"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId("drop"),
        position: drop,
        infoWindow: const InfoWindow(title: "Drop"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ),
    );
  }

  Future<void> _drawRouteUsingDirections(
      LatLng start,
      LatLng end,
      ) async {
    PolylinePoints polylinePoints = PolylinePoints(
      apiKey: "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk",
    );

    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(start.latitude, start.longitude),
      destination: PointLatLng(end.latitude, end.longitude),
      mode: TravelMode.driving, // ✅ REQUIRED
    );

    PolylineResult result =
    await polylinePoints.getRouteBetweenCoordinates(
      request: request,
    );

    if (result.points.isNotEmpty) {
      List<LatLng> route = result.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          width: 6,
          color: Colors.blue,
          points: route,
        ),
      );

      setState(() {});
    } else {
      debugPrint("❌ No route found : ${result.errorMessage}");
    }
  }




  void _moveCameraToBounds() {
    if (_allPoints.isEmpty || _mapController == null) return;

    double x0 = _allPoints.first.latitude;
    double x1 = _allPoints.first.latitude;
    double y0 = _allPoints.first.longitude;
    double y1 = _allPoints.first.longitude;

    for (LatLng p in _allPoints) {
      if (p.latitude > x1) x1 = p.latitude;
      if (p.latitude < x0) x0 = p.latitude;
      if (p.longitude > y1) y1 = p.longitude;
      if (p.longitude < y0) y0 = p.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: bottomButtons(context, controller),
        body: Column(
          children: [
            SizedBox(
              height: 260,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(controller.runningOrderResponse!.orders![0].pickup!.lat!),
                    double.parse(controller.runningOrderResponse!.orders![0].pickup!.lng!),
                  ),
                  zoom: 14,
                ),
                onMapCreated: (m) {
                  _mapController = m;
                  Future.delayed(Duration(milliseconds: 500), () {
                    _moveCameraToBounds();
                  });
                },
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          'https://randomuser.me/api/portraits/men/1.jpg'),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.runningOrderResponse!.orders![0].pickup!.name.toString(),
                                          style: TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            AppContants.makePhoneCall(
                                                controller.runningOrderResponse!.orders![0].pickup!.contactNumber.toString());
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.call_outlined, color: Colors.blue,
                                                  size: 16),
                                              const SizedBox(width: 5),
                                              Text(
                                                  '${controller.runningOrderResponse!.orders![0].pickup!.contactNumber.toString()}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (
                                        context) => FaqScreen(),));
                                  },
                                  child: Image.asset('assets/img/help.png',
                                    height: 40,
                                  ),
                                )
                              ],
                            ),
                          ),

                          SizedBox(height: 10,),

                          InkWell(
                            onTap: () {
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${AppContants.rupessSystem} ${controller.runningOrderResponse!.orders![0].totalAmount ?? ""}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FutureBuilder<Map<String, dynamic>>(
                                    future: controller.calculateDropDistancesForBooking(controller.runningOrderResponse!.orders![0]),
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined, color: Colors.green,),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              controller.runningOrderResponse!.orders![0].pickup!.address ?? "",
                                              style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            controller.runningOrderResponse!.orders![0].pickup!.status ?? "",
                                            style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          AppContants.makePhoneCall(
                                              controller.runningOrderResponse!.orders![0].senderContactNumber.toString());
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.call_outlined, color: Colors.blue,
                                                size: 16),
                                            const SizedBox(width: 5),
                                            Text('${controller.runningOrderResponse!.orders![0].senderContactNumber.toString()} , ${controller.runningOrderResponse!.orders![0].senderName.toString()}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.runningOrderResponse!.orders![0].dropoffs?.length ?? 0,
                              itemBuilder: (context, index) {
                                final dropoff = controller.runningOrderResponse!.orders![0].dropoffs![index];

                                // bool isCompleted = index < currentDropIndex.value ||
                                //    (isLastDropCompleted.value && index == currentDropIndex.value);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_outlined, color: Colors.red,),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    dropoff.address ?? "",
                                                    style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  dropoff.status ?? "",
                                                  style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () {
                                                AppContants.makePhoneCall(dropoff.contactNumber.toString());
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.call_outlined, color: Colors.blue, size: 16),
                                                  const SizedBox(width: 5),
                                                  Text('${dropoff.contactNumber} , ${dropoff.name}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          // const SizedBox(height: 25),

                          const SizedBox(height: 35),
                          controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() ==
                              "loading"
                              ? LoadingTimer(
                            loadingChargePerMin: controller.loadingCharges.toString(),
                            maxLoadingTime: controller.maxTime.toString(),
                          )
                              : SizedBox.shrink(),
                          controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() ==
                              "unloading"
                              ? UnLoadingTimer(
                            loadingChargePerMin: controller.loadingCharges.toString(),
                            maxLoadingTime: controller.maxTime.toString(),
                          )
                              : SizedBox.shrink(),
                          controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "accpeted" ?
                           Padding(
                             padding: const EdgeInsets.only(bottom: 8.0),
                             child: Align(
                               alignment: Alignment.centerLeft,
                               child: Text('Enter Pickup Pin Here',
                               style: TextStyle(
                                   color: TColor.primaryText,
                                   fontSize: 18,
                                   fontWeight: FontWeight.w600
                               ),
                               ),
                             ),
                           ) : SizedBox.shrink(),
                          controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "accpeted" ?
                          PinCodeTextField(
                            appContext: context,
                            length: 4,
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            autoDisposeControllers: false,
                            animationType: AnimationType.fade,
                            enableActiveFill: true,
                            cursorColor: Colors.black,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8),
                              fieldHeight: 55,
                              fieldWidth: 50,

                              // 👇 Border colors
                              inactiveColor: Colors.black,
                              activeColor: Colors.black,
                              selectedColor: Colors.black,

                              // 👇 Background colors
                              activeFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              inactiveFillColor: Colors.grey.shade50,

                              disabledColor: Colors.black,
                            ),

                            onCompleted: (enteredOtp) {

                              String apiOtp = controller
                                  .runningOrderResponse!
                                  .orders![0]
                                  .pickupOtp
                                  .toString();

                              if (enteredOtp == apiOtp) {

                                // ✅ Correct OTP → Auto API Call
                                controller.startLoadingApi(
                                  controller.getUserID().toString(),
                                  context,
                                  controller.runningOrderResponse!.orders![0].bookingId.toString(),
                                  controller.runningOrderResponse!.orders![0].pickup!.locationId.toString(),
                                );

                              } else {

                                showCustomSnackBar("Wrong Pickup Pin",isError: true,getXSnackBar: true);
                                otpController.clear();
                              }
                            },

                            onChanged: (value) {},
                          ) : SizedBox.shrink(),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons(BuildContext context, AuthController controller) {
    return Container(
      padding: EdgeInsets.only(bottom: 50,top: 20),
      child:   controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() ==
          "delivered" &&
          controller.runningOrderResponse!.orders![0].paymentStatus.toString().toLowerCase() ==
              "pending" ?

      Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Collect Payment".tr, style: TextStyle(fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),),
                Flexible(
                  child: Text(
                    "${AppContants.rupessSystem} ${controller.runningOrderResponse!.orders![0].totalAmount ?? ""}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),

          InkWell(
            onTap: () {
              //   Navigator.pop(context);
              controller.currentDropIndex.value = 0;
              controller.loadingStart.value = false;
              controller.unloadingStart.value = false;
              controller.showCompletePayment.value = false;
              controller.orderPayment(controller.runningOrderResponse!.orders![0].bookingId.toString(),
                  controller.runningOrderResponse!.orders![0].driverId.toString(),
                  controller.generate8DigitKey().toString());
            },
            child: Container(
              height: 40,


              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: TColor.red,
                  borderRadius: BorderRadius.circular(30)

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    "Cash Collect".tr,
                    style: TextStyle(
                      color: TColor.primaryTextW,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),


        ],
      ) :
      Row(
        children: [
          controller.runningOrderResponse!.orders![0].orderStatus.toString() == "unloading" ?
          SizedBox() :
          Expanded(
            child: InkWell(
              onTap: () async {
                if (controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "picked") {
                  final drops = controller.runningOrderResponse!.orders![0].dropoffs ?? [];
                  if (drops.isEmpty) return;
                  final sortedDrops = List.from(drops)
                    ..sort((a, b) => int.parse(a.sequence.toString())
                        .compareTo(int.parse(b.sequence.toString())));

                  final dropIndex = controller.currentDropIndex.value;
                  if (dropIndex < sortedDrops.length) {
                    final drop = sortedDrops[dropIndex];

                    controller.openGoogleMap(
                      double.parse(drop.lat.toString()),
                      double.parse(drop.lng.toString()),
                    );
                  } else {
                    print("✅ All drops completed");
                  }
                }
                else {
                  controller.openGoogleMap(double.parse(
                      controller.runningOrderResponse!.orders![0].pickup!.lat.toString()), double
                      .parse(controller.runningOrderResponse!.orders![0].pickup!.lng.toString()));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: TColor.red,
                    borderRadius: BorderRadius.circular(30)

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_outlined, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text(
                      controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "picked"
                          ? "Drop Location".tr :
                      controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "accpeted" ?
                      "Pickup Direction".tr :
                      "Direction".tr,
                      style: TextStyle(
                        color: TColor.primaryTextW,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          // isLoadingTime == false ?
          Expanded(
              child:  InkWell(
                onTap: () async {
                  if ( controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "accpeted") {

                    String enteredOtp = otpController.text.trim();
                    String apiOtp = controller
                        .runningOrderResponse!
                        .orders![0]
                        .pickupOtp
                        .toString();

                    if (enteredOtp.length != 4) {
                      showCustomSnackBar("Please enter 4 digit Pin for continue ride",getXSnackBar: true,isError: true);
                      return;
                    }

                    if (enteredOtp == apiOtp) {

                      // ✅ Correct OTP → Call API
                      controller.startLoadingApi(
                        controller.getUserID().toString(),
                        context,
                        controller.runningOrderResponse!.orders![0].bookingId.toString(),
                        controller.runningOrderResponse!.orders![0].pickup!.locationId.toString(),
                      );

                    } else {
                      showCustomSnackBar("Wrong OTP",isError: true,getXSnackBar: true);

                    }
                    }
                  else if (controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "loading") {
                    controller.orderPicked(orderID: controller.runningOrderResponse!.orders![0].bookingId.toString(),locationID: controller.runningOrderResponse!.orders![0].pickup!.locationId.toString(),context: context);
                    // checkDriverBooking(context);
                  }
                  else if (controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "unloading") {

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content:  Text("Are you sure you want to complete this ride?".tr,
                          style: TextStyle(
                            fontFamily: "NunitoSans",
                            fontWeight: FontWeight.w500,
                            fontSize: 19
                          ),),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child:  Text("No".tr),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.orderDelivered(
                                  orderID: controller.runningOrderResponse!.orders![0].bookingId.toString(),
                                  context: context,
                                );

                                controller.resetLoadingTimer();
                                controller.resetUnLoadingTimer();
                              },
                              child:  Text("Yes".tr),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else if (controller.runningOrderResponse!.orders![0].orderStatus
                      .toString()
                      .toLowerCase() ==
                      "picked") {

                    final drops =
                        controller.runningOrderResponse!.orders![0].dropoffs ?? [];

                    if (drops.isEmpty) return;

                    final sortedDrops = List.from(drops)
                      ..sort((a, b) => int.parse(a.sequence.toString())
                          .compareTo(int.parse(b.sequence.toString())));

                    // 🔥 Always find FIRST pending drop
                    final nextPendingDrop = sortedDrops.firstWhere(
                          (d) => d.status.toString().toLowerCase() == "pending",
                      orElse: () => null,
                    );

                    if (nextPendingDrop == null) {
                      print("🎉 All drops completed");
                      return;
                    }

                    print("👉 Working on Drop ID: ${nextPendingDrop.locationId}");

                    final isSuccess = await controller.startUnLoadingApi(
                      controller.getUserID().toString(),
                      context,
                      controller.runningOrderResponse!.orders![0].bookingId.toString(),
                      nextPendingDrop.locationId.toString(),
                    );

                    if (!isSuccess) {
                      print("⛔ Failed — retry same drop");
                    }
                  }
                  },
                child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "accpeted" ?
                              "Start Loading".tr
                                  :  controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "loading" ?
                              "Start Trip".tr :
                              controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "picked"
                                  ? "Unloading".tr :
                              controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "unloading" ?
                              "Completed".tr
                                  : "Unknown error",
                              style: TextStyle(
                                color: TColor.primaryTextW,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                ),
              )
          )
        ],
      ),
    );
  }
}
