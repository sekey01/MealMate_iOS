class CourierModel {
  final String CourierId;
  final double CourierLatitude;
  final double CourierLongitude;
  final String CourierGhanaCardPictureUrl;
  final String CourierPictureUrl;
  final String CourierName;
  final int CourierContact;
  final String CourierEmail;
  final String CourierVehicle;
  final String CourierVehicleNumber;
  final bool isCourierOnline;

  CourierModel({
    required this.CourierId,
    required this.CourierLatitude,
    required this.CourierLongitude,
    required this.CourierGhanaCardPictureUrl,
    required this.CourierPictureUrl,
    required this.CourierName,
    required this.CourierContact,
    required this.CourierEmail,
    required this.CourierVehicle,
    required this.CourierVehicleNumber,
    this.isCourierOnline = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'CourierId': CourierId,
      'CourierLatitude': CourierLatitude,
      'CourierLongitude': CourierLongitude,
      'CourierGhanaCardPictureUrl': CourierGhanaCardPictureUrl,
      'CourierPictureUrl': CourierPictureUrl,
      'CourierName': CourierName,
      'CourierContact': CourierContact,
      'CourierEmail': CourierEmail,
      'CourierVehicle': CourierVehicle,
      'CourierVehicleNumber': CourierVehicleNumber,
      'isCourierOnline': isCourierOnline,
    };
  }

  factory CourierModel.fromMap(Map<String, dynamic> data, String id) {
    return CourierModel(
      CourierId: data['CourierId'] ?? '',
      CourierLatitude: (data['CourierLatitude'] ?? 0.0).toDouble(),
      CourierLongitude: (data['CourierLongitude'] ?? 0.0).toDouble(),
      CourierGhanaCardPictureUrl: data['CourierGhanaCardPictureUrl'] ?? '',
      CourierPictureUrl: data['CourierPictureUrl'] ?? '',
      CourierName: data['CourierName'] ?? '',
      CourierContact: data['CourierContact'] ?? 0,
      CourierEmail: data['CourierEmail'] ?? '',
      CourierVehicle: data['CourierVehicle'] ?? '',
      CourierVehicleNumber: data['CourierVehicleNumber'] ?? '',
      isCourierOnline: data['isCourierOnline'] ?? false,
    );
  }
}