import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/icon_title_cell.dart';
import 'package:taxi_driver/common_widget/menu_row.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/home/driver_my_rides_view.dart';
import 'package:taxi_driver/view/home/home_view.dart';
import 'package:taxi_driver/view/login/welcome_view.dart';
import 'package:taxi_driver/view/menu/earning_view.dart';
import 'package:taxi_driver/view/menu/ratings_view.dart';
import 'package:taxi_driver/view/menu/service_type_view.dart';
import 'package:taxi_driver/view/menu/settings_view.dart';
import 'package:taxi_driver/view/menu/summary_view.dart';
import 'package:taxi_driver/view/menu/wallet_view.dart';
import 'package:taxi_driver/view/user/user_my_rides_view.dart';

import '../../common/appContants.dart';
import '../../common_widget/setting_row.dart';
import '../home/support/faq.dart';
import '../login/bank_detail_view.dart';
import '../login/document_upload_view.dart';
import '../login/mobile_number_view.dart';
import '../payment/payment_list.dart';
import 'change_password_view.dart';
import 'my_profile_view.dart';
import 'my_vehicle_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (AuthController authController) =>
       Scaffold(
         backgroundColor: TColor.lightWhite,
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
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FaqScreen(),));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/img/question_mark.png",
                                  width: 20,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Help".tr,
                                  style: TextStyle(
                                    color: TColor.primaryTextW,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
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
                                context.push(const SummaryView());
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
                                      child:authController.driverInResponse!=null && authController.driverInResponse!.driverDetails!.file_name!=null && authController.driverInResponse!.driverDetails!.file_name!.isNotEmpty ?
                                      Image.network("${AppContants.imageURL}uploaded_files/user_img/${authController.driverInResponse!.driverDetails!.file_name!}", width: 100,
                                        height: 100,fit: BoxFit.cover,): Image.asset(
                                        "assets/img/u1.png",
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                   InkWell(
                                            onTap: (){
                                              // context.push(const RatingsView() );
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
                                             authController.driverInResponse!=null && authController.driverInResponse!.driverDetails!.ratings!=null && authController.driverInResponse!.driverDetails!.ratings!.isNotEmpty ?"${authController.driverInResponse!.driverDetails!.ratings!}":"",
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
                                      authController.driverInResponse!.driverDetails!.firstName??"${authController.driverInResponse!.driverDetails!.lastName??""}",
                                      style: TextStyle(
                                        color: TColor.primaryTextW,
                                        fontSize: 16,
                                      ),
                                    ),

                                    Text(
                                      authController.driverInResponse!.driverDetails!.categoryName??"",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuRow(
                        title: "Home",
                        icon: "assets/img/home.png",
                        onPressed: () {

                          Get.offAll(HomeView());
                        }),
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

                    Container(
                      width: double.infinity,
                      color: TColor.primary.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          "Account",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    MenuRow(
                        title: "My Profile",
                        icon: "assets/img/sm_profile.png",
                        onPressed: () {
                          context.push(const MyProfileView());
                        }),
                    MenuRow(
                        title: "My Vehicle",
                        icon: "assets/img/sm_my_vehicle.png",
                        onPressed: () {
                          context.push(const MyVehicleView());
                        }),
                    MenuRow(
                        title: "Personal Documents",
                        icon: "assets/img/sm_document.png",
                        onPressed: () {
                          context.push(
                              DocumentUploadView(title: "Personal Document",id: authController.getUserID()??"",isEdit: true,));
                        }),
                    MenuRow(
                        title: "Bank details",
                        icon: "assets/img/sm_bank.png",
                        onPressed: () {
                          context.push( BankDetailView(driverID: authController.getUserID()??"",isEdit: true,));
                        }),
                    MenuRow(
                        title: "Change Password",
                        icon: "assets/img/sm_password.png",
                        onPressed: () {
                          context.push(const ChangePasswordView());
                        }),
                    MenuRow(
                        title: "Earnings",
                        icon: "assets/img/summary.png",
                        onPressed: () {
                          context.push(const SummaryView());
                        }),

                    Container(
                      width: double.infinity,
                      color: TColor.primary.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          "Earnings".tr,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    MenuRow(
                      title: "Language",
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                  child: Obx(() {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: const Color(0xffDCDCDC)),
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: RadioListTile(
                                                title: Text('English'.tr),
                                                activeColor: const Color(0xff014E70),
                                                value: "English",
                                                groupValue: authController.selectedLanguage.value,
                                                onChanged: (value) {
                                                  locale = const Locale('en', 'US');
                                                  authController.selectedLanguage.value = value!;
                                                  updateLanguage("English");
                                                  setState(() {});
                                                },
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xffDCDCDC)),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: RadioListTile(
                                              title: Text('हिन्दी'.tr),
                                              activeColor: const Color(0xff014E70),
                                              value: "Hindi",
                                              groupValue: authController.selectedLanguage.value,
                                              onChanged: (value) {
                                                locale = const Locale('hi', 'IN');
                                                authController.selectedLanguage.value = value!;
                                                updateLanguage("Hindi");
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20, right: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xffDCDCDC)),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: RadioListTile(
                                              title: Text('தமிழ்'.tr),
                                              activeColor: const Color(0xff014E70),
                                              value: "தமிழ்",
                                              groupValue: authController.selectedLanguage.value,
                                              onChanged: (value) {
                                                locale = const Locale('ta', 'IN');
                                                authController.selectedLanguage.value = value!;
                                                updateLanguage("தமிழ்");
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20, right: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xffDCDCDC)),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: RadioListTile(
                                              title: Text('বাংলা'.tr),
                                              activeColor: const Color(0xff014E70),
                                              value: "বাংলা",
                                              groupValue: authController.selectedLanguage.value,
                                              onChanged: (value) {
                                                locale = const Locale('bn', 'BD');
                                                authController.selectedLanguage.value = value!;
                                                updateLanguage("বাংলা");
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20, right: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xffDCDCDC)),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: RadioListTile(
                                              title: Text('తెలుగు'.tr),
                                              activeColor: const Color(0xff014E70),
                                              value: "తెలుగు",
                                              groupValue: authController.selectedLanguage.value,
                                              onChanged: (value) {
                                                locale = const Locale('te', 'IN');
                                                authController.selectedLanguage.value = value!;
                                                updateLanguage("తెలుగు");
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),

                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Padding(
                                        //     padding: const EdgeInsets.only(left: 20, right: 20),
                                        //     child: Container(
                                        //         decoration: BoxDecoration(
                                        //             border: Border.all(color: const Color(0xffDCDCDC)),
                                        //             borderRadius: BorderRadius.circular(15)),
                                        //         child: RadioListTile(
                                        //           title: const Text('Several languages'),
                                        //           activeColor: const Color(0xff014E70),
                                        //           value: "Several languages",
                                        //           groupValue: language.value,
                                        //           onChanged: (value) {
                                        //             print(selectedLAnguage.value.toString());
                                        //             setState(() {
                                        //               language.value = value!;
                                        //             });
                                        //           },
                                        //         ))),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.updateLocale(locale);
                                            Get.back();
                                          },
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                              child: Container(
                                                height: 56,
                                                width: MediaQuery.sizeOf(context).width,
                                                color: Colors.green,
                                                child: Center(
                                                  child: Text(
                                                    'Apply'.tr,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    );
                                  }));
                            });
                      },
                      icon: "assets/img/language.png",
                    ),
                    MenuRow(
                        title: "Setting",
                        icon: "assets/img/setting.png",
                        onPressed: () {
                          context.push(const SettingsView());
                        }),
                    // MenuRow(
                    //     title: "Notifications",
                    //     icon: "assets/img/notification.png",
                    //     onPressed: () {
                    //
                    //     }),

                    MenuRow(
                        title: "Logout",
                        icon: "assets/img/logout.png",
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          Globs.udBoolSet(false, Globs.userLogin);
                          Globs.udSet({}, Globs.userPayload);
                          authController.changeLoginStatus(
                            status: "offline",
                            context: context,
                          );
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
