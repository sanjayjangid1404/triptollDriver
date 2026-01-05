import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/home/home_view.dart';
import 'package:taxi_driver/view/home/order/category_list_page.dart';
import 'package:taxi_driver/view/login/mobile_number_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {


  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);


    getToken();
    super.initState();
    print('calll:::::::splash');
    load();
   
  }

  getToken()async{
    String? token = "";

    token =  await AppContants.getToken();

    setState(() {

    });

    print(token);
  }

  void load() async {
    await Future.delayed(const Duration(seconds: 3));
    loadNextScreen();
  }

  void loadNextScreen() {

    if(Get.find<AuthController>().isLoggedIn()){

      if(Get.find<AuthController>().isCategoryID()){
        context.push(const HomeView());
      }
      else {
        context.push(const CategoryListPage());
      }



    }
    else {
      context.push(const MobileNumberView());
    }
    // if (Globs.udValueBool(Globs.userLogin)) {
    //   if (ServiceCall.userType == 2) {
    //     //Driver Login
    //     if (ServiceCall.userObj[KKey.status] == 1) {
    //       context.push(const HomeView());
    //     } else {
    //       context.push(const ProfileImageView());
    //     }
    //   } else {
    //     //User Login
    //     context.push(const UserHomeView());
    //   }
    // } else {
    //   context.push(const MobileNumberView());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),
          Image.asset(
            "assets/img/logo.png",
            width: 100,
            height: 100,
          )
        ],
      ),
    );
  }
}
