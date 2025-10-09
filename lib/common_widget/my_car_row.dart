import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/controller/authController.dart';

class MyCarRow extends StatelessWidget {



  const MyCarRow({super.key});

  @override
  Widget build(BuildContext context) {


    return GetBuilder<AuthController>(
      builder: (authController) =>
       Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: InkWell(

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${ authController.driverInResponse!.driverDetails!.categoryName?? ""} - ${authController.driverInResponse!.driverDetails!.vehicleType ?? ""} ",
                      style: TextStyle(color: TColor.primaryText, fontSize: 16),
                    ),
                    Text(
                      " ${authController.driverInResponse!.driverDetails!.vehicleNumber ?? ""}",
                      style: TextStyle(color: TColor.secondaryText, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),

              if( "${authController.driverInResponse!.driverDetails!.runningOrder}"  == "1" )
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.pin_drop_outlined,
                  color: TColor.primary,
                  size: 25,
                ),
              ),

              if (authController.driverInResponse!.driverDetails!.vehicleImg != "")
                CachedNetworkImage(
                  imageUrl: AppContants.imageURL + (authController.driverInResponse!.driverDetails!.vehicleImg ?? ""),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,

                  /// जब तक image load हो रही है
                  placeholder: (context, url) => Image.asset(
                    "assets/img/images.jpg",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  /// अगर image load fail हो जाए
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        "assets/img/images.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),


                )

              // Image.asset(
              //   cObj["image"] as String? ?? "",
              //   width: 50,
              //   height: 50,
              //   fit: BoxFit.cover,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
