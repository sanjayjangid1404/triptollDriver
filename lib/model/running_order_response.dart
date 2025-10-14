/// message : "Running Orders"
/// status : true
/// orders : [{"booking_id":"1352","order_id":"969917169733","amount":"451.31","driver_id":"338","category_id":"112","cus_id":"770","start_trip":"no","order_status":"accpeted","payment_status":"pending","booking_date":"2025-10-10 16:55:09","accept_time":"2025-10-10 17:04:07","distance":null,"expected_time":null,"pickup":{"location_id":"1941","address":"2, Malviya Nagar, Jaipur, India","lat":"26.837129174511","lng":"75.833861455321","name":"Himpreet singh","contact_number":"9649768510","distance_to_next":"4.20","expected_time_to_next":"10m","completion_time":null,"loading_duration":"0","loading_time":"0000-00-00 00:00:00","loading_charge":"0.00"},"dropoffs":[{"location_id":"1942","address":"3/488, Malviya Nagar, Jaipur, India","lat":"26.856442796183","lng":"75.808519273996","name":"Himpreet singh","contact_number":"9649768510","sequence":"2","distance_to_next":"0.00","expected_time_to_next":"0m","completion_time":null,"loading_duration":null,"loading_time":null,"loading_charge":null,"unloading_duration":"0","unloading_time":"0000-00-00 00:00:00","unloading_charge":"0.00"}]}]

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

/// booking_id : "1352"
/// order_id : "969917169733"
/// amount : "451.31"
/// driver_id : "338"
/// category_id : "112"
/// cus_id : "770"
/// start_trip : "no"
/// order_status : "accpeted"
/// payment_status : "pending"
/// booking_date : "2025-10-10 16:55:09"
/// accept_time : "2025-10-10 17:04:07"
/// distance : null
/// expected_time : null
/// pickup : {"location_id":"1941","address":"2, Malviya Nagar, Jaipur, India","lat":"26.837129174511","lng":"75.833861455321","name":"Himpreet singh","contact_number":"9649768510","distance_to_next":"4.20","expected_time_to_next":"10m","completion_time":null,"loading_duration":"0","loading_time":"0000-00-00 00:00:00","loading_charge":"0.00"}
/// dropoffs : [{"location_id":"1942","address":"3/488, Malviya Nagar, Jaipur, India","lat":"26.856442796183","lng":"75.808519273996","name":"Himpreet singh","contact_number":"9649768510","sequence":"2","distance_to_next":"0.00","expected_time_to_next":"0m","completion_time":null,"loading_duration":null,"loading_time":null,"loading_charge":null,"unloading_duration":"0","unloading_time":"0000-00-00 00:00:00","unloading_charge":"0.00"}]

class Orders {
  Orders({
      String? bookingId, 
      String? orderId, 
      String? amount, 
      String? driverId, 
      String? categoryId, 
      String? cusId, 
      String? startTrip, 
      String? orderStatus, 
      String? paymentStatus, 
      String? bookingDate, 
      String? acceptTime, 
      dynamic distance, 
      dynamic expectedTime, 
      Pickup? pickup, 
      List<Dropoffs>? dropoffs,}){
    _bookingId = bookingId;
    _orderId = orderId;
    _amount = amount;
    _driverId = driverId;
    _categoryId = categoryId;
    _cusId = cusId;
    _startTrip = startTrip;
    _orderStatus = orderStatus;
    _paymentStatus = paymentStatus;
    _bookingDate = bookingDate;
    _acceptTime = acceptTime;
    _distance = distance;
    _expectedTime = expectedTime;
    _pickup = pickup;
    _dropoffs = dropoffs;
}

  Orders.fromJson(dynamic json) {
    _bookingId = json['id'];
    _orderId = json['order_id'];
    _amount = json['amount'];
    _driverId = json['driver_id'];
    _categoryId = json['category_id'];
    _cusId = json['cus_id'];
    _startTrip = json['start_trip'];
    _orderStatus = json['order_status'];
    _paymentStatus = json['payment_status'];
    _bookingDate = json['booking_date'];
    _acceptTime = json['accept_time'];
    _distance = json['distance'];
    _expectedTime = json['expected_time'];
    _pickup = json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null;
    if (json['dropoffs'] != null) {
      _dropoffs = [];
      json['dropoffs'].forEach((v) {
        _dropoffs?.add(Dropoffs.fromJson(v));
      });
    }
  }
  String? _bookingId;
  String? _orderId;
  String? _amount;
  String? _driverId;
  String? _categoryId;
  String? _cusId;
  String? _startTrip;
  String? _orderStatus;
  String? _paymentStatus;
  String? _bookingDate;
  String? _acceptTime;
  dynamic _distance;
  dynamic _expectedTime;
  Pickup? _pickup;
  List<Dropoffs>? _dropoffs;
Orders copyWith({  String? bookingId,
  String? orderId,
  String? amount,
  String? driverId,
  String? categoryId,
  String? cusId,
  String? startTrip,
  String? orderStatus,
  String? paymentStatus,
  String? bookingDate,
  String? acceptTime,
  dynamic distance,
  dynamic expectedTime,
  Pickup? pickup,
  List<Dropoffs>? dropoffs,
}) => Orders(  bookingId: bookingId ?? _bookingId,
  orderId: orderId ?? _orderId,
  amount: amount ?? _amount,
  driverId: driverId ?? _driverId,
  categoryId: categoryId ?? _categoryId,
  cusId: cusId ?? _cusId,
  startTrip: startTrip ?? _startTrip,
  orderStatus: orderStatus ?? _orderStatus,
  paymentStatus: paymentStatus ?? _paymentStatus,
  bookingDate: bookingDate ?? _bookingDate,
  acceptTime: acceptTime ?? _acceptTime,
  distance: distance ?? _distance,
  expectedTime: expectedTime ?? _expectedTime,
  pickup: pickup ?? _pickup,
  dropoffs: dropoffs ?? _dropoffs,
);
  String? get bookingId => _bookingId;
  String? get orderId => _orderId;
  String? get amount => _amount;
  String? get driverId => _driverId;
  String? get categoryId => _categoryId;
  String? get cusId => _cusId;
  String? get startTrip => _startTrip;
  String? get orderStatus => _orderStatus;
  String? get paymentStatus => _paymentStatus;
  String? get bookingDate => _bookingDate;
  String? get acceptTime => _acceptTime;
  dynamic get distance => _distance;
  dynamic get expectedTime => _expectedTime;
  Pickup? get pickup => _pickup;
  List<Dropoffs>? get dropoffs => _dropoffs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _bookingId;
    map['order_id'] = _orderId;
    map['amount'] = _amount;
    map['driver_id'] = _driverId;
    map['category_id'] = _categoryId;
    map['cus_id'] = _cusId;
    map['start_trip'] = _startTrip;
    map['order_status'] = _orderStatus;
    map['payment_status'] = _paymentStatus;
    map['booking_date'] = _bookingDate;
    map['accept_time'] = _acceptTime;
    map['distance'] = _distance;
    map['expected_time'] = _expectedTime;
    if (_pickup != null) {
      map['pickup'] = _pickup?.toJson();
    }
    if (_dropoffs != null) {
      map['dropoffs'] = _dropoffs?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// location_id : "1942"
/// address : "3/488, Malviya Nagar, Jaipur, India"
/// lat : "26.856442796183"
/// lng : "75.808519273996"
/// name : "Himpreet singh"
/// contact_number : "9649768510"
/// sequence : "2"
/// distance_to_next : "0.00"
/// expected_time_to_next : "0m"
/// completion_time : null
/// loading_duration : null
/// loading_time : null
/// loading_charge : null
/// unloading_duration : "0"
/// unloading_time : "0000-00-00 00:00:00"
/// unloading_charge : "0.00"

class Dropoffs {
  Dropoffs({
      String? locationId, 
      String? address, 
      String? lat, 
      String? lng, 
      String? name, 
      String? contactNumber, 
      String? sequence, 
      String? distanceToNext, 
      String? expectedTimeToNext, 
      dynamic completionTime, 
      dynamic loadingDuration, 
      dynamic loadingTime, 
      dynamic loadingCharge, 
      String? unloadingDuration, 
      String? unloadingTime, 
      String? unloadingCharge,}){
    _locationId = locationId;
    _address = address;
    _lat = lat;
    _lng = lng;
    _name = name;
    _contactNumber = contactNumber;
    _sequence = sequence;
    _distanceToNext = distanceToNext;
    _expectedTimeToNext = expectedTimeToNext;
    _completionTime = completionTime;
    _loadingDuration = loadingDuration;
    _loadingTime = loadingTime;
    _loadingCharge = loadingCharge;
    _unloadingDuration = unloadingDuration;
    _unloadingTime = unloadingTime;
    _unloadingCharge = unloadingCharge;
}

  Dropoffs.fromJson(dynamic json) {
    _locationId = json['location_id'];
    _address = json['address'];
    _lat = json['lat'];
    _lng = json['lng'];
    _name = json['name'];
    _contactNumber = json['contact_number'];
    _sequence = json['sequence'];
    _distanceToNext = json['distance_to_next'];
    _expectedTimeToNext = json['expected_time_to_next'];
    _completionTime = json['completion_time'];
    _loadingDuration = json['loading_duration'];
    _loadingTime = json['loading_time'];
    _loadingCharge = json['loading_charge'];
    _unloadingDuration = json['unloading_duration'];
    _unloadingTime = json['unloading_time'];
    _unloadingCharge = json['unloading_charge'];
  }
  String? _locationId;
  String? _address;
  String? _lat;
  String? _lng;
  String? _name;
  String? _contactNumber;
  String? _sequence;
  String? _distanceToNext;
  String? _expectedTimeToNext;
  dynamic _completionTime;
  dynamic _loadingDuration;
  dynamic _loadingTime;
  dynamic _loadingCharge;
  String? _unloadingDuration;
  String? _unloadingTime;
  String? _unloadingCharge;
Dropoffs copyWith({  String? locationId,
  String? address,
  String? lat,
  String? lng,
  String? name,
  String? contactNumber,
  String? sequence,
  String? distanceToNext,
  String? expectedTimeToNext,
  dynamic completionTime,
  dynamic loadingDuration,
  dynamic loadingTime,
  dynamic loadingCharge,
  String? unloadingDuration,
  String? unloadingTime,
  String? unloadingCharge,
}) => Dropoffs(  locationId: locationId ?? _locationId,
  address: address ?? _address,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
  name: name ?? _name,
  contactNumber: contactNumber ?? _contactNumber,
  sequence: sequence ?? _sequence,
  distanceToNext: distanceToNext ?? _distanceToNext,
  expectedTimeToNext: expectedTimeToNext ?? _expectedTimeToNext,
  completionTime: completionTime ?? _completionTime,
  loadingDuration: loadingDuration ?? _loadingDuration,
  loadingTime: loadingTime ?? _loadingTime,
  loadingCharge: loadingCharge ?? _loadingCharge,
  unloadingDuration: unloadingDuration ?? _unloadingDuration,
  unloadingTime: unloadingTime ?? _unloadingTime,
  unloadingCharge: unloadingCharge ?? _unloadingCharge,
);
  String? get locationId => _locationId;
  String? get address => _address;
  String? get lat => _lat;
  String? get lng => _lng;
  String? get name => _name;
  String? get contactNumber => _contactNumber;
  String? get sequence => _sequence;
  String? get distanceToNext => _distanceToNext;
  String? get expectedTimeToNext => _expectedTimeToNext;
  dynamic get completionTime => _completionTime;
  dynamic get loadingDuration => _loadingDuration;
  dynamic get loadingTime => _loadingTime;
  dynamic get loadingCharge => _loadingCharge;
  String? get unloadingDuration => _unloadingDuration;
  String? get unloadingTime => _unloadingTime;
  String? get unloadingCharge => _unloadingCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location_id'] = _locationId;
    map['address'] = _address;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['name'] = _name;
    map['contact_number'] = _contactNumber;
    map['sequence'] = _sequence;
    map['distance_to_next'] = _distanceToNext;
    map['expected_time_to_next'] = _expectedTimeToNext;
    map['completion_time'] = _completionTime;
    map['loading_duration'] = _loadingDuration;
    map['loading_time'] = _loadingTime;
    map['loading_charge'] = _loadingCharge;
    map['unloading_duration'] = _unloadingDuration;
    map['unloading_time'] = _unloadingTime;
    map['unloading_charge'] = _unloadingCharge;
    return map;
  }

}

/// location_id : "1941"
/// address : "2, Malviya Nagar, Jaipur, India"
/// lat : "26.837129174511"
/// lng : "75.833861455321"
/// name : "Himpreet singh"
/// contact_number : "9649768510"
/// distance_to_next : "4.20"
/// expected_time_to_next : "10m"
/// completion_time : null
/// loading_duration : "0"
/// loading_time : "0000-00-00 00:00:00"
/// loading_charge : "0.00"

class Pickup {
  Pickup({
      String? locationId, 
      String? address, 
      String? lat, 
      String? lng, 
      String? name, 
      String? contactNumber, 
      String? distanceToNext, 
      String? expectedTimeToNext, 
      dynamic completionTime, 
      String? loadingDuration, 
      String? loadingTime, 
      String? loadingCharge,}){
    _locationId = locationId;
    _address = address;
    _lat = lat;
    _lng = lng;
    _name = name;
    _contactNumber = contactNumber;
    _distanceToNext = distanceToNext;
    _expectedTimeToNext = expectedTimeToNext;
    _completionTime = completionTime;
    _loadingDuration = loadingDuration;
    _loadingTime = loadingTime;
    _loadingCharge = loadingCharge;
}

  Pickup.fromJson(dynamic json) {
    _locationId = json['location_id'];
    _address = json['address'];
    _lat = json['lat'];
    _lng = json['lng'];
    _name = json['name'];
    _contactNumber = json['contact_number'];
    _distanceToNext = json['distance_to_next'];
    _expectedTimeToNext = json['expected_time_to_next'];
    _completionTime = json['completion_time'];
    _loadingDuration = json['loading_duration'];
    _loadingTime = json['loading_time'];
    _loadingCharge = json['loading_charge'];
  }
  String? _locationId;
  String? _address;
  String? _lat;
  String? _lng;
  String? _name;
  String? _contactNumber;
  String? _distanceToNext;
  String? _expectedTimeToNext;
  dynamic _completionTime;
  String? _loadingDuration;
  String? _loadingTime;
  String? _loadingCharge;
Pickup copyWith({  String? locationId,
  String? address,
  String? lat,
  String? lng,
  String? name,
  String? contactNumber,
  String? distanceToNext,
  String? expectedTimeToNext,
  dynamic completionTime,
  String? loadingDuration,
  String? loadingTime,
  String? loadingCharge,
}) => Pickup(  locationId: locationId ?? _locationId,
  address: address ?? _address,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
  name: name ?? _name,
  contactNumber: contactNumber ?? _contactNumber,
  distanceToNext: distanceToNext ?? _distanceToNext,
  expectedTimeToNext: expectedTimeToNext ?? _expectedTimeToNext,
  completionTime: completionTime ?? _completionTime,
  loadingDuration: loadingDuration ?? _loadingDuration,
  loadingTime: loadingTime ?? _loadingTime,
  loadingCharge: loadingCharge ?? _loadingCharge,
);
  String? get locationId => _locationId;
  String? get address => _address;
  String? get lat => _lat;
  String? get lng => _lng;
  String? get name => _name;
  String? get contactNumber => _contactNumber;
  String? get distanceToNext => _distanceToNext;
  String? get expectedTimeToNext => _expectedTimeToNext;
  dynamic get completionTime => _completionTime;
  String? get loadingDuration => _loadingDuration;
  String? get loadingTime => _loadingTime;
  String? get loadingCharge => _loadingCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location_id'] = _locationId;
    map['address'] = _address;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['name'] = _name;
    map['contact_number'] = _contactNumber;
    map['distance_to_next'] = _distanceToNext;
    map['expected_time_to_next'] = _expectedTimeToNext;
    map['completion_time'] = _completionTime;
    map['loading_duration'] = _loadingDuration;
    map['loading_time'] = _loadingTime;
    map['loading_charge'] = _loadingCharge;
    return map;
  }

}