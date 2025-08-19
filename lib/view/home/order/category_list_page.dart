import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/controller/authController.dart';

import '../../../common/appContants.dart';
import '../../../common_widget/round_button.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {

  int selectIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      Get.find<AuthController>().getAllVehicleData();
      setState(() {

      });


    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(

         appBar: AppBar(
           backgroundColor: TColor.primary,
           title: Text("Select Vehicle",style: TextStyle(color: Colors.white),),
         ),
        body:  authController.isVehicle ? Center(child: CircularProgressIndicator(color: TColor.primary,),):
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: authController.vehicleData!=null && authController.vehicleData!.data!=null ? authController.vehicleData!.data!.length:0,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          itemBuilder: (context, index) {



            return  InkWell(
              onTap: (){

                setState(() {
                  selectIndex = index;
                });

              },
              child: Container(

                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: selectIndex == index ? TColor.primary: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex:3,
                        child: Image.network("${AppContants.imageURL}uploaded_files/category_img/${authController.vehicleData!.data![index].fileName}",height: 40,)),
                    Expanded(
                        flex:7,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${authController.vehicleData!.data![index].name??""}",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),),
                                  // Text("${authController.vehicleData!.data![index].model??""}",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),
                                  Text("${authController.vehicleData!.data![index].maxLoad??"0"} Kg",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),


                                ],
                              ),
                            ),

                          ],
                        ))


                  ],
                ),

              ),
            );
          },),

         bottomSheet: Padding(
           padding: const EdgeInsets.all(8.0),
           child: RoundButton(
             onPressed: () {

               authController.updateDriverVehicle(orderID: authController.vehicleData!.data![selectIndex].id.toString());

               //  context.push(  OTPView(number: txtMobile.text, code: countryCode.dialCode) );
             },
             title: "Save",
           ),
         ),
      ),
    );
  }
}
