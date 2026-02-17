import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/title_subtitle_cell.dart';
import '../../common/appContants.dart';
import '../../controller/authController.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int touchedIndex = -1;

  Map todayObj = {};
  Map weekObj = {};

  List todayTripsArr = [];

  List weeklyTripsArr = [];
  List weeklyChartArr = [];
  DateTime today = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;
  late DateTime startOfMonth;
  late DateTime endOfMonth;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    // apiList();
    DateTime today = DateTime.now();
    startDate = today.subtract(Duration(days: 6)); // last 7 days
    endDate = today;
    Get.find<AuthController>().getDailyEarningsFun(formattedDate.toString());
    Get.find<AuthController>().getBookingsBydateAndDriverFun(formattedDate.toString());
    Get.find<AuthController>().getLifetimeEarningsFun();
    Get.find<AuthController>().getDateRangeEarningsFun(
      stateDate: startDate.toString().split(' ')[0],
      endDate: endDate.toString().split(' ')[0],
    );
    DateTime now = DateTime.now();
    startOfMonth = DateTime(now.year, now.month, 1);
    endOfMonth = DateTime(now.year, now.month + 1, 0);
    Get.find<AuthController>().getDateRangeEarningsMonthFun(
      stateDate: startOfMonth.toString().split(' ')[0],
      endDate: endOfMonth.toString().split(' ')[0],
    );
  }
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // var todayTotal = double.tryParse(Get
    //     .find<AuthController>()
    //     .dailyEarningsMd.value
    //     .totalEarnings
    //     .toString()) ?? 0.0;
    var todayCashTotal =
        double.tryParse(todayObj["cash_amt"].toString()) ?? 0.0;
    var todayOnlineTotal =
        double.tryParse(todayObj["online_amt"].toString()) ?? 0.0;

    var weekTotal = double.tryParse(weekObj["total_amt"].toString()) ?? 0.0;
    var weekCashTotal = double.tryParse(weekObj["cash_amt"].toString()) ?? 0.0;
    var weekOnlineTotal =
        double.tryParse(weekObj["online_amt"].toString()) ?? 0.0;

    return Scaffold(
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
          "Summary".tr,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          TabBar(
            controller: controller,
            indicatorColor: TColor.primary,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            labelColor: TColor.primary,
            unselectedLabelColor: TColor.placeholder,
            labelStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            unselectedLabelStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            tabs:  [
              Tab(
                text: "TODAY".tr,
              ),
              Tab(
                text: "STATEMENT".tr,
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 0.5,
            color: TColor.lightGray,
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: TextButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.utc(2000, 1, 1),
                              lastDate: DateTime
                                  .now(), // sirf past aur today tak hi chalega
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _selectedDay = pickedDate;
                              });

                              String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                              // API call
                              Get.find<AuthController>().getDailyEarningsFun(
                                  formattedDate);
                              Get.find<AuthController>()
                                  .getBookingsBydateAndDriverFun(formattedDate);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDay == null
                                    ? "Select Date".tr
                                    : "${DateFormat('yyyy-MM-dd').format(
                                    _selectedDay!)}",
                                style: const TextStyle(
                                    fontSize: 16), // styling optional
                              ),
                              Text(
                                "Select Date".tr,
                                style: const TextStyle(fontSize: 14,
                                    color: Colors.grey), // styling optional
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() {
                        return Get
                            .find<AuthController>()
                            .dailyEarningsMd
                            .value
                            .status == true ?
                        Container(
                          color: TColor.lightWhite,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  width: double.maxFinite,
                                  height: 12,
                                  color: TColor.lightWhite,
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  DateTime.now().stringFormat(
                                      format: "EEE, dd MMM yy"),
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "₹",
                                      style: TextStyle(
                                          color: TColor.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      Get
                                          .find<AuthController>()
                                          .dailyEarningsMd
                                          .value
                                          .totalEarnings
                                          .toString(),
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      height: 0.5,
                                      color: TColor.lightGray,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TitleSubtitleCell(
                                            title:
                                            Get
                                                .find<AuthController>()
                                                .dailyEarningsMd
                                                .value
                                                .totalTrips
                                                .toString(),
                                            subtitle: "Trips".tr,
                                          ),
                                        ),
                                        Container(
                                          height: 80,
                                          width: 0.5,
                                          color: TColor.lightGray,
                                        ),
                                        Expanded(
                                          child: TitleSubtitleCell(
                                            title: Get
                                                .find<AuthController>()
                                                .dailyEarningsMd
                                                .value
                                                .totalHours
                                                .toString(),
                                            subtitle: "Total Hours".tr,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      height: 60,
                                      color: TColor.lightWhite,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "TRIPS".tr,
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Obx(() {
                                      return Get
                                          .find<AuthController>()
                                          .refreshInt > 0 ?
                                      ListView.separated(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        itemBuilder: (context, index) {
                                          var sObj = Get
                                              .find<AuthController>()
                                              .getBookingsBydateAndDriverModelList[index];

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      'Booking Time'.tr,
                                                      style: TextStyle(
                                                          color: TColor
                                                              .primaryText,
                                                          fontSize: 13),
                                                    ),
                                                    Text(
                                                      sObj.bookingDate != null
                                                          ? sObj.bookingDate!
                                                          .dataFormatttt(
                                                          format: "hh:mm a")
                                                          : "--",
                                                      style: TextStyle(
                                                          color: TColor
                                                              .primaryText,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w600),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      '₹${sObj.totalAmount
                                                          .toString()}',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: TColor
                                                              .primaryText,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      "${"Paid by".tr} ${ sObj.paymentType == 'cash' ? "cash".tr : "online".tr }",
                                                      style: TextStyle(
                                                          color: TColor
                                                              .secondaryText,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                        const Divider(
                                          indent: 0,
                                        ),
                                        itemCount: Get
                                            .find<AuthController>()
                                            .getBookingsBydateAndDriverModelList
                                            .length,
                                      ) :
                                      SizedBox.shrink();
                                    }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ) : SizedBox();
                      }),
                    ],
                  ),
                ),
                Container(
                  color: TColor.lightWhite,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Obx(() {
                          return Get
                              .find<AuthController>()
                              .weeklyEarn
                              .value
                              .status == true ?
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey
                                )
                            ),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('This Week'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                  ),
                                ),
                                Text('${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text('₹${Get
                                            .find<AuthController>()
                                            .weeklyEarn
                                            .value
                                            .totalEarnings
                                            .toString()}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Earnings'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(Get
                                            .find<AuthController>()
                                            .weeklyEarn
                                            .value
                                            .totalHours
                                            .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Total Hours'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(Get
                                            .find<AuthController>()
                                            .weeklyEarn
                                            .value
                                            .totalTrips
                                            .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Trips Taken'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ) :
                              SizedBox();
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        Obx(() {
                          return Get
                              .find<AuthController>()
                              .monthlyEarnModel
                              .value
                              .status == true ?
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey
                                )
                            ),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('This Month'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                  ),
                                ),
                                Text('${startOfMonth.toString().split(' ')[0]} to ${endOfMonth.toString().split(' ')[0]}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text('₹${Get
                                            .find<AuthController>()
                                            .monthlyEarnModel
                                            .value
                                            .totalEarnings
                                            .toString()}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Earnings'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(Get
                                            .find<AuthController>()
                                            .monthlyEarnModel
                                            .value
                                            .totalHours
                                            .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Total Hours'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(Get
                                            .find<AuthController>()
                                            .monthlyEarnModel
                                            .value
                                            .totalTrips
                                            .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Trips Taken'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ) :
                          SizedBox();
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        Obx(() {
                          return Get
                              .find<AuthController>()
                              .lifeTimeEarnModel
                              .value
                              .status == true ?
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey
                                )
                            ),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lifetime Statement'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text('₹${Get.find<AuthController>().lifeTimeEarnModel.value.totalEarnings.toString()}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Earnings'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(Get
                                            .find<AuthController>()
                                            .lifeTimeEarnModel
                                            .value
                                            .totalHours
                                            .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Total Hours'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(Get
                                            .find<AuthController>()
                                            .lifeTimeEarnModel
                                            .value
                                            .totalTrips
                                            .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text('Trips Taken'.tr,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ) :
                          SizedBox();
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(color: TColor.secondaryText, fontSize: 12);

    var obj = weeklyChartArr[value.toInt()] as Map? ?? {};

    return SideTitleWidget(
        space: 16,
        axisSide: meta.axisSide,
        child: Text(
          obj["date"].toString().stringFormatToOtherFormat(newFormat: "EEE"),
          style: style,
        ));
  }

  List<BarChartGroupData> showingGroups() =>
      weeklyChartArr.map((e) {
        var i = weeklyChartArr.indexOf(e);
        return makeGroupData(i,
            double.tryParse(e["total_amt"].toString()) ?? 0.0, TColor.primary,
            isTouched: i == touchedIndex);
      }).toList();

  BarChartGroupData makeGroupData(int x, double y, Color barColor,
      {bool isTouched = false,
        double width = 40,
        List<int> showTooltips = const []}) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: barColor,
          width: width,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.green, width: 0),
          backDrawRodData: BackgroundBarChartRodData(show: false))
    ]);
  }

  //TODO: ApiCalling
  void apiList() {
    Globs.showHUD();
    ServiceCall.post(
      {
        "driver_id": Get.find<AuthController>().getUserID(),
        "date": DateTime.now().stringFormat(format: "YYYY-MM-DD"),
      },
      AppContants.getDailyEarningsURL,
      isTokenApi: true,
      withSuccess: (responseObj) async {
        Globs.hideHUD();

        if (responseObj[KKey.status] == "1") {
          var payloadObj = responseObj[KKey.payload] as Map? ?? {};
          todayObj = payloadObj["today"] as Map? ?? {};
          weekObj = payloadObj["week"] as Map? ?? {};

          todayTripsArr = todayObj["list"] as List? ?? [];
          weeklyTripsArr = weekObj["list"] as List? ?? [];
          weeklyChartArr = (weekObj["chart"] as List? ?? []).reversed.toList();

          if (mounted) {
            setState(() {});
          }
        } else {
          mdShowAlert(
              "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
        }
      },
      failure: (err) async {
        Globs.hideHUD();
        debugPrint(err.toString());
      },
    );
  }
}
extension StringExtension on String {
  String dataFormatttt({String format = "hh:mm a"}) {
    try {
      final dateTime =
      DateFormat("yyyy-MM-dd HH:mm:ss").parse(this, true);
      return DateFormat(format).format(dateTime);
    } catch (e) {
      return this;
    }
  }
}
