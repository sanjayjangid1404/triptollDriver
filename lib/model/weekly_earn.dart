/// status : true
/// message : "Date range earnings and stats retrieved successfully"
/// driver_id : "338"
/// start_date : "2025-09-20"
/// end_date : "2025-09-26"
/// total_earnings : "29346.56"
/// total_hours : "1.30"
/// total_trips : 51

class WeeklyEarn {
  WeeklyEarn({
      bool? status, 
      dynamic message, 
      dynamic driverId, 
      dynamic startDate, 
      dynamic endDate, 
      dynamic totalEarnings, 
      dynamic totalHours, 
      dynamic totalTrips,}){
    _status = status;
    _message = message;
    _driverId = driverId;
    _startDate = startDate;
    _endDate = endDate;
    _totalEarnings = totalEarnings;
    _totalHours = totalHours;
    _totalTrips = totalTrips;
}

  WeeklyEarn.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _driverId = json['driver_id'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _totalEarnings = json['total_earnings'];
    _totalHours = json['total_hours'];
    _totalTrips = json['total_trips'];
  }
  bool? _status;
  dynamic _message;
  dynamic _driverId;
  dynamic _startDate;
  dynamic _endDate;
  dynamic _totalEarnings;
  dynamic _totalHours;
  dynamic _totalTrips;
WeeklyEarn copyWith({  bool? status,
  dynamic message,
  dynamic driverId,
  dynamic startDate,
  dynamic endDate,
  dynamic totalEarnings,
  dynamic totalHours,
  dynamic totalTrips,
}) => WeeklyEarn(  status: status ?? _status,
  message: message ?? _message,
  driverId: driverId ?? _driverId,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  totalEarnings: totalEarnings ?? _totalEarnings,
  totalHours: totalHours ?? _totalHours,
  totalTrips: totalTrips ?? _totalTrips,
);
  bool? get status => _status;
  dynamic get message => _message;
  dynamic get driverId => _driverId;
  dynamic get startDate => _startDate;
  dynamic get endDate => _endDate;
  dynamic get totalEarnings => _totalEarnings;
  dynamic get totalHours => _totalHours;
  dynamic get totalTrips => _totalTrips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['driver_id'] = _driverId;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['total_earnings'] = _totalEarnings;
    map['total_hours'] = _totalHours;
    map['total_trips'] = _totalTrips;
    return map;
  }

}