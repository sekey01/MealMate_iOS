import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../PaymentProvider/payment_provider.dart';
import 'SendOrderModel.dart';

class SendOrderProvider extends ChangeNotifier {
  final String OrdersCollection = 'OrdersCollection';
  Future<void> sendOrder(context, OrderInfo order,bool isCashOnDelivery, String vendorId, double price, String contact) async {
    try {
      await FirebaseFirestore.instance
          .collection(OrdersCollection)
          .add(order.toMap());
      ///ADD MONEY TO VENDOR ACCOUNT
      if(isCashOnDelivery){
        await Provider.of<PaymentProvider>(context,listen: false).addMoneyToVendorAccountCashOnDelivery(context,vendorId, price, '${contact}');
      }

      else{
        await   Provider.of<PaymentProvider>(context,listen: false).addMoneyToVendorAccount(context,vendorId, price, '${contact}');
      }


    } catch (e) {
      print('Error sending order: $e');
    }
  }
}