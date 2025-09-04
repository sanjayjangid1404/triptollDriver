class MissedOrderListModel {
  dynamic id;
  dynamic driverId;
  dynamic bookingId;
  dynamic bId;
  dynamic bookedDriver;
  dynamic orderId;
  dynamic cusId;
  dynamic firstName;
  dynamic lastName;
  dynamic totalAmount;
  dynamic distance;
  dynamic expectedTime;
  dynamic categoryId;
  dynamic bookingDate;
  dynamic orderStatus;

  MissedOrderListModel(
      {this.id,
        this.driverId,
        this.bookingId,
        this.bId,
        this.bookedDriver,
        this.orderId,
        this.cusId,
        this.firstName,
        this.lastName,
        this.totalAmount,
        this.distance,
        this.expectedTime,
        this.categoryId,
        this.bookingDate,
        this.orderStatus});

  MissedOrderListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    bookingId = json['booking_id'];
    bId = json['b_id'];
    bookedDriver = json['booked_driver'];
    orderId = json['order_id'];
    cusId = json['cus_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    totalAmount = json['total_amount'];
    distance = json['distance'];
    expectedTime = json['expected_time'];
    categoryId = json['category_id'];
    bookingDate = json['booking_date'];
    orderStatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['booking_id'] = this.bookingId;
    data['b_id'] = this.bId;
    data['booked_driver'] = this.bookedDriver;
    data['order_id'] = this.orderId;
    data['cus_id'] = this.cusId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['total_amount'] = this.totalAmount;
    data['distance'] = this.distance;
    data['expected_time'] = this.expectedTime;
    data['category_id'] = this.categoryId;
    data['booking_date'] = this.bookingDate;
    data['order_status'] = this.orderStatus;
    return data;
  }
}
