
import 'dart:io';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/controller/authController.dart';

import 'package:url_launcher/url_launcher.dart';
class AppContants
{
  static String appName = "TripToll";
  static String token = "Auth Token";
  static String link = "Auth Token";
  static String faceId = "Face Id";
  static String rupessSystem = "₹";
  static String userPassword = "User Password";
  static String userDeviceID = "User Device Token";
  static const String cartList = 'canteen_cart_list';
  static String userID = "User ID";
  static String bookingID = "Booking ID";
  static String userName = "User Name";
  static String maxTimeVar = "max time";
  static String loadingCharges = "loading charges";
  static String isLoadingTime = "is loading time";
  static String userKYC = "User KYC";
  static String userPayment = "User Payment";
  static String userFee= "User Fee";
  static String userEmail = "User Email";
  static String userPhone = "User Phone";
  static String notification = "Notification ID";
  // static String baseURl = "https://apitest.crossroadhelpline.in/api/"; 
  // static String baseURl = "https://dev.triptoll.in/api/";
  static String baseURl = "https://triptoll.in/app-admin/api/";
  // static String imageURL = "https://dev.triptoll.in/";
  static String imageURL = "https://triptoll.in/app-admin/";
  static String loginUrl = "User/login/tbl_driver";
  static String incomeDriverURL = "Driver/getWalletAmount";
  static String paymentHistoryURL = "Driver/getPaymentHistory";
  static String driverBasicInfoURL = "Driver/createDriver";
  static String driverFAQURl = "Home/getFaq/driver";
  static String ticketRezURL = "Driver/ticketRezByDriver";
  static String driverFAQHelpURl = "Home/getFaqHelp/driver";
  static String checkTicketLimit = "Driver/checkTicketLimit";
  static String getCityURL = "home/getCity";
  static String updateDriverBankDetailURL = "Driver/updateDriverBankDetail";
  static String updateDriverVehicleDetail = "Driver/updateDriverVehicleDetail";
  static String updateDriverKycURL = "Driver/updateDriverKYCDetail";
  static String forgetPasswordURL = "User/forgotPasswordOTP";
  static String getNotificationHistoryURL = "User/getNotificationHistory";
  static String updatePasswordURL = "User/updatePassword";
  static String updateDriverPaymentStatusURL = "Driver/updateDriverPaymentStatus";
  static String sendDriverOTPURL = "Driver/driverSignupOTP";
  static String updateDriverLocation = "User/updateLocation";
  static String orderPaymentURL = "Booking/orderPayment";
  static String updateDriverVehicleURL = "Driver/updateDriverVehicle";
  static String driverInfoURL = "Driver/getDataById/";
  static String uploadAdharFrontURL = "Driver/uploadAdharFront";
  static String uploadAdharBackURL = "Driver/uploadAdharBack";
  static String uploadPanImageURL = "Driver/uploadPanImage";
  static String uploadLicenseFrontURL = "Driver/uploadLicenseFront";
  static String uploadLicenseBackURL = "Driver/uploadLicenseBack";
  static String uploadInsuranceImageURL = "Driver/uploadInsuranceImage";
  static String changeLoginStatusURL = "Driver/driver_status";
  static String accpetBookingURL = "Booking/accpetBooking";
  static String orderPickedURL = "Booking/orderPicked";
  static String orderDeliveredURL = "Booking/orderDelivered";
  static String startJourneyToNextUrl = "Booking/startJourneyToNext";
  static String getBookingsBydateAndDriverURL = "Booking/getBookingsBydateAndDriver";
  static String driverOnlineTImeURL = "Driver/driver_online_time";
  static String getWalletHistoryURL = "Driver/getWalletHistory";
  static String checkDriverDeviceURL = "Driver/checkDriverDevice";
  static String getDailyEarningsURL = "Driver/getDailyEarnings";
  static String saveFirebaseTokenURL = "Home/saveFirebaseXToken";
  static String bookingStatusChangeURl = "Booking/changeBookingStatus/";
  static String startTripURL = "Booking/startTrip";
  static String orderLoadingURL = "Booking/orderLoading";
  static String orderUnloadingURL = "Booking/orderUnloading";
  static String checkDriverBooking = "Booking/check_running_order_driver";
  static String getBookingNotificationURL = "Booking/findNewBookings";
  static String getAllCategory = "home/getAllCategory";
  static String checkPaymentURL = "Booking/checkPayment";
  static String cancelOrderURL = "Booking/cancelOrder";
  static String saveBookingURl = "Booking/saveBooking";
  static String getAllVehicle = "home/getAllCategory";
  static String getAllBookingURL = "Booking/getAllBooking";
  static String getBookingDetails = "Booking/getBookingDetail";
  static String driverDetailURL = "Driver/getDriverDetail";
  static String driverDetailsURL = "Driver/getDriverDetails";
  static String getPaymentHistoryUrl = "Driver/getPaymentHistory";
  static String getMissedOrdersUrl = "Driver/getMissedOrders";
  static String getDateRangeEarningsUrl = "Driver/getDateRangeEarnings";
  static String getLifetimeEarningsUrl = "Driver/getLifetimeEarnings";
  static String getInactiveBalanceUrl = "Driver/getInactiveBalance?driver_id=";
  static String categoryVehicleURL = "home/getVehicleByCategoryId/";
  static String verifyOtpURl = "verify-otp";
  static String myComplaintURl = "get-my-complaints";
  static String addDriverWalletURL = "Driver/addDriverWallet";
  static String getMyReferral = "get-my-referral-code";
  static String userMembership = "user-membership-details";
  static String userProfileURL = "get-latest-user-profile";
  static String userUpdateProfileUrl = "update-user-profile";
  static String updateProfileURl = "profile-update";
  static String referralEarning = "get-referral-earning-details";
  static String getFamilyAddedVehiclesURL = "get-family-added-vehicles";
  static String getOwnReferrals = "get-own-referrals?status=PAID&page=1&size=10";
  static String getFaultName = "get-fault-name";
  static String getSubFaultName = "get-sub-fault-name";
  static String getRemarkURl = "get-remark";
  static String crateNewRemark = "create-new-remark";
  static String addComplainURl = "register-complaint-by-user";
  static String sowRegisterComplain = "sow-register-complaint-by-user";
  static String sowMemberShipCard = "sow-user-membership-details";
  static String getPackagesURL = "get-packages";
  static String prcMemberURL = "prc-member-activation";
  static String prcUpgradePackage = "prc-upgrade-package";
  static String payNowURL = "pay-now";
  static String prcQuickHelp = "prc-quick-rsa-help";
  static String checkPaymentStatus = "check-payment-status";
  static String promoCodeCheckURL = "prc-apply-prome-code-referral-code";
  static String getMakerURL = "get-maker-model?vehicle_type=Four_Wheeler";
  static String getModelURL = "get-model?vehicle_type=FOUR_WHEELER&maker_name=";
  static String paytmMID = "pEhuoh06789111182793";
  static String paytmToken = "b321952990ed47ce99dadca2684a54091723097676896";
  static String reviewURLLink = "https://g.page/r/CWdRrns2HdWhEAE/review";
  static const String POPPINS = "Poppins";
  static const String OPEN_SANS = "OpenSans";
  static const String SKIP = "Skip";
  static const String NEXT = "Next";
  static const String SLIDER_HEADING_1 = "Fast & Secure Payments";
  static const String SLIDER_HEADING_2 = "Recharge & Pay Bills in Seconds";
  static const String SLIDER_HEADING_3 = "Shop Smart & Earn Rewards";
  static const String SLIDER_DESC = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ultricies, erat vitae porta consequat.";
  static const String SLIDER_DESC1 = "Pay instantly using UPI, wallet, debit/credit cards, and more. Your transactions are safe with bank-grade security.";
  static const String SLIDER_DESC2 = "Mobile recharge, DTH, electricity, gas — everything you need in one place.";
  static const String SLIDER_DESC3 = "Get exciting cashback and offers every time you shop or pay bills.";

  static double btnRadius = 4;


  // https://api.crossroadshelpline.com/api/get-fault-name?vehicle_type=FOUR_WHEELER&fault_type=ACCIDENT


  static String changeDateFormat(String date,String format)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat("MMM d, yyyy - hh:mm a").format(dateTime);

    return DateFormat(format).format(dateTime);
  }
  static bool differentDate(String date)
  {
    DateTime currentTime = DateTime.now();
    DateTime specifiedTime = DateTime.parse(date);

    Duration difference = currentTime.difference(specifiedTime);
    bool isDifferenceLessThan10Minutes = difference.inMinutes.abs() < 10;

    print("Is difference less than 10 minutes: $isDifferenceLessThan10Minutes");

    return difference.inMinutes.abs() < 10;
  }

  static bool currentFood(String date, String startTime, String endTime) {
    // Get the current date in "yyyy-MM-dd" format
    String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    print("date=>$date");
    print("startTime=>$startTime");
    print("endTime=>$endTime");

    // Combine the current date with the given time
    String startDateTimeString = "$formattedDate $startTime";
    String endDateTimeString = "$formattedDate $endTime";

    DateTime startDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(startDateTimeString);
    DateTime endDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(endDateTimeString);
    DateTime currentDate = DateTime.now();

    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(startDate) || currentDate.isAtSameMomentAs(endDate);
  }

  static notFoundText(String text)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),),
    );
  }


  static Future<String?> getToken() async {
    String? token = "";


    SharedPreferences sp = await SharedPreferences.getInstance();
    // await Provider.of<StepTrackerProvider>(context, listen: false).getFitData();

    if(Platform.isAndroid)
    {
      token =  await FirebaseMessaging.instance.getToken();
    }
    else
    {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    sp.setString("saveDeviceID", token??"");
    print("token=>$token");

    if(token!=null){
      Get.find<AuthController>().saveFirebaseToken(token);
    }

    return token!=null ? token:"";
  }


  static Color getColor(String plan)
  {
    if(plan.toLowerCase() == "lifetime pan india" || plan.toLowerCase() =="instant rsa" || plan.toLowerCase() =="titanium pan india"
        || plan.toLowerCase() =="titanium family plan" || plan.toLowerCase() =="lifetime family plan" || plan.toLowerCase() =="sow package 1")
    {
      return Colors.white;
    }
    else
    {
      return Colors.black;
    }
  }



  static List<BoxShadow>? searchBoxShadow =  [const BoxShadow(
      offset: Offset(0,3),
      color: Color(0x208F94FB), blurRadius: 5, spreadRadius: 2)];





  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }


  // static void showNoteBottomSheet(BuildContext context,AuthController authController,String bookingID,bool isOrder) {
  //
  //
  //   TextEditingController _noteController = TextEditingController();
  //   TextEditingController _reasonController = TextEditingController();
  //   final _formKey = GlobalKey<FormState>();
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           left: 16,
  //           right: 16,
  //           top: 20,
  //           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Reason",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 12),
  //             TextFormField(
  //               controller: _reasonController,
  //               maxLines: 4,
  //               decoration: InputDecoration(
  //                 hintText: "Write reason...",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //               validator: (value) {
  //                 if (value == null || value.trim().isEmpty) {
  //                   return "Note can't be empty";
  //                 }
  //                 return null;
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             Text(
  //               "Additional Information",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 12),
  //             TextFormField(
  //               controller: _noteController,
  //               maxLines: 4,
  //               decoration: InputDecoration(
  //                 hintText: "Write your information here...",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //               validator: (value) {
  //                 if (value == null || value.trim().isEmpty) {
  //                   return "Note can't be empty";
  //                 }
  //                 return null;
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             ElevatedButton.icon(
  //               onPressed: () {
  //
  //                 authController.cancelOrder(bookingID: bookingID,reason: _reasonController.text,comment: _noteController.text,isOrder:isOrder);
  //               },
  //
  //               label: Text("Cancel",style: TextStyle(fontSize: 14,color: Colors.white),),
  //               style: ElevatedButton.styleFrom(
  //                 minimumSize: Size(double.infinity, 48),
  //                 backgroundColor: AppColors.secondaryGradient,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


}

