class BookingListResponse {
  bool? status;
  List<BookingListResponseData>? data;

  BookingListResponse({this.status, this.data});

  BookingListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <BookingListResponseData>[];
      json['data'].forEach((v) {
        data!.add(new BookingListResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingListResponseData {
  dynamic id;
  dynamic orderId;
  dynamic cusId;
  dynamic driverId;
  dynamic categoryId;
  dynamic rate;
  dynamic amount;
  dynamic totalAmount;
  dynamic bookingDate;
  dynamic orderStatus;
  dynamic acceptTime;
  dynamic closeTime;
  dynamic paymentType;
  dynamic trnId;
  dynamic startTrip;
  dynamic addDate;
  dynamic distance;
  Pickup? pickup;
  List<Dropoffs>? dropoffs;

  BookingListResponseData(
      {this.id,
        this.orderId,
        this.cusId,
        this.driverId,
        this.categoryId,
        this.rate,
        this.amount,
        this.totalAmount,
        this.bookingDate,
        this.orderStatus,
        this.acceptTime,
        this.closeTime,
        this.paymentType,
        this.distance,
        this.trnId,
        this.startTrip,
        this.addDate,
        this.pickup,
        this.dropoffs});

  BookingListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    cusId = json['cus_id'];
    driverId = json['driver_id'];
    categoryId = json['category_id'];
    rate = json['rate'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    bookingDate = json['booking_date'];
    orderStatus = json['order_status'];
    acceptTime = json['accept_time'];
    distance = json['distance'];
    closeTime = json['close_time'];
    paymentType = json['payment_type'];
    trnId = json['trn_id'];
    startTrip = json['start_trip'];
    addDate = json['add_date'];
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    if (json['dropoffs'] != null) {
      dropoffs = <Dropoffs>[];
      json['dropoffs'].forEach((v) {
        dropoffs!.add(new Dropoffs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['cus_id'] = this.cusId;
    data['driver_id'] = this.driverId;
    data['category_id'] = this.categoryId;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['distance'] = this.distance;
    data['total_amount'] = this.totalAmount;
    data['booking_date'] = this.bookingDate;
    data['order_status'] = this.orderStatus;
    data['accept_time'] = this.acceptTime;
    data['close_time'] = this.closeTime;
    data['payment_type'] = this.paymentType;
    data['trn_id'] = this.trnId;
    data['start_trip'] = this.startTrip;
    data['add_date'] = this.addDate;
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.dropoffs != null) {
      data['dropoffs'] = this.dropoffs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pickup {
  dynamic locationId;
  dynamic address;
  dynamic lat;
  dynamic lng;
  dynamic distanceToNext;
  dynamic expectedTimeToNext;
  dynamic completionTime;
  dynamic loadingDuration;
  dynamic loadingTime;
  dynamic loadingCharge;

  Pickup(
      {this.locationId,
        this.address,
        this.lat,
        this.lng,
        this.distanceToNext,
        this.expectedTimeToNext,
        this.completionTime,
        this.loadingDuration,
        this.loadingTime,
        this.loadingCharge});

  Pickup.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    distanceToNext = json['distance_to_next'];
    expectedTimeToNext = json['expected_time_to_next'];
    completionTime = json['completion_time'];
    loadingDuration = json['loading_duration'];
    loadingTime = json['loading_time'];
    loadingCharge = json['loading_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['distance_to_next'] = this.distanceToNext;
    data['expected_time_to_next'] = this.expectedTimeToNext;
    data['completion_time'] = this.completionTime;
    data['loading_duration'] = this.loadingDuration;
    data['loading_time'] = this.loadingTime;
    data['loading_charge'] = this.loadingCharge;
    return data;
  }
}

class Dropoffs {
  dynamic locationId;
  dynamic address;
  dynamic lat;
  dynamic lng;
  dynamic name;
  dynamic contactNumber;
  dynamic sequence;
  dynamic distanceToNext;
  dynamic expectedTimeToNext;
  dynamic completionTime;
  dynamic unloadingDuration;
  dynamic unloadingTime;
  dynamic unloadingCharge;

  Dropoffs(
      {this.locationId,
        this.address,
        this.lat,
        this.lng,
        this.name,
        this.contactNumber,
        this.sequence,
        this.distanceToNext,
        this.expectedTimeToNext,
        this.completionTime,
        this.unloadingDuration,
        this.unloadingTime,
        this.unloadingCharge});

  Dropoffs.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    name = json['name'];
    contactNumber = json['contact_number'];
    sequence = json['sequence'];
    distanceToNext = json['distance_to_next'];
    expectedTimeToNext = json['expected_time_to_next'];
    completionTime = json['completion_time'];
    unloadingDuration = json['unloading_duration'];
    unloadingTime = json['unloading_time'];
    unloadingCharge = json['unloading_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['sequence'] = this.sequence;
    data['distance_to_next'] = this.distanceToNext;
    data['expected_time_to_next'] = this.expectedTimeToNext;
    data['completion_time'] = this.completionTime;
    data['unloading_duration'] = this.unloadingDuration;
    data['unloading_time'] = this.unloadingTime;
    data['unloading_charge'] = this.unloadingCharge;
    return data;
  }
}
