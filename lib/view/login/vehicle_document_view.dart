import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_driver/common/appContants.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/custom_snackbar.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';
import 'package:taxi_driver/common_widget/document_row.dart';
import 'package:taxi_driver/common_widget/image_picker_view.dart';
import 'package:taxi_driver/common_widget/popup_layout.dart';
import 'package:taxi_driver/common_widget/round_button.dart';
import 'package:taxi_driver/view/login/document_upload_view.dart';
import 'package:taxi_driver/view/login/subscription_plan_view.dart';

import '../../common_widget/line_text_field.dart';
import '../../controller/authController.dart';
import '../../model/vehicle_data.dart';
import 'package:image/image.dart' as img;

class VehicleDocumentUploadView extends StatefulWidget {
  String id;
  bool isEdit;

   VehicleDocumentUploadView({super.key,required this.id,this.isEdit = false});

  @override
  State<VehicleDocumentUploadView> createState() =>
      _VehicleDocumentUploadViewState();
}

class _VehicleDocumentUploadViewState extends State<VehicleDocumentUploadView> {
  List documentList = [];
  TextEditingController vehicleModelCt = TextEditingController();
  TextEditingController vehicleNumberCt = TextEditingController();
  TextEditingController rcNumberCt = TextEditingController();
  Data? selectedCategory;
  String? selectedFuel;
  String rcforntImage = "";
  String editCategoryID = "";
  String editRegistrationFees = "";
  String editCategoryName = "";
  String editfuelType = "";

  String rcBackImage = "";
  List<String>fuelType = ["Petrol","Diesel","Electric","CNG","EV"];
  final VehicleImages _images = VehicleImages();
  final ImagePicker _picker = ImagePicker();
  Future<File> convertPngToJpg(File pngFile) async {
    final bytes = await pngFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Could not decode image");
    }

    final jpgBytes = img.encodeJpg(image, quality: 90);
    final jpgFile = File(pngFile.path.replaceAll(".png", ".jpg"));

    await jpgFile.writeAsBytes(jpgBytes);
    return jpgFile;
  }

  Future<void> _pickImage(ImageSource source, bool isVehicleImage, bool isBack) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        File file = File(image.path);

        // Convert if PNG
        if (file.path.toLowerCase().endsWith(".png")) {
          file = await convertPngToJpg(file);
        }

        setState(() {
          if (isVehicleImage) {
            _images.vehicleImage = file;
          } else {
            // Handle RC images
            if (isBack) {
              _images.rcBackImage = file;
            } else {
              _images.rcFrontImage = file;
            }
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${"Failed to pick image:".tr} ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      Get.find<AuthController>().getAllVehicleData();

      if(Get.find<AuthController>().driverInResponse!=null){
        vehicleModelCt.text = Get.find<AuthController>().driverInResponse!.driverDetails!.vehicleType??"";
        vehicleNumberCt.text = Get.find<AuthController>().driverInResponse!.driverDetails!.vehicleNumber??"";
        rcNumberCt.text = Get.find<AuthController>().driverInResponse!.driverDetails!.rcNo??"";
        editCategoryName = Get.find<AuthController>().driverInResponse!.driverDetails!.categoryName??"";
        editfuelType = Get.find<AuthController>().driverInResponse!.driverDetails!.vehicleType??"";
        editCategoryID = Get.find<AuthController>().driverInResponse!.driverDetails!.categoryId??"";
        editRegistrationFees = Get.find<AuthController>().driverInResponse!.driverDetails!.registrationFees??"0";
        selectedFuel = Get.find<AuthController>().driverInResponse!.driverDetails!.vehicleType?? 'Petrol';
        rcforntImage = AppContants.imageURL+"/uploaded_files/id_proof_img/"+(Get.find<AuthController>().driverInResponse!.driverDetails!.rcFrontImg??"");
        rcBackImage = AppContants.imageURL+"/uploaded_files/id_proof_back_img/"+(Get.find<AuthController>().driverInResponse!.driverDetails!.rcBackImg??"");

      }
      setState(() {

      });


    });


   // apiList();
  }


  Widget _buildImageBox(File? image, String label, bool isVehicleImage,bool isBack,String networkImage) {
    return GestureDetector(
      onTap: () {

        if(!Get.find<AuthController>().isKyc()){
          _pickImage(ImageSource.gallery, isVehicleImage,isBack);
        }

        },
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: image != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(image, fit: BoxFit.cover),
        )
            : networkImage.isNotEmpty ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(networkImage, fit: BoxFit.cover),
        ):

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 30),
            SizedBox(height: 8),
            Text(label.tr, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 25,
              height: 25,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Vehicle Document".tr,
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 25,
                fontWeight: FontWeight.w800),
          ),
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

                authController.vehicleData!=null && authController.vehicleData!.data!=null ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   authController.isKyc() ?
                   LineTextField(
                     title: "Category".tr,
                     hintText: "Ex: ",
                     readyOnly:  authController.isKyc(),
                     controller: TextEditingController(text: editCategoryName),
                   ):
                   DropdownButtonFormField<Data>(
                      value: selectedCategory,
                      hint: Text("Category".tr),
                      items: authController.vehicleData!.data!.map((category) {
                        return DropdownMenuItem<Data>(
                          value: category,
                          child: Text(category.name!),
                        );
                      }).toList(),
                      onChanged: (value){
                        print(authController.isKyc());

                        if(!authController.isKyc()){

                          if(widget.isEdit){
                            editCategoryID = value!.id.toString();
                            editRegistrationFees = value!.fees_1.toString();
                          }
                          else {
                            selectedCategory = value;
                          }


                          setState(() {

                          });
                        }


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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedFuel,
                      hint: Text("Fuel Type".tr),
                      items: fuelType.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category!),
                        );
                      }).toList(),
                      onChanged: (value){

                        if(!authController.isKyc()){

                          if(widget.isEdit){
                            editfuelType = value!.toString();
                          }
                          else {
                            selectedFuel = value;
                          }



                          setState(() {

                          });
                        }


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
                ),

                const SizedBox(
                  height: 8,
                ),

                LineTextField(
                  title: "Vehicle Model".tr,
                  hintText: "Ex: ",
                  readyOnly:  authController.isKyc(),
                  controller: vehicleModelCt,
                ),
                const SizedBox(
                  height: 8,
                ),
                LineTextField(
                  title: "Vehicle Number".tr,
                  hintText: "Ex: ",
                  readyOnly: authController.isKyc(),
                  controller: vehicleNumberCt,
                ),
                const SizedBox(
                  height: 8,
                ),

                LineTextField(
                  title: "RC Number".tr,
                  hintText: "Ex: ",
                  readyOnly:  authController.isKyc(),
                  controller: rcNumberCt,
                ),
                const SizedBox(
                  height: 8,
                ),

                // Text('Vehicle Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                // SizedBox(height: 8),
                // _buildImageBox(_images.vehicleImage, 'Add Vehicle Photo', true,false),

                SizedBox(height: 20),
                Text('RC Document'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Front Side'.tr),
                        SizedBox(height: 8),
                        _buildImageBox(_images.rcFrontImage, 'RC Front', false,false,rcforntImage),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Back Side'.tr),
                        SizedBox(height: 8),
                        _buildImageBox(_images.rcBackImage, 'RC Back', false,true,rcBackImage),
                      ],
                    ),
                  ],
                ),



                SizedBox(height: 30,),

              authController.isUploading ? Center(child: CircularProgressIndicator(color: TColor.primary,),):
              authController.isKyc() ? SizedBox.shrink() : RoundButton(
                  onPressed: () {

                    if(widget.isEdit){
                      if(editCategoryID.isEmpty){
                        showCustomSnackBar("Select Category".tr);
                      }else if(editfuelType.isEmpty){
                        showCustomSnackBar("Select Fuel type".tr);
                      }
                      else if(vehicleModelCt.text.isEmpty){
                        showCustomSnackBar("Enter vehicle model".tr);
                      }
                      else if(vehicleNumberCt.text.isEmpty){
                        showCustomSnackBar("Enter vehicle number".tr);
                      }else if(rcNumberCt.text.isEmpty) {

                        showCustomSnackBar("Enter RC number".tr);
                      }
                      // else if(_images.vehicleImage==null){
                      //   showCustomSnackBar("Select vehicle image");
                      // }

                      else {
                        /*driver_id:2376
vehicle_model:2019
vehicle_number:RJ14AH83726
fuel_type:Petrol
category_id:114
rc_no:*/
                        var body = {
                          "driver_id":widget.id,
                          "vehicle_model":vehicleModelCt.text,
                          "vehicle_number":vehicleNumberCt.text,
                          "fuel_type":editfuelType,
                          "category_id":editCategoryID,
                          "registration_fees":editRegistrationFees,
                          "rc_no":rcNumberCt.text,
                        };



                        authController.vehicleDetailsUpload(body, widget.id, null,_images.rcFrontImage!=null ? XFile(_images.rcFrontImage!.path):null,_images.rcBackImage!=null ?  XFile(_images.rcBackImage!.path):null,context,isEdit: true);

                      }
                    }
                    else {
                      if(selectedCategory==null){
                        showCustomSnackBar("Select Category".tr);
                      }else if(selectedFuel==null){
                        showCustomSnackBar("Select Fuel type".tr);
                      }
                      else if(vehicleModelCt.text.isEmpty){
                        showCustomSnackBar("Enter vehicle model".tr);
                      }else if(vehicleNumberCt.text.isEmpty){
                        showCustomSnackBar("Enter vehicle number".tr);
                      }else if(rcNumberCt.text.isEmpty) {

                        showCustomSnackBar("Enter RC number".tr);
                      }
                      // else if(_images.vehicleImage==null){
                      //   showCustomSnackBar("Select vehicle image");
                      // }

                      else if(_images.rcFrontImage==null){
                        showCustomSnackBar("Select RC front image".tr);
                      }
                      else if(_images.rcBackImage==null){
                        showCustomSnackBar("Select RC back image".tr);
                      }
                      else {
                        /*driver_id:2376
vehicle_model:2019
vehicle_number:RJ14AH83726
fuel_type:Petrol
category_id:114
rc_no:*/
                        var body = {
                          "driver_id":widget.id,
                          "vehicle_model":vehicleModelCt.text,
                          "vehicle_number":vehicleNumberCt.text,
                          "fuel_type":selectedFuel.toString(),
                          "category_id":selectedCategory!.id.toString(),
                          "registration_fees":selectedCategory!.fees_1.toString(),
                          "rc_no":rcNumberCt.text,
                        };



                        authController.vehicleDetailsUpload(body, widget.id, null, XFile(_images.rcFrontImage!.path), XFile(_images.rcBackImage!.path),context);

                      }
                    }




                  },
                  title:widget.isEdit ? "UPDATE".tr: "NEXT".tr,
                ),
                SizedBox(height: 30,)

              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: ApiCalling
 /* void apiList() {
    Globs.showHUD();
    ServiceCall.post(
      {"user_car_id": widget.obj["user_car_id"].toString()},
      SVKey.svCarDocumentList,
      isTokenApi: true,
      withSuccess: (responseObj) async {
        Globs.hideHUD();
        if (responseObj[KKey.status] == "1") {
          documentList = responseObj[KKey.payload] as List? ?? [];
          if (mounted) {
            setState(() {});
          }
        } else {
          mdShowAlert(
              "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
        }
      },
      failure: (error) async {
        Globs.hideHUD();
        mdShowAlert("Error", error.toString(), () {});
      },
    );
  }*/


}

class VehicleImages {
  File? vehicleImage;
  File? rcFrontImage;
  File? rcBackImage;

  bool get allImagesSelected =>
      vehicleImage != null && rcFrontImage != null && rcBackImage != null;
}
