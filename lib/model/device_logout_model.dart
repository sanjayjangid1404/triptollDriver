/// status : true
/// is_valid : true
/// current_device_token : "RKQ1.211119.001"

class DeviceLogoutModel {
  DeviceLogoutModel({
      bool? status, 
      bool? isValid, 
      dynamic currentDeviceToken,}){
    _status = status;
    _isValid = isValid;
    _currentDeviceToken = currentDeviceToken;
}

  DeviceLogoutModel.fromJson(dynamic json) {
    _status = json['status'];
    _isValid = json['is_valid'];
    _currentDeviceToken = json['current_device_token'];
  }
  bool? _status;
  bool? _isValid;
  dynamic _currentDeviceToken;
DeviceLogoutModel copyWith({  bool? status,
  bool? isValid,
  dynamic currentDeviceToken,
}) => DeviceLogoutModel(  status: status ?? _status,
  isValid: isValid ?? _isValid,
  currentDeviceToken: currentDeviceToken ?? _currentDeviceToken,
);
  bool? get status => _status;
  bool? get isValid => _isValid;
  dynamic get currentDeviceToken => _currentDeviceToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['is_valid'] = _isValid;
    map['current_device_token'] = _currentDeviceToken;
    return map;
  }

}