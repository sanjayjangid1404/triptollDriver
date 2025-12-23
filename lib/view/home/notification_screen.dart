import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../controller/authController.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
 @override
  void initState() {
    super.initState();
    Get.find<AuthController>().getNotificationHistory({
      "user_type":'Driver',
      "city_id": Get.find<AuthController>().driverInResponse!.driverDetails!.cityId.toString(),
      "vehicle_category":Get.find<AuthController>().driverInResponse!.driverDetails!.categoryId.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        centerTitle: true,
        title: Text('Notification\'s'.tr,
          style: TextStyle(
              color: Colors.black
          ),),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          final model = Get.find<AuthController>().notificationHistoryModel.value;
          final notifications = model.notifications;
          if (model.status != true) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/not_found.json',
                height: 80,
              ),
            );
          }

          if (notifications == null || notifications.isEmpty) {
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/not_found.json',
                    height: 200,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      "New Notifications Not Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            shrinkWrap: true,
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            itemBuilder: (context, index) {
              final item = notifications[index];

              DateTime parsedDate = DateTime.parse(item.addDate.toString());
              String formattedDate =
              DateFormat('yyyy-MM-dd').format(parsedDate);

              return ListTile(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(
                  item.message.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
