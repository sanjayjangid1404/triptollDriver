import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_driver/common/custom_snackbar.dart';
import 'package:taxi_driver/controller/authController.dart';

import '../../../model/faq_driver_response.dart';

class FaqScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FaqScreen> with SingleTickerProviderStateMixin {



  late AnimationController _animationController;
  late Animation<double> _animation;
  AuthController authController  = Get.find<AuthController>();
  String? selectedFaqId;
  FaqDriverResponse? selectedFaq;
  Key _dropdownKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                // Company Header
                _buildCompanyHeader(),
                SizedBox(height: 32),
                // Website and Details
                _buildCompanyDetails(),
                SizedBox(height: 32),
                // FAQ Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Frequently Asked Questions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      key: _dropdownKey,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedFaqId,
                        isExpanded: true,
                        underline: SizedBox(),
                        hint: Text("Choose a question"),
                        items: authController.faqDriverResponse.map((FaqDriverResponse item) {
                          return DropdownMenuItem<String>(
                            value: item.id.toString(),
                            child: Text(item.title ?? ""),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {

                            if (newValue != null) {
                              selectedFaqId = newValue;
                              selectedFaq = authController.faqDriverResponse
                                  .firstWhere((element) => element.id == newValue);
                            } else {
                              selectedFaq = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                // Submit Button
                _buildSubmitButton(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Center(
      child: Column(
        children: [
          Image.asset("assets/img/triptoll_name.png",height: 200,),
          SizedBox(height: 16),


        ],
      ),
    );
  }

  Widget _buildCompanyDetails() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.language, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                "Company Website:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 34.0),
            child: GestureDetector(
              onTap: () {
                // Handle website tap
              },
              child: Text(
                "https://triptoll.in/",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[600],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Triptoll was founded in Aug 2024 by Mr. M.S. Duhan and Mr. Virendra Tripathy. we are a trusted and reliable logistics delivery service provider, dedicated to making your relocation experience smooth, efficient, and stress-free. ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle submit action



          if(selectedFaqId!=null) {
            authController.ticketRez({
            "driver_id":authController.getUserID().toString(),
            "faq_id":selectedFaqId.toString(),
            "user_type":"driver"

          });
          }
          else {
            showCustomSnackBar("select faq");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          "SUBMIT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}