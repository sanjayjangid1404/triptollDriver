/// id : "650"
/// user_id : "338"
/// type : "driver"
/// wallet_amount : "5"
/// trn_type : "debit"
/// trn_id : null
/// payment_type : null
/// remark : "10% Amount of ORD-590 has been paid"
/// status : ""
/// payment_date : null
/// add_date : "2025-08-07 09:54:53"
/// update_date : "0000-00-00 00:00:00"

class WalletResponse {
  WalletResponse({
      dynamic id, 
      dynamic userId, 
      dynamic type, 
      dynamic walletAmount, 
      dynamic trnType, 
      dynamic trnId, 
      dynamic paymentType, 
      dynamic remark, 
      dynamic status, 
      dynamic paymentDate, 
      dynamic addDate, 
      dynamic updateDate,}){
    _id = id;
    _userId = userId;
    _type = type;
    _walletAmount = walletAmount;
    _trnType = trnType;
    _trnId = trnId;
    _paymentType = paymentType;
    _remark = remark;
    _status = status;
    _paymentDate = paymentDate;
    _addDate = addDate;
    _updateDate = updateDate;
}

  WalletResponse.fromJson(dynamic json) {
    if (json == null) return;
    _id = json['id']?.toString();
    _userId = json['user_id']?.toString();
    _type = json['type']?.toString();
    _walletAmount = json['wallet_amount']?.toString();
    _trnType = json['trn_type']?.toString();
    _trnId = json['trn_id'];
    _paymentType = json['payment_type'];
    _remark = json['remark']?.toString();
    _status = json['status']?.toString();
    _paymentDate = json['payment_date'];
    _addDate = json['add_date']?.toString();
    _updateDate = json['update_date']?.toString();
  }
  dynamic _id;
  dynamic _userId;
  dynamic _type;
  dynamic _walletAmount;
  dynamic _trnType;
  dynamic _trnId;
  dynamic _paymentType;
  dynamic _remark;
  dynamic _status;
  dynamic _paymentDate;
  dynamic _addDate;
  dynamic _updateDate;
WalletResponse copyWith({  dynamic id,
  dynamic userId,
  dynamic type,
  dynamic walletAmount,
  dynamic trnType,
  dynamic trnId,
  dynamic paymentType,
  dynamic remark,
  dynamic status,
  dynamic paymentDate,
  dynamic addDate,
  dynamic updateDate,
}) => WalletResponse(  id: id ?? _id,
  userId: userId ?? _userId,
  type: type ?? _type,
  walletAmount: walletAmount ?? _walletAmount,
  trnType: trnType ?? _trnType,
  trnId: trnId ?? _trnId,
  paymentType: paymentType ?? _paymentType,
  remark: remark ?? _remark,
  status: status ?? _status,
  paymentDate: paymentDate ?? _paymentDate,
  addDate: addDate ?? _addDate,
  updateDate: updateDate ?? _updateDate,
);
  dynamic get id => _id;
  dynamic get userId => _userId;
  dynamic get type => _type;
  dynamic get walletAmount => _walletAmount;
  dynamic get trnType => _trnType;
  dynamic get trnId => _trnId;
  dynamic get paymentType => _paymentType;
  dynamic get remark => _remark;
  dynamic get status => _status;
  dynamic get paymentDate => _paymentDate;
  dynamic get addDate => _addDate;
  dynamic get updateDate => _updateDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['type'] = _type;
    map['wallet_amount'] = _walletAmount;
    map['trn_type'] = _trnType;
    map['trn_id'] = _trnId;
    map['payment_type'] = _paymentType;
    map['remark'] = _remark;
    map['status'] = _status;
    map['payment_date'] = _paymentDate;
    map['add_date'] = _addDate;
    map['update_date'] = _updateDate;
    return map;
  }

}