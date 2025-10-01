/// status : true
/// message : "Inactive balance retrieved successfully."
/// data : {"driver_id":"338","total_inactive_balance":0}

class InactiveWalletModel {
  InactiveWalletModel({
      bool? status, 
      dynamic message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  InactiveWalletModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  dynamic _message;
  Data? _data;
InactiveWalletModel copyWith({  bool? status,
  dynamic message,
  Data? data,
}) => InactiveWalletModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  dynamic get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// driver_id : "338"
/// total_inactive_balance : 0

class Data {
  Data({
      dynamic driverId, 
      dynamic totalInactiveBalance,}){
    _driverId = driverId;
    _totalInactiveBalance = totalInactiveBalance;
}

  Data.fromJson(dynamic json) {
    _driverId = json['driver_id'];
    _totalInactiveBalance = json['total_inactive_balance'];
  }
  dynamic _driverId;
  dynamic _totalInactiveBalance;
Data copyWith({  dynamic driverId,
  dynamic totalInactiveBalance,
}) => Data(  driverId: driverId ?? _driverId,
  totalInactiveBalance: totalInactiveBalance ?? _totalInactiveBalance,
);
  dynamic get driverId => _driverId;
  dynamic get totalInactiveBalance => _totalInactiveBalance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['driver_id'] = _driverId;
    map['total_inactive_balance'] = _totalInactiveBalance;
    return map;
  }

}