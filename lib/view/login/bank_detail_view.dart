import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/custom_snackbar.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/login/document_upload_view.dart';

import 'mobile_number_view.dart';

class BankDetailView extends StatefulWidget {
  String driverID;
  bool isEdit;
   BankDetailView({super.key,required this.driverID,this.isEdit =false});

  @override
  State<BankDetailView> createState() => _BankDetailViewState();
}

class _BankDetailViewState extends State<BankDetailView> {
  TextEditingController txtBankName = TextEditingController();
  TextEditingController txtAccountHolderName = TextEditingController();
  TextEditingController txtAccountNumber = TextEditingController();
  TextEditingController txtSwiftCode = TextEditingController();
  TextEditingController txtUPICode = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AuthController authController = Get.find<AuthController>();

    if(widget.isEdit && authController.driverInResponse!=null){
      txtBankName.text = authController.driverInResponse!.driverDetails!.bankName??"";
      txtAccountNumber.text = authController.driverInResponse!.driverDetails!.accountNo??"";
      txtUPICode.text = authController.driverInResponse!.driverDetails!.upiId??"";
      txtSwiftCode.text = authController.driverInResponse!.driverDetails!.ifscCode??"";

      setState(() {

      });
    }
   // getBankDetail();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
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
            "Bank Details",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 25,
                fontWeight: FontWeight.w800),
          ),
          actions: [
          !widget.isEdit ?
          InkWell(
              onTap: (){

                showCustomSnackBar("Account Created please Login",isError: false);
                Get.offAll(MobileNumberView());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 8),
                child: Text("Skip",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
              ),
            ):SizedBox()
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                LineTextField(
                  readyOnly: authController.isKyc(),
                  title: "Bank Name",
                  hintText: "Ex: SBI",
                  controller: txtBankName,
                ),
                const SizedBox(
                  height: 8,
                ),
                LineTextField(
                  readyOnly: authController.isKyc(),
                  title: "Account Holder name",
                  hintText: "Ex: A Patel",
                  controller: txtAccountHolderName,
                ),
                const SizedBox(
                  height: 8,
                ),
                LineTextField(
                  readyOnly: authController.isKyc(),
                  title: "Account Number",
                  hintText: "Ex: 12345678945245",
                  controller: txtAccountNumber,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 8,
                ),
                LineTextField(
                  readyOnly: authController.isKyc(),
                  title: "IFSC Code",
                  hintText: "YT123C",
                  controller: txtSwiftCode,
                ),
                const SizedBox(
                  height: 8,
                ),

                LineTextField(
                  readyOnly: authController.isKyc(),
                  title: "UPI",
                  hintText: "",
                  controller: txtUPICode,
                ),
                const SizedBox(
                  height: 8,
                ),
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
                    /*driver_id:2376
bank_name:Axis Bank
ifsc_code:UTIB00892
account_no:60382736268462
upi_id:viren@axis*/
                    var body = {
                      "driver_id":widget.driverID,
                      "bank_name":txtBankName.text,
                      "ifsc_code":txtSwiftCode.text,
                      "account_no":txtAccountNumber.text,
                      "upi_id":txtUPICode.text,
                      "account_holder":txtAccountHolderName.text,

                    };
                    authController.updateDriverBankDetail(body,isEdit: widget.isEdit,context);

                   // updateAction();
                    // context.push(const DocumentUploadView(title: "Personal Document" ),);
                  },
                  title: "Submit",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: Button Action

  void updateAction() {
    if (txtBankName.text.isEmpty) {
      mdShowAlert("Error", "Please enter bank name", () {});
      return;
    }

    if (txtAccountHolderName.text.isEmpty) {
      mdShowAlert("Error", "Please enter account holder name", () {});
      return;
    }

     if (txtAccountNumber.text.isEmpty) {
      mdShowAlert("Error", "Please enter account number", () {});
      return;
    }

    if (txtSwiftCode.text.isEmpty) {
      mdShowAlert("Error", "Please enter Bank Swift/IFSC Code", () {});
      return;
    }

    endEditing();

    updateBankDetail({
      "account_name": txtAccountHolderName.text,
      "ifsc": txtSwiftCode.text,
      "account_no": txtAccountNumber.text,
      "bank_name": txtBankName.text,
    });
  }

  //TODO:Service Call
  void getBankDetail() {
    Globs.showHUD();
    ServiceCall.post({}, SVKey.svBankDetail, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        var payload = responseObj[KKey.payload] as Map? ?? {};
        setState(() {
          txtAccountHolderName.text = payload["account_name"] as String? ?? "";
          txtAccountNumber.text = payload["account_no"] as String? ?? "";
          txtBankName.text = payload["bank_name"] as String? ?? "";
          txtSwiftCode.text = payload["bsb"] as String? ?? "";
        });
      } else {
        mdShowAlert(
            "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err, () {});
    });
  }

  void updateBankDetail(Map<String, dynamic> parameter) {
    Globs.showHUD();
    ServiceCall.post(parameter, SVKey.svDriverBankDetailUpdate, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();

      if (responseObj[KKey.status] == "1") {
        mdShowAlert("Success",
            responseObj[KKey.message] as String? ?? MSG.success, () {});
      } else {
        mdShowAlert(
            "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err, () {});
    });
  }
}
