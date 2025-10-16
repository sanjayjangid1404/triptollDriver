import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/login/otp_view.dart';
import 'package:taxi_driver/view/login/profile_image_view.dart';
import 'package:taxi_driver/view/login/sign_up_view.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../cubit/login_cubit.dart';
import '../home/home_view.dart';
import '../user/user_home_view.dart';
import 'forgot.dart';

Locale locale = const Locale('en', 'US');
class MobileNumberView extends StatefulWidget {
  const MobileNumberView({super.key});

  @override
  State<MobileNumberView> createState() => _MobileNumberViewState();
}

class _MobileNumberViewState extends State<MobileNumberView> {
  FlCountryCodePicker countryCodePicker = const FlCountryCodePicker();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController passwordMobile = TextEditingController();
  late CountryCode countryCode;
  bool _obscureText = true;
  AuthController authController = Get.find<AuthController>();
  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }
  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? lang = sharedPreferences.getString("app_language");

    if (lang == null || lang == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      authController.selectedLanguage.value = "English";
    } else if (lang == "தமிழ்" || lang == "Tamil") {
      Get.updateLocale(const Locale('ta', 'IN'));
      authController.selectedLanguage.value = 'தமிழ்';
    } else if (lang == "తెలుగు" || lang == "Telugu") {
      Get.updateLocale(const Locale('te', 'IN'));
      authController.selectedLanguage.value = 'తెలుగు';
    } else if (lang == "বাংলা" || lang == "Bengali") {
      Get.updateLocale(const Locale('bn', 'IN'));
      authController.selectedLanguage.value = 'বাংলা';
    } else {
      // Default fallback
      Get.updateLocale(const Locale('en', 'US'));
      authController.selectedLanguage.value = "English";
    }
  }
  Future<void> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfoPlugin.androidInfo;
        setState(() {
          Get.find<AuthController>().deviceId = androidInfo.id;
        });
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfoPlugin.iosInfo;
        setState(() {
          Get.find<AuthController>().deviceId = iosInfo.identifierForVendor ?? "Unknown";
        });
      }
    } catch (e) {
      setState(() {
        Get.find<AuthController>().deviceId = "Failed to get device ID: $e";
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLanguage();
    getDeviceId();
    countryCode = countryCodePicker.countryCodes
        .firstWhere((element) => element.name == "India");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) =>
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
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
                                            color: Color(0xFFEC6C0C),
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
                                    )
                                  ],
                                );
                              }));
                        });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.language,),
                      Text('Language'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Image.asset("assets/img/triptoll_name.png",height: 120,),
              Text(
                "Login Driver".tr,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 25,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      // final code =
                      //     await countryCodePicker.showPicker(context: context);
                      // if (code != null) {
                      //   countryCode = code;
                      //   setState(() {});
                      // }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 20,
                          child: countryCode.flagImage(),
                        ),
                        Text(
                          "  ${countryCode.dialCode}",
                          style:
                          TextStyle(color: TColor.primaryText, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: txtMobile,
                      keyboardType: TextInputType.phone,
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        // hintText: "9876543210",
                        hintText: "Enter Your Mobile Number".tr,
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                    ),
                  )
                ],
              ),
              const Divider(),

              TextField(
                controller: passwordMobile,
                keyboardType: TextInputType.text,
                obscureText: _obscureText,
                decoration:  InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: "Password".tr,
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // toggle password visibility
                      });
                    },
                  ),

                ),
              ),
              const Divider(),
              const SizedBox(
                height: 8,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to forget password screen
                    Get.to(Forgot());
                    print("Forget Password tapped");
                  },
                  child: Text(
                    "Forgot Password?".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      color: TColor.primary,
                      // decoration: TextDecoration.underline,
                      // decorationColor: AppColors.primaryGradient
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "By continuing, I confirm that i have read & agree to the".tr,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Terms & conditions".tr,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    " and ".tr,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    "Privacy policy".tr,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              RoundButton(
                onPressed: () {
                  if(txtMobile.text.isEmpty || txtMobile.text.length!=10){
                    mdShowAlert("Fail".tr, "Enter valid mobile no.".tr, () {});
                  }
                  else if(passwordMobile.text.isEmpty){
                    mdShowAlert("Fail".tr, "Enter password".tr, () {});
                  }
                  else {
                    authController.loginFunction(txtMobile.text, passwordMobile.text,authController.deviceId);
                    Future.delayed(Duration(seconds: 5),() {
                      authController.checkDriverDevice(authController.deviceId);
                    },);

                  }

                  //  context.push(  OTPView(number: txtMobile.text, code: countryCode.dialCode) );
                },
                title: "Login as Driver".tr,
              ),



              InkWell(
                onTap: (){

                  Get.to(SignUpView());

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("Create Account".tr,style: TextStyle(fontSize: 16,color: TColor.primary,decoration: TextDecoration.underline),),
                ),
              )

              // const SizedBox(
              //   height: 15,
              // ),
              // RoundButton(
              //   onPressed: () {
              //     context.push(  OTPView(number: txtMobile.text, code: countryCode.dialCode, isDriver: false,) );
              //   },
              //   title: "Login AS USER",
              // )
            ],
          ),
        ),
      ),
    );
  }

  void submitApiData() {
    context.read<LoginCubit>().submitLogin(passwordMobile.text, txtMobile.text, "driver");
  }
}
