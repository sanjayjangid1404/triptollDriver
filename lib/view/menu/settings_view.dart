import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common_widget/setting_row.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/home/support/support_list_view.dart';
import 'package:taxi_driver/view/login/bank_detail_view.dart';
import 'package:taxi_driver/view/login/document_upload_view.dart';
import 'package:taxi_driver/view/menu/change_password_view.dart';
import 'package:taxi_driver/view/menu/contact_us_view.dart';
import 'package:taxi_driver/view/menu/my_profile_view.dart';
import 'package:taxi_driver/view/menu/my_vehicle_view.dart';
import 'package:taxi_driver/view/page/refund.dart';
import 'package:taxi_driver/view/page/terms_and_condition.dart';

import '../home/faq_list_screen.dart';
import '../page/privacy.dart';
import '../page/shipping.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
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
          centerTitle: true,
          title: Text(
            "Settings",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        backgroundColor: TColor.lightWhite,
        body:authController.getUserID()!=null && authController.getUserID()!.isNotEmpty ?
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  "HELP",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SettingRow(
                  title: "Terms & Conditions",
                  icon: "assets/img/sm_document.png",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndCondition(),));
                  }),
              SettingRow(
                  title: "Privacy Policies",
                  icon: "assets/img/sm_document.png",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage(),));
                  }),

              SettingRow(
                  title: "Refund Policy",
                  icon: "assets/img/sm_profile.png",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Refund(),));
                  }),

              SettingRow(
                  title: "Shipping Policy",
                  icon: "assets/img/sm_profile.png",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Shipping(),));
                  }),
              SettingRowIcon(
                icon: Icon(Icons.info_outline,color: Colors.grey,),
                title: '  FAQ',
                onPressed: () => Get.to(FrequentlyAskedQuestionsScreen()),
              ),

            ],
          ),
        ):SizedBox(),
      ),
    );
  }
}
