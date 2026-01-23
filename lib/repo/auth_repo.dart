import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../common/appContants.dart';

class AuthRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

 /* Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(
        ApiController.REGISTER_URI, signUpBody.toJson());
  }*/

  Future<Response> login({String? phone,String? password,String? token,String? deviceToken}) async {
    return await apiClient.postData(
        AppContants.loginUrl,{"contact_number":phone!,"password":password!,"user_type":"driver","token":token,"device_token" : deviceToken});
  }

  Future<Response> incomeDriver({String? userID}) async {
    print("call");
    return await apiClient.postMultipartData(
        AppContants.incomeDriverURL,{
      "user_id":userID.toString(),
      "user_type":"driver",
    },[]);
  }

  Future<Response> paymentHistory({String? userID}) async {
    print("call");
    return await apiClient.postMultipartData(
        AppContants.paymentHistoryURL,{
      "user_id":userID.toString(),
      "user_type":"driver",
    },[]);
  }
  Future<Response> getFaqList() async {
    return await apiClient.getData(AppContants.driverFAQHelpURl);
  }
  Future<Response> updateDriverLocation({String? userID,String? lat,String? long,String? locationTimer,String? driverStatus}) async {
    print("call");
    return await apiClient.postData(
        AppContants.updateDriverLocation,{
          "lat":lat,
          "user_id":userID,
          "long":long,
          "location_time":locationTimer,
          "driver_status" : driverStatus
    });
  }
  Future<Response> addWalletPayment({String? customerID,String? amount,String? trnId}) async {
    return await apiClient.postData(
        AppContants.addDriverWalletURL,{
      "driver_id":customerID,
      "amount":amount,
      "payment_type":"wallet recharge",
      "trn_id":trnId,
    });
  }

  Future<Response> orderPayment({String? id,String? driverID,String? key}) async {
    return await apiClient.postData(
        AppContants.orderPaymentURL,{
      "booking_id":id,
      "driver_id":driverID,
      "transaction_id":key,
      // "razorpay_payment_id":key,
      "payment_status":"success",
      "payment_type":"cash",
    });
  }

  Future<Response> changeLoginStatus({String? userID,String? status}) async {
    print("call");
    return await apiClient.postMultipartData(
        AppContants.changeLoginStatusURL,{
          "status":status!,
          "driver_id":userID!,

    },[]);
  }
  Future<Response> getAvailableScheduledBookings({String? catID,String? cityId}) async {
    print("call");
    return await apiClient.postData(
        AppContants.getAvailableScheduledBookingsURL,{
          "city_id":cityId!,
          "category_id":catID!,

    });
  }
  Future<Response> getMyScheduledBookings({String? userId}) async {
    print("call");
    return await apiClient.postData(
        AppContants.getDriverScheduledBookingsURL,{
          "driver_id":userId!,

    });
  }

  Future<Response> driverBasicInfo(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.driverBasicInfoURL,body,multipartBody);
  }

  Future<Response> updateDriverBankDetail(body) async {

    return await apiClient.postMultipartData(
        AppContants.updateDriverBankDetailURL,body,[]);
  }

  Future<Response> ticketRez(body) async {

    return await apiClient.postMultipartData(
        AppContants.ticketRezURL,body,[]);
  }
  Future<Response> checkTicketLimits(body) async {

    return await apiClient.postMultipartData(
        AppContants.checkTicketLimit,body,[]);
  }

  Future<Response> getCity() async {

    return await apiClient.getData(
        AppContants.getCityURL);
  }

  Future<Response> driverFAQ() async {

    return await apiClient.getData(
        AppContants.driverFAQURl);
  }

  Future<Response> updateDriverKyc(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.updateDriverKycURL,body,multipartBody);
  }
  Future<Response> updateAdharFrontKyc(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.uploadAdharFrontURL,body,multipartBody);
  }
  Future<Response> updateAdharBackKyc(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.uploadAdharBackURL,body,multipartBody);
  }
  Future<Response> updatePenCardKyc(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.uploadPanImageURL,body,multipartBody);
  }
  Future<Response> updateLicenceFKyc(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.uploadLicenseFrontURL,body,multipartBody);
  }
  Future<Response> updateLicenceBKyc(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.uploadLicenseBackURL,body,multipartBody);
  }
  Future<Response> updateInsuranceImageURLKyc(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.uploadInsuranceImageURL,body,multipartBody);
  }

  Future<Response> forgetPassword(body) async {
    return await apiClient.postData(
        AppContants.forgetPasswordURL,body);
  }

  Future<Response> updatePassword(body) async {
    return await apiClient.postData(
        AppContants.updatePasswordURL,body);
  }

  Future<Response> updateDriverPaymentStatus(body) async {

    return await apiClient.postMultipartData(
        AppContants.updateDriverPaymentStatusURL,body,[]);
  }

  Future<Response> vehicleDetailsUpload(body,List<MultipartBody> multipartBody) async {

    return await apiClient.postMultipartData(
        AppContants.updateDriverVehicleDetail,body,multipartBody);
  }

  Future<Response> accpetBooking({String? userID,String? bookingId}) async {
    print("call");
    return await apiClient.postData(
        AppContants.accpetBookingURL,{
          "booking_id":bookingId!,
          "driver_id":userID!,

    });
  }

  Future<Response> updateDriverVehicle({String? userID,String? category_id}) async {
    print("call");
    return await apiClient.postData(
        AppContants.updateDriverVehicleURL,{
          "category_id":category_id!,
          "id":userID!,

    });
  }
  Future<Response> paymentHistoryRepo(body) async {
    print("call:::::::::::::::::::");
    return await apiClient.postMultipartData(
        AppContants.getPaymentHistoryUrl,body,[]);
  }
  Future<Response> missedOrderRepo(body) async {
    print("call:::::::::::::::::::");
    return await apiClient.postMultipartData(
        AppContants.getMissedOrdersUrl,body,[]);
  }

  Future<Response> orderPicked({String? userID,String? locationID,String? bookingId,String? loadingTime,String? loadingCharges}) async {
    print("call");
    return await apiClient.postData(
        AppContants.orderPickedURL,{
          "booking_id":bookingId!,
          "driver_id":userID!,
          "loading_duration":loadingTime!,
          "loading_charge":loadingCharges!,
          "location_id":locationID!,
          "total_amount": '0',

    });
  }

  Future<Response> orderDelivered({String? userID,String? unloadDuration,String? unloadCharges,String? bookingId}) async {
    print("call");
    return await apiClient.postData(
        AppContants.orderDeliveredURL,{
          "booking_id":bookingId!,
          "driver_id":userID!,
          "unloading_duration":unloadDuration,
          "unloading_charge":unloadCharges,
          "total_amount":'0',

    });
  }
  Future<Response> startJourneyToNextFun({String? userID,String? bookingId}) async {
    print("call");
    return await apiClient.postData(
        AppContants.startJourneyToNextUrl,{
          "booking_id":bookingId!,
          "driver_id":userID!,
    });
  }

  Future<Response> driverOnlineTIme({String? userID}) async {
    print("call");
    return await apiClient.postMultipartData(
        AppContants.driverOnlineTImeURL,{
          "date":AppContants.changeDateFormat(DateTime.now().toString(), "yyyy-MM-dd"),
          "driver_id":userID!,

    },[]);
  }

  Future<Response> driverOnlineTotalTIme({String? userID}) async {
    print("call");
    return await apiClient.postMultipartData(
        AppContants.driverOnlineTImeURL,{

          "driver_id":userID!,

    },[]);
  }

  Future<Response> getWalletHistory({String? userID}) async {
    print("call");
    return await apiClient.postMultipartData(
        "${AppContants.getWalletHistoryURL}",{
      "user_id":userID.toString(),
      "user_type":"driver",
    },[]);
  }

  Future<Response> saveFirebaseToken({String? userID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.saveFirebaseTokenURL,{"token":userID});
  }

  Future<Response> bookingStatusChange({String? userID,String? status,String? cus_id,String? orderID,String? amount}) async {
    print("call");
    return await apiClient.postData(
        AppContants.bookingStatusChangeURl+orderID!,{
          "status":status,
          "user_id":userID,
          "cus_id":cus_id,
          "order_id":orderID,
          "amount":amount,

    });
  }

  Future<Response> checkDriverBooking({String? userID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.checkDriverBooking,{

          "driver_id":userID,


    });
  }

  Future<Response> startLoading({String? bookingId,String? userID,String? locationID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.orderLoadingURL,{

          "booking_id":bookingId,
          "driver_id":userID,
          "location_id":locationID,


    });
  }

  Future<Response> startUnLoading({String? bookingId,String? userID,String? locationID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.orderUnloadingURL,{

          "booking_id":bookingId,
          "driver_id":userID,
          "location_id":locationID,


    });
  }
  Future<Response> checkDriverDevice({String? deviceToken,String? userID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.checkDriverDeviceURL,{

          "driver_id":userID,
          "device_token":deviceToken,


    });
  }
  Future<Response> notificationHistory(body) async {
    print("call:::::::::::::::::::");
    return await apiClient.postMultipartData(
        AppContants.getNotificationHistoryURL,body,[]);
  }


  Future<Response> getDailyEarnings({String? date,String? userID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.getDailyEarningsURL,{

          "driver_id":userID,
          "date":date,


    });
  }
  Future<Response> getLifetimeEarningsUrl({String? userID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.getLifetimeEarningsUrl,{
          "driver_id":userID,


    });
  }
  Future<Response> getInactiveBalanceUrl({String? userID}) async {
    print("call");
    return await apiClient.getData(
        '${AppContants.getInactiveBalanceUrl}$userID');
  }

  Future<Response> getBookingsBydateAndDriver({String? date,String? userID}) async {
    print("call");
    return await apiClient.postData(
        AppContants.getBookingsBydateAndDriverURL,{

          "driver_id":userID,
          "date":date,


    });
  }

  Future<Response> getDateRangeEarnings({String? startDate,String? userID, String? endDate}) async {
    print("call");
    return await apiClient.postData(
        AppContants.getDateRangeEarningsUrl,{

          "driver_id":userID,
          "start_date": startDate,
          "end_date": endDate,


    });
  }

  Future<Response> startTrip({String? iD,String? type}) async {
    print("call");
    return await apiClient.postData(
        AppContants.startTripURL,{

          "id":iD,
          "start_trip":type,


    });
  }

  Future<Response> getBookingNotification({String? userID}) async {
    print("call");
    return await apiClient.postData(
        "${AppContants.getBookingNotificationURL}",{"driver_id":userID});
  }

  Future<Response> driverInfo(String userID) async {
    return await apiClient.getData(
        AppContants.driverInfoURL+userID);
  }

  Future<Response> getAllVehicle() async {
    return await apiClient.getData(
        AppContants.getAllVehicle);
  }

  Future<Response> checkPayment({String? bookingID}) async {
    return await apiClient.postData(
        AppContants.checkPaymentURL,{"booking_id":bookingID});
  }Future<Response> cancelOrder({String? bookingID,String? userID,String? reason,String? comment}) async {
    return await apiClient.postData(
        AppContants.cancelOrderURL,{"order_id":bookingID,"cus_id":userID,"reason":reason,"additional_comment":comment});
  }

  Future<Response> getAllBooking({String? status,String? limit,String? offset,String? userID}) async {
    return await apiClient.getData(
        "${AppContants.getAllBookingURL}?status=$status&limit=$limit&user_id=$userID&user_type=driver");
  }

  Future<Response> getBookingDetails({String? bookingID,String? userID}) async {
    return await apiClient.getData(
        "${AppContants.getBookingDetails}/$bookingID?user_type=customer&user_id=$userID");
  }

  Future<Response> getBookingDriver({String? bookingID}) async {
    return await apiClient.getData(
        "${AppContants.driverDetailsURL}?booking_id=$bookingID");
  }
  Future<Response> getDriverDetail({String? customerID}) async {
    return await apiClient.postData(
        AppContants.driverDetailURL,{
      "driver_id":customerID,
    });
  }
  Future<Response> getCategorySub(String id) async {
    return await apiClient.getData(
        AppContants.categoryVehicleURL+id);
  }
  Future<Response> bookNow({
    required String amount,
    required String categoryId,
    required String categoryName,
    required String cusId,
    required String discount,
    required String discountPercentage,
    required String dropAddress,
    required String dropAddressHeading,
    required String dropLat,
    required String dropLong,
    required String paymentType,
    required String pickupAddress,
    required String pickupHeading,
    required String pickupLat,
    required String pickupLong,
    required String rate,
    required String receiverContactNumber,
    required String receiverName,
    required String senderContactNumber,
    required String senderName,
    required String stopAddress,
    required String stopCharge,
    required String totalAmount,
    required String totalDistance,
    required String vehicleId,
    required String vehicleImg,
    required String vehicleName,
  }) async {
    final body = {
      "amount": amount,
      "category_id": categoryId,
      "category_name": categoryName,
      "cus_id": cusId,
      "discount": discount,
      "discount_percentage": discountPercentage,
      "drop_address": dropAddress,
      "drop_address_heading": dropAddressHeading,
      "drop_lat": dropLat,
      "drop_long": dropLong,
      "payment_type": paymentType,
      "pickup_address": pickupAddress,
      "pickup_heading": pickupHeading,
      "pickup_lat": pickupLat,
      "pickup_long": pickupLong,
      "rate": rate,
      "receiver_contact_number": receiverContactNumber,
      "receiver_name": receiverName,
      "sender_contact_number": senderContactNumber,
      "sender_name": senderName,
      "stop_address": stopAddress,
      "stop_charge": stopCharge,
      "total_amount": totalAmount,
      "total_distance": totalDistance,
      "vehicle_id": vehicleId,
      "vehicle_img": vehicleImg,
      "vehicle_name": vehicleName,
    };

    return await apiClient.postData(AppContants.saveBookingURl, body);
  }





  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(
        token);
    return await sharedPreferences.setString(AppContants.token, token);
  }

  Future<bool>saveUserId(String id)
  async{
    return await sharedPreferences.setString(AppContants.userID, id);
  }

  Future<bool>saveUserBooking(String id)
  async{
    return await sharedPreferences.setString(AppContants.bookingID, id);
  }

  Future<bool>isCategoryValue(bool? id)
  async{
    return await sharedPreferences.setBool("category_id", id??false);
  }

  Future<bool>saveUserName(String name)
  async{
    return await sharedPreferences.setString(AppContants.userName, name);
  }
  Future<bool>setMaxTime(String maxTime)
  async{
    return await sharedPreferences.setString(AppContants.maxTimeVar, maxTime);
  }
  Future<bool>setPricePerMinute(String setPricePer)
  async{
    return await sharedPreferences.setString(AppContants.loadingCharges, setPricePer);
  }
  Future<bool>saveIsLoadingTime(bool name)
  async{
    return await sharedPreferences.setBool(AppContants.isLoadingTime, name);
  }

  Future<bool>saveUserKyc(bool name)
  async{
    return await sharedPreferences.setBool(AppContants.userKYC, name);
  }

  Future<bool>saveUserPayment(bool name)
  async{
    return await sharedPreferences.setBool(AppContants.userPayment, name);
  }

  Future<bool>saveUserFee(String name)
  async{
    return await sharedPreferences.setString(AppContants.userFee, name);
  }

  Future<bool>saveUserEmail(String name)
  async{
    return await sharedPreferences.setString(AppContants.userEmail, name);
  }
  Future<bool>saveUserCityId(String cityId)
  async{
    return await sharedPreferences.setString(AppContants.cityId, cityId);
  } Future<bool>saveUserCategoryIdNew(String catIDNew)
  async{
    return await sharedPreferences.setString(AppContants.cateIdNew, catIDNew);
  }

  Future<bool>saveUserPhone(String name)
  async{
    return await sharedPreferences.setString(AppContants.userPhone, name);
  }


  Future<bool>saveUserDeviceId(String token)
  async{
    return await sharedPreferences.setString("saveDeviceID", token);
  }
  Future<bool>saveUserPassword(String password)
  async{
    return await sharedPreferences.setString(AppContants.userPassword, password);
  }


  bool isLoggedIn() {
    return sharedPreferences.getString(AppContants.token)!=null && sharedPreferences.getString(AppContants.token)!.isNotEmpty? true:false;
  }
 /* Future<Response> updateToken() async {
    String _deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
      }
    } else {
      _deviceToken = await _saveDeviceToken();
    }
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
    return await apiClient.postData(AppConstants.TOKEN_URI,
        {"_method": "put", "cm_firebase_token": _deviceToken});
  }*/

  bool clearSharedData() {

    sharedPreferences.remove(AppContants.token);
    apiClient.token = null;
    apiClient.updateHeader("");
    return true;
  }
}