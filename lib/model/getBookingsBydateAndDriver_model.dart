/// id : "1275"
/// order_id : "425198280966"
/// cus_id : "309"
/// driver_id : "338"
/// category_id : "112"
/// rate : "38.00"
/// amount : "601.00"
/// total_amount : "601.00"
/// booking_date : "2025-09-25 13:02:36"
/// order_status : "paid"
/// accept_time : "2025-09-25 13:03:02"
/// close_time : null
/// payment_type : "cash"
/// payment_status : "success"
/// trn_id : "26644824"
/// pickup_lat : "26.836182912636758"
/// pickup_long : "75.83378333598375"
/// pickup_address : "19, Jagatpura, Jaipur, India"
/// sender_name : "Mohan S"
/// sender_contact_number : "9266809133"
/// drop_lat : "26.752988406857597"
/// drop_long : "75.83555560559034"
/// drop_address : "Jtm Mall, Jagatpura, Jaipur, India"
/// distance : "16.88"
/// expected_time : "33m"
/// receiver_name : "Mohan S"
/// receiver_contact_number : "9266809133"
/// reason : null
/// additional_comment : null
/// picked_time : "2025-09-25 13:04:37"
/// delivery_time : "2025-09-25 13:07:03"
/// cancelled_time : null
/// payment_time : "2025-09-25 13:11:15"
/// current_lat : null
/// current_lng : null
/// total_distance_travelled : null
/// start_trip : "yes"
/// loading_duration : "1"
/// loading_time : null
/// loading_charge : "0.00"
/// unloading_duration : null
/// unloading_time : null
/// unloading_charge : null
/// add_date : "2025-09-25 13:02:36"
/// is_fake : "0"
/// status : null
/// customer_first_name : "Mohan"
/// customer_last_name : "S"
/// customer_contact_number : "9266809133"
/// driver_first_name : "Mohan"
/// driver_last_name : "K"
/// driver_contact_number : "9266809133"
/// name : "Tata Ace"

class GetBookingsBydateAndDriverModel {
  GetBookingsBydateAndDriverModel({
      String? id, 
      String? orderId, 
      String? cusId, 
      String? driverId, 
      String? categoryId, 
      String? rate, 
      String? amount, 
      String? totalAmount, 
      String? bookingDate, 
      String? orderStatus, 
      String? acceptTime, 
      dynamic closeTime, 
      String? paymentType, 
      String? paymentStatus, 
      String? trnId, 
      String? pickupLat, 
      String? pickupLong, 
      String? pickupAddress, 
      String? senderName, 
      String? senderContactNumber, 
      String? dropLat, 
      String? dropLong, 
      String? dropAddress, 
      String? distance, 
      String? expectedTime, 
      String? receiverName, 
      String? receiverContactNumber, 
      dynamic reason, 
      dynamic additionalComment, 
      String? pickedTime, 
      String? deliveryTime, 
      dynamic cancelledTime, 
      String? paymentTime, 
      dynamic currentLat, 
      dynamic currentLng, 
      dynamic totalDistanceTravelled, 
      String? startTrip, 
      String? loadingDuration, 
      dynamic loadingTime, 
      String? loadingCharge, 
      dynamic unloadingDuration, 
      dynamic unloadingTime, 
      dynamic unloadingCharge, 
      String? addDate, 
      String? isFake, 
      dynamic status, 
      String? customerFirstName, 
      String? customerLastName, 
      String? customerContactNumber, 
      String? driverFirstName, 
      String? driverLastName, 
      String? driverContactNumber, 
      String? name,}){
    _id = id;
    _orderId = orderId;
    _cusId = cusId;
    _driverId = driverId;
    _categoryId = categoryId;
    _rate = rate;
    _amount = amount;
    _totalAmount = totalAmount;
    _bookingDate = bookingDate;
    _orderStatus = orderStatus;
    _acceptTime = acceptTime;
    _closeTime = closeTime;
    _paymentType = paymentType;
    _paymentStatus = paymentStatus;
    _trnId = trnId;
    _pickupLat = pickupLat;
    _pickupLong = pickupLong;
    _pickupAddress = pickupAddress;
    _senderName = senderName;
    _senderContactNumber = senderContactNumber;
    _dropLat = dropLat;
    _dropLong = dropLong;
    _dropAddress = dropAddress;
    _distance = distance;
    _expectedTime = expectedTime;
    _receiverName = receiverName;
    _receiverContactNumber = receiverContactNumber;
    _reason = reason;
    _additionalComment = additionalComment;
    _pickedTime = pickedTime;
    _deliveryTime = deliveryTime;
    _cancelledTime = cancelledTime;
    _paymentTime = paymentTime;
    _currentLat = currentLat;
    _currentLng = currentLng;
    _totalDistanceTravelled = totalDistanceTravelled;
    _startTrip = startTrip;
    _loadingDuration = loadingDuration;
    _loadingTime = loadingTime;
    _loadingCharge = loadingCharge;
    _unloadingDuration = unloadingDuration;
    _unloadingTime = unloadingTime;
    _unloadingCharge = unloadingCharge;
    _addDate = addDate;
    _isFake = isFake;
    _status = status;
    _customerFirstName = customerFirstName;
    _customerLastName = customerLastName;
    _customerContactNumber = customerContactNumber;
    _driverFirstName = driverFirstName;
    _driverLastName = driverLastName;
    _driverContactNumber = driverContactNumber;
    _name = name;
}

  GetBookingsBydateAndDriverModel.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _cusId = json['cus_id'];
    _driverId = json['driver_id'];
    _categoryId = json['category_id'];
    _rate = json['rate'];
    _amount = json['amount'];
    _totalAmount = json['total_amount'];
    _bookingDate = json['booking_date'];
    _orderStatus = json['order_status'];
    _acceptTime = json['accept_time'];
    _closeTime = json['close_time'];
    _paymentType = json['payment_type'];
    _paymentStatus = json['payment_status'];
    _trnId = json['trn_id'];
    _pickupLat = json['pickup_lat'];
    _pickupLong = json['pickup_long'];
    _pickupAddress = json['pickup_address'];
    _senderName = json['sender_name'];
    _senderContactNumber = json['sender_contact_number'];
    _dropLat = json['drop_lat'];
    _dropLong = json['drop_long'];
    _dropAddress = json['drop_address'];
    _distance = json['distance'];
    _expectedTime = json['expected_time'];
    _receiverName = json['receiver_name'];
    _receiverContactNumber = json['receiver_contact_number'];
    _reason = json['reason'];
    _additionalComment = json['additional_comment'];
    _pickedTime = json['picked_time'];
    _deliveryTime = json['delivery_time'];
    _cancelledTime = json['cancelled_time'];
    _paymentTime = json['payment_time'];
    _currentLat = json['current_lat'];
    _currentLng = json['current_lng'];
    _totalDistanceTravelled = json['total_distance_travelled'];
    _startTrip = json['start_trip'];
    _loadingDuration = json['loading_duration'];
    _loadingTime = json['loading_time'];
    _loadingCharge = json['loading_charge'];
    _unloadingDuration = json['unloading_duration'];
    _unloadingTime = json['unloading_time'];
    _unloadingCharge = json['unloading_charge'];
    _addDate = json['add_date'];
    _isFake = json['is_fake'];
    _status = json['status'];
    _customerFirstName = json['customer_first_name'];
    _customerLastName = json['customer_last_name'];
    _customerContactNumber = json['customer_contact_number'];
    _driverFirstName = json['driver_first_name'];
    _driverLastName = json['driver_last_name'];
    _driverContactNumber = json['driver_contact_number'];
    _name = json['name'];
  }
  String? _id;
  String? _orderId;
  String? _cusId;
  String? _driverId;
  String? _categoryId;
  String? _rate;
  String? _amount;
  String? _totalAmount;
  String? _bookingDate;
  String? _orderStatus;
  String? _acceptTime;
  dynamic _closeTime;
  String? _paymentType;
  String? _paymentStatus;
  String? _trnId;
  String? _pickupLat;
  String? _pickupLong;
  String? _pickupAddress;
  String? _senderName;
  String? _senderContactNumber;
  String? _dropLat;
  String? _dropLong;
  String? _dropAddress;
  String? _distance;
  String? _expectedTime;
  String? _receiverName;
  String? _receiverContactNumber;
  dynamic _reason;
  dynamic _additionalComment;
  String? _pickedTime;
  String? _deliveryTime;
  dynamic _cancelledTime;
  String? _paymentTime;
  dynamic _currentLat;
  dynamic _currentLng;
  dynamic _totalDistanceTravelled;
  String? _startTrip;
  String? _loadingDuration;
  dynamic _loadingTime;
  String? _loadingCharge;
  dynamic _unloadingDuration;
  dynamic _unloadingTime;
  dynamic _unloadingCharge;
  String? _addDate;
  String? _isFake;
  dynamic _status;
  String? _customerFirstName;
  String? _customerLastName;
  String? _customerContactNumber;
  String? _driverFirstName;
  String? _driverLastName;
  String? _driverContactNumber;
  String? _name;
GetBookingsBydateAndDriverModel copyWith({  String? id,
  String? orderId,
  String? cusId,
  String? driverId,
  String? categoryId,
  String? rate,
  String? amount,
  String? totalAmount,
  String? bookingDate,
  String? orderStatus,
  String? acceptTime,
  dynamic closeTime,
  String? paymentType,
  String? paymentStatus,
  String? trnId,
  String? pickupLat,
  String? pickupLong,
  String? pickupAddress,
  String? senderName,
  String? senderContactNumber,
  String? dropLat,
  String? dropLong,
  String? dropAddress,
  String? distance,
  String? expectedTime,
  String? receiverName,
  String? receiverContactNumber,
  dynamic reason,
  dynamic additionalComment,
  String? pickedTime,
  String? deliveryTime,
  dynamic cancelledTime,
  String? paymentTime,
  dynamic currentLat,
  dynamic currentLng,
  dynamic totalDistanceTravelled,
  String? startTrip,
  String? loadingDuration,
  dynamic loadingTime,
  String? loadingCharge,
  dynamic unloadingDuration,
  dynamic unloadingTime,
  dynamic unloadingCharge,
  String? addDate,
  String? isFake,
  dynamic status,
  String? customerFirstName,
  String? customerLastName,
  String? customerContactNumber,
  String? driverFirstName,
  String? driverLastName,
  String? driverContactNumber,
  String? name,
}) => GetBookingsBydateAndDriverModel(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  cusId: cusId ?? _cusId,
  driverId: driverId ?? _driverId,
  categoryId: categoryId ?? _categoryId,
  rate: rate ?? _rate,
  amount: amount ?? _amount,
  totalAmount: totalAmount ?? _totalAmount,
  bookingDate: bookingDate ?? _bookingDate,
  orderStatus: orderStatus ?? _orderStatus,
  acceptTime: acceptTime ?? _acceptTime,
  closeTime: closeTime ?? _closeTime,
  paymentType: paymentType ?? _paymentType,
  paymentStatus: paymentStatus ?? _paymentStatus,
  trnId: trnId ?? _trnId,
  pickupLat: pickupLat ?? _pickupLat,
  pickupLong: pickupLong ?? _pickupLong,
  pickupAddress: pickupAddress ?? _pickupAddress,
  senderName: senderName ?? _senderName,
  senderContactNumber: senderContactNumber ?? _senderContactNumber,
  dropLat: dropLat ?? _dropLat,
  dropLong: dropLong ?? _dropLong,
  dropAddress: dropAddress ?? _dropAddress,
  distance: distance ?? _distance,
  expectedTime: expectedTime ?? _expectedTime,
  receiverName: receiverName ?? _receiverName,
  receiverContactNumber: receiverContactNumber ?? _receiverContactNumber,
  reason: reason ?? _reason,
  additionalComment: additionalComment ?? _additionalComment,
  pickedTime: pickedTime ?? _pickedTime,
  deliveryTime: deliveryTime ?? _deliveryTime,
  cancelledTime: cancelledTime ?? _cancelledTime,
  paymentTime: paymentTime ?? _paymentTime,
  currentLat: currentLat ?? _currentLat,
  currentLng: currentLng ?? _currentLng,
  totalDistanceTravelled: totalDistanceTravelled ?? _totalDistanceTravelled,
  startTrip: startTrip ?? _startTrip,
  loadingDuration: loadingDuration ?? _loadingDuration,
  loadingTime: loadingTime ?? _loadingTime,
  loadingCharge: loadingCharge ?? _loadingCharge,
  unloadingDuration: unloadingDuration ?? _unloadingDuration,
  unloadingTime: unloadingTime ?? _unloadingTime,
  unloadingCharge: unloadingCharge ?? _unloadingCharge,
  addDate: addDate ?? _addDate,
  isFake: isFake ?? _isFake,
  status: status ?? _status,
  customerFirstName: customerFirstName ?? _customerFirstName,
  customerLastName: customerLastName ?? _customerLastName,
  customerContactNumber: customerContactNumber ?? _customerContactNumber,
  driverFirstName: driverFirstName ?? _driverFirstName,
  driverLastName: driverLastName ?? _driverLastName,
  driverContactNumber: driverContactNumber ?? _driverContactNumber,
  name: name ?? _name,
);
  String? get id => _id;
  String? get orderId => _orderId;
  String? get cusId => _cusId;
  String? get driverId => _driverId;
  String? get categoryId => _categoryId;
  String? get rate => _rate;
  String? get amount => _amount;
  String? get totalAmount => _totalAmount;
  String? get bookingDate => _bookingDate;
  String? get orderStatus => _orderStatus;
  String? get acceptTime => _acceptTime;
  dynamic get closeTime => _closeTime;
  String? get paymentType => _paymentType;
  String? get paymentStatus => _paymentStatus;
  String? get trnId => _trnId;
  String? get pickupLat => _pickupLat;
  String? get pickupLong => _pickupLong;
  String? get pickupAddress => _pickupAddress;
  String? get senderName => _senderName;
  String? get senderContactNumber => _senderContactNumber;
  String? get dropLat => _dropLat;
  String? get dropLong => _dropLong;
  String? get dropAddress => _dropAddress;
  String? get distance => _distance;
  String? get expectedTime => _expectedTime;
  String? get receiverName => _receiverName;
  String? get receiverContactNumber => _receiverContactNumber;
  dynamic get reason => _reason;
  dynamic get additionalComment => _additionalComment;
  String? get pickedTime => _pickedTime;
  String? get deliveryTime => _deliveryTime;
  dynamic get cancelledTime => _cancelledTime;
  String? get paymentTime => _paymentTime;
  dynamic get currentLat => _currentLat;
  dynamic get currentLng => _currentLng;
  dynamic get totalDistanceTravelled => _totalDistanceTravelled;
  String? get startTrip => _startTrip;
  String? get loadingDuration => _loadingDuration;
  dynamic get loadingTime => _loadingTime;
  String? get loadingCharge => _loadingCharge;
  dynamic get unloadingDuration => _unloadingDuration;
  dynamic get unloadingTime => _unloadingTime;
  dynamic get unloadingCharge => _unloadingCharge;
  String? get addDate => _addDate;
  String? get isFake => _isFake;
  dynamic get status => _status;
  String? get customerFirstName => _customerFirstName;
  String? get customerLastName => _customerLastName;
  String? get customerContactNumber => _customerContactNumber;
  String? get driverFirstName => _driverFirstName;
  String? get driverLastName => _driverLastName;
  String? get driverContactNumber => _driverContactNumber;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['cus_id'] = _cusId;
    map['driver_id'] = _driverId;
    map['category_id'] = _categoryId;
    map['rate'] = _rate;
    map['amount'] = _amount;
    map['total_amount'] = _totalAmount;
    map['booking_date'] = _bookingDate;
    map['order_status'] = _orderStatus;
    map['accept_time'] = _acceptTime;
    map['close_time'] = _closeTime;
    map['payment_type'] = _paymentType;
    map['payment_status'] = _paymentStatus;
    map['trn_id'] = _trnId;
    map['pickup_lat'] = _pickupLat;
    map['pickup_long'] = _pickupLong;
    map['pickup_address'] = _pickupAddress;
    map['sender_name'] = _senderName;
    map['sender_contact_number'] = _senderContactNumber;
    map['drop_lat'] = _dropLat;
    map['drop_long'] = _dropLong;
    map['drop_address'] = _dropAddress;
    map['distance'] = _distance;
    map['expected_time'] = _expectedTime;
    map['receiver_name'] = _receiverName;
    map['receiver_contact_number'] = _receiverContactNumber;
    map['reason'] = _reason;
    map['additional_comment'] = _additionalComment;
    map['picked_time'] = _pickedTime;
    map['delivery_time'] = _deliveryTime;
    map['cancelled_time'] = _cancelledTime;
    map['payment_time'] = _paymentTime;
    map['current_lat'] = _currentLat;
    map['current_lng'] = _currentLng;
    map['total_distance_travelled'] = _totalDistanceTravelled;
    map['start_trip'] = _startTrip;
    map['loading_duration'] = _loadingDuration;
    map['loading_time'] = _loadingTime;
    map['loading_charge'] = _loadingCharge;
    map['unloading_duration'] = _unloadingDuration;
    map['unloading_time'] = _unloadingTime;
    map['unloading_charge'] = _unloadingCharge;
    map['add_date'] = _addDate;
    map['is_fake'] = _isFake;
    map['status'] = _status;
    map['customer_first_name'] = _customerFirstName;
    map['customer_last_name'] = _customerLastName;
    map['customer_contact_number'] = _customerContactNumber;
    map['driver_first_name'] = _driverFirstName;
    map['driver_last_name'] = _driverLastName;
    map['driver_contact_number'] = _driverContactNumber;
    map['name'] = _name;
    return map;
  }

}