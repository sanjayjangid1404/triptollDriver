import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taxi_driver/common/color_extension.dart';


import '../../common/appContants.dart';
import '../../controller/authController.dart';

class PaymentList extends StatefulWidget {
  const PaymentList({super.key});

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  int index = 0;
  AuthController authController  = Get.find<AuthController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // configureBackgroundGeolocation();
      Get.find<AuthController>().getPaymentList({
        "driver_id":authController.getUserID().toString(),
      });
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: TColor.primary,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Payment", style: TextStyle(fontSize: 18, color: Colors.white),),

        ),
        body: authController.paymentHistoryModel != null ?
        Column(
          children: [


            Expanded(
              child: ListView.builder(
                itemCount: authController.paymentResponse.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = authController.paymentResponse[index];
                  String createdAt = item.createdAt.toString();
                  DateTime dateTime = DateTime.parse(createdAt);
                  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Image.asset("assets/img/logo.png",)),

                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [

                                        Text(item.message.toString(),
                                          style: TextStyle(fontSize: 14,
                                              color: Colors.black),),
                                        Text('#${item.transactionId.toString()}',
                                          style: TextStyle(fontSize: 14,
                                              color: Colors.black),),
                                        Text(formattedDate, style: TextStyle(
                                            fontSize: 14,
                                            color: TColor.primary,
                                            fontWeight: FontWeight.w400),),

                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(item.paymentType.toString(),
                                        style: TextStyle(fontSize: 18,
                                            color: Colors.black),),
                                      Text("${AppContants.rupessSystem}${item.totalAmt ?? ''}",
                                        style: TextStyle(
                                            fontSize: 22, color: TColor.primary),),
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                },),
            )
          ],
        ) :Center(child: CircularProgressIndicator(color: TColor.primary,),),
      );
    });
  }
}
