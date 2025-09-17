import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

              Image.asset("assets/img/triptoll_name.png",height: 120,),
              Text(
                "Login Driver",
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
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        // hintText: "9876543210",
                        hintText: "Enter Your Mobile Number",
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
                  hintText: "Password",
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
                    "Forgot Password?",
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
                    "By continuing, I confirm that i have read & agree to the",
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
                    "Terms & conditions",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    " and ",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    "Privacy policy",
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
                    mdShowAlert("Fail", "Enter valid mobile no.", () {});
                  }
                  else if(passwordMobile.text.isEmpty){
                    mdShowAlert("Fail", "Enter password", () {});
                  }
                  else {
                    authController.loginFunction(txtMobile.text, passwordMobile.text);

                  }

                  //  context.push(  OTPView(number: txtMobile.text, code: countryCode.dialCode) );
                },
                title: "Login as Driver",
              ),



              InkWell(
                onTap: (){

                  Get.to(SignUpView());

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("Create Account",style: TextStyle(fontSize: 16,color: TColor.primary,decoration: TextDecoration.underline),),
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
