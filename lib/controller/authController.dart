import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/main.dart';
import 'package:taxi_driver/model/booking_details_response.dart';
import 'package:taxi_driver/model/booking_list_response.dart';
import 'package:taxi_driver/model/booking_notification_response.dart';
import 'package:taxi_driver/model/driver_in_response.dart';
import 'package:taxi_driver/model/payment_history_model.dart';
import 'package:taxi_driver/view/home/home_view.dart';
import 'package:taxi_driver/view/login/bank_detail_view.dart';
import 'package:taxi_driver/view/login/mobile_number_view.dart';
import 'package:taxi_driver/view/login/vehicle_document_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_checker.dart';
import '../api/api_client.dart';
import '../common/appContants.dart';
import '../common/custom_snackbar.dart';
import '../common/driver_notification_service.dart';
import '../common/globs.dart';
import '../common/route_helper.dart';
import '../model/category_type_response.dart' hide Data;
import '../model/check_ticket_limit_model.dart';
import '../model/city_response.dart';
import '../model/daily_earnings_md.dart';
import '../model/device_logout_model.dart';
import '../model/faq_driver_response.dart';
import '../model/faq_model.dart';
import '../model/getBookingsBydateAndDriver_model.dart';
import '../model/inactive_wallet_model.dart';
import '../model/life_time_earn_model.dart';
import '../model/missed_order_list_model.dart';
import '../model/monthly_earn_model.dart';
import '../model/notification_history_model.dart';
import '../model/running_order_response.dart';
import '../model/subCategoryVehicle.dart' hide Data;
import '../model/vehicle_data.dart' hide Data;
import '../model/wallet_response.dart';
import '../model/weekly_earn.dart';
import '../repo/auth_repo.dart';
import '../view/home/order/category_list_page.dart';
import '../view/home/show_timer.dart';
import '../view/home/support/faq.dart';
import '../view/home/tip_request_view.dart';
import '../view/home/unloading_timer.dart';
import '../view/login/document_upload_view.dart';
import 'package:http/http.dart' as http;

import '../view/running/runnig_order_screen.dart';

class AuthController extends GetxController implements GetxService {



  DateTime? onlineStartTime;
  Duration totalOnlineDuration = Duration.zero;
  String time = '0 h 0 m';
  AuthRepo authRepo;
  AuthController({required this.authRepo});
  bool isLoading = false;
  bool isLoadingTime = false;
  RxBool loadingStart = false.obs;
  int elapsedSeconds = 0;
  var currentDropIndex = 0.obs;
  RxBool isLastDropCompleted = false.obs;
  String bookingId = '';
  int elapsedSecondsUnload = 0;
  double chargesLoading = 0.0;
  double chargesUnLoading = 0.0;
  RxBool unloadingStart = false.obs;
  RxBool showCompletePayment = false.obs;
  RxBool showUnLoading = false.obs;
  String maxTime = '0';
  String loadingCharges = '0';
  String realLoadingTime = '0';
  String realUnLoadingTime = '0';
  bool isBookingProcess = false;
  bool isShowDriver = false;
  bool hasShownSheet = false;
  File? _image;
  String _verificationCode = '';
  String walletAmount = "0";
  CategoryTypeResponse? categoryTypeResponse = CategoryTypeResponse();
  SubCategoryVehicle? subCategoryVehicle = SubCategoryVehicle();
  VehicleData? vehicleData = VehicleData();
  int? getIndex;
  List<String>banners = [
    "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FLifetime-Family-Plan-offer-slider.1c6725bf.webp&w=3840&q=75",
    "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FFree-Car-Care-Kit.46a9b3ee.webp&w=3840&q=75",
    "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FTitanium-Family-Plan.d35e75e6.webp&w=3840&q=75",
    "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FPlatinum-Family-Plan.2eb81b06.webp&w=3840&q=75"
  ];
  int currentIndex = 0;
  bool isVehicle = false;
  String newBookingID = "";
  Timer? _locationUpdateTimer;
  String _email = '';
  String get verificationCode => _verificationCode;
  String get email => _email;
  File? get image => _image;
  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;
  StreamSubscription<Position>? _positionStreamSubscription;
  Future<void> _loadSavedDropIndex() async {
    final prefs = await SharedPreferences.getInstance();
    currentDropIndex.value = prefs.getInt('currentDropIndex_$bookingId') ?? 0;
    print("Loaded saved drop index: ${currentDropIndex.value}");
  }

  /// 🔹 Save drop index to SharedPreferences
  Future<void> _saveDropIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentDropIndex_$bookingId', currentDropIndex.value);
  }

  /// 🔹 Increment drop index after successful unload
  Future<void> nextDrop(int totalDrops) async {
    if (currentDropIndex.value < totalDrops - 1) {
      currentDropIndex.value++;
      await _saveDropIndex();
    } else {
      print("✅ All dropoffs completed");
    }
  }

  /// 🔹 Clear index after order is delivered
  Future<void> clearDropIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentDropIndex_$bookingId');
    currentDropIndex.value = 0;
    print("Drop index cleared for booking $bookingId");
  }
  RxInt isShow = 0.obs;
  @override
  void onInit() {
    super.onInit();
   // if(isLoggedIn()) {
    getDeviceId();
    _loadSavedDropIndex();
      Stream.periodic(const Duration(seconds: 15)).listen((_) {
        checkDriverDevice(deviceId);
      });
    //}
    _checkLocationPermission();
  }

  Timer? _bookingNotificationTimer;


  /// इसे हर 10 सेकंड में कॉल करेगा
  void startBookingNotificationPolling(BuildContext context) {
    _bookingNotificationTimer?.cancel();

    _bookingNotificationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      // getBookingNotification(context);
    });
  }

  String checkLoginTime(int loginSeconds) {
    double hours = loginSeconds / 3600;

    if (hours > 12) {
      return "false";
    } else {
      return hours.toStringAsFixed(2); // hours ko 2 decimal tak string me
    }
  }
  List<FaqModel?> faqLIstResponse = [];
  Future<void>getFaqListFunction() async {

    update();
    Response response = await authRepo.getFaqList();



    faqLIstResponse = [];
    if(response.statusCode==200 || response.statusCode ==400)
    {


      for(int i=0; i<response.body.length; i++){
        faqLIstResponse.add( FaqModel.fromJson(response.body[i]));
      }

      update();
    }
    else {

      ApiChecker.checkApi(response);

    }
    update();
  }
  void checkAndStartBookingNotification(BuildContext context) {
    startBookingNotificationPolling(context);

    // condition check: driverInResponse != null && runningOrder != "yes"
    // if (driverInResponse != null &&/* driverInResponse!.runningOrder.toString() != "yes" &&*/ runningOrderResponse!=null && runningOrderResponse!.orders==null) {
    //   print("isDriver Not Runing ");
    //   startBookingNotificationPolling(context);
    // } else {
    //   print("isDriver  Runing ");
    //   stopBookingNotificationPolling(); // "yes" आने पर बंद कर दो
    // }
  }

  void stopBookingNotificationPolling() {
    _bookingNotificationTimer?.cancel();
    _bookingNotificationTimer = null;

    print("Stopped polling.");
  }

  /// App बंद या Controller destroy हो तब टाइमर बंद करें
  @override
  void onClose() {
    _bookingNotificationTimer?.cancel();
    stopBookingNotificationPolling();
    _positionStreamSubscription?.cancel();
    super.onClose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // 0 means smallest movement bhi track hoga
    );

    _positionStreamSubscription?.cancel(); // safety: pehle ka stream close karo

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      print("📍 New Position: ${position.latitude}, ${position.longitude}");

      if (_locationUpdateTimer == null || !_locationUpdateTimer!.isActive) {
        _updateDriverLocationOnServer(position.latitude, position.longitude);

        _locationUpdateTimer = Timer(const Duration(seconds: 10), () {
          // Timer khatam hone par next call allow hoga
          _updateDriverLocationOnServer(position.latitude, position.longitude);
        });
      }
    });
  }

  Future<void>addWalletPaymentFun({String? amount, String? transitionId, required BuildContext context})
  async {

    isVehicle = true;

    update();
    print(getUserDeviceID());
    subCategoryVehicle = null;



    Response response = await authRepo.addWalletPayment(customerID: getUserID(),amount: amount,trnId: transitionId);

    //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Transaction Completed Successfully!'.tr,
          onConfirmBtnTap: (){
            Get.offAll(HomeView());
          }
      );

      // subCategoryVehicle = SubCategoryVehicle.fromJson(response.body);
      //
      // isVehicle = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isVehicle = false;
    update();



  }
  Future<void> _updateDriverLocationOnServer(double latitude,
      double longitude) async {

    try {
      print("🚀 Updating location with lat: $latitude, long: $longitude, ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}");

      await updateDriverLocation(
        lat: latitude.toString(),
        long: longitude.toString(),
        locationTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );

      print("✅ Location updated successfully");
    } catch (e) {
      print("❌ Error updating location: $e");
    }
  }

  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    _locationUpdateTimer?.cancel();
    print("🛑 Location updates stopped");
  }


  updateGetIndex(int index) {
    getIndex = index;
    update();
  }

  void setCurrentIndex(int index, bool notify) {
    currentIndex = index;
    if (notify) {
      update();
    }
  }

  RxString selectedLanguage = "English".obs;
  Future<void> loginFunction(String email, String password,deviceToken) async {
    isLoading = true;

    update();
    print(getUserDeviceID());
    String? token = "";

    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    }
    else {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }


    Response response = await authRepo.login(
        token: token,
        phone: email, password: password,
    deviceToken: deviceToken);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (response.body["status"].toString() == "false") {
        showCustomSnackBar(
            response.body["message"], getXSnackBar: false, isError: true);
      }
      else {
        showCustomSnackBar(
            response.body["message"], getXSnackBar: false, isError: false);
        // loginResponse = LoginResponse.fromJson(response.body);
        // _lResponse = LoginResponse.fromJson(response.body);
        authRepo.saveUserToken(response.body['token']);
        if (response.body["category_id"] != null &&
            response.body["category_id"].isNotEmpty &&
            response.body["category_id"].toString() != "0") {
          authRepo.isCategoryValue(true);
        }
        else {
          authRepo.isCategoryValue(false);
        }
        authRepo.saveUserName(response.body['name']);
        authRepo.saveUserEmail(response.body['email']);
        authRepo.setMaxTime(response.body['max_loading_time'].toString());
        authRepo.setPricePerMinute(response.body['loading_charge_per_min'].toString());

        if (response.body['is_loading_time'].toString() == "true") {
          authRepo.saveIsLoadingTime(true);
        }
        else {
          authRepo.saveIsLoadingTime(false);
        }
        if (response.body['kyc_status'].toString() == "complete") {
          authRepo.saveUserKyc(true);
        }
        else {
          authRepo.saveUserKyc(false);
        }

        if (response.body['payment_status'].toString() == "paid") {
          authRepo.saveUserPayment(true);
        }
        else {
          authRepo.saveUserKyc(false);
        }
        authRepo.saveUserPhone(response.body['contact_number']);
        authRepo.saveUserFee(response.body['registration_fees'].toString());
        // authRepo.saveUserPassword(password);
        authRepo.saveUserId(response.body['id'].toString());
        // if(response.body["success"]) {
        //   showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);
        // }


        if (response.body["category_id"] != null &&
            response.body["category_id"].isNotEmpty &&
            response.body["category_id"].toString() != "0") {
          Get.offAll(HomeView());
        }
        else {
          Get.offAll(CategoryListPage());
        }
      }
      _image = null;
    }
    else {
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
  String deviceId = "Unknown";
  Future<void> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfoPlugin.androidInfo;
        // setState(() {
         deviceId = androidInfo.id;
        // });
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfoPlugin.iosInfo;
        // setState(() {
          deviceId = iosInfo.identifierForVendor ?? "Unknown";
        // });
      }
    } catch (e) {
      // setState(() {
       deviceId = "Failed to get device ID: $e";
      // });
    }
  }
  Future<void> checkDriverDevice(deviceToken) async {
    update();
    getDeviceId();
    if(getUserID() != null && deviceToken != 'Unknown'){
    Response response = await authRepo.checkDriverDevice(
    deviceToken: deviceToken,
    userID: getUserID());
    deviceLogoutModel = DeviceLogoutModel();
    if (response.statusCode == 200) {
      deviceLogoutModel = DeviceLogoutModel.fromJson(response.body);
      print('object:::::::::${response.body['is_valid'].toString()}');
      if(response.body['is_valid'] == false){
        logoutUser();
        update();
      }
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
    }
  }
  Future<void> getNotificationHistory(body) async {
    // update();
    Response response = await authRepo.notificationHistory(body);
    if (response.statusCode == 200) {

      notificationHistoryModel.value = NotificationHistoryModel.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    // update();
  }

  Future<void> getDailyEarningsFun(date) async {
    // update();
    getDeviceId();
    Response response = await authRepo.getDailyEarnings(
    date: date,
    userID: getUserID());
    if (response.statusCode == 200) {
      dailyEarningsMd.value = DailyEarningsMd.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
  Future<void> getDateRangeEarningsFun({stateDate,endDate}) async {
    // update();
    getDeviceId();
    Response response = await authRepo.getDateRangeEarnings(
    endDate: endDate,
    startDate: stateDate,
    userID: getUserID());
    if (response.statusCode == 200) {
      weeklyEarn.value = WeeklyEarn.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
  Future<void> getDateRangeEarningsMonthFun({stateDate,endDate}) async {
    // update();
    getDeviceId();
    Response response = await authRepo.getDateRangeEarnings(
    endDate: endDate,
    startDate: stateDate,
    userID: getUserID());
    if (response.statusCode == 200) {
      monthlyEarnModel.value = MonthlyEarnModel.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  Future<void> getLifetimeEarningsFun() async {
    // update();
    getDeviceId();
    Response response = await authRepo.getLifetimeEarningsUrl(
    userID: getUserID());
    if (response.statusCode == 200) {
      lifeTimeEarnModel.value = LifeTimeEarnModel.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  List<GetBookingsBydateAndDriverModel>getBookingsBydateAndDriverModelList = [];
  RxInt refreshInt = 0.obs;
  Future<void> getBookingsBydateAndDriverFun(date) async {
    // update();
    getDeviceId();
    getBookingsBydateAndDriverModelList = [];
    Response response = await authRepo.getBookingsBydateAndDriver(
    date: date,
    userID: getUserID());
    if (response.statusCode == 200 || response.statusCode == 400) {
      refreshInt.value = DateTime.now().microsecondsSinceEpoch;
      for (int i = 0; i < response.body.length; i++) {
        getBookingsBydateAndDriverModelList.add(GetBookingsBydateAndDriverModel.fromJson(response.body[i]));
      }
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  Future<void> incomeDriver() async {
    isLoading = true;

    update();
    print(getUserDeviceID());
    walletAmount = "0";


    Response response = await authRepo.incomeDriver(userID: getUserID());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (response.body["balance_amount"] != null) {
        walletAmount =
            (double.parse((response.body["balance_amount"] ?? 0).toString()))
                .toStringAsFixed(0);
        update();
      }
    }
    else {
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  Future<void> paymentHistory() async {
    isLoading = true;

    update();
    print(getUserDeviceID());


    Response response = await authRepo.paymentHistory(userID: getUserID());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {


    }
    else {
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  Future<void> updateDriverLocation({String? lat, String? long, String? locationTime}) async {
    isLoading = true;

    update();
    print(getUserDeviceID());


    if (isLoggedIn()) {
      Response response = await authRepo.updateDriverLocation(
          userID: getUserID(), long: long, lat: lat,locationTimer: locationTime);

      //  LoginResponse? loginResponse;

      if (response.statusCode == 200 || response.statusCode == 400) {
        print('response himu ${response.body.toString()}');

        /// updateDriverLocation(lat:lat.toString(),long:long.toString());

      }
      else {
        ApiChecker.checkApi(response);
      }

      isLoading = false;
      update();
    }
  }

  List<WalletResponse>walletResponseList = [];
  // List<InactiveWalletModel>walletInactiveList = [];
  InactiveWalletModel inactiveWalletModel = InactiveWalletModel();
  Future<void> changeLoginStatus(
      {String? status, BuildContext? context}) async {
    isLoading = true;

    update();
    print(getUserDeviceID());


    Response response = await authRepo.changeLoginStatus(
      userID: getUserID(), status: status,);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (status == "online") {
        await DriverNotificationService.showOnlineNotification();
      }

      else {
        await DriverNotificationService.showOfflineNotification();
      }

      driverInfo(context!);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }


  String todayLoginTIme = "";

  Future<void> driverOnlineTIme() async {
    isLoading = true;

    update();
    print(getUserDeviceID());


    Response response = await authRepo.driverOnlineTIme(userID: getUserID());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (response.body != null) {
        todayLoginTIme = response.body["online_time"].toString();
        update();
      }
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  String totalLoginTIme = "";

  Future<void> driverOnlineTotalTIme() async {
    isLoading = true;

    update();
    print(getUserDeviceID());


    Response response = await authRepo.driverOnlineTotalTIme(
        userID: getUserID());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (response.body != null) {
        totalLoginTIme = response.body["online_time"].toString();
        update();
      }
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  Future<void> getWalletHistory() async {
    isLoading = true;

    update();
    print(getUserDeviceID());

    walletResponseList = [];

    Response response = await authRepo.getWalletHistory(userID: getUserID());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      for (int i = 0; i < response.body.length; i++) {
        walletResponseList.add(WalletResponse.fromJson(response.body[i]));
      }
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
  Future<void> getWalletInactiveHistory() async {
    isLoading = true;

    update();
    print(getUserDeviceID());
    Response response = await authRepo.getInactiveBalanceUrl(userID: getUserID());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      inactiveWalletModel = InactiveWalletModel.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  Future<void> saveFirebaseToken(String token) async {
    isLoading = true;

    update();
    print(getUserDeviceID());


    Response response = await authRepo.saveFirebaseToken(userID: token);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {


    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }

  Future<void> bookingStatusChange(
      {String? status, String? cus_id, String? orderID, String? amount, int? value}) async {
    isLoading = true;
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.bookingStatusChange(userID: getUserID(),
        status: status,
        cus_id: cus_id,
        orderID: orderID,
        amount: amount);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      hasShownSheet = false;

      Get.offAll(HomeView());
      // if(value ==0) {
      //   Get.offAll(HomeView());
      // }


    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> accpetBooking(
      {String? cus_id, String? orderID, String? amount, int? value}) async {
    isLoading = true;
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.accpetBooking(
        userID: getUserID(), bookingId: orderID);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      stopRingtone();


      hasShownSheet = false;

      Get.offAll(HomeView());
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> saveDriverBasicDetails(body, File? adhaarF) async {
    isUploading = true;


    update();
    print(getUserDeviceID());
    String? token = "";
    List<MultipartBody> multipartBody = [];

    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    }
    else {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    if (adhaarF != null) {
      multipartBody.add(MultipartBody("profile_img", XFile(adhaarF.path)));
    }
    body.addAll({
      "device_token": token.toString()
    });


    Response response = await authRepo.driverBasicInfo(body, multipartBody);

    //  LoginResponse? loginResponse;
    if (response.statusCode == 200 || response.statusCode == 400) {
      if (response.body["data"] != null) {
        Get.to(VehicleDocumentUploadView(
          id: response.body["data"]["driver_id"].toString(),));
      } else if(response.body["message"] == 'User Already Registered.'){
        showCustomSnackBar(response.body["message"].toString(),isError: true);
        Get.offAllNamed(RouteHelper.login);
      }
    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  bool isUploading = false;
  bool isRegistration = false;

  Future<void> updatePassword(body) async {
    isRegistration = true;

    update();


    Response response = await authRepo.updatePassword(body);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      showCustomSnackBar(
          response.body["message"], getXSnackBar: false, isError: false);


      Get.offAll(MobileNumberView());
      update();
    }
    else {
      ApiChecker.checkApi(response);
    }

    isRegistration = false;
    update();
  }

  Future<void> changePassword(body) async {
    isRegistration = true;

    update();


    Response response = await authRepo.updatePassword(body);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      showCustomSnackBar(
          response.body["message"], getXSnackBar: false, isError: false);


      Get.back();
      update();
    }
    else {
      ApiChecker.checkApi(response);
    }

    isRegistration = false;
    update();
  }

  Future<dynamic> forgetPassword(body) async {
    isRegistration = true;

    update();

    String? token;


    Response response = await authRepo.forgetPassword(body);

    //  LoginResponse? loginResponse;

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 400) {
      update();
      isRegistration = false;
      return response.body;
    }
    else {
      ApiChecker.checkApi(response);
      isRegistration = false;
      update();

      return null;
    }
  }


  Future<void> updateDriverKyc(body, BuildContext context,
      {XFile? adhaarF, XFile? adhaarb, XFile? panImage, XFile? licenseNumberB, XFile? lienB, XFile? insur, bool isEdit = false}) async
  {
    isUploading = true;

    update();


    //  LoginResponse? loginResponse;

    List<MultipartBody> multipartBody = [];


    if (adhaarF != null) {
      multipartBody.add(MultipartBody("adhar_front", XFile(adhaarF.path)));
    }
    if (adhaarb != null) {
      multipartBody.add(MultipartBody("adhaar_back", XFile(adhaarb.path)));
    }
    if (panImage != null) {
      multipartBody.add(MultipartBody("pan_image", XFile(panImage.path)));
    }

    if (licenseNumberB != null) {
      multipartBody.add(
          MultipartBody("license_front", XFile(licenseNumberB.path)));
    }

    if (lienB != null) {
      multipartBody.add(MultipartBody("license_back", XFile(lienB.path)));
    }

    if (insur != null) {
      multipartBody.add(MultipartBody("insurance_img", XFile(insur.path)));
    }


    Response response = await authRepo.updateDriverKyc(body, multipartBody);
    if (response.statusCode == 200) {
      // if(response.body["data"]!=null){

      if (isEdit) {
        Get.back();
        driverInfo(context);
      }
      else {
        Get.to(
            BankDetailView(driverID: response.body["driver_id"].toString(),));
      }

      // }


    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> updateAdharFront(body,
      {XFile? adhaarF}) async
  {
    // isUploading = true;

    update();


    //  LoginResponse? loginResponse;

    List<MultipartBody> multipartBody = [];


    if (adhaarF != null) {
      multipartBody.add(MultipartBody("adhar_front", XFile(adhaarF.path)));
    }

    Response response = await authRepo.updateAdharFrontKyc(body, multipartBody);
    if (response.statusCode == 200) {
      // if(response.body["data"]!=null){

      // }


    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }
  Future<void> updateAdharBack(body,
      {XFile? adhaarB}) async
  {
    update();
    List<MultipartBody> multipartBody = [];

    if (adhaarB != null) {
      multipartBody.add(MultipartBody("adhaar_back", XFile(adhaarB.path)));
    }
    Response response = await authRepo.updateAdharBackKyc(body, multipartBody);
    if (response.statusCode == 200) {}
    else {}
    Globs.hideHUD();
    update();
  }
  Future<void> updatePenCard(body,
      {XFile? adhaarB}) async
  {
    update();
    List<MultipartBody> multipartBody = [];

    if (adhaarB != null) {
      multipartBody.add(MultipartBody("pan_image", XFile(adhaarB.path)));
    }
    Response response = await authRepo.updatePenCardKyc(body, multipartBody);
    if (response.statusCode == 200) {}
    else {}
    Globs.hideHUD();
    update();
  }
  Future<void> updateLicenceFKyc(body,
      {XFile? adhaarB}) async
  {
    update();
    List<MultipartBody> multipartBody = [];

    if (adhaarB != null) {
      multipartBody.add(MultipartBody("license_front", XFile(adhaarB.path)));
    }
    Response response = await authRepo.updateLicenceFKyc(body, multipartBody);
    if (response.statusCode == 200) {}
    else {}
    Globs.hideHUD();
    update();
  }
  Future<void> updateLicenceBKyc(body,
      {XFile? adhaarB}) async
  {
    update();
    List<MultipartBody> multipartBody = [];

    if (adhaarB != null) {
      multipartBody.add(MultipartBody("license_back", XFile(adhaarB.path)));
    }
    Response response = await authRepo.updateLicenceBKyc(body, multipartBody);
    if (response.statusCode == 200) {}
    else {}
    Globs.hideHUD();
    update();
  }
  Future<void> updateInsuranceImageURLKyc(body,
      {XFile? adhaarB}) async
  {
    update();
    List<MultipartBody> multipartBody = [];

    if (adhaarB != null) {
      multipartBody.add(MultipartBody("insurance_img", XFile(adhaarB.path)));
    }
    Response response = await authRepo.updateInsuranceImageURLKyc(body, multipartBody);
    if (response.statusCode == 200) {}
    else {}
    Globs.hideHUD();
    update();
  }

  Future<void> updateDriverBankDetail(body, BuildContext context,
      {bool isEdit = false}) async {
    isUploading = true;

    Response response = await authRepo.updateDriverBankDetail(body);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      showCustomSnackBar("Account Created please Login".tr, isError: false);

      if (isEdit) {
        Get.back();
        driverInfo(context);
      }
      else {
        Get.offAll(MobileNumberView());
      }
    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> ticketRez(body) async {
    isUploading = true;

    Response response = await authRepo.ticketRez(body);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      showCustomSnackBar("Ticket raise successfully".tr, isError: false);

      Get.back();
    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  CheckTicketLimitModel checkTicketLimitModel = CheckTicketLimitModel();
  DeviceLogoutModel deviceLogoutModel = DeviceLogoutModel();
  Rx<DailyEarningsMd> dailyEarningsMd = DailyEarningsMd().obs;
  Rx<NotificationHistoryModel> notificationHistoryModel = NotificationHistoryModel().obs;
  Rx<LifeTimeEarnModel> lifeTimeEarnModel = LifeTimeEarnModel().obs;
  Rx<WeeklyEarn> weeklyEarn = WeeklyEarn().obs;
  Rx<MonthlyEarnModel> monthlyEarnModel = MonthlyEarnModel().obs;
  Future<void> checkTicket(body) async {
    Response response = await authRepo.checkTicketLimits(body);
    if (response.statusCode == 200) {
      checkTicketLimitModel = CheckTicketLimitModel.fromJson(response.body);

    }
    else {
    }
    Globs.hideHUD();
    update();
  }

  Future<void> updateDriverPaymentStatus(body) async {
    isUploading = true;

    Response response = await authRepo.updateDriverPaymentStatus(body);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      authRepo.saveUserPayment(true);

      update();
      Get.offAll(HomeView());
    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  List<CityResponse> cityResponse = [];
  List<PaymentHistoryModel> paymentResponse = [];

  Future<void> getCity() async {
    isUploading = true;


    Response response = await authRepo.getCity();
    cityResponse = [];

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      for (int i = 0; i < response.body.length; i++) {
        cityResponse.add(CityResponse.fromJson(response.body[i]));
      }


      update();
    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> getPaymentList(body) async {
    Response response = await authRepo.paymentHistoryRepo(body);
    paymentResponse = [];

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      for (int i = 0; i < response.body.length; i++) {
        paymentResponse.add(PaymentHistoryModel.fromJson(response.body[i]));
      }


      update();
    }
    else {


    }
    Globs.hideHUD();
    update();
  }

  List<FaqDriverResponse>faqDriverResponse = [];

  Future<void> getDriverFAQ() async {
    isUploading = true;


    Response response = await authRepo.driverFAQ();
    faqDriverResponse = [];

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      for (int i = 0; i < response.body.length; i++) {
        faqDriverResponse.add(FaqDriverResponse.fromJson(response.body[i]));
      }


      update();
    }
    else {


    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> vehicleDetailsUpload(body, String id, XFile? vehicle,
      XFile? frontImage, XFile?backImage, BuildContext context,
      {bool isEdit = false}) async {
    isUploading = true;
    update();
    List<MultipartBody> multipartBody = [];

    // print(frontImage!.path.toString());
    // print(backImage!.path.toString());

    // if(vehicle!=null){
    //   multipartBody.add(MultipartBody("vehicle_image", XFile(vehicle.path)));
    // }
    if (frontImage != null) {
      multipartBody.add(MultipartBody("rc_front", XFile(frontImage.path)));
    }
    if (backImage != null) {
      multipartBody.add(MultipartBody("rc_back", XFile(backImage.path)));
    }

    print(getUserDeviceID());
    String? token = "";


    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    }
    else {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }


    Response response = await authRepo.vehicleDetailsUpload(
        body, multipartBody);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200) {
      if (isEdit) {
        driverInfo(context);
        Get.back();
      }
      else {
        Get.to(DocumentUploadView(
          title: "ID Proof", id: response.body["driver_id"].toString(),));
      }
    }
    else {

     showCustomSnackBar(response.body['message'].toString(),isError: true,getXSnackBar: true);
    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> updateDriverVehicle({String? orderID}) async {
    isUploading = true;


    update();
    print(getUserDeviceID());


    Response response = await authRepo.updateDriverVehicle(
        userID: getUserID(), category_id: orderID);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      hasShownSheet = false;

      Get.offAll(HomeView());
    }
    else {
      ApiChecker.checkApi(response);
    }

    isUploading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> orderPicked(
      {String? cus_id, String? orderID, String? amount, int? value,String? locationID,context}) async {
    isLoading = true;
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.orderPicked(
        userID: getUserID(),
        bookingId: orderID,
        loadingCharges: chargesLoading.toString(),
        loadingTime: realLoadingTime.toString(),
         locationID: locationID

    );

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      stopRingtone();
      authRepo.saveUserBooking(orderID.toString());
      hasShownSheet = false;
      checkDriverBooking(context);
      // Get.offAll(HomeView());
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> orderDelivered(
      {String? cus_id, String? orderID, String? amount, int? value,context}) async
  {
    isLoading = true;
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.orderDelivered(
        userID: getUserID(), bookingId: orderID,
       unloadCharges: chargesUnLoading.toString(),
        unloadDuration: realUnLoadingTime.toString()
    );

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      hasShownSheet = false;
      authRepo.saveUserBooking("0");
      startJourneyToNext(  cus_id: getUserID(), orderID: orderID);
      // Get.offAll(HomeView());
      checkDriverBooking(context);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    Globs.hideHUD();
    update();
  }

  Future<void> startJourneyToNext(
      {String? cus_id, String? orderID}) async
  {
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.startJourneyToNextFun(
        userID: getUserID(), bookingId: orderID,
    );

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {

      // Get.offAll(HomeView());
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    Globs.hideHUD();
    update();
  }


  RunningOrderResponse? runningOrderResponse = RunningOrderResponse();

  Future<void> checkDriverBooking(BuildContext context) async {
    update();
    print(getUserDeviceID());

    if (isKyc() && isPayment()) {
      isLoading = true;
      // Globs.showHUD();
      Response response = await authRepo.checkDriverBooking(
          userID: getUserID());

      //  LoginResponse? loginResponse;


      if (response.statusCode == 200 || response.statusCode == 400) {
        runningOrderResponse = null;


        runningOrderResponse = RunningOrderResponse.fromJson(response.body);

        checkAndStartBookingNotification(context);

        if (response.body["status"] == false) {
          checkAndStartBookingNotification(context);
        }
        else {
          // checkAndShowBottomSheet(context);
          checkAndShowPage(context);
        }


        update();
      }
      else {
        ApiChecker.checkApi(response);
      }

      isLoading = false;
      // Globs.hideHUD();
      update();
    }
  }

  Future<void> startTrip(String id, String status, BuildContext context,
      String cusId, String orderID, String amount) async
  {
    isLoading = true;
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.startTrip(iD: id, type: status);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (status.toLowerCase() == "no") {
        checkAndStartBookingNotification(context);

        bookingStatusChange(status: "close",
            cus_id: cusId,
            orderID: orderID,
            amount: amount,
            value: 1);
      }
      else {
        bookingStatusChange(status: "accept",
            cus_id: cusId,
            orderID: orderID,
            amount: amount,
            value: 1);
      }


      update();
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    Globs.hideHUD();
    update();
  }
  Future<void> startLoadingApi(String id, BuildContext context, String orderID,String locationID) async
  {
    isLoading = true;
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.startLoading(bookingId: orderID,userID: id,locationID: locationID);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      hasShownSheet = false;
      checkDriverBooking(context);
      // Get.offAll(HomeView());
      update();
    }
    else {
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    Globs.hideHUD();
    update();
  }
  Future<void> startUnLoadingApi(String id, BuildContext context, String orderID,String locationID) async
  {
    isLoading = true;
    Globs.showHUD();

    update();
    print(getUserDeviceID());


    Response response = await authRepo.startUnLoading(bookingId: orderID,userID: id,locationID: locationID);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      hasShownSheet = false;
      checkDriverBooking(context);
      // Get.offAll(HomeView());
      update();
    }
    else {
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    Globs.hideHUD();
    update();
  }

  void checkAndShowBottomSheet(BuildContext context) {
    if (runningOrderResponse != null && runningOrderResponse!.orders != null &&
        runningOrderResponse!.orders !.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showRunningDetailsSheet(runningOrderResponse!.orders![0], context);
      });
    } else if (notificationResponse.isNotEmpty) {
      print("length=>${notificationResponse.length}");

      update();
      stopBookingNotificationPolling();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          //   showRideDetailsSheet(notificationResponse[0], context);
        }
      });
    }
  }

  List<BookingNotificationResponse> notificationResponse = [];

  Future<void> getBookingNotification(BuildContext context) async {
    isLoading = true;

    update();
    print(getUserDeviceID());


    if (isKyc() && isPayment()) {
      Response response = await authRepo.getBookingNotification(
          userID: getUserID());

      //  LoginResponse? loginResponse;

      if (response.statusCode == 200 || response.statusCode == 400) {
        notificationResponse = [];

        if (response.body["bookings"] != null &&
            response.body["bookings"].isNotEmpty) {
          for (int i = 0; i < response.body["bookings"].length; i++) {
            notificationResponse.add(BookingNotificationResponse.fromJson(
                response.body["bookings"][i]));
          }

          // checkAndShowBottomSheet(context);
          checkAndShowPage(context);
          checkDriverBooking(context);
          stopBookingNotificationPolling();

          //  await  context.push( TipRequestView(bObj: BookingNotificationResponse.fromJson(response.body[0])) );
        }
      }
      else {
        ApiChecker.checkApi(response);
      }

      isLoading = false;
      update();
    }
  }


  Future<void> getAllVehicleData() async {
    isVehicle = true;

    update();
    print(getUserDeviceID());


    vehicleData = null;

    Response response = await authRepo.getAllVehicle();


    if (response.statusCode == 200 || response.statusCode == 400) {
      vehicleData = VehicleData.fromJson(response.body);

      isVehicle = false;
      update();
    }
    else {
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);
    }

    isVehicle = false;
    update();
  }

  DriverInResponse? driverInResponse = DriverInResponse();

  // Future<void> driverInfo(BuildContext context) async {
  //   isLoading = true;
  //
  //   update();
  //   print(getUserDeviceID());
  //   driverInResponse = null;
  //
  //
  //   Response response = await authRepo.driverInfo(getUserID().toString());
  //
  //   //  LoginResponse? loginResponse;
  //
  //   if (response.statusCode == 200 || response.statusCode == 400) {
  //     driverInResponse = DriverInResponse.fromJson(response.body);
  //
  //     if (driverInResponse != null) {
  //       if (driverInResponse!.paymentStatus.toString() == "paid") {
  //         authRepo.saveUserPayment(true);
  //       }
  //       else {
  //         authRepo.saveUserPayment(false);
  //       }
  //
  //       if (driverInResponse!.kyc.toString() == "complete") {
  //         authRepo.saveUserKyc(true);
  //       }
  //       else {
  //         authRepo.saveUserKyc(false);
  //       }
  //     }
  //
  //     checkDriverBooking(context);
  //
  //
  //     update();
  //   }
  //   else {
  //     ApiChecker.checkApi(response);
  //   }
  //
  //   isLoading = false;
  //   update();
  // }

  Future<void> driverInfo(BuildContext context) async {
    isLoading = true;

    update();
    print(getUserDeviceID());
    driverInResponse = null;


    Response response = await authRepo.getDriverDetail(customerID: getUserID().toString());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      driverInResponse = DriverInResponse.fromJson(response.body);

      if (driverInResponse != null) {
        if (driverInResponse!.driverDetails!.paymentStatus.toString() == "paid") {
          authRepo.saveUserPayment(true);
        }
        else {
          authRepo.saveUserPayment(false);
        }

        if (driverInResponse!.driverDetails!.kyc.toString() == "complete") {
          authRepo.saveUserKyc(true);
        }
        else {
          authRepo.saveUserKyc(false);
        }
      }

      checkDriverBooking(context);


      update();
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
  bool getAllBookingLoading = false;

  List<BookingListResponse>bookingListResponse = [];
  List<MissedOrderListModel> missedOrderListModel = [];

  Future<void> getAllBooking(
      {String? status, String? limit, String? offset}) async {
    getAllBookingLoading = true;

    update();
    print(getUserDeviceID());


    // vehicleData = null;
    Response response = await authRepo.getAllBooking(
        status: status, limit: limit, offset: offset, userID: getUserID());


    bookingListResponse = [];
    if (response.statusCode == 200 || response.statusCode == 400) {
      isShowDriver = false;
      for (int i = 0; i < response.body.length; i++) {
        bookingListResponse.add(BookingListResponse.fromJson(response.body[i]));
      }


      // getAllBookingLoading = false;
      update();
    }
    else {
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);
    }

    getAllBookingLoading = false;
    update();
  }

  Future<void> getMissedOrder(body) async {
    Response response = await authRepo.missedOrderRepo(body);
    missedOrderListModel = [];
    if (response.statusCode == 200 || response.statusCode == 400) {
      for (int i = 0; i < response.body.length; i++) {
        missedOrderListModel.add(
            MissedOrderListModel.fromJson(response.body[i]));
      }


      update();
    }
    else {


    }
    Globs.hideHUD();
    update();
  }

  bool isBookingDetails = false;
  BookingDetailsResponse? bookingDetailsResponse = BookingDetailsResponse();
  PaymentHistoryModel? paymentHistoryModel = PaymentHistoryModel();

  Future<void> getBookingDetails(
      {String? bookingID, String? driverLat, String? driverLng}) async
  {
    isBookingDetails = true;

    update();
    print(getUserDeviceID());
    bookingDetailsResponse = null;


    // vehicleData = null;
    Response response = await authRepo.getBookingDetails(
        bookingID: bookingID, userID: getUserID());


    if (response.statusCode == 200 || response.statusCode == 400) {
      bookingDetailsResponse = BookingDetailsResponse.fromJson(response.body);

      if (driverLat != null && driverLat!.isNotEmpty && driverLng != null &&
          driverLng!.isNotEmpty && bookingDetailsResponse != null) {
        print("driverLat!=>$driverLat!");
        print("driverLng!=>$driverLng!");
      }


      // getAllBookingLoading = false;
      update();
    }
    else {
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);
    }

    isBookingDetails = false;
    update();
  }

  Future<void> updateImage(var image) async
  {
    _image = image;

    update();
  }


  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();

    // Pick image from the front camera
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,

    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }

    update();
  }


  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool isCategoryID() {
    return authRepo.sharedPreferences.getBool("category_id") ?? false;
  }

  bool isKyc() {
    return authRepo.sharedPreferences.getBool(AppContants.userKYC) ?? false;
  }

  bool isPayment() {
    return authRepo.sharedPreferences.getBool(AppContants.userPayment) ?? false;
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String? getUserID() {
    return authRepo.sharedPreferences.getString(AppContants.userID);
  }

  String? getRegistrationFee() {
    return authRepo.sharedPreferences.getString(AppContants.userFee);
  }

  String? getUserDeviceID() {
    return authRepo.sharedPreferences.getString(AppContants.userDeviceID);
  }

  String? getUserPassword() {
    return authRepo.sharedPreferences.getString(AppContants.userPassword);
  }

  String? getUserName() {
    return authRepo.sharedPreferences.getString(AppContants.userName);
  }

  String? getUserEmail() {
    return authRepo.sharedPreferences.getString(AppContants.userEmail);
  }

  String? getUserPhone() {
    return authRepo.sharedPreferences.getString(AppContants.userPhone);
  }

  Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ✅ Clear all stored preferences
    await prefs.clear();

    // ✅ Optional: navigate to login or splash screen
    Get.offAll(MobileNumberView());
    driverInResponse = DriverInResponse();
  }


  void showRideDetailsSheet(BookingNotificationResponse notificationResponse,
      BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      // Allows the sheet to take up more space
      backgroundColor: Colors.transparent,
      // Makes the rounded corners visible
      builder: (context) =>
          Container(
            padding: const EdgeInsets.only(top: 20),
            // Space for the drag handle
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: DraggableScrollableSheet(
              expand: false,
              shouldCloseOnMinExtent: false,
              initialChildSize: 0.5,
              // Initial height (40% of screen)
              minChildSize: 0.3,
              // Minimum height when dragged down
              maxChildSize: 0.7,
              // Maximum height when dragged up
              builder: (context, scrollController) {
                return WillPopScope(
                  onWillPop: () async {
                    // ❌ back button से बंद नहीं होने देना
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: _buildRideDetailsContent(
                        notificationResponse, context),
                  ),
                );
              },
            ),
          ),
    );
  }


  void showRunningDetailsSheet(Orders? notificationResponse,
      BuildContext context)
  {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      showDragHandle: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: DraggableScrollableSheet(
              expand: false,
              shouldCloseOnMinExtent: false,
              initialChildSize: 0.5,
              minChildSize: 0.2,
              maxChildSize: 0.7,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: buildRunningDetailsContent(
                      notificationResponse!,
                      context,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


// The content of your bottom sheet (your original Column widget with slight modifications)
  Widget _buildRideDetailsContent(BookingNotificationResponse bookingResponse,
      BuildContext context) {
    return Column(
      children: [
        // Drag handle indicator
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 15),

        // Your original content with some padding adjustments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${AppContants.rupessSystem} ${bookingResponse.data![0].amount ?? ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: calculateDropDistancesForBooking(bookingResponse.data![0]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Calculating...",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                        } else {
                          final data = snapshot.data!;
                          final km = data['total_distance_km'];
                          final duration = data['total_duration'];

                          return Text(
                            "${km.toStringAsFixed(2)} KM • $duration",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: TColor.secondaryText, fontSize: 18),
                          );
                        }
                      },
                    ),
                  ),


                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: TColor.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${bookingResponse.data![0].pickup!.address ?? ""}",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: TColor.primary),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${bookingResponse.data![0].dropoffs![0].address ?? ""}",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      stopRingtone();
                      // Navigator.pop(context); // Close the bottom sheet
                      bookingStatusChange(
                          status: "cancel",
                          amount: bookingResponse.data![0].amount,
                          orderID: bookingResponse.data![0].orderId,
                          cus_id: bookingResponse.data![0].cusId,
                          value: 0
                      );
                    },
                    child: Container(

                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: TColor.red,
                        shape: BoxShape.circle,

                      ),
                      child: Icon(Icons.close, color: Colors.white,),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        accpetBooking(
                            orderID: bookingResponse.data![0].orderId,
                            cus_id: bookingResponse.data![0].cusId,
                            value: 0
                        );
                      },
                      child: Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "TAP TO ACCEPT".tr,
                                  style: TextStyle(
                                    color: TColor.primaryTextW,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "15",
                                style: TextStyle(
                                  color: TColor.primaryTextW,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }
  void openDirection(Orders order) {
    if (order.orderStatus!.toLowerCase() == "picked") {
      final sorted = List.from(order.dropoffs!)
        ..sort((a, b) => int.parse(a.sequence!).compareTo(int.parse(b.sequence!)));

      final drop = sorted[currentDropIndex.value];

      openGoogleMap(double.parse(drop.lat!), double.parse(drop.lng!));
    } else {
      openGoogleMap(double.parse(order.pickup!.lat!), double.parse(order.pickup!.lng!));
    }
  }
  String getStatusButtonText(Orders order) {
    final status = order.orderStatus!.toLowerCase();

    if (status == "accpeted") return "Start Loading";
    if (status == "loading") return "Start Trip";
    if (status == "picked") return "Unloading";
    if (status == "unloading") return "Completed";

    return "Action";
  }

  void handleStatusAction(Orders order, BuildContext context) async {
    final status = order.orderStatus!.toLowerCase();

    if (status == "accpeted") {
      startLoadingApi(getUserID().toString(), context, order.bookingId.toString(),
          order.pickup!.locationId.toString());
    }

    else if (status == "loading") {
      orderPicked(orderID: order.bookingId.toString(),
          locationID: order.pickup!.locationId.toString(),context: context);
    }

    else if (status == "picked") {

      final drops = order.dropoffs ?? [];
      final sorted = List.from(drops)
        ..sort((a, b) => int.parse(a.sequence!).compareTo(int.parse(b.sequence!)));

      final drop = sorted[currentDropIndex.value];

      await startUnLoadingApi(
        getUserID().toString(),
        context,
        order.bookingId.toString(),
        drop.locationId.toString(),
      );

      await nextDrop(sorted.length);
    }

    else if (status == "unloading") {
      orderDelivered(orderID: order.bookingId.toString());
    }
  }

  void checkAndShowPage(BuildContext context) {
    if (runningOrderResponse != null &&
        runningOrderResponse!.orders != null &&
        runningOrderResponse!.orders!.isNotEmpty) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RunningOrderScreen(
              // order: runningOrderResponse!.orders![0],
            ),
          ),
        );
      });
    }
  }

  Widget buildRunningDetailsContent(Orders bookingResponse,
      BuildContext context) {
    return Column(
      children: [
        // Drag handle indicator
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 15),

        // Your original content with some padding adjustments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/men/1.jpg'),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${bookingResponse.pickup!.name.toString()}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                AppContants.makePhoneCall(
                                    bookingResponse.pickup!.contactNumber.toString());
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.call_outlined, color: Colors.blue,
                                      size: 16),
                                  const SizedBox(width: 5),
                                  Text(
                                      '${bookingResponse.pickup!.contactNumber.toString()}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => FaqScreen(),));
                      },
                      child: Image.asset('assets/img/help.png',
                        height: 40,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 10,),

              InkWell(
                onTap: () {
                  print('dsdsdsds${ loadingStart.value.toString()}');
                  print('dsdsdsds${ unloadingStart.value.toString()}');
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${AppContants.rupessSystem} ${bookingResponse.amount ?? ""}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: calculateDropDistancesForBooking(bookingResponse),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("Calculating...",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: TColor.secondaryText, fontSize: 18));
                          } else {
                            final data = snapshot.data!;
                            final km = data['total_distance_km'];
                            final duration = data['total_duration'];

                            return Text(
                              "${km.toStringAsFixed(2)} KM • $duration",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.secondaryText, fontSize: 18),
                            );
                          }
                        },
                      ),
                    ),
                    /*Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img/rate_tip.png",
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "5",
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.green,),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${bookingResponse.pickup!.address ?? ""}",
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              AppContants.makePhoneCall(
                                  bookingResponse.pickup!.contactNumber.toString());
                            },
                            child: Row(
                              children: [
                                Icon(Icons.call_outlined, color: Colors.blue,
                                    size: 16),
                                const SizedBox(width: 5),
                                Text('${bookingResponse.pickup!.contactNumber.toString()} , ${bookingResponse.pickup!.name.toString()}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.red,),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: bookingResponse.dropoffs?.length ?? 0,
                        itemBuilder: (context, index) {
                          final dropoff = bookingResponse.dropoffs![index];

                           // bool isCompleted = index < currentDropIndex.value ||
                           //    (isLastDropCompleted.value && index == currentDropIndex.value);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dropoff.address ?? "",
                                        style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    AppContants.makePhoneCall(dropoff.contactNumber.toString());
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.call_outlined, color: Colors.blue, size: 16),
                                      const SizedBox(width: 5),
                                      Text('${dropoff.contactNumber} , ${dropoff.name}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              bookingResponse.orderStatus.toString().toLowerCase() ==
                  "delivered" &&
                  bookingResponse.paymentStatus.toString().toLowerCase() ==
                      "pending" ?

              Column(
                children: [
                  Text("Collect Payment".tr, style: TextStyle(fontSize: 16,
                      color: TColor.primary,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),

                  InkWell(
                    onTap: () {
                      //   Navigator.pop(context);
                      currentDropIndex.value = 0;
                      loadingStart.value = false;
                      unloadingStart.value = false;
                      showCompletePayment.value = false;
                      orderPayment(bookingResponse.bookingId.toString(),
                          bookingResponse.driverId.toString(),
                          generate8DigitKey().toString());
                    },
                    child: Container(
                      height: 40,


                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: TColor.red,
                          borderRadius: BorderRadius.circular(30)

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            "Cash Collect".tr,
                            style: TextStyle(
                              color: TColor.primaryTextW,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ) :
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (bookingResponse.orderStatus.toString()
                            .toLowerCase() == "picked") {
                          final drops = bookingResponse.dropoffs ?? [];
                          if (drops.isEmpty) return;
                          final sortedDrops = List.from(drops)
                            ..sort((a, b) => int.parse(a.sequence.toString())
                                .compareTo(int.parse(b.sequence.toString())));

                          final dropIndex = currentDropIndex.value;
                          if (dropIndex < sortedDrops.length) {
                            final drop = sortedDrops[dropIndex];

                            openGoogleMap(
                              double.parse(drop.lat.toString()),
                              double.parse(drop.lng.toString()),
                            );
                            // final firestore = FirebaseFirestore.instance;
                            // await firestore.collection('location_id_direction').add({
                            //   'bookingId': bookingResponse.bookingId.toString(),
                            //   'locationId': drop.locationId.toString(),
                            //   'timestamp': DateTime.now(),
                            // });
                            // print("🗺️ Opening map for sequence ${drop.sequence} "
                            //     "| Location ID: ${drop.locationId}");
                          } else {
                            print("✅ All drops completed");
                          }
                        }
                        else {
                          openGoogleMap(double.parse(
                              bookingResponse.pickup!.lat.toString()), double
                              .parse(bookingResponse.pickup!.lng.toString()));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: TColor.red,
                            borderRadius: BorderRadius.circular(30)

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_outlined, color: Colors.white,),
                            SizedBox(width: 10,),
                            Text(
                              "Direction".tr,
                              style: TextStyle(
                                color: TColor.primaryTextW,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // isLoadingTime == false ?
                  Expanded(
                    child:  InkWell(
                      onTap: () async {
                        // final status = bookingResponse.orderStatus.toString().toLowerCase();

                        if ( bookingResponse.orderStatus.toString().toLowerCase() == "accpeted") {
                          startLoadingApi(getUserID().toString(), context, bookingResponse.bookingId.toString(),bookingResponse.pickup!.locationId.toString());
                          // checkDriverBooking(context);
                        }
                        else if (bookingResponse.orderStatus.toString().toLowerCase() == "loading") {
                          orderPicked(orderID: bookingResponse.bookingId.toString(),locationID: bookingResponse.pickup!.locationId.toString());
                          // checkDriverBooking(context);
                        }
                        else if (bookingResponse.orderStatus.toString().toLowerCase() == "unloading") {
                          orderDelivered(orderID: bookingResponse.bookingId.toString());
                          // await clearDropIndex();
                          // checkDriverBooking(context);
                        }
                        else if (bookingResponse.orderStatus.toString().toLowerCase() == "picked") {
                          print('🚚 Order Picked — Starting unloading logic');

                          final drops = bookingResponse.dropoffs ?? [];

                          if (drops.isEmpty) {
                            print('⚠️ No dropoff found.');
                            return;
                          }

                          // Sort drops by sequence (if not already sorted)
                          final sortedDrops = List.from(drops)
                            ..sort((a, b) => int.parse(a.sequence.toString())
                                .compareTo(int.parse(b.sequence.toString())));

                          int dropIndex = currentDropIndex.value;

                          // 🧠 Safety: If dropIndex is out of range, reset it to 0
                          if (dropIndex >= sortedDrops.length) {
                            dropIndex = 0;
                            currentDropIndex.value = 0;
                          }

                          final drop = sortedDrops[dropIndex];

                          // ✅ Call unloading API
                          await startUnLoadingApi(
                            getUserID().toString(),
                            context,
                            bookingResponse.bookingId.toString(),
                            drop.locationId.toString(),
                          );
                          // final firestore = FirebaseFirestore.instance;
                          // await firestore.collection('location_id_unloading').add({
                          //   'bookingId': bookingResponse.bookingId.toString(),
                          //   'locationId': drop.locationId.toString(),
                          //   'timestamp': DateTime.now(),
                          // });
                          // print("📦 Unloading completed for sequence ${drop.sequence}");
                          await nextDrop(sortedDrops.length);
                        }

                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:
                        // isLoadingTime == true ?
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bookingResponse.orderStatus.toString().toLowerCase() == "accpeted" ?
                                  "Start Loading".tr
                                      :  bookingResponse.orderStatus.toString().toLowerCase() == "loading" ?
                                  "Start Trip".tr :
                                  bookingResponse.orderStatus.toString().toLowerCase() == "picked"
                                      ? "Unloading".tr :
                                  bookingResponse.orderStatus.toString().toLowerCase() == "unloading" ?
                                  "Completed".tr
                                      : "Unknown error",
                                  style: TextStyle(
                                    color: TColor.primaryTextW,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                        //     :
                        // Stack(
                        //   alignment: Alignment.centerRight,
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Text(
                        //           bookingResponse.orderStatus.toString()
                        //               .contains("picked")
                        //               ? "Completed"
                        //               : "Start Trip",
                        //           style: TextStyle(
                        //             color: TColor.primaryTextW,
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.w700,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ),
                    )
                  )
                      // :
                  // Expanded(
                  //   child: InkWell(
                  //     onTap: () {
                  //
                  //       Navigator.pop(context);
                  //       if(bookingResponse.orderStatus.toString().toLowerCase() == "picked" ){
                  //
                  //         orderDelivered(orderID:bookingResponse.bookingId.toString());
                  //
                  //         //  startTrip(bookingResponse.id.toString(), "no",context,bookingResponse.cusId.toString(),bookingResponse.bookingId.toString(),bookingResponse.amount.toString());
                  //
                  //
                  //       }
                  //       else if (bookingResponse.orderStatus.toString().toLowerCase() == "accpeted"){
                  //         orderPicked(orderID:bookingResponse.bookingId.toString());
                  //         // startTrip(bookingResponse.id.toString(), "yes",context,bookingResponse.cusId.toString(),bookingResponse.bookingId.toString(),bookingResponse.amount.toString());
                  //       }
                  //       else if(bookingResponse.orderStatus.toString().toLowerCase() == "loading"){
                  //         orderPicked(orderID: bookingResponse.bookingId.toString());
                  //       }
                  //
                  //     },
                  //     child: Container(
                  //       width: 100,
                  //       height: 40,
                  //       margin: const EdgeInsets.symmetric(horizontal: 20),
                  //       padding: const EdgeInsets.all(6),
                  //       decoration: BoxDecoration(
                  //         color: TColor.primary,
                  //         borderRadius: BorderRadius.circular(30),
                  //       ),
                  //       child: Stack(
                  //         alignment: Alignment.centerRight,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Text(
                  //                 bookingResponse.orderStatus.toString().contains("picked")  ? "Completed".tr:"Start Trip".tr,
                  //                 style: TextStyle(
                  //                   color: TColor.primaryTextW,
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w700,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 35),
              // bookingResponse.orderStatus.toString().toLowerCase() == "delivered" && bookingResponse.paymentStatus.toString().toLowerCase() == "pending"  ?
              bookingResponse.orderStatus.toString().toLowerCase() ==
                      "loading"
                  ? LoadingTimer(
                      loadingChargePerMin: loadingCharges.toString(),
                      maxLoadingTime: maxTime.toString(),
                    )
                  : SizedBox.shrink(),
              bookingResponse.orderStatus.toString().toLowerCase() ==
                      "unloading"
                  ? UnLoadingTimer(
                      loadingChargePerMin: loadingCharges.toString(),
                      maxLoadingTime: maxTime.toString(),
                    )
                  : SizedBox.shrink(),
              // : SizedBox.shrink(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }


  String generate8DigitKey() {
    final random = Random();
    return (10000000 + random.nextInt(90000000)).toString();
  }

  Future<void> orderPayment(String id, String driverID, String key) async {
    isVehicle = true;

    update();
    print(getUserDeviceID());
    subCategoryVehicle = null;


    Response response = await authRepo.orderPayment(
        id: id, driverID: driverID, key: key);

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      Get.offAll(HomeView());

      // subCategoryVehicle = SubCategoryVehicle.fromJson(response.body);
      //
      // isVehicle = false;
      update();
    }
    else {
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);
    }

    isVehicle = false;
    update();
  }

  Future<void> openGoogleMap(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Google Maps नहीं खुल पाया!';
    }
  }

  // double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   const R = 6371.0; // Earth's radius in kilometers
  //
  //   // Convert degrees to radians
  //   double dLat = _toRadians(lat2 - lat1);
  //   double dLon = _toRadians(lon2 - lon1);
  //
  //   // Apply Haversine formula
  //   double a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
  //           sin(dLon / 2) * sin(dLon / 2);
  //
  //   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //   double distance = R * c; // Distance in kilometers
  //
  //   return distance;
  // }

  Future<Map<String, dynamic>> calculateDropDistancesForBooking(dynamic booking) async {
    const apiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";

    final url = Uri.parse("https://routes.googleapis.com/directions/v2:computeRoutes");

    final headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask": "routes.distanceMeters,routes.duration"
    };

    final pickup = booking.pickup;
    final dropoffs = booking.dropoffs;

    if (dropoffs == null || dropoffs.isEmpty) {
      return {
        "total_distance_km": 0.0,
        "total_duration": "0m",
        "drops": []
      };
    }

    double currentLat = double.parse(pickup.lat);
    double currentLng = double.parse(pickup.lng);

    double totalDistance = 0;
    int totalSeconds = 0;
    List<Map<String, dynamic>> drops = [];

    for (int i = 0; i < dropoffs.length; i++) {
      final drop = dropoffs[i];

      final body = jsonEncode({
        "origin": {
          "location": {"latLng": {"latitude": currentLat, "longitude": currentLng}}
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": double.parse(drop.lat),
              "longitude": double.parse(drop.lng)
            }
          }
        },
        "travelMode": "DRIVE"
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final route = data["routes"][0];
          final distance = (route["distanceMeters"] ?? 0) as int;
          final durationRaw = (route["duration"] ?? "0s") as String;

          int seconds = int.tryParse(durationRaw.replaceAll("s", "")) ?? 0;
          totalSeconds += seconds;
          totalDistance += distance / 1000.0; // convert to KM

          int hours = seconds ~/ 3600;
          int minutes = (seconds % 3600) ~/ 60;
          String durationText = hours > 0 ? "${hours}h ${minutes}m" : "${minutes}m";

          drops.add({
            "drop_address": drop.address,
            "sequence": drop.sequence,
            "distance_km": (distance / 1000.0).toStringAsFixed(2),
            "duration_text": durationText,
          });

          currentLat = double.parse(drop.lat);
          currentLng = double.parse(drop.lng);
        }
      }
    }

    int totalHours = totalSeconds ~/ 3600;
    int totalMinutes = (totalSeconds % 3600) ~/ 60;
    String totalDuration =
    totalHours > 0 ? "${totalHours}h ${totalMinutes}m" : "${totalMinutes}m";

    return {
      "total_distance_km": totalDistance,
      "total_duration": totalDuration,
      "drops": drops,
    };
  }




  double _toRadians(double degree) {
    return degree * (pi / 180);
  }


}