import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/model/booking_notification_response.dart';
// import 'package:taxi_driver/common/socket_manager.dart';
// import 'package:taxi_driver/view/home/run_ride_view.dart';

class TipRequestView extends StatefulWidget {
  final BookingNotificationResponse bObj;
  const TipRequestView({super.key, required this.bObj});

  @override
  State<TipRequestView> createState() => _TipRequestViewState();
}

class _TipRequestViewState extends State<TipRequestView> {
  bool isOpen = true;

   // late MapController controller;
  var pickup; // Delhi
  var drop ;   // Mumbai
  //23.02756018230479, 72.58131973941731
  //23.02726396414328, 72.5851928489523

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    callAPI();

    // controller = MapController(
    //   initPosition: GeoPoint(
    //     latitude: double.tryParse(widget.bObj.pickupLat.toString()) ?? 0.0,
    //     longitude:
    //         double.tryParse(widget.bObj.pickupLong.toString()) ?? 0.0,
    //   ),
    // );
    // //
    // pickup = GeoPoint(latitude: double.tryParse(widget.bObj.pickupLat.toString()) ?? 0.0, longitude: double.tryParse(widget.bObj.pickupLong.toString()) ?? 0.0);
    // drop = GeoPoint(latitude: double.tryParse(widget.bObj.dropLat.toString()) ?? 0.0, longitude: double.tryParse(widget.bObj.dropLong.toString()) ?? 0.0);
    // controller.addObserver(this);

    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
     //controller.dispose();
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

  Future<Map<String, dynamic>> fetchGoogleMapsRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required String apiKey,
    String mode = "driving", // "walking", "bicycling", "transit"
  }) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$originLat,$originLng&'
          'destination=$destLat,$destLng&'
          'mode=$mode&'
          'departure_time=now&' // For real-time traffic
          'key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final leg = route['legs'][0];
        return {
          'distance': leg['distance']['text'], // e.g., "1,150 km"
          'duration': leg['duration']['text'], // e.g., "15 hours 30 mins"
          'duration_in_traffic': leg['duration_in_traffic']?['text'], // Traffic-adjusted
        };
      } else {
        throw Exception("Error2: ${data['status']}");
      }
    } else {
      throw Exception("Failed to fetch route");
    }
  }

  Future<Map<String, dynamic>> fetchOSRMRoute(
      double lat1, double lng1, double lat2, double lng2,
      ) async {
    final response = await http.get(
      Uri.parse('https://router.project-osrm.org/route/v1/driving/$lng1,$lat1;$lng2,$lat2'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final distanceKm = (data['routes'][0]['distance'] / 1000).toStringAsFixed(1);
      final durationHours = (data['routes'][0]['duration'] / 3600).toStringAsFixed(1);
      return {
        'distance': '$distanceKm km',
        'duration': '$durationHours hours',
      };
    } else {
      throw Exception("OSRM Error: ${response.statusCode}");
    }
  }


  String distance = "0";
  String duration = "0";
  void callAPI()async{
    final result = await fetchOSRMRoute(
      /*originLat:*/ double.parse(widget.bObj.pickupLat??"0"), // Delhi
      /*originLng:*/ double.parse(widget.bObj.pickupLong??"0"),
      /*destLat:*/ double.parse(widget.bObj.dropLat??"0"),// Mumbai
      /*destLng:*/ double.parse(widget.bObj.dropLong??"0"),
     // apiKey: "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk", // 🔴 Replace with your key
    //  mode: "driving",
    );

    setState(() {
      distance = "${result['distance']}";
      duration = "${result['duration']}";
    });

    print("Distance: ${result['distance']}");
    print("Duration: ${result['duration']}");
    print("Duration (with traffic): ${result['duration_in_traffic']}");
  }

  @override
  Widget build(BuildContext context) {


    return GetBuilder<AuthController>(
      builder: (AuthController authController) =>
       Scaffold(
        body: Stack(
          children: [
            /*OSMFlutter(
              controller: controller,
              osmOption: OSMOption(
                  enableRotationByGesture: true,

                  zoomOption: const ZoomOption(
                    initZoom: 8,
                    minZoomLevel: 3,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                  ),
                  staticPoints: [

                  ],
                  roadConfiguration: const RoadOption(
                    roadColor: Colors.blueAccent,

                  ),
                  // markerOption: MarkerOption(
                  //   defaultMarker: const MarkerIcon(
                  //     icon: Icon(
                  //       Icons.person_pin_circle,
                  //       color: Colors.blue,
                  //       size: 56,
                  //     ),
                  //   ),
                  // ),
                  showDefaultInfoWindow: false),
              onMapIsReady: (isReady) {
                if (isReady) {
                  print("map is ready");
                }
              },
              onLocationChanged: (myLocation) {
                print("user location :$myLocation");
              },
              onGeoPointClicked: (myLocation) {
                print("GeoPointClicked location :$myLocation");
              },
            ),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${duration ?? ""}",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 25,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${AppContants.rupessSystem} ${widget.bObj.totalAmount ?? ""}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${distance}  KM",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/img/rate_tip.png",
                                    width: 15,
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
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
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: TColor.secondary,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "${widget.bObj.pickupAddress ?? ""}",
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(color: TColor.primary),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "${widget.bObj.dropAddress ?? ""}",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          authController.bookingStatusChange(status: "accept",amount: widget.bObj.totalAmount,orderID: widget.bObj.orderId,cus_id: widget.bObj.cusId);

                          //   apiAcceptRide();
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
                      const SizedBox(
                        height: 25,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            authController.bookingStatusChange(status: "cancelled",amount: widget.bObj.totalAmount,orderID: widget.bObj.orderId,cus_id: widget.bObj.cusId);

                         //   apiDeclineRide();
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/img/close.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                  Text(
                                    "No Thanks",
                                    style: TextStyle(
                                        color: TColor.primaryText, fontSize: 16),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



  // void addMarker() async {
  //   await controller.setMarkerOfStaticPoint(
  //     id: "pickup",
  //     markerIcon: MarkerIcon(
  //       iconWidget: Image.asset(
  //         "assets/img/pickup_pin.png",
  //         width: 80,
  //         height: 80,
  //       ),
  //     ),
  //   );
  //
  //   await controller.setMarkerOfStaticPoint(
  //     id: "dropoff",
  //     markerIcon: MarkerIcon(
  //       iconWidget: Image.asset(
  //         "assets/img/drop_pin.png",
  //         width: 80,
  //         height: 80,
  //       ),
  //     ),
  //   );
  //
  //   //23.02756018230479, 72.58131973941731
  //   //23.02726396414328, 72.5851928489523
  //   await controller.setStaticPosition([
  //     GeoPoint(
  //         latitude:
  //             double.tryParse(widget.bObj.pickupLat.toString()) ?? 0.0,
  //         longitude:
  //             double.tryParse(widget.bObj.pickupLong.toString()) ?? 0.0)
  //   ], "pickup");
  //
  //   await controller.setStaticPosition([
  //     GeoPoint(
  //         latitude: double.tryParse(widget.bObj.dropLat.toString()) ?? 0.0,
  //         longitude:
  //             double.tryParse(widget.bObj.dropLong.toString()) ?? 0.0)
  //   ], "dropoff");
  //
  //   loadMapRoad();
  // }
  //
  // void loadMapRoad() async {
  //   await controller.drawRoad(
  //       GeoPoint(
  //           latitude:
  //               double.tryParse(widget.bObj.pickupLat.toString()) ?? 0.0,
  //           longitude:
  //               double.tryParse(widget.bObj.pickupLong.toString()) ?? 0.0),
  //       GeoPoint(
  //           latitude:
  //               double.tryParse(widget.bObj.dropLat.toString()) ?? 0.0,
  //           longitude:
  //               double.tryParse(widget.bObj.dropLong.toString()) ?? 0.0),
  //       roadType: RoadType.car,
  //       roadOption: const RoadOption(
  //         roadColor: Colors.blueAccent,
  //         roadBorderWidth: 5,
  //       ));
  // }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
    //  addMarker();
    }
  }

  // //TODO: ApiCalling
  // void apiAcceptRide() {
  //   Globs.showHUD();
  //   ServiceCall.post({
  //     "booking_id": widget.bObj["booking_id"].toString(),
  //     "request_token": widget.bObj["request_token"] ?? ""
  //   }, SVKey.svDriverRideAccept, isTokenApi: true,
  //       withSuccess: (responseObj) async {
  //     Globs.hideHUD();
  //     if (responseObj[KKey.status] == "1") {
  //       context.pop();
  //       ////context.push(const RunRideView());
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content:
  //               Text(responseObj[KKey.message] as String? ?? MSG.success)));
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     } else {
  //       mdShowAlert(Globs.appName,
  //           responseObj[KKey.message] as String? ?? MSG.fail, () {});
  //     }
  //   }, failure: (error) async {
  //     Globs.hideHUD();
  //     mdShowAlert(Globs.appName, error as String? ?? MSG.fail, () {});
  //   });
  // }
  //
  // void apiDeclineRide() {
  //   Globs.showHUD();
  //   ServiceCall.post({
  //     "booking_id": widget.bObj["booking_id"].toString(),
  //     "request_token": widget.bObj["request_token"] ?? ""
  //   }, SVKey.svDriverRideDecline, isTokenApi: true,
  //       withSuccess: (responseObj) async {
  //     Globs.hideHUD();
  //     if (responseObj[KKey.status] == "1") {
  //       context.pop();
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content:
  //               Text(responseObj[KKey.message] as String? ?? MSG.success)));
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     } else {
  //       mdShowAlert(Globs.appName,
  //           responseObj[KKey.message] as String? ?? MSG.fail, () {});
  //     }
  //   }, failure: (error) async {
  //     Globs.hideHUD();
  //     mdShowAlert(Globs.appName, error as String? ?? MSG.fail, () {});
  //   });
  // }
}
