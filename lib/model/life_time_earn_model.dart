/// status : true
/// message : "Lifetime earnings and stats retrieved successfully"
/// driver_id : "338"
/// total_earnings : "29420.56"
/// total_hours : "705.76"
/// total_trips : 78

class LifeTimeEarnModel {
  LifeTimeEarnModel({
      bool? status, 
      dynamic message, 
      dynamic driverId, 
      dynamic totalEarnings, 
      dynamic totalHours, 
      dynamic totalTrips,}){
    _status = status;
    _message = message;
    _driverId = driverId;
    _totalEarnings = totalEarnings;
    _totalHours = totalHours;
    _totalTrips = totalTrips;
}

  LifeTimeEarnModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _driverId = json['driver_id'];
    _totalEarnings = json['total_earnings'];
    _totalHours = json['total_hours'];
    _totalTrips = json['total_trips'];
  }
  bool? _status;
  dynamic _message;
  dynamic _driverId;
  dynamic _totalEarnings;
  dynamic _totalHours;
  dynamic _totalTrips;
LifeTimeEarnModel copyWith({  bool? status,
  dynamic message,
  dynamic driverId,
  dynamic totalEarnings,
  dynamic totalHours,
  dynamic totalTrips,
}) => LifeTimeEarnModel(  status: status ?? _status,
  message: message ?? _message,
  driverId: driverId ?? _driverId,
  totalEarnings: totalEarnings ?? _totalEarnings,
  totalHours: totalHours ?? _totalHours,
  totalTrips: totalTrips ?? _totalTrips,
);
  bool? get status => _status;
  dynamic get message => _message;
  dynamic get driverId => _driverId;
  dynamic get totalEarnings => _totalEarnings;
  dynamic get totalHours => _totalHours;
  dynamic get totalTrips => _totalTrips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['driver_id'] = _driverId;
    map['total_earnings'] = _totalEarnings;
    map['total_hours'] = _totalHours;
    map['total_trips'] = _totalTrips;
    return map;
  }

}