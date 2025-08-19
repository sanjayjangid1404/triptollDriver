import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

class VehicleDocumentUploadView extends StatefulWidget {
  String id;

   VehicleDocumentUploadView({super.key,required this.id});

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
  List<String>fuelType = ["Petrol","Diesel","Electric","CNG"];
  final VehicleImages _images = VehicleImages();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, bool isVehicleImage) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (isVehicleImage) {
            _images.vehicleImage = File(image.path);
          } else {
            // Handle RC images
            if (_images.rcFrontImage == null) {
              _images.rcFrontImage = File(image.path);
            } else {
              _images.rcBackImage = File(image.path);
            }
          }
        });

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      Get.find<AuthController>().getAllVehicleData();
      setState(() {

      });


    });


   // apiList();
  }


  Widget _buildImageBox(File? image, String label, bool isVehicleImage) {
    return GestureDetector(
      onTap: () => _pickImage(ImageSource.gallery, isVehicleImage),
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
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 30),
            SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
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
            "Vehicle Document",
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
                    DropdownButtonFormField<Data>(
                      value: selectedCategory,
                      hint: Text("Category"),
                      items: authController.vehicleData!.data!.map((category) {
                        return DropdownMenuItem<Data>(
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedFuel,
                      hint: Text("Fuel Type"),
                      items: fuelType.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category!),
                        );
                      }).toList(),
                      onChanged: (value){

                        selectedFuel = value;

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
                ),

                const SizedBox(
                  height: 8,
                ),

                LineTextField(
                  title: "Vehicle Model",
                  hintText: "Ex: ",
                  controller: vehicleModelCt,
                ),
                const SizedBox(
                  height: 8,
                ),
                LineTextField(
                  title: "Vehicle Number",
                  hintText: "Ex: ",
                  controller: vehicleNumberCt,
                ),
                const SizedBox(
                  height: 8,
                ),

                LineTextField(
                  title: "RC Number",
                  hintText: "Ex: ",
                  controller: rcNumberCt,
                ),
                const SizedBox(
                  height: 8,
                ),

                Text('Vehicle Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildImageBox(_images.vehicleImage, 'Add Vehicle Photo', true),

                SizedBox(height: 20),
                Text('RC Document', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Front Side'),
                        SizedBox(height: 8),
                        _buildImageBox(_images.rcFrontImage, 'RC Front', false),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Back Side'),
                        SizedBox(height: 8),
                        _buildImageBox(_images.rcBackImage, 'RC Back', false),
                      ],
                    ),
                  ],
                ),



                SizedBox(height: 30,),

              authController.isUploading ? Center(child: CircularProgressIndicator(color: TColor.primary,),):
              RoundButton(
                  onPressed: () {

                    if(selectedCategory==null){
                      showCustomSnackBar("Select Category");
                    }else if(selectedFuel==null){
                      showCustomSnackBar("Select Fuel type");
                    }
                    else if(vehicleModelCt.text.isEmpty){
                      showCustomSnackBar("Enter vehicle model");
                    }else if(vehicleNumberCt.text.isEmpty){
                      showCustomSnackBar("Enter vehicle number");
                    }else if(rcNumberCt.text.isEmpty) {

                      showCustomSnackBar("Enter RC number");
                    }
                    // else if(_images.vehicleImage==null){
                    //   showCustomSnackBar("Select vehicle image");
                    // }

                    else if(_images.rcFrontImage==null){
                      showCustomSnackBar("Select RC front image");
                    }
                    else if(_images.rcBackImage==null){
                      showCustomSnackBar("Select RC back image");
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

                      authController.vehicleDetailsUpload(body, widget.id, null, XFile(_images.rcFrontImage!.path), XFile(_images.rcBackImage!.path));

                    }


                  },
                  title: "NEXT",
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

  void apiUploadDoc(Map<String, String> parameter, Map<String, File> imgObj) {
    Globs.showHUD();

    ServiceCall.multipart(parameter, SVKey.svDriverUploadDocument,
        isTokenApi: true, imgObj: imgObj, withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        mdShowAlert("Success", responseObj[KKey.message].toString(), () {});
       // apiList();
      } else {
        mdShowAlert("Error", responseObj[KKey.message].toString(), () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err.toString(), () {});
    });
  }
}

class VehicleImages {
  File? vehicleImage;
  File? rcFrontImage;
  File? rcBackImage;

  bool get allImagesSelected =>
      vehicleImage != null && rcFrontImage != null && rcBackImage != null;
}
