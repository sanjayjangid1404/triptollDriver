import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {


      // configureBackgroundGeolocation();
      Get.find<AuthController>().paymentHistory();





      setState(() {

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: TColor.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Payment",style: TextStyle(fontSize: 18,color: Colors.white),),

      ),
      body: Column(
        children: [


          Expanded(
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
            
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
                          flex:1,
                          child: Image.asset("assets/img/logo.png",)),
            
                      Expanded(
                          flex:8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
            
                                      Text("Amount Of ORD-449",style: TextStyle(fontSize: 14,color: Colors.black),),
                                      Text("07 Jun 2025",style: TextStyle(fontSize: 14,color: TColor.primary,fontWeight: FontWeight.w400),),
            
                                    ],
                                  ),
                                ),
            
                                Text("${AppContants.rupessSystem}400",style: TextStyle(fontSize: 22,color: TColor.primary),)
                              ],
                            ),
                          ))
                    ],
                  ),
                );
            
            },),
          )
        ],
      ),
    );
  }
}
