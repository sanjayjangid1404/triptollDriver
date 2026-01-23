class GetScheduledOrderModel {
  bool? status;
  dynamic message;
  List<Data>? data;

  GetScheduledOrderModel({this.status, this.message, this.data});

  GetScheduledOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic orderId;
  dynamic orderStatus;
  dynamic scheduleDate;
  dynamic scheduleTime;
  dynamic totalAmount;
  dynamic firstName;
  dynamic lastName;
  dynamic contactNumber;
  dynamic pickupAddress;
  dynamic lat;
  dynamic lng;

  Data(
      {this.id,
        this.orderId,
        this.orderStatus,
        this.scheduleDate,
        this.scheduleTime,
        this.totalAmount,
        this.firstName,
        this.lastName,
        this.contactNumber,
        this.pickupAddress,
        this.lat,
        this.lng});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    scheduleDate = json['schedule_date'];
    scheduleTime = json['schedule_time'];
    totalAmount = json['total_amount'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    contactNumber = json['contact_number'];
    pickupAddress = json['pickup_address'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['order_status'] = this.orderStatus;
    data['schedule_date'] = this.scheduleDate;
    data['schedule_time'] = this.scheduleTime;
    data['total_amount'] = this.totalAmount;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['contact_number'] = this.contactNumber;
    data['pickup_address'] = this.pickupAddress;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
