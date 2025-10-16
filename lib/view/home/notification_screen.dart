import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  final List<Map<String, String>> notifications = [
    {
      "title": "Order Delivered",
      "message": "Your order #12345 has been successfully delivered.",
      "time": "10:30 AM"
    },
    {
      "title": "New Offer!",
      "message": "Get 20% off on your next ride. Limited time only!",
      "time": "Yesterday"
    },
    {
      "title": "Payment Successful",
      "message": "₹450 has been deducted from your wallet.",
      "time": "2 days ago"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        centerTitle: true,
        title: Text('Notification\'s'.tr,
        style: TextStyle(
          color: Colors.black
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: notifications.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return ListTile(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text(
                item["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(item["message"]!),
              trailing: Text(
                item["time"]!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            );
          },
        ),
          ],
        ),
      ),
    );
  }
}
