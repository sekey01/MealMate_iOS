import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentProvider extends ChangeNotifier {
  /// Mobile Money Payment
  Future<void> payWithMobileMoney(String phoneNumber, double amount) async {
    final url = Uri.parse('https://api.mobilemoneyprovider.com/pay');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_API_KEY',
    };
    final body = jsonEncode({
      'phoneNumber': phoneNumber,
      'amount': amount,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // Payment successful
        print('Payment successful');
      } else {
        // Handle error
        print('Payment failed: ${response.body}');
      }
    } catch (e) {
      // Handle network error
      print('Network error: $e');
    }
  }
}