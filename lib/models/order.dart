class Order {
  String userName;
  String serviceId;
  String serviceProviderId;
  String userId;
  String warehouseId;
  String address;
  String location;
  String latitude;
  String longitude;
  String unit;
  String category;
  String type;
  String userNumber;
  String amount;
  String quantity;
  String timeStamp;
  String serviceName;
  String productName;
  String imageUrl;
  String email;
  String productId;
  String orderId;
  String status;
  String deliveryDate;
  Order({
    this.productName,
    this.status,
    this.orderId,
    this.address,
    this.amount,
    this.category,
    this.email,
    this.imageUrl,
    this.latitude,
    this.location,
    this.longitude,
    this.quantity,
    this.serviceId,
    this.productId,
    this.serviceName,
    this.serviceProviderId,
    this.timeStamp,
    this.type,
    this.unit,
    this.userId,
    this.userName,
    this.userNumber,
    this.warehouseId,
    this.deliveryDate,
  });
}
