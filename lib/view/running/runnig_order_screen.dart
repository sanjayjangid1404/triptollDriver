import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/appContants.dart';
import '../../common/color_extension.dart';
import '../../controller/authController.dart';
import '../../model/running_order_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/show_timer.dart';
import '../home/support/faq.dart';
import '../home/unloading_timer.dart';


class RunningOrderScreen extends StatefulWidget {
  // final Orders order;

  // const RunningOrderScreen({
  //   // required this.order
  //
  // });

  @override
  State<RunningOrderScreen> createState() => _RunningOrderScreenState();
}

class _RunningOrderScreenState extends State<RunningOrderScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _allPoints = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      _prepareMapData();
    });
  }

  // ---------------------------
  // PREPARE ALL MARKERS + LINES
  // ---------------------------
  void _prepareMapData() async {
    final pickup = Get.find<AuthController>().runningOrderResponse!.orders![0].pickup!;
    final drops = Get.find<AuthController>().runningOrderResponse!.orders![0].dropoffs ?? [];

    List<LatLng> routePoints = [];

    // Pickup
    LatLng pickupPoint = LatLng(
      double.parse(pickup.lat.toString()),
      double.parse(pickup.lng.toString()),
    );

    routePoints.add(pickupPoint);

    // Dropoffs sorted
    List sortedDrops = List.from(drops)
      ..sort((a, b) => int.parse(a.sequence!).compareTo(int.parse(b.sequence!)));

    for (var d in sortedDrops) {
      routePoints.add(
        LatLng(double.parse(d.lat.toString()), double.parse(d.lng.toString())),
      );
    }

    _allPoints = routePoints;

    _addMarkers(routePoints);
    await _drawPolylines(routePoints);

    _moveCameraToBounds();

    setState(() {});
  }

  // Add markers A, B, C...
  void _addMarkers(List<LatLng> points) {
    for (int i = 0; i < points.length; i++) {
      String letter = String.fromCharCode(65 + i); // A B C D...

      _markers.add(
        Marker(
          markerId: MarkerId(letter),
          position: points[i],
          infoWindow: InfoWindow(title: "Point $letter"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              i == 0 ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  // Draw Polyline route
  Future<void> _drawPolylines(List<LatLng> points) async {
    Polyline polyline = Polyline(
      polylineId: PolylineId("route"),
      points: points,
      width: 6,
      color: Colors.blue,
    );

    _polylines.add(polyline);
  }

  // Fit map to all markers
  void _moveCameraToBounds() {
    if (_allPoints.isEmpty) return;

    LatLngBounds bounds = _createBounds(_allPoints);

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }

  LatLngBounds _createBounds(List<LatLng> list) {
    double? x0, x1, y0, y1;

    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(x0!, y0!),
      northeast: LatLng(x1!, y1!),
    );
  }

  // ---------------------------
  // UI
  // ---------------------------
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
                                          '${controller.runningOrderResponse!.orders![0].pickup!.name.toString()}',
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
                                    "${AppContants.rupessSystem} ${controller.runningOrderResponse!.orders![0].amount ?? ""}",
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
                                              controller.runningOrderResponse!.orders![0].pickup!.contactNumber.toString());
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.call_outlined, color: Colors.blue,
                                                size: 16),
                                            const SizedBox(width: 5),
                                            Text('${controller.runningOrderResponse!.orders![0].pickup!.contactNumber.toString()} , ${controller.runningOrderResponse!.orders![0].pickup!.name.toString()}'),
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
                          // : SizedBox.shrink(),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Collect Payment".tr, style: TextStyle(fontSize: 16,
              color: TColor.primary,
              fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),

          InkWell(
            onTap: () {
              //   Navigator.pop(context);
              controller.currentDropIndex.value = 0;
              controller.loadingStart.value = false;
              controller.unloadingStart.value = false;
              controller.showCompletePayment.value = false;
              controller.orderPayment(controller.runningOrderResponse!.orders![0].orderId.toString(),
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
          Expanded(
            child: InkWell(
              onTap: () async {
                if (controller.runningOrderResponse!.orders![0].orderStatus.toString()
                    .toLowerCase() == "picked") {
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
                    // final firestore = FirebaseFirestore.instance;
                    // await firestore.collection('location_id_direction').add({
                    //   'bookingId': bookingResponse.bookingId.toString(),
                    //   'locationId': drop.locationId.toString(),
                    //   'timestamp': DateTime.now(),
                    // });
                    // print("🗺️ Opening map for sequence ${drop.sequence} "
                    //     "| Location ID: ${drop.locationId}");
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
                  // final status = bookingResponse.orderStatus.toString().toLowerCase();

                  if ( controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "accpeted") {
                    controller.startLoadingApi(controller.getUserID().toString(), context, controller.runningOrderResponse!.orders![0].bookingId.toString(),controller.runningOrderResponse!.orders![0].pickup!.locationId.toString());
                    // checkDriverBooking(context);
                  }
                  else if (controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "loading") {
                    controller.orderPicked(orderID: controller.runningOrderResponse!.orders![0].bookingId.toString(),locationID: controller.runningOrderResponse!.orders![0].pickup!.locationId.toString(),context: context);
                    // checkDriverBooking(context);
                  }
                  else if (controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "unloading") {
                    controller.orderDelivered(orderID: controller.runningOrderResponse!.orders![0].bookingId.toString(),context: context);
                    // await clearDropIndex();
                    // checkDriverBooking(context);
                  }
                  else if (controller.runningOrderResponse!.orders![0].orderStatus.toString().toLowerCase() == "picked") {
                    print('🚚 Order Picked — Starting unloading logic');

                    final drops = controller.runningOrderResponse!.orders![0].dropoffs ?? [];

                    if (drops.isEmpty) {
                      print('⚠️ No dropoff found.');
                      return;
                    }

                    // Sort drops by sequence (if not already sorted)
                    final sortedDrops = List.from(drops)
                      ..sort((a, b) => int.parse(a.sequence.toString())
                          .compareTo(int.parse(b.sequence.toString())));

                    int dropIndex = controller.currentDropIndex.value;

                    // 🧠 Safety: If dropIndex is out of range, reset it to 0
                    if (dropIndex >= sortedDrops.length) {
                      dropIndex = 0;
                      controller.currentDropIndex.value = 0;
                    }

                    final drop = sortedDrops[dropIndex];

                    // ✅ Call unloading API
                    await controller.startUnLoadingApi(
                      controller.getUserID().toString(),
                      context,
                      controller.runningOrderResponse!.orders![0].bookingId.toString(),
                      drop.locationId.toString(),
                    );
                    await controller.nextDrop(sortedDrops.length);
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
