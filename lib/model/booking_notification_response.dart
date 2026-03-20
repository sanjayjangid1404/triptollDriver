/// status : true
/// message : "New Bookings Found"
/// data : [{"booking_id":"1347","order_id":"474596853820","amount":"390.00","vehicle_id":null,"cus_id":"773","is_fake":false,"pickup":{"address":"2, Malviya Nagar, Jaipur, India","lat":"26.837191999079","lng":"75.833885595202"},"dropoffs":[{"address":"2, Malviya Nagar, Jaipur, India","lat":"26.84362235798","lng":"75.826867930591","name":"Himpreet Singh","contact_number":"8619394874","sequence":"2"}],"distance":0}]

class BookingNotificationResponse {
  BookingNotificationResponse({
      dynamic status, 
      dynamic message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  BookingNotificationResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  dynamic _status;
  dynamic _message;
  List<Data>? _data;
BookingNotificationResponse copyWith({  dynamic status,
  dynamic message,
  List<Data>? data,
}) => BookingNotificationResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  dynamic get status => _status;
  dynamic get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// booking_id : "1347"
/// order_id : "474596853820"
/// amount : "390.00"
/// vehicle_id : null
/// cus_id : "773"
/// is_fake : false
/// pickup : {"address":"2, Malviya Nagar, Jaipur, India","lat":"26.837191999079","lng":"75.833885595202"}
/// dropoffs : [{"address":"2, Malviya Nagar, Jaipur, India","lat":"26.84362235798","lng":"75.826867930591","name":"Himpreet Singh","contact_number":"8619394874","sequence":"2"}]
/// distance : 0

class Data {
  Data({
      dynamic bookingId, 
      dynamic orderId, 
      dynamic amount, 
      dynamic vehicleId, 
      dynamic orderStatus,
      dynamic scheduleTime,
      dynamic scheduleDate,
      dynamic cusId,
      dynamic isFake, 
      Pickup? pickup, 
      List<Dropoffs>? dropoffs, 
      dynamic distance,}){
    _bookingId = bookingId;
    _orderId = orderId;
    _amount = amount;
    _vehicleId = vehicleId;
    _orderStatus = orderStatus;
    _scheduleTime = scheduleTime;
    _scheduleDate = scheduleDate;
    _cusId = cusId;
    _isFake = isFake;
    _pickup = pickup;
    _dropoffs = dropoffs;
    _distance = distance;
}

  Data.fromJson(dynamic json) {
    _bookingId = json['booking_id'];
    _orderId = json['order_id'];
    _amount = json['amount'];
    _vehicleId = json['vehicle_id'];
    _orderStatus = json['order_status'];
    _scheduleDate = json['schedule_date'];
    _scheduleTime = json['schedule_time'];
    _cusId = json['cus_id'];
    _isFake = json['is_fake'];
    _pickup = json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null;
    if (json['dropoffs'] != null) {
      _dropoffs = [];
      json['dropoffs'].forEach((v) {
        _dropoffs?.add(Dropoffs.fromJson(v));
      });
    }
    _distance = json['distance'];
  }
  dynamic _bookingId;
  dynamic _orderId;
  dynamic _amount;
  dynamic _vehicleId;
  dynamic _orderStatus;
  dynamic _scheduleTime;
  dynamic _scheduleDate;
  dynamic _cusId;
  dynamic _isFake;
  Pickup? _pickup;
  List<Dropoffs>? _dropoffs;
  dynamic _distance;
Data copyWith({  dynamic bookingId,
  dynamic orderId,
  dynamic amount,
  dynamic vehicleId,
  dynamic orderStatus,
  dynamic scheduleTime,
  dynamic scheduleDate,
  dynamic cusId,
  dynamic isFake,
  Pickup? pickup,
  List<Dropoffs>? dropoffs,
  dynamic distance,
}) => Data(  bookingId: bookingId ?? _bookingId,
  orderId: orderId ?? _orderId,
  amount: amount ?? _amount,
  vehicleId: vehicleId ?? _vehicleId,
  scheduleTime: scheduleTime ?? _scheduleTime,
  scheduleDate: scheduleDate ?? _scheduleDate,
  orderStatus: orderStatus ?? _orderStatus,
  cusId: cusId ?? _cusId,
  isFake: isFake ?? _isFake,
  pickup: pickup ?? _pickup,
  dropoffs: dropoffs ?? _dropoffs,
  distance: distance ?? _distance,
);
  dynamic get bookingId => _bookingId;
  dynamic get orderId => _orderId;
  dynamic get amount => _amount;
  dynamic get vehicleId => _vehicleId;
  dynamic get scheduleTime => _scheduleTime;
  dynamic get scheduleDate => _scheduleDate;
  dynamic get orderStatus => _orderStatus;
  dynamic get cusId => _cusId;
  dynamic get isFake => _isFake;
  Pickup? get pickup => _pickup;
  List<Dropoffs>? get dropoffs => _dropoffs;
  dynamic get distance => _distance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['booking_id'] = _bookingId;
    map['order_id'] = _orderId;
    map['amount'] = _amount;
    map['vehicle_id'] = _vehicleId;
    map['order_status'] = _orderStatus;
    map['schedule_date'] = _scheduleDate;
    map['schedule_time'] = _scheduleTime;
    map['cus_id'] = _cusId;
    map['is_fake'] = _isFake;
    if (_pickup != null) {
      map['pickup'] = _pickup?.toJson();
    }
    if (_dropoffs != null) {
      map['dropoffs'] = _dropoffs?.map((v) => v.toJson()).toList();
    }
    map['distance'] = _distance;
    return map;
  }

}

/// address : "2, Malviya Nagar, Jaipur, India"
/// lat : "26.84362235798"
/// lng : "75.826867930591"
/// name : "Himpreet Singh"
/// contact_number : "8619394874"
/// sequence : "2"

class Dropoffs {
  Dropoffs({
      dynamic address, 
      dynamic lat, 
      dynamic lng, 
      dynamic name, 
      dynamic contactNumber, 
      dynamic sequence,}){
    _address = address;
    _lat = lat;
    _lng = lng;
    _name = name;
    _contactNumber = contactNumber;
    _sequence = sequence;
}

  Dropoffs.fromJson(dynamic json) {
    _address = json['address'];
    _lat = json['lat'];
    _lng = json['lng'];
    _name = json['name'];
    _contactNumber = json['contact_number'];
    _sequence = json['sequence'];
  }
  dynamic _address;
  dynamic _lat;
  dynamic _lng;
  dynamic _name;
  dynamic _contactNumber;
  dynamic _sequence;
Dropoffs copyWith({  dynamic address,
  dynamic lat,
  dynamic lng,
  dynamic name,
  dynamic contactNumber,
  dynamic sequence,
}) => Dropoffs(  address: address ?? _address,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
  name: name ?? _name,
  contactNumber: contactNumber ?? _contactNumber,
  sequence: sequence ?? _sequence,
);
  dynamic get address => _address;
  dynamic get lat => _lat;
  dynamic get lng => _lng;
  dynamic get name => _name;
  dynamic get contactNumber => _contactNumber;
  dynamic get sequence => _sequence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['name'] = _name;
    map['contact_number'] = _contactNumber;
    map['sequence'] = _sequence;
    return map;
  }

}

/// address : "2, Malviya Nagar, Jaipur, India"
/// lat : "26.837191999079"
/// lng : "75.833885595202"

class Pickup {
  Pickup({
      dynamic address, 
      dynamic lat, 
      dynamic lng,}){
    _address = address;
    _lat = lat;
    _lng = lng;
}

  Pickup.fromJson(dynamic json) {
    _address = json['address'];
    _lat = json['lat'];
    _lng = json['lng'];
  }
  dynamic _address;
  dynamic _lat;
  dynamic _lng;
Pickup copyWith({  dynamic address,
  dynamic lat,
  dynamic lng,
}) => Pickup(  address: address ?? _address,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
);
  dynamic get address => _address;
  dynamic get lat => _lat;
  dynamic get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }

}