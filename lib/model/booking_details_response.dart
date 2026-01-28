/// id : "512"
/// order_id : "512"
/// cus_id : "309"
/// driver_id : "338"
/// asigned_driver : null
/// category_id : "0"
/// vehicle_id : "114"
/// rate : "7"
/// amount : "77"
/// total_amount : "77"
/// stop_charge : "0"
/// booking_date : "2025-07-29"
/// status : "accept"
/// read_status : "new"
/// accept_time : null
/// close_time : null
/// discount : "0"
/// discount_percentage : "0"
/// payment_type : "Online"
/// trn_id : ""
/// pickup_lat : "26.83713814945176"
/// pickup_long : "75.83388827741146"
/// pickup_address : "2, Malviya Nagar, Jaipur, India"
/// sender_name : "Mohan S"
/// sender_contact_number : "9266809133"
/// apartment_type : ""
/// drop_lat : "26.906233955536404"
/// drop_long : "75.81631477922201"
/// drop_address : "SMS HOSPITAL, Ashok Nagar, Jaipur, India"
/// receiver_name : "eeer"
/// receiver_contact_number : "5828228282"
/// reason : null
/// additional_comment : null
/// start_trip : "yes"
/// add_date : "2025-07-29 11:27:01"
/// contact_number : "9266809133"
/// lat : "26.846846846847"
/// long : "75.830955518982"
/// first_name : "Mohan"
/// last_name : "K"
/// gender : "male"
/// vehicle_name : "Diesel"
/// model : "2023"
/// rc_no : "gagahash"
/// weight : "500"
/// weight_type : "kgs"
/// category_name : "EV / 3 Wheeler"
/// vehicle_img : "670bc024681b7-1728823328734.jpg"
/// id_proof_img : "6708b6dcc651e-1728624333430.jpg"
/// id_proof_back_img : "6708b6dd82bf5-1728624343954.jpg"
/// category_img : "66fe2bf0886c3-AA.png"
/// driver_img : null
/// review : null
/// rating : null
/// all_drop_address : []

class BookingDetailsResponse {
  BookingDetailsResponse({
     dynamic id, 
     dynamic orderId, 
     dynamic cusId, 
     dynamic driverId, 
      dynamic asignedDriver, 
     dynamic categoryId, 
     dynamic vehicleId, 
     dynamic rate, 
     dynamic amount, 
     dynamic totalAmount, 
     dynamic stopCharge, 
     dynamic bookingDate, 
     dynamic status, 
     dynamic readStatus, 
      dynamic acceptTime, 
      dynamic closeTime, 
     dynamic discount, 
     dynamic discountPercentage, 
     dynamic paymentType, 
     dynamic trnId, 
     dynamic pickupLat, 
     dynamic pickupLong, 
     dynamic pickupAddress, 
     dynamic senderName, 
     dynamic senderContactNumber, 
     dynamic apartmentType, 
     dynamic dropLat, 
     dynamic dropLong, 
     dynamic dropAddress, 
     dynamic receiverName, 
     dynamic receiverContactNumber, 
      dynamic reason, 
      dynamic additionalComment, 
     dynamic startTrip, 
     dynamic addDate, 
     dynamic contactNumber, 
     dynamic lat, 
     dynamic long, 
     dynamic firstName, 
     dynamic lastName, 
     dynamic gender, 
     dynamic vehicleName, 
     dynamic model, 
     dynamic rcNo, 
     dynamic weight, 
     dynamic weightType, 
     dynamic categoryName, 
     dynamic vehicleImg, 
     dynamic idProofImg, 
     dynamic idProofBackImg, 
     dynamic categoryImg, 
      dynamic driverImg, 
      dynamic review, 
      dynamic rating, 
      List<dynamic>? allDropAddress,}){
    _id = id;
    _orderId = orderId;
    _cusId = cusId;
    _driverId = driverId;
    _asignedDriver = asignedDriver;
    _categoryId = categoryId;
    _vehicleId = vehicleId;
    _rate = rate;
    _amount = amount;
    _totalAmount = totalAmount;
    _stopCharge = stopCharge;
    _bookingDate = bookingDate;
    _status = status;
    _readStatus = readStatus;
    _acceptTime = acceptTime;
    _closeTime = closeTime;
    _discount = discount;
    _discountPercentage = discountPercentage;
    _paymentType = paymentType;
    _trnId = trnId;
    _pickupLat = pickupLat;
    _pickupLong = pickupLong;
    _pickupAddress = pickupAddress;
    _senderName = senderName;
    _senderContactNumber = senderContactNumber;
    _apartmentType = apartmentType;
    _dropLat = dropLat;
    _dropLong = dropLong;
    _dropAddress = dropAddress;
    _receiverName = receiverName;
    _receiverContactNumber = receiverContactNumber;
    _reason = reason;
    _additionalComment = additionalComment;
    _startTrip = startTrip;
    _addDate = addDate;
    _contactNumber = contactNumber;
    _lat = lat;
    _long = long;
    _firstName = firstName;
    _lastName = lastName;
    _gender = gender;
    _vehicleName = vehicleName;
    _model = model;
    _rcNo = rcNo;
    _weight = weight;
    _weightType = weightType;
    _categoryName = categoryName;
    _vehicleImg = vehicleImg;
    _idProofImg = idProofImg;
    _idProofBackImg = idProofBackImg;
    _categoryImg = categoryImg;
    _driverImg = driverImg;
    _review = review;
    _rating = rating;
    _allDropAddress = allDropAddress;
}

  BookingDetailsResponse.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _cusId = json['cus_id'];
    _driverId = json['driver_id'];
    _asignedDriver = json['asigned_driver'];
    _categoryId = json['category_id'];
    _vehicleId = json['vehicle_id'];
    _rate = json['rate'];
    _amount = json['amount'];
    _totalAmount = json['total_amount'];
    _stopCharge = json['stop_charge'];
    _bookingDate = json['booking_date'];
    _status = json['status'];
    _readStatus = json['read_status'];
    _acceptTime = json['accept_time'];
    _closeTime = json['close_time'];
    _discount = json['discount'];
    _discountPercentage = json['discount_percentage'];
    _paymentType = json['payment_type'];
    _trnId = json['trn_id'];
    _pickupLat = json['pickup_lat'];
    _pickupLong = json['pickup_long'];
    _pickupAddress = json['pickup_address'];
    _senderName = json['sender_name'];
    _senderContactNumber = json['sender_contact_number'];
    _apartmentType = json['apartment_type'];
    _dropLat = json['drop_lat'];
    _dropLong = json['drop_long'];
    _dropAddress = json['drop_address'];
    _receiverName = json['receiver_name'];
    _receiverContactNumber = json['receiver_contact_number'];
    _reason = json['reason'];
    _additionalComment = json['additional_comment'];
    _startTrip = json['start_trip'];
    _addDate = json['add_date'];
    _contactNumber = json['contact_number'];
    _lat = json['lat'];
    _long = json['long'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _gender = json['gender'];
    _vehicleName = json['vehicle_name'];
    _model = json['model'];
    _rcNo = json['rc_no'];
    _weight = json['weight'];
    _weightType = json['weight_type'];
    _categoryName = json['category_name'];
    _vehicleImg = json['vehicle_img'];
    _idProofImg = json['id_proof_img'];
    _idProofBackImg = json['id_proof_back_img'];
    _categoryImg = json['category_img'];
    _driverImg = json['driver_img'];
    _review = json['review'];
    _rating = json['rating'];
    // if (json['all_drop_address'] != null) {
    //   _allDropAddress = [];
    //   json['all_drop_address'].forEach((v) {
    //     _allDropAddress?.add(Dynamic.fromJson(v));
    //   });
    // }
  }
 dynamic _id;
 dynamic _orderId;
 dynamic _cusId;
 dynamic _driverId;
  dynamic _asignedDriver;
 dynamic _categoryId;
 dynamic _vehicleId;
 dynamic _rate;
 dynamic _amount;
 dynamic _totalAmount;
 dynamic _stopCharge;
 dynamic _bookingDate;
 dynamic _status;
 dynamic _readStatus;
  dynamic _acceptTime;
  dynamic _closeTime;
 dynamic _discount;
 dynamic _discountPercentage;
 dynamic _paymentType;
 dynamic _trnId;
 dynamic _pickupLat;
 dynamic _pickupLong;
 dynamic _pickupAddress;
 dynamic _senderName;
 dynamic _senderContactNumber;
 dynamic _apartmentType;
 dynamic _dropLat;
 dynamic _dropLong;
 dynamic _dropAddress;
 dynamic _receiverName;
 dynamic _receiverContactNumber;
  dynamic _reason;
  dynamic _additionalComment;
 dynamic _startTrip;
 dynamic _addDate;
 dynamic _contactNumber;
 dynamic _lat;
 dynamic _long;
 dynamic _firstName;
 dynamic _lastName;
 dynamic _gender;
 dynamic _vehicleName;
 dynamic _model;
 dynamic _rcNo;
 dynamic _weight;
 dynamic _weightType;
 dynamic _categoryName;
 dynamic _vehicleImg;
 dynamic _idProofImg;
 dynamic _idProofBackImg;
 dynamic _categoryImg;
  dynamic _driverImg;
  dynamic _review;
  dynamic _rating;
  List<dynamic>? _allDropAddress;
BookingDetailsResponse copyWith({ dynamic id,
 dynamic orderId,
 dynamic cusId,
 dynamic driverId,
  dynamic asignedDriver,
 dynamic categoryId,
 dynamic vehicleId,
 dynamic rate,
 dynamic amount,
 dynamic totalAmount,
 dynamic stopCharge,
 dynamic bookingDate,
 dynamic status,
 dynamic readStatus,
  dynamic acceptTime,
  dynamic closeTime,
 dynamic discount,
 dynamic discountPercentage,
 dynamic paymentType,
 dynamic trnId,
 dynamic pickupLat,
 dynamic pickupLong,
 dynamic pickupAddress,
 dynamic senderName,
 dynamic senderContactNumber,
 dynamic apartmentType,
 dynamic dropLat,
 dynamic dropLong,
 dynamic dropAddress,
 dynamic receiverName,
 dynamic receiverContactNumber,
  dynamic reason,
  dynamic additionalComment,
 dynamic startTrip,
 dynamic addDate,
 dynamic contactNumber,
 dynamic lat,
 dynamic long,
 dynamic firstName,
 dynamic lastName,
 dynamic gender,
 dynamic vehicleName,
 dynamic model,
 dynamic rcNo,
 dynamic weight,
 dynamic weightType,
 dynamic categoryName,
 dynamic vehicleImg,
 dynamic idProofImg,
 dynamic idProofBackImg,
 dynamic categoryImg,
  dynamic driverImg,
  dynamic review,
  dynamic rating,
  List<dynamic>? allDropAddress,
}) => BookingDetailsResponse(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  cusId: cusId ?? _cusId,
  driverId: driverId ?? _driverId,
  asignedDriver: asignedDriver ?? _asignedDriver,
  categoryId: categoryId ?? _categoryId,
  vehicleId: vehicleId ?? _vehicleId,
  rate: rate ?? _rate,
  amount: amount ?? _amount,
  totalAmount: totalAmount ?? _totalAmount,
  stopCharge: stopCharge ?? _stopCharge,
  bookingDate: bookingDate ?? _bookingDate,
  status: status ?? _status,
  readStatus: readStatus ?? _readStatus,
  acceptTime: acceptTime ?? _acceptTime,
  closeTime: closeTime ?? _closeTime,
  discount: discount ?? _discount,
  discountPercentage: discountPercentage ?? _discountPercentage,
  paymentType: paymentType ?? _paymentType,
  trnId: trnId ?? _trnId,
  pickupLat: pickupLat ?? _pickupLat,
  pickupLong: pickupLong ?? _pickupLong,
  pickupAddress: pickupAddress ?? _pickupAddress,
  senderName: senderName ?? _senderName,
  senderContactNumber: senderContactNumber ?? _senderContactNumber,
  apartmentType: apartmentType ?? _apartmentType,
  dropLat: dropLat ?? _dropLat,
  dropLong: dropLong ?? _dropLong,
  dropAddress: dropAddress ?? _dropAddress,
  receiverName: receiverName ?? _receiverName,
  receiverContactNumber: receiverContactNumber ?? _receiverContactNumber,
  reason: reason ?? _reason,
  additionalComment: additionalComment ?? _additionalComment,
  startTrip: startTrip ?? _startTrip,
  addDate: addDate ?? _addDate,
  contactNumber: contactNumber ?? _contactNumber,
  lat: lat ?? _lat,
  long: long ?? _long,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  gender: gender ?? _gender,
  vehicleName: vehicleName ?? _vehicleName,
  model: model ?? _model,
  rcNo: rcNo ?? _rcNo,
  weight: weight ?? _weight,
  weightType: weightType ?? _weightType,
  categoryName: categoryName ?? _categoryName,
  vehicleImg: vehicleImg ?? _vehicleImg,
  idProofImg: idProofImg ?? _idProofImg,
  idProofBackImg: idProofBackImg ?? _idProofBackImg,
  categoryImg: categoryImg ?? _categoryImg,
  driverImg: driverImg ?? _driverImg,
  review: review ?? _review,
  rating: rating ?? _rating,
  allDropAddress: allDropAddress ?? _allDropAddress,
);
 dynamic get id => _id;
 dynamic get orderId => _orderId;
 dynamic get cusId => _cusId;
 dynamic get driverId => _driverId;
  dynamic get asignedDriver => _asignedDriver;
 dynamic get categoryId => _categoryId;
 dynamic get vehicleId => _vehicleId;
 dynamic get rate => _rate;
 dynamic get amount => _amount;
 dynamic get totalAmount => _totalAmount;
 dynamic get stopCharge => _stopCharge;
 dynamic get bookingDate => _bookingDate;
 dynamic get status => _status;
 dynamic get readStatus => _readStatus;
  dynamic get acceptTime => _acceptTime;
  dynamic get closeTime => _closeTime;
 dynamic get discount => _discount;
 dynamic get discountPercentage => _discountPercentage;
 dynamic get paymentType => _paymentType;
 dynamic get trnId => _trnId;
 dynamic get pickupLat => _pickupLat;
 dynamic get pickupLong => _pickupLong;
 dynamic get pickupAddress => _pickupAddress;
 dynamic get senderName => _senderName;
 dynamic get senderContactNumber => _senderContactNumber;
 dynamic get apartmentType => _apartmentType;
 dynamic get dropLat => _dropLat;
 dynamic get dropLong => _dropLong;
 dynamic get dropAddress => _dropAddress;
 dynamic get receiverName => _receiverName;
 dynamic get receiverContactNumber => _receiverContactNumber;
  dynamic get reason => _reason;
  dynamic get additionalComment => _additionalComment;
 dynamic get startTrip => _startTrip;
 dynamic get addDate => _addDate;
 dynamic get contactNumber => _contactNumber;
 dynamic get lat => _lat;
 dynamic get long => _long;
 dynamic get firstName => _firstName;
 dynamic get lastName => _lastName;
 dynamic get gender => _gender;
 dynamic get vehicleName => _vehicleName;
 dynamic get model => _model;
 dynamic get rcNo => _rcNo;
 dynamic get weight => _weight;
 dynamic get weightType => _weightType;
 dynamic get categoryName => _categoryName;
 dynamic get vehicleImg => _vehicleImg;
 dynamic get idProofImg => _idProofImg;
 dynamic get idProofBackImg => _idProofBackImg;
 dynamic get categoryImg => _categoryImg;
  dynamic get driverImg => _driverImg;
  dynamic get review => _review;
  dynamic get rating => _rating;
  List<dynamic>? get allDropAddress => _allDropAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['cus_id'] = _cusId;
    map['driver_id'] = _driverId;
    map['asigned_driver'] = _asignedDriver;
    map['category_id'] = _categoryId;
    map['vehicle_id'] = _vehicleId;
    map['rate'] = _rate;
    map['amount'] = _amount;
    map['total_amount'] = _totalAmount;
    map['stop_charge'] = _stopCharge;
    map['booking_date'] = _bookingDate;
    map['status'] = _status;
    map['read_status'] = _readStatus;
    map['accept_time'] = _acceptTime;
    map['close_time'] = _closeTime;
    map['discount'] = _discount;
    map['discount_percentage'] = _discountPercentage;
    map['payment_type'] = _paymentType;
    map['trn_id'] = _trnId;
    map['pickup_lat'] = _pickupLat;
    map['pickup_long'] = _pickupLong;
    map['pickup_address'] = _pickupAddress;
    map['sender_name'] = _senderName;
    map['sender_contact_number'] = _senderContactNumber;
    map['apartment_type'] = _apartmentType;
    map['drop_lat'] = _dropLat;
    map['drop_long'] = _dropLong;
    map['drop_address'] = _dropAddress;
    map['receiver_name'] = _receiverName;
    map['receiver_contact_number'] = _receiverContactNumber;
    map['reason'] = _reason;
    map['additional_comment'] = _additionalComment;
    map['start_trip'] = _startTrip;
    map['add_date'] = _addDate;
    map['contact_number'] = _contactNumber;
    map['lat'] = _lat;
    map['long'] = _long;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['gender'] = _gender;
    map['vehicle_name'] = _vehicleName;
    map['model'] = _model;
    map['rc_no'] = _rcNo;
    map['weight'] = _weight;
    map['weight_type'] = _weightType;
    map['category_name'] = _categoryName;
    map['vehicle_img'] = _vehicleImg;
    map['id_proof_img'] = _idProofImg;
    map['id_proof_back_img'] = _idProofBackImg;
    map['category_img'] = _categoryImg;
    map['driver_img'] = _driverImg;
    map['review'] = _review;
    map['rating'] = _rating;
    if (_allDropAddress != null) {
      map['all_drop_address'] = _allDropAddress?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}