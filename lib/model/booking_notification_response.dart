/// id : "648"
/// order_id : "175777547362"
/// cus_id : "309"
/// driver_id : null
/// asigned_driver : null
/// category_id : "114"
/// vehicle_id : "114"
/// rate : "6"
/// amount : "88"
/// total_amount : "88"
/// stop_charge : "0"
/// booking_date : "2025-08-10 16:52:55"
/// order_status : "new"
/// read_status : "new"
/// accept_time : null
/// close_time : null
/// discount : "0"
/// discount_percentage : "0"
/// payment_type : "Online"
/// trn_id : null
/// pickup_lat : "26.8892974"
/// pickup_long : "75.9117226"
/// pickup_address : "38, Sumel, Jaipur, Rajasthan"
/// sender_name : "Mohan S"
/// sender_contact_number : "9266809133"
/// apartment_type : ""
/// drop_lat : "26.906233955536404"
/// drop_long : "75.81631477922201"
/// drop_address : "SMS HOSPITAL, Ashok Nagar, Jaipur, India"
/// receiver_name : "tuur"
/// receiver_contact_number : "8964464466"
/// reason : null
/// additional_comment : null
/// picked_time : "2025-08-10 16:52:55"
/// delivery_time : "2025-08-10 16:52:55"
/// cancelled_time : null
/// start_trip : "no"
/// add_date : "2025-08-10 16:52:55"

class BookingNotificationResponse {
  BookingNotificationResponse({
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
    dynamic orderStatus,
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
    dynamic pickedTime,
    dynamic deliveryTime,
    dynamic cancelledTime,
    dynamic isFake,
    dynamic startTrip,
    dynamic addDate,}){
    _id = id;
    _isFake = isFake;
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
    _orderStatus = orderStatus;
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
    _pickedTime = pickedTime;
    _deliveryTime = deliveryTime;
    _cancelledTime = cancelledTime;
    _startTrip = startTrip;
    _addDate = addDate;
  }

  BookingNotificationResponse.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _cusId = json['cus_id'];
    _isFake = json['is_fake'];
    _driverId = json['driver_id'];
    _asignedDriver = json['asigned_driver'];
    _categoryId = json['category_id'];
    _vehicleId = json['vehicle_id'];
    _rate = json['rate'];
    _amount = json['amount'];
    _totalAmount = json['total_amount'];
    _stopCharge = json['stop_charge'];
    _bookingDate = json['booking_date'];
    _orderStatus = json['order_status'];
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
    _pickedTime = json['picked_time'];
    _deliveryTime = json['delivery_time'];
    _cancelledTime = json['cancelled_time'];
    _startTrip = json['start_trip'];
    _addDate = json['add_date'];
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
  dynamic _orderStatus;
  dynamic _readStatus;
  dynamic _acceptTime;
  dynamic _closeTime;
  dynamic _isFake;
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
  dynamic _pickedTime;
  dynamic _deliveryTime;
  dynamic _cancelledTime;
  dynamic _startTrip;
  dynamic _addDate;
  BookingNotificationResponse copyWith({  dynamic id,
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
    dynamic orderStatus,
    dynamic readStatus,
    dynamic acceptTime,
    dynamic closeTime,
    dynamic isFake,
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
    dynamic pickedTime,
    dynamic deliveryTime,
    dynamic cancelledTime,
    dynamic startTrip,
    dynamic addDate,
  }) => BookingNotificationResponse(  id: id ?? _id,
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
    orderStatus: orderStatus ?? _orderStatus,
    readStatus: readStatus ?? _readStatus,
    acceptTime: acceptTime ?? _acceptTime,
    closeTime: closeTime ?? _closeTime,
    isFake: isFake ?? _isFake,
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
    pickedTime: pickedTime ?? _pickedTime,
    deliveryTime: deliveryTime ?? _deliveryTime,
    cancelledTime: cancelledTime ?? _cancelledTime,
    startTrip: startTrip ?? _startTrip,
    addDate: addDate ?? _addDate,
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
  dynamic get orderStatus => _orderStatus;
  dynamic get readStatus => _readStatus;
  dynamic get acceptTime => _acceptTime;
  dynamic get closeTime => _closeTime;
  dynamic get isFake => _isFake;
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
  dynamic get pickedTime => _pickedTime;
  dynamic get deliveryTime => _deliveryTime;
  dynamic get cancelledTime => _cancelledTime;
  dynamic get startTrip => _startTrip;
  dynamic get addDate => _addDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['cus_id'] = _cusId;
    map['is_fake'] = _isFake;
    map['driver_id'] = _driverId;
    map['asigned_driver'] = _asignedDriver;
    map['category_id'] = _categoryId;
    map['vehicle_id'] = _vehicleId;
    map['rate'] = _rate;
    map['amount'] = _amount;
    map['total_amount'] = _totalAmount;
    map['stop_charge'] = _stopCharge;
    map['booking_date'] = _bookingDate;
    map['order_status'] = _orderStatus;
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
    map['picked_time'] = _pickedTime;
    map['delivery_time'] = _deliveryTime;
    map['cancelled_time'] = _cancelledTime;
    map['start_trip'] = _startTrip;
    map['add_date'] = _addDate;
    return map;
  }

}