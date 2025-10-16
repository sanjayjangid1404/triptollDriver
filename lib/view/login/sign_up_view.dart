import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/custom_snackbar.dart';
import 'package:taxi_driver/common_widget/line_text_field.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/login/bank_detail_view.dart';
import 'package:taxi_driver/view/login/vehicle_document_view.dart';

import '../../model/city_response.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  FlCountryCodePicker countryCodePicker = const FlCountryCodePicker();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController otpCt = TextEditingController();
  // TextEditingController txtHomeAddress = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController emailCt = TextEditingController();
  TextEditingController referralCt = TextEditingController();
  late CountryCode countryCode;
  TextEditingController txtPassword = TextEditingController();
  bool isSHowOTP = false;
  bool otpVerify = false;
  bool _isPasswordVisible = false;
  CityResponse? selectedCategory;
  String OTP = "";
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery); // gallery ya camera
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  } Future<void> _pickImageCamera() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera); // gallery ya camera
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    countryCode = countryCodePicker.countryCodes
        .firstWhere((element) => element.name == "India");

    WidgetsBinding.instance.addPostFrameCallback((_) {

      Get.find<AuthController>().getCity();
      setState(() {

      });


    });
  }


  bool isLoading = false;
  String apiResponse = "";

  Future<void> sendOtp() async {
    setState(() {
      isLoading = true;
      apiResponse = "";
    });

     String apiUrl =
        "${AppContants.baseURl}${AppContants.sendDriverOTPURL}";
     print(apiUrl);
     print({
       "contact_number": txtMobile.text,
     });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "contact_number": txtMobile.text,
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        startTimer();


        setState(() {
          OTP = data["otp_code"].toString();
          apiResponse = data.toString();
          isSHowOTP = true;
          print(OTP);
        });
      } else {
        setState(() {
          apiResponse = "Error: ${response.statusCode}";
          isSHowOTP = true;
        });
      }
    } catch (e) {
      setState(() {
        apiResponse = "Exception: $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool isOtpButtonEnabled = true; // by default enabled
  int secondsRemaining = 0;
  Timer? _timer;

  void startTimer() {
    setState(() {
      isOtpButtonEnabled = false;
      secondsRemaining = 30;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 1) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          isOtpButtonEnabled = true;
          secondsRemaining = 0;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create profile".tr,
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 25,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 30,
                ),

                Center(
                  child: Stack(
                    children: [
                      // Circular profile image
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                        _image != null ? FileImage(_image!) : null, // show picked image
                        child: _image == null
                            ? Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                      // Edit button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickDocumentImage,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15,),
                LineTextField(
                  title: "First name",
                  hintText: "Ex: Amit",
                  controller: txtFirstName,

                ),
                const SizedBox(
                  height: 8,
                ),

                LineTextField(
                  title: "Last name".tr,
                  hintText: "Ex: Patel",
                  controller: txtLastName,

                ),
                const SizedBox(
                  height: 8,
                ),

                authController.cityResponse.isNotEmpty ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<CityResponse>(
                      value: selectedCategory,
                      hint: Text("City".tr),
                      items: authController.cityResponse!.map((category) {
                        return DropdownMenuItem<CityResponse>(
                          value: category,
                          child: Text(category.name!),
                        );
                      }).toList(),
                      onChanged: (value){

                        selectedCategory = value;

                        setState(() {

                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                      isExpanded: true,
                    ),
                    Container(
                      color: TColor.lightGray,
                      height: 0.5,
                      width: double.maxFinite,
                    ),
                  ],
                ):SizedBox(),
                const SizedBox(
                  height: 8,
                ),

                Text(
                  "Mobile Number".tr,
                  style: TextStyle(color: TColor.placeholder, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        final code =
                            await countryCodePicker.showPicker(context: context);
                        if (code != null) {
                          countryCode = code;
                          setState(() {});
                        }
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
                        maxLength: 10,
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          counter: SizedBox(),
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                          hintText: "Enter Your Phone Number".tr,
                          suffixIcon: InkWell(
                            onTap: isOtpButtonEnabled
                                ? () {
                              if (txtMobile.text.isNotEmpty &&
                                  txtMobile.text.length == 10) {
                                sendOtp();
                                setState(() {
                                  otpVerify = false;
                                });
                              } else {
                                showCustomSnackBar("Invalid Mobile no".tr);
                              }
                            }
                                : null,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                isOtpButtonEnabled
                                    ? "GET OTP".tr
                                    : "${'Retry in'.tr} $secondsRemaining s", // timer dikhega
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isOtpButtonEnabled ? Colors.green : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        ),
                      ),
                    )
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 8,
                ),

               isSHowOTP ?  Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "OTP".tr,
                      style: TextStyle(color: TColor.placeholder, fontSize: 14),
                    ),
                    TextField(
                      controller: otpCt,
                      keyboardType: TextInputType.phone,
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "Enter Otp Here".tr,
                          hintStyle: TextStyle(color: Colors.grey)  ,
                          suffixIcon:otpVerify ? SizedBox(): InkWell(
                            onTap: (){

                              if(otpCt.text.isNotEmpty && otpCt.text.length ==6 && otpCt.text == OTP) {
                                setState(() {
                                  otpVerify = true;
                                });
                                showCustomSnackBar("OTP Verify".tr,isError: false);
                              }
                              else {
                                showCustomSnackBar("Invalid OTP".tr);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text("Verify".tr,style: TextStyle(fontSize: 14,color: Colors.green,fontWeight: FontWeight.bold),),
                            ),
                          )


                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ):SizedBox(),


                LineTextField(
                  title: "Email",
                  hintText: "Ex: triptoll@gmail.com",
                  controller: emailCt,
                ),

                const SizedBox(
                  height: 8,
                ),
                LineTextField(
                  title: "Password",
                  hintText: "******",
                  controller: txtPassword,
                  obscureText: !_isPasswordVisible, // toggle hide/show
                  right: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // change state
                      });
                    },
                    icon: Image.asset(
                      _isPasswordVisible
                          ? "assets/img/password_hide.png" // icon when visible
                          : "assets/img/password_show.png", // icon when hidden
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),

                 const SizedBox(
                  height: 8,
                ),
                LineTextField(
                  title: "Referral code".tr,
                  hintText: "Enter Referral Code".tr,
                  controller: referralCt,
                ),
                const SizedBox(
                  height: 8,
                ),

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
                authController.isUploading ? Center(child: CircularProgressIndicator(color: TColor.primary,),):  RoundButton(
                  onPressed: () {

                    if(txtFirstName.text.isEmpty){
                      showCustomSnackBar("Enter first name".tr);
                    }else if(txtLastName.text.isEmpty){
                      showCustomSnackBar("Enter last name".tr);
                    }
                    else if(txtMobile.text.isEmpty){
                      showCustomSnackBar("Enter mobile number".tr);
                    }
                    else if(selectedCategory==null){
                      showCustomSnackBar("Select city".tr);
                    }else if(emailCt.text.isEmpty){
                      showCustomSnackBar("Enter valid email".tr);
                    }
                    else if(emailCt.text.isEmpty){
                      showCustomSnackBar("Enter password".tr);
                    }
                    else if(isSHowOTP && otpCt.text.isEmpty){
                      showCustomSnackBar("Enter OTP".tr);
                    }
                    else if(!otpVerify){
                      showCustomSnackBar("Invalid OTP".tr);
                    }
                    else if(!isSHowOTP ){
                      showCustomSnackBar("Verify mobile number".tr);
                    }
                    else if(_image==null){
                      showCustomSnackBar("Please select self image".tr);
                    }
                    else {

                      /*first_name:vijay
last_name:yogi
email:vijayyogi123@gmail.com
contact_number:8290588422
gender:male
password:8290588422
otp:123456*/
                      var body = {
                        "first_name":txtFirstName.text,
                        "last_name":txtLastName.text,
                        "email":emailCt.text,
                        "contact_number":txtMobile.text,
                        "password":txtPassword.text,
                        "otp":otpCt.text,
                        "gender":"male",
                        "city_id":selectedCategory!.id.toString(),
                        "referral_code":referralCt.text.trim(),

                      };
                      authController.saveDriverBasicDetails(body,_image);
                    }




                  },
                  title: "REGISTER".tr,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDocumentImage() async {
    try {
      print("Value=>${Get.find<AuthController>().isKyc()}");
      if (!Get.find<AuthController>().isKyc()) {
        // Bottom Sheet Open
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (BuildContext ctx) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: Colors.blue),
                    title:  Text("Take Photo from Camera".tr),
                    onTap: () async {
                      Navigator.pop(ctx);
                      _pickImageCamera();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo, color: Colors.green),
                    title:  Text("Choose from Gallery".tr),
                    onTap: () async {
                      Navigator.pop(ctx);
                      _pickImage();
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'Failed to pick image:'.tr} ${e.toString()}')),
      );
    }
  }
}
