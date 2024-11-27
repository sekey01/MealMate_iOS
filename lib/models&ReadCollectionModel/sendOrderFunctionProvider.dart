import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'SendOrderModel.dart';

class SendOrderProvider extends ChangeNotifier {
  final String OrdersCollection = 'OrdersCollection';
  Future<void> sendOrder(OrderInfo x) async {
    try {
      await FirebaseFirestore.instance
          .collection(OrdersCollection)
          .add(x.toMap());
    } catch (e) {
      print('Error sending order: $e');
    }
  }
}
