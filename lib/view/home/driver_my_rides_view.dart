import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/view/home/tip_detail_view.dart';
import '../../controller/authController.dart';

class DriverMyRidesView extends StatefulWidget {
  const DriverMyRidesView({super.key});

  @override
  State<DriverMyRidesView> createState() => _DriverMyRidesViewState();
}

class _DriverMyRidesViewState extends State<DriverMyRidesView> {
  List ridesArr = [];
  double totalAmount = 0.0;
  double driverAmount = 0.0;
  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getLifetimeEarningsFun();
      Get.find<AuthController>().getMissedOrder({
        "driver_id": authController.getUserID().toString(),
      });
      Get.find<AuthController>().getAllBooking(
          status: "success", limit: "100", offset: "10");


      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (AuthController authController) =>
          DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0.5,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Image.asset(
                      "assets/img/back.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    "My Rides".tr,
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  actions: [
                    Get
                        .find<AuthController>()
                        .lifeTimeEarnModel
                        .value
                        .status == true ?
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "${AppContants.rupessSystem} ${Get
                              .find<AuthController>()
                              .lifeTimeEarnModel
                              .value
                              .totalEarnings ?? ''}",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        )) :
                    SizedBox.shrink()
                  ],
                  bottom: TabBar(
                    indicatorColor: Colors.green,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Completed".tr),
                      Tab(text: "Missed".tr),
                    ],
                  ),
                ),
                body: TabBarView(
                    children: [
              Obx(() {
                return authController.bookingListResponseData.value.data != null
                    ? ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        itemBuilder: (context, index) {
                          var rObj = authController
                              .bookingListResponseData.value.data![index];

                          var km = 10;
                          var rideTotalAmount =
                              double.tryParse(rObj.totalAmount.toString()) ??
                                  0.0;
                          var driverAmount =
                              double.tryParse(rObj.totalAmount.toString()) ??
                                  0.0;
                          return InkWell(
                            onTap: () {
                              context.push(TipDetailsView(obj: rObj));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 2)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/img/logo.png",
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                rObj.dropoffs?.length ?? 0,
                                                (i) {
                                                  final drop =
                                                      rObj.dropoffs![i];
                                                  return Text(
                                                    drop.name ?? "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: TColor.primaryText,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              rObj.addDate != null
                                                  ? AppContants
                                                      .changeDateFormat(
                                                          rObj.addDate!,
                                                          "dd MMM yyyy")
                                                  : "",
                                              style: TextStyle(
                                                color: TColor.secondaryText,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${AppContants.rupessSystem}${rObj.totalAmount}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: TColor.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            rObj.orderStatus ?? "",
                                            style: TextStyle(
                                                color:
                                                    rObj.orderStatus == 'paid'
                                                        ? Colors.black
                                                        : Colors.red,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          rObj.pickup!.address ?? "",
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: TColor.red,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            rObj.dropoffs?.length ?? 0,
                                            (i) {
                                              final drop = rObj.dropoffs![i];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: Text(
                                                  drop.address ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (rObj.orderStatus == "pickup")
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  if (rObj.orderStatus == "delivered")
                                    Column(
                                      children: [
                                        const Divider(),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Total Distance: ".tr,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: TColor.primaryText,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "${km.toStringAsFixed(1)} KM",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "Duration: ".tr,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: TColor.primaryText,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "",
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: TColor.primaryText,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Driver Amount: ".tr,
                                              style: TextStyle(
                                                  color: TColor.primaryText,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "${AppContants.rupessSystem} ${driverAmount.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color: TColor.secondary,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total Amount: ".tr,
                                              style: TextStyle(
                                                  color: TColor.primaryText,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "${AppContants.rupessSystem} ${rideTotalAmount.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color: TColor.primary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 2,
                            ),
                        itemCount: authController
                                .bookingListResponseData.value.data?.length ??
                            0)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lottie/not_found.json',
                              height: 200),
                          Text(
                            'Completed Orders Not Found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
              }),
              authController.missedOrderListModel.isNotEmpty
                          ?
                      ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          itemBuilder: (context, index) {
                            var rObj = authController
                                .missedOrderListModel[index];

                            var km = 10;
                            var rideTotalAmount =
                                double.tryParse(rObj.totalAmount.toString()) ??
                                    0.0;
                            var driverAmount =
                                double.tryParse(rObj.totalAmount.toString()) ??
                                    0.0;
                            return InkWell(
                              onTap: () {
                                // context.push(TipDetailsView(obj: rObj));
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 2)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Image.asset("assets/img/logo.png",
                                                height: 40,),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      rObj.firstName ??
                                                          "Unknown",
                                                      style: TextStyle(
                                                          color: TColor
                                                              .primaryText,
                                                          fontSize: 17,
                                                          fontWeight: FontWeight
                                                              .w800),
                                                    ),
                                                    Text(
                                                      rObj!.bookingDate != null
                                                          ? "${AppContants
                                                          .changeDateFormat(
                                                          rObj!.bookingDate!,
                                                          "dd MMM yyyy")}"
                                                          : "",
                                                      style: TextStyle(
                                                          color: TColor
                                                              .secondaryText,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              rObj.bookedDriver == null
                                                  ? 'Missed'.tr
                                                  : '${rObj.orderStatus ??
                                                  ""}     ',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              '${AppContants.rupessSystem}${rObj
                                                  .totalAmount ?? '0.0'}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                          const SizedBox(
                            height: 15,
                          ),
                          itemCount: authController.missedOrderListModel.length)
                          :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                              'assets/lottie/not_found.json', height: 200),
                          Text(
                            'Missed Orders Not Found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ]
                )
            ),
          ),
    );
  }

  //TODO: ApiCalling

  void apiAllRidesList() {
    Globs.showHUD();
    ServiceCall.post({}, SVKey.svDriverAllRides, isTokenApi: true,
        withSuccess: (responseObj) async {
          Globs.hideHUD();
          if (responseObj[KKey.status] == "1") {
            var payloadObj = responseObj[KKey.payload] as Map? ?? {};
            ridesArr = payloadObj["ride_list"] as List? ?? [];
            totalAmount =
                double.tryParse(payloadObj["total"].toString()) ?? 0.0;
            driverAmount =
                double.tryParse(payloadObj["driver_total"].toString()) ?? 0.0;

            if (mounted) {
              setState(() {});
            }
          } else {
            mdShowAlert(
                "Error",
                responseObj[KKey.message] as String? ?? MSG.fail, () {});
          }
        }, failure: (err) async {
          Globs.hideHUD();
          debugPrint(err.toString());
        });
  }

  String statusText(Map rideObj) {
    switch (rideObj["booking_status"]) {
      case 2:
        return "On Way";
      case 3:
        return "Waiting";
      case 4:
        return "Started";
      case 5:
        return "Completed";
      case 6:
        return "Cancel";
      case 7:
        return "No Drivers";
      default:
        return "Pending";
    }
  }

  Color statusColor(Map rideObj) {
    switch (rideObj["booking_status"]) {
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.green;
      case 5:
        return Colors.green;
      case 6:
        return Colors.red;
      case 7:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String statusWiseDateTime(Map rideObj) {
    switch (rideObj["booking_status"]) {
      case 2:
        return (rideObj["accpet_time"] as String?)
            ?.dataFormat()
            .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 3:
        return (rideObj["start_time"] as String?)
            ?.dataFormat()
            .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 4:
        return (rideObj["start_time"] as String?)
            ?.dataFormat()
            .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 5:
        return (rideObj["stop_time"] as String?)
            ?.dataFormat()
            .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 6:
        return (rideObj["stop_time"] as String?)
            ?.dataFormat()
            .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 7:
        return (rideObj["stop_time"] as String?)
            ?.dataFormat()
            .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      default:
        return (rideObj["pickup_date"] as String?)
            ?.dataFormat()
            .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
    }
  }
}
