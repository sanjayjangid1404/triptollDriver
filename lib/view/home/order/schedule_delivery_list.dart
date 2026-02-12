import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/appContants.dart';
import '../../../controller/authController.dart';

class ScheduleDeliveryList extends StatefulWidget {
  bool isClick = false;
   ScheduleDeliveryList({super.key,required this.isClick});

  @override
  State<ScheduleDeliveryList> createState() => _ScheduleDeliveryListState();
}

class _ScheduleDeliveryListState extends State<ScheduleDeliveryList>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    if(widget.isClick == true){
      _tabController.index = 1;
      setState(() {

      });
    }
     Get.find<AuthController>().getScheduledOrderFun();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      if (_tabController.index == 0) {
        Get.find<AuthController>().getScheduledOrderFun();
      } else {
        Get.find<AuthController>().getMyScheduledOrderFun();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: const Text(
          'Scheduled Orders',
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: "Upcoming Scheduled"),
            Tab(text: "Accepted Deliveries"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ScheduledOrdersList(),
          AcceptedScheduledOrdersList(),
        ],
      ),
    );
  }
}
class ScheduledOrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Get.find<AuthController>().getScheduledOrderFun();
      },
      child: Obx(() {
        final model =
            Get.find<AuthController>().getScheduledOrderModel.value;
        final orders = model.data;

        if (model.status != true) {
          return Center(
            child: Lottie.asset('assets/lottie/not_found.json', height: 200),
          );
        }

        if (orders == null || orders.isEmpty) {
          return Center(child: Text("Scheduled Orders Not Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return ScheduledOrderCard(item: orders[index],isAccepted: false,);
          },
        );
      }),
    );
  }
}
class AcceptedScheduledOrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Get.find<AuthController>().getMyScheduledOrderFun();
      },
      child: Obx(() {
        final model =
            Get.find<AuthController>().getMyScheduleOrderModel.value;
        final orders = model.data;

        if (model.status != true) {
          return Center(
            child: Lottie.asset('assets/lottie/not_found.json', height: 200),
          );
        }

        if (orders == null || orders.isEmpty) {
          return Center(child: Text("Accepted Orders Not Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return ScheduledOrderCardMy(item: orders[index],isAccepted: true,);
          },
        );
      }),
    );
  }
}


class ScheduledOrderCard extends StatelessWidget {
  final dynamic item;
  final bool isAccepted;

  const ScheduledOrderCard({
    super.key,
    required this.item,
    this.isAccepted = false,
  });

  @override
  Widget build(BuildContext context) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isAccepted
                      ? Colors.orange.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAccepted ? "Accepted" : "Pending",
                  style: TextStyle(
                    color: isAccepted ? Colors.orange : Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                "#ORD-${item.id}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Address
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              Get.find<AuthController>().openGoogleMap(double.parse(
                  item.lat.toString()), double
                  .parse(item.lng.toString()));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.pickupAddress ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Date & Time
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(formattedDate),
              const SizedBox(width: 20),
              const Icon(Icons.access_time_outlined,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(formattedTime),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Customer Name :'),
              const SizedBox(width: 6),
              Expanded(child: Text(item.firstName ?? '',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              )),
            ],
          ),
          Row(
            children: [
              Text('Customer Phone No. :'),
              const SizedBox(width: 6),
              Expanded(
                  child: InkWell(
                    onTap: () async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: item.contactNumber ?? '',
                      );

                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      }
                    },
                    child: Text(item.contactNumber ?? '',
                                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      decoration: TextDecoration.underline
                                    ),
                                  ),
                  )),
            ],
          ),

          const Divider(height: 30),

          /// Amount
          Text(
            "${AppContants.rupessSystem} ${item.totalAmount ?? ""}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),


          if (!isAccepted) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      AuthController authController  = Get.find<AuthController>();
                      authController.isLoadingTime = prefs.getBool(AppContants.isLoadingTime)!;
                      print('dsdskdsds${authController.isLoadingTime.toString()}');
                      authController.maxTime = prefs.getString(AppContants.maxTimeVar)!;
                      authController.loadingCharges = prefs.getString(AppContants.loadingCharges)!;
                      authController.checkDriverBooking(context);
                      Navigator.pop(context);
                      Get.find<AuthController>().accpetBooking(
                          orderID: item.id.toString(),
                          cus_id:authController.getUserID(),
                          value: 0
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
class ScheduledOrderCardMy extends StatelessWidget {
  final dynamic item;
  final bool isAccepted;

  const ScheduledOrderCardMy({
    super.key,
    required this.item,
    this.isAccepted = false,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (item.scheduleDate != null && item.scheduleDate!.isNotEmpty) {
      DateTime date = DateTime.parse(item.scheduleDate!);
      formattedDate = DateFormat('dd-MM-yyyy').format(date);
    }

    String formattedTime = '';
    String formattedTimeMinus10 = '';
    if (item.scheduleTime != null && item.scheduleTime!.isNotEmpty) {
      DateTime time =
      DateFormat("HH:mm:ss").parse(item.scheduleTime!);
      formattedTime = DateFormat('hh:mm a').format(time);
      DateTime minus10Time = time.subtract(const Duration(minutes: 30));
      formattedTimeMinus10 = DateFormat('hh:mm a').format(minus10Time);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isAccepted
                      ? Colors.orange.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAccepted ? "Accepted" : "Pending",
                  style: TextStyle(
                    color: isAccepted ? Colors.orange : Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                "#ORD-${item.id}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Address
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              Get.find<AuthController>().openGoogleMap(double.parse(
                  item.lat.toString()), double
                  .parse(item.lng.toString()));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 'Pickup Address :',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.pickupAddress ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Date & Time
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(formattedDate),
              const SizedBox(width: 20),
              const Icon(Icons.access_time_outlined,
                  size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(formattedTime),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Sender Name :'),
              const SizedBox(width: 6),
              Expanded(child: Text(item.senderName ?? '',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16
              ),
              )),
            ],
          ),
          Row(
            children: [
              Text('Sender Phone No. :'),
              const SizedBox(width: 6),
              Expanded(
                  child: InkWell(
                    onTap: () async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: item.senderContactNumber ?? '',
                      );

                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      }
                    },
                    child: Text(item.senderContactNumber ?? '',
                                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      decoration: TextDecoration.underline
                                    ),
                                  ),
                  )),
            ],
          ),
          Row(
            children: [
              Text('Customer Name :'),
              const SizedBox(width: 6),
              Expanded(child: Text(item.firstName ?? '',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              )),
            ],
          ),
          Row(
            children: [
              Text('Customer Phone No. :'),
              const SizedBox(width: 6),
              Expanded(
                  child: InkWell(
                    onTap: () async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: item.contactNumber ?? '',
                      );

                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      }
                    },
                    child: Text(item.contactNumber ?? '',
                                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      decoration: TextDecoration.underline
                                    ),
                                  ),
                  )),
            ],
          ),

          const Divider(height: 30),

          /// Amount
          Text(
            "${AppContants.rupessSystem} ${item.totalAmount ?? ""}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          if (isAccepted) ...[
            const SizedBox(height: 16),
            Text(
              'Order details will be shown after ${formattedTimeMinus10.toString()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
          if (!isAccepted) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      AuthController authController  = Get.find<AuthController>();
                      authController.isLoadingTime = prefs.getBool(AppContants.isLoadingTime)!;
                      print('dsdskdsds${authController.isLoadingTime.toString()}');
                      authController.maxTime = prefs.getString(AppContants.maxTimeVar)!;
                      authController.loadingCharges = prefs.getString(AppContants.loadingCharges)!;
                      authController.checkDriverBooking(context);
                      Navigator.pop(context);
                      Get.find<AuthController>().accpetBooking(
                          orderID: item.id.toString(),
                          cus_id:authController.getUserID(),
                          value: 0
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
