class OrderInfo {
  final String vendorId;
  final String foodName;
  final double price;
  final String phoneNumber;
  final double Latitude;
  final double Longitude;
  final int quantity;
  final String message;
  final DateTime time;
  final bool delivered;
  final bool courier;
  final int CourierId;
  final String CourierName;
  final String CourierContact;
  final bool served;
  final String adminEmail;
  final int adminContact;
  final String VendorAccount ;
  final bool isCashOnDelivery;



  OrderInfo({
    required this.vendorId,
    required this.foodName,
    required this.price,
    required this.phoneNumber,
    required this.Latitude,
    required this.Longitude,
    required this.quantity,
    required this.message,
    required this.time,
    required this.served,
    required this.courier,
    required this.CourierId,
    required this.CourierName,
    required this.CourierContact,
    required this.delivered,
    required this.adminEmail,
    required  this.adminContact,
    required this.VendorAccount,
    required this.isCashOnDelivery,

  });

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'foodName': foodName,
      'price': price,
      'phoneNumber': phoneNumber,
      'Latitude': Latitude,
      'Longitude': Longitude,
      'quantity': quantity,
      'others': message, // 'others' is a new field that was added to the OrderInfo model
      'time': time,
      'served': served,
      'courier' : courier,
      'delivered': delivered,
      'adminEmail': adminEmail,
      'adminContact': adminContact,
      'CourierId': CourierId,
      'CourierName': CourierName,
      'CourierContact': CourierContact,
      'VendorAccount': VendorAccount,
      'isCashOnDelivery': isCashOnDelivery,

    };
  }

  factory OrderInfo.fromMap(Map<String, dynamic> data, String id) {
    return OrderInfo(
      vendorId: data['vendorId'],
      foodName: data['foodName'],
      price: data['price'],
      phoneNumber: data['phoneNumber'],
      Latitude: data['Latitude'],
      Longitude: data['Longitude'],
      quantity: data['quantity'],
      message: data['others'],
      time: data['time'].toDate(),
      served: data['served']?? false,
      courier: data['courier']?? false,
      CourierId: data['CourierId']?? '',
      CourierName: data['CourierName']?? '',
      CourierContact: data['CourierContact']?? '',
      delivered: data['delivered']?? false,
      adminEmail:  data['adminEmail']?? '',
        adminContact: data['adminContact'] ?? '',
      VendorAccount: data['VendorAccount']?? '',
      isCashOnDelivery: data['isCashOnDelivery']?? false,
    );
  }
}
