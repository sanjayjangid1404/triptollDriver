/// message : "Running Orders"
/// status : true
/// orders : [{"id":"652","order_id":"108081045379","cus_id":"309","driver_id":"338","asigned_driver":null,"category_id":"114","vehicle_id":"114","rate":"7","amount":"96","total_amount":"96","stop_charge":"0","booking_date":"2025-08-10 18:27:59","order_status":"delivered","read_status":"new","accept_time":"2025-08-10 21:26:42","close_time":null,"discount":"0","discount_percentage":"0","payment_type":"Online","payment_status":"pending","trn_id":null,"pickup_lat":"26.8892941636895","pickup_long":"75.91172832995653","pickup_address":"38, Sumel, Jaipur, India","sender_name":"Mohan S","sender_contact_number":"9266809133","apartment_type":"","drop_lat":"26.906233955536404","drop_long":"75.81631477922201","drop_address":"SMS HOSPITAL, Ashok Nagar, Jaipur, India","receiver_name":"ccf","receiver_contact_number":"5699698999","reason":null,"additional_comment":null,"picked_time":"2025-08-10 21:28:27","delivery_time":"2025-08-10 21:28:38","cancelled_time":null,"payment_time":null,"start_trip":"yes","add_date":"2025-08-10 18:27:59"}]

class RunningOrderResponse {
  RunningOrderResponse({
      String? message, 
      bool? status, 
      List<Orders>? orders,}){
    _message = message;
    _status = status;
    _orders = orders;
}

  RunningOrderResponse.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders?.add(Orders.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _status;
  List<Orders>? _orders;
RunningOrderResponse copyWith({  String? message,
  bool? status,
  List<Orders>? orders,
}) => RunningOrderResponse(  message: message ?? _message,
  status: status ?? _status,
  orders: orders ?? _orders,
);
  String? get message => _message;
  bool? get status => _status;
  List<Orders>? get orders => _orders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    if (_orders != null) {
      map['orders'] = _orders?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "652"
/// order_id : "108081045379"
/// cus_id : "309"
/// driver_id : "338"
/// asigned_driver : null
/// category_id : "114"
/// vehicle_id : "114"
/// rate : "7"
/// amount : "96"
/// total_amount : "96"
/// stop_charge : "0"
/// booking_date : "2025-08-10 18:27:59"
/// order_status : "delivered"
/// read_status : "new"
/// accept_time : "2025-08-10 21:26:42"
/// close_time : null
/// discount : "0"
/// discount_percentage : "0"
/// payment_type : "Online"
/// payment_status : "pending"
/// trn_id : null
/// pickup_lat : "26.8892941636895"
/// pickup_long : "75.91172832995653"
/// pickup_address : "38, Sumel, Jaipur, India"
/// sender_name : "Mohan S"
/// sender_contact_number : "9266809133"
/// apartment_type : ""
/// drop_lat : "26.906233955536404"
/// drop_long : "75.81631477922201"
/// drop_address : "SMS HOSPITAL, Ashok Nagar, Jaipur, India"
/// receiver_name : "ccf"
/// receiver_contact_number : "5699698999"
/// reason : null
/// additional_comment : null
/// picked_time : "2025-08-10 21:28:27"
/// delivery_time : "2025-08-10 21:28:38"
/// cancelled_time : null
/// payment_time : null
/// start_trip : "yes"
/// add_date : "2025-08-10 18:27:59"

class Orders {
  Orders({
      String? id, 
      String? orderId, 
      String? cusId, 
      String? driverId, 
      dynamic asignedDriver, 
      String? categoryId, 
      String? vehicleId, 
      String? rate, 
      String? amount, 
      String? totalAmount, 
      String? stopCharge, 
      String? bookingDate, 
      String? orderStatus, 
      String? readStatus, 
      String? acceptTime, 
      dynamic closeTime, 
      String? discount, 
      String? discountPercentage, 
      String? paymentType, 
      String? paymentStatus, 
      dynamic trnId, 
      String? pickupLat, 
      String? pickupLong, 
      String? pickupAddress, 
      String? senderName, 
      String? senderContactNumber, 
      String? apartmentType, 
      String? dropLat, 
      String? dropLong, 
      String? dropAddress, 
      String? receiverName, 
      String? receiverContactNumber, 
      dynamic reason, 
      dynamic additionalComment, 
      String? pickedTime, 
      String? deliveryTime, 
      dynamic cancelledTime, 
      dynamic paymentTime, 
      String? startTrip, 
      String? addDate,}){
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
    _orderStatus = orderStatus;
    _readStatus = readStatus;
    _acceptTime = acceptTime;
    _closeTime = closeTime;
    _discount = discount;
    _discountPercentage = discountPercentage;
    _paymentType = paymentType;
    _paymentStatus = paymentStatus;
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
    _paymentTime = paymentTime;
    _startTrip = startTrip;
    _addDate = addDate;
}

  Orders.fromJson(dynamic json) {
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
    _orderStatus = json['order_status'];
    _readStatus = json['read_status'];
    _acceptTime = json['accept_time'];
    _closeTime = json['close_time'];
    _discount = json['discount'];
    _discountPercentage = json['discount_percentage'];
    _paymentType = json['payment_type'];
    _paymentStatus = json['payment_status'];
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
    _paymentTime = json['payment_time'];
    _startTrip = json['start_trip'];
    _addDate = json['add_date'];
  }
  String? _id;
  String? _orderId;
  String? _cusId;
  String? _driverId;
  dynamic _asignedDriver;
  String? _categoryId;
  String? _vehicleId;
  String? _rate;
  String? _amount;
  String? _totalAmount;
  String? _stopCharge;
  String? _bookingDate;
  String? _orderStatus;
  String? _readStatus;
  String? _acceptTime;
  dynamic _closeTime;
  String? _discount;
  String? _discountPercentage;
  String? _paymentType;
  String? _paymentStatus;
  dynamic _trnId;
  String? _pickupLat;
  String? _pickupLong;
  String? _pickupAddress;
  String? _senderName;
  String? _senderContactNumber;
  String? _apartmentType;
  String? _dropLat;
  String? _dropLong;
  String? _dropAddress;
  String? _receiverName;
  String? _receiverContactNumber;
  dynamic _reason;
  dynamic _additionalComment;
  String? _pickedTime;
  String? _deliveryTime;
  dynamic _cancelledTime;
  dynamic _paymentTime;
  String? _startTrip;
  String? _addDate;
Orders copyWith({  String? id,
  String? orderId,
  String? cusId,
  String? driverId,
  dynamic asignedDriver,
  String? categoryId,
  String? vehicleId,
  String? rate,
  String? amount,
  String? totalAmount,
  String? stopCharge,
  String? bookingDate,
  String? orderStatus,
  String? readStatus,
  String? acceptTime,
  dynamic closeTime,
  String? discount,
  String? discountPercentage,
  String? paymentType,
  String? paymentStatus,
  dynamic trnId,
  String? pickupLat,
  String? pickupLong,
  String? pickupAddress,
  String? senderName,
  String? senderContactNumber,
  String? apartmentType,
  String? dropLat,
  String? dropLong,
  String? dropAddress,
  String? receiverName,
  String? receiverContactNumber,
  dynamic reason,
  dynamic additionalComment,
  String? pickedTime,
  String? deliveryTime,
  dynamic cancelledTime,
  dynamic paymentTime,
  String? startTrip,
  String? addDate,
}) => Orders(  id: id ?? _id,
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
  discount: discount ?? _discount,
  discountPercentage: discountPercentage ?? _discountPercentage,
  paymentType: paymentType ?? _paymentType,
  paymentStatus: paymentStatus ?? _paymentStatus,
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
  paymentTime: paymentTime ?? _paymentTime,
  startTrip: startTrip ?? _startTrip,
  addDate: addDate ?? _addDate,
);
  String? get id => _id;
  String? get orderId => _orderId;
  String? get cusId => _cusId;
  String? get driverId => _driverId;
  dynamic get asignedDriver => _asignedDriver;
  String? get categoryId => _categoryId;
  String? get vehicleId => _vehicleId;
  String? get rate => _rate;
  String? get amount => _amount;
  String? get totalAmount => _totalAmount;
  String? get stopCharge => _stopCharge;
  String? get bookingDate => _bookingDate;
  String? get orderStatus => _orderStatus;
  String? get readStatus => _readStatus;
  String? get acceptTime => _acceptTime;
  dynamic get closeTime => _closeTime;
  String? get discount => _discount;
  String? get discountPercentage => _discountPercentage;
  String? get paymentType => _paymentType;
  String? get paymentStatus => _paymentStatus;
  dynamic get trnId => _trnId;
  String? get pickupLat => _pickupLat;
  String? get pickupLong => _pickupLong;
  String? get pickupAddress => _pickupAddress;
  String? get senderName => _senderName;
  String? get senderContactNumber => _senderContactNumber;
  String? get apartmentType => _apartmentType;
  String? get dropLat => _dropLat;
  String? get dropLong => _dropLong;
  String? get dropAddress => _dropAddress;
  String? get receiverName => _receiverName;
  String? get receiverContactNumber => _receiverContactNumber;
  dynamic get reason => _reason;
  dynamic get additionalComment => _additionalComment;
  String? get pickedTime => _pickedTime;
  String? get deliveryTime => _deliveryTime;
  dynamic get cancelledTime => _cancelledTime;
  dynamic get paymentTime => _paymentTime;
  String? get startTrip => _startTrip;
  String? get addDate => _addDate;

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
    map['order_status'] = _orderStatus;
    map['read_status'] = _readStatus;
    map['accept_time'] = _acceptTime;
    map['close_time'] = _closeTime;
    map['discount'] = _discount;
    map['discount_percentage'] = _discountPercentage;
    map['payment_type'] = _paymentType;
    map['payment_status'] = _paymentStatus;
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
    map['payment_time'] = _paymentTime;
    map['start_trip'] = _startTrip;
    map['add_date'] = _addDate;
    return map;
  }

}