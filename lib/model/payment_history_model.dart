class PaymentHistoryModel {
  dynamic id;
  dynamic driverId;
  dynamic transactionId;
  dynamic merchantId;
  dynamic merchantTransactionId;
  dynamic totalAmt;
  dynamic paymentType;
  dynamic code;
  dynamic response;
  dynamic paidStatus;
  dynamic message;
  dynamic createdAt;

  PaymentHistoryModel(
      {this.id,
        this.driverId,
        this.transactionId,
        this.merchantId,
        this.merchantTransactionId,
        this.totalAmt,
        this.paymentType,
        this.code,
        this.response,
        this.paidStatus,
        this.message,
        this.createdAt});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    transactionId = json['transaction_id'];
    merchantId = json['merchantId'];
    merchantTransactionId = json['merchantTransactionId'];
    totalAmt = json['total_amt'];
    paymentType = json['payment_type'];
    code = json['code'];
    response = json['response'];
    paidStatus = json['paid_status'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['transaction_id'] = this.transactionId;
    data['merchantId'] = this.merchantId;
    data['merchantTransactionId'] = this.merchantTransactionId;
    data['total_amt'] = this.totalAmt;
    data['payment_type'] = this.paymentType;
    data['code'] = this.code;
    data['response'] = this.response;
    data['paid_status'] = this.paidStatus;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}
