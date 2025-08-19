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
import 'package:taxi_driver/controller/authController.dart';
import 'package:taxi_driver/view/login/bank_detail_view.dart';

import '../../common_widget/line_text_field.dart';
import '../../common_widget/round_button.dart';

class DocumentUploadView extends StatefulWidget {
  final String title;
  final String id;
   bool isEdit;
   DocumentUploadView({super.key, required this.title, required this.id,this.isEdit = false});

  @override
  State<DocumentUploadView> createState() => _DocumentUploadViewState();
}

class _DocumentUploadViewState extends State<DocumentUploadView> {
  List documentList = [];
  TextEditingController aadhaarCt = TextEditingController();
  TextEditingController licenseCt = TextEditingController();
  TextEditingController insuranceCt = TextEditingController();
  TextEditingController panCt = TextEditingController();
  final KYCDocument _kycDocs = KYCDocument();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthController authController = Get.find<AuthController>();

    if(widget.isEdit && authController.driverInResponse!=null){
      aadhaarCt.text = authController.driverInResponse!.adharNo ??"";
      licenseCt.text = authController.driverInResponse!.licenseNo ??"";
      insuranceCt.text = authController.driverInResponse!.insurance ??"";
      panCt.text = authController.driverInResponse!.panNo ??"";

      setState(() {

      });
    }
   // apiList();
  }

  Future<void> _pickDocumentImage(String docType) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          switch (docType) {
            case 'aadhar_front':
              _kycDocs.aadharFront = File(image.path);
              break;
            case 'aadhar_back':
              _kycDocs.aadharBack = File(image.path);
              break;
            case 'psu':
              _kycDocs.psuImage = File(image.path);
              break;
            case 'license_front':
              _kycDocs.licenseFront = File(image.path);
              break;
            case 'license_back':
              _kycDocs.licenseBack = File(image.path);
              break;
            case 'insurance':
              _kycDocs.insuranceImage = File(image.path);
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Widget _buildImageBox(File? file, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: file != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(file, fit: BoxFit.cover),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 30),
            SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentField({
    required String label,
    required String docType,
    required File? file,

  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text('Upload $label', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            _buildImageBox(
              file,
              docType.contains('front') ? 'Front Side' :
              docType.contains('back') ? 'Back Side' : 'Document',
                  () => _pickDocumentImage(docType),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
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
            widget.title,
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
                LineTextField(
                  title: "Aadhaar Number",
                  hintText: "Ex: ",
                  controller: aadhaarCt,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    _buildDocumentField(
                      label: 'Aadhar Card ',
                      docType: 'aadhar_front',
                      file: _kycDocs.aadharFront,

                    ),
                    _buildDocumentField(
                      label: '',
                      docType: 'aadhar_back',
                      file: _kycDocs.aadharBack,
                    ),
                  ],
                ),

                LineTextField(
                  title: "Pan Number",
                  hintText: "Ex: ",
                  controller: panCt,
                ),

                const SizedBox(
                  height: 8,
                ),

                _buildDocumentField(
                  label: 'Pan Number',
                  docType: 'psu',
                  file: _kycDocs.psuImage,

                ),
                LineTextField(
                  title: "License Number",
                  hintText: "Ex: ",
                  controller: licenseCt,
                ),

                const SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    _buildDocumentField(
                      label: 'License Number',
                      docType: 'license_front',
                      file: _kycDocs.licenseFront,

                    ),
                    _buildDocumentField(
                      label: '',
                      docType: 'license_back',
                      file: _kycDocs.licenseBack,
                    ),
                  ],
                ),

                LineTextField(
                  title: "Insurance Number",
                  hintText: "Ex: ",
                  controller: insuranceCt,
                ),

                const SizedBox(
                  height: 8,
                ),

                _buildDocumentField(
                  label: 'Insurance Number',
                  docType: 'insurance',
                  file: _kycDocs.insuranceImage,

                ),




                // PSU


                // License

                 authController.isUploading ? Center(child: CircularProgressIndicator(color: TColor.primary,),):
                RoundButton(
                  onPressed: () {

                    if(aadhaarCt.text.isEmpty){
                      showCustomSnackBar("Enter Aadhaar Number");
                    }
                    else if(licenseCt.text.isEmpty){
                      showCustomSnackBar("Enter License Number");
                    }
                    else if(_kycDocs.aadharFront==null){
                      showCustomSnackBar("Upload Aadhaar Front Image");
                    }
                    else if(_kycDocs.aadharBack==null){
                      showCustomSnackBar("Upload Aadhaar Back Image");
                    }

                    else if(_kycDocs.licenseFront==null){
                      showCustomSnackBar("Upload License Front Image");
                    }

                    else if(_kycDocs.licenseBack==null){
                      showCustomSnackBar("Upload License Back Image");
                    }


                    else {
                      var body = {
                        "driver_id": widget.id,
                        "adhar_no": aadhaarCt.text,
                        "pan_no": panCt.text,
                        "license_no": licenseCt.text,
                        "insurance": insuranceCt.text,
                      };
                      authController.updateDriverKyc(
                          body,context,isEdit: widget.isEdit, adhaarF:_kycDocs.aadharFront!=null ? XFile(_kycDocs.aadharFront!.path):null,
                          adhaarb: _kycDocs.aadharBack!=null ? XFile(_kycDocs.aadharBack!.path):null,
                          insur:_kycDocs.insuranceImage!=null ? XFile(_kycDocs.insuranceImage!.path):null,
                          licenseNumberB:_kycDocs.licenseFront!=null ? XFile(_kycDocs.licenseFront!.path):null,
                          lienB: _kycDocs.licenseBack!=null ?XFile(_kycDocs.licenseBack!.path):null,
                          panImage:_kycDocs.psuImage!=null ? XFile(_kycDocs.psuImage!.path):null);
                    }
                  },
                  title: "NEXT",
                ),

                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: ApiCalling

  void apiList() {
    Globs.showHUD();
    ServiceCall.post({}, SVKey.svPersonalDocumentList, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        documentList = responseObj[KKey.payload] as List? ?? [];

        if (mounted) {
          setState(() {});
        }
      } else {
        mdShowAlert("Error", responseObj[KKey.message].toString(), () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err.toString(), () {});
    });
  }

  void apiUploadDoc(Map<String, String> parameter, Map<String, File> imgObj) {
    Globs.showHUD();

    ServiceCall.multipart(parameter, SVKey.svDriverUploadDocument,
        isTokenApi: true, imgObj: imgObj, withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        mdShowAlert("Success", responseObj[KKey.message].toString(), () {});
        apiList();
      } else {
        mdShowAlert("Error", responseObj[KKey.message].toString(), () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert("Error", err.toString(), () {});
    });
  }
}

class KYCDocument {
  File? aadharFront;
  File? aadharBack;
  File? psuImage;
  File? licenseFront;
  File? licenseBack;
  File? insuranceImage;

  bool get allDocumentsUploaded =>
      aadharFront != null &&
          aadharBack != null &&
          psuImage != null &&
          licenseFront != null &&
          licenseBack != null &&
          insuranceImage != null;
}
