import 'package:google_maps_flutter/google_maps_flutter.dart';

class UploadModel {
  final String ProductImageUrl;
  final String shopImageUrl;
  final String restaurant;
  final String paymentKey;
  final String foodName;
  final double price;
  final String location;
  final String time;
  final String vendorId;
  final bool isAvailable;
  final double latitude;
  final double longitude;
  final String adminEmail;
  final int adminContact;
  final int maxDistance;
  final bool hasCourier;


  UploadModel({
  required this.ProductImageUrl,
    required this.shopImageUrl,
    required this.paymentKey,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.vendorId,
    required this.location,
    required this.time,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
    required this.adminEmail,
    required this.adminContact,
    required this.maxDistance,
    required this.hasCourier,


  });

  Map<String, dynamic> toMap() {
    return {
      'ProductImageUrl': ProductImageUrl,
      'shopImageUrl': shopImageUrl,
      'paymentKey': paymentKey,
      'restaurant': restaurant,
      'foodName': foodName,
      'price': price,
      'location': location,
      'time': time,
      'vendorId': vendorId,
      'isActive': isAvailable,
      'latitude' : latitude?? 0,
      'longitude': longitude?? 0,
      'adminEmail': adminEmail ?? '',
      'adminContact': adminContact?? '',
      'maxDistance': maxDistance?? 0,
      'hasCourier': hasCourier?? false,
    };
  }
}
