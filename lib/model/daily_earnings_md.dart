/// status : true
/// message : "Daily earnings and stats retrieved successfully"
/// driver_id : "338"
/// date : "2025-09-25"
/// total_earnings : "5303.56"
/// total_hours : "0.21"
/// total_trips : 10

class DailyEarningsMd {
  DailyEarningsMd({
      bool? status, 
      dynamic message, 
      dynamic driverId, 
      dynamic date, 
      dynamic totalEarnings, 
      dynamic totalHours, 
      dynamic totalTrips,}){
    _status = status;
    _message = message;
    _driverId = driverId;
    _date = date;
    _totalEarnings = totalEarnings;
    _totalHours = totalHours;
    _totalTrips = totalTrips;
}

  DailyEarningsMd.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _driverId = json['driver_id'];
    _date = json['date'];
    _totalEarnings = json['total_earnings'];
    _totalHours = json['total_hours'];
    _totalTrips = json['total_trips'];
  }
  bool? _status;
  dynamic _message;
  dynamic _driverId;
  dynamic _date;
  dynamic _totalEarnings;
  dynamic _totalHours;
  dynamic _totalTrips;
DailyEarningsMd copyWith({  bool? status,
  dynamic message,
  dynamic driverId,
  dynamic date,
  dynamic totalEarnings,
  dynamic totalHours,
  dynamic totalTrips,
}) => DailyEarningsMd(  status: status ?? _status,
  message: message ?? _message,
  driverId: driverId ?? _driverId,
  date: date ?? _date,
  totalEarnings: totalEarnings ?? _totalEarnings,
  totalHours: totalHours ?? _totalHours,
  totalTrips: totalTrips ?? _totalTrips,
);
  bool? get status => _status;
  dynamic get message => _message;
  dynamic get driverId => _driverId;
  dynamic get date => _date;
  dynamic get totalEarnings => _totalEarnings;
  dynamic get totalHours => _totalHours;
  dynamic get totalTrips => _totalTrips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['driver_id'] = _driverId;
    map['date'] = _date;
    map['total_earnings'] = _totalEarnings;
    map['total_hours'] = _totalHours;
    map['total_trips'] = _totalTrips;
    return map;
  }

}