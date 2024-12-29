class VendorModel {
  final String shopImageUrl;
  final String VendorIdCard;
  final String shopName;
  final int vendorId;
  final String vendorAccount;
  final String vendorName;
  final String vendorEmail;
  final String vendorPhone;
  final String vendorAddress;
  final double vendorAccountBalance;

  VendorModel({
    required this.shopImageUrl,
    required this.VendorIdCard,
    required this.shopName,
    required this.vendorId,
    required this.vendorAccount,
    required this.vendorName,
    required this.vendorEmail,
    required this.vendorPhone,
    required this.vendorAddress,
    required this.vendorAccountBalance,
  });

  // Convert a VendorModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'shopImageUrl': shopImageUrl,
      'VendorIdCard': VendorIdCard,
      'shopName': shopName,
      'vendorId': vendorId,
      'vendorAccount': vendorAccount,
      'vendorName': vendorName,
      'vendorEmail': vendorEmail,
      'vendorPhone': vendorPhone,
      'vendorAddress': vendorAddress,
      'vendorAccountBalance': vendorAccountBalance,
    };
  }

  // Create a VendorModel from a Map
  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      shopImageUrl: map['shopImageUrl'] ?? '',
      VendorIdCard: map['VendorIdCard'] ?? '',
      shopName: map['shopName'] ?? '',
      vendorId: map['vendorId'] ?? 0,
      vendorAccount: map['vendorAccount'] ?? '',
      vendorName: map['vendorName'] ?? '',
      vendorEmail: map['vendorEmail'] ?? '',
      vendorPhone: map['vendorPhone'] ?? '',
      vendorAddress: map['vendorAddress'] ?? '',
      vendorAccountBalance: map['vendorAccountBalance'] ?? 0.0,
    );
  }
}