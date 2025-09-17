import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/icon_title_row.dart';
import 'package:taxi_driver/common_widget/title_subtitle_cell.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/menu/edit_profile_view.dart';
import 'package:taxi_driver/view/menu/ratings_view.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {

  bool isKyc = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        backgroundColor: TColor.lightWhite,
        appBar: AppBar(
          backgroundColor: const Color(0xff282F39),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 25,
              height: 25,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.push(const EditProfileView());
              },
              icon: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.width * 0.6,
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.width * 0.35,
                      color: const Color(0xff282F39),
                    ),
                  ),
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 2)
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                      authController.driverInResponse!.firstName??"${authController.driverInResponse!.lastName??""}",
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    height: 0.5,
                                    width: double.maxFinite,
                                    color: TColor.lightGray,
                                  ),
                                  Row(
                                    children: [
                                       Expanded(
                                        child: TitleSubtitleCell(
                                            title: "${authController.driverInResponse!.categoryName??""}",
                                            subtitle:"${authController.driverInResponse!.vehicleType??""}"),
                                      ),
                                      Container(
                                        height: 60,
                                        width: 0.5,
                                        color: TColor.lightGray,
                                      ),
                                       Expanded(
                                        child: TitleSubtitleCell(
                                            title: "${authController.driverInResponse!.weightName??"0"}", subtitle: "${authController.driverInResponse!.weightType??"KG"}"),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/img/u1.png",
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.push(const RatingsView());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/img/rate_profile.png",
                                        width: 15,
                                        height: 15,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "4.89",
                                        style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  "PERSONAL INFO",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  children: [
                    IconTitleRow(
                        icon: "assets/img/phone.png", title: "${authController.driverInResponse!.contactNumber??""}", onPressed: () {}),
                    IconTitleRow(
                        icon: "assets/img/email.png", title: "${authController.driverInResponse!.email??""}", onPressed: () {}),
                    // IconTitleRow(
                    //     icon: "assets/img/language.png", title: "English and Spanish", onPressed: () {}),
                    IconTitleRow(
                        icon: "assets/img/home.png", title: "${authController.driverInResponse!.address??""}", onPressed: () {}),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
