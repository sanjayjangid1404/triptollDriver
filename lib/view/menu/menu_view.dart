import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/icon_title_cell.dart';
import 'package:taxi_driver/common_widget/menu_row.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/home/driver_my_rides_view.dart';
import 'package:taxi_driver/view/login/welcome_view.dart';
import 'package:taxi_driver/view/menu/earning_view.dart';
import 'package:taxi_driver/view/menu/ratings_view.dart';
import 'package:taxi_driver/view/menu/service_type_view.dart';
import 'package:taxi_driver/view/menu/settings_view.dart';
import 'package:taxi_driver/view/menu/summary_view.dart';
import 'package:taxi_driver/view/menu/wallet_view.dart';
import 'package:taxi_driver/view/user/user_my_rides_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (AuthController authController) =>
       Scaffold(
        body: Column(
          children: [
            authController.driverInResponse!=null ?
            Container(
              decoration: BoxDecoration(color: TColor.primaryText),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Image.asset(
                              "assets/img/close.png",
                              width: 20,
                              height: 20,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/img/question_mark.png",
                                width: 20,
                                height: 20,
                                color: Colors.white,
                              ),
                              Text(
                                "Help",
                                style: TextStyle(
                                  color: TColor.primaryTextW,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconTitleCell(
                              title: "Payment",
                              icon: "assets/img/earnings.png",
                              onPressed: () {
                                context.push(
                                  const EarningView(),
                                );
                              }),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                            onTap: (){
                                              context.push(const RatingsView() );
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
                                    ),),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      authController.driverInResponse!.firstName??"${authController.driverInResponse!.lastName??""}",
                                      style: TextStyle(
                                        color: TColor.primaryTextW,
                                        fontSize: 16,
                                      ),
                                    ),

                                    Text(
                                      authController.driverInResponse!.categoryName??"",
                                      style: TextStyle(
                                        color: TColor.primaryTextW,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconTitleCell(
                              title: "Wallet",
                              icon: "assets/img/wallet.png",
                              onPressed: () {

                                context.push(const WalletView());

                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ):SizedBox(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MenuRow(
                        title: "Home",
                        icon: "assets/img/home.png",
                        onPressed: () {}),
                    MenuRow(
                        title: "My Rides",
                        icon: "assets/img/summary.png",
                        onPressed: () {

                          // if(ServiceCall.userType == 1) {
                          //   context.push(const UserMyRidesView());
                          // }else{
                            context.push(const DriverMyRidesView());
                          // }

                        }),
                    MenuRow(
                        title: "Summary",
                        icon: "assets/img/summary.png",
                        onPressed: () {
                          context.push(const SummaryView());
                        }),
                    MenuRow(
                        title: "My Subscription",
                        icon: "assets/img/my_subscription.png",
                        onPressed: () {}),
                    MenuRow(
                        title: "Notifications",
                        icon: "assets/img/notification.png",
                        onPressed: () {}),
                    MenuRow(
                        title: "Settings",
                        icon: "assets/img/setting.png",
                        onPressed: () {
                          context.push(const SettingsView());
                        }),
                    MenuRow(
                        title: "Logout",
                        icon: "assets/img/logout.png",
                        onPressed: () {

                          Globs.udBoolSet(false, Globs.userLogin);
                          Globs.udSet({}, Globs.userPayload);
                          Get.find<AuthController>().logoutUser();

                         // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeView() ) , (route) => false);

                        }),
                    const SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
