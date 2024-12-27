import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../Notification/notification_Provider.dart';

class PaymentProvider extends ChangeNotifier {


  ///THIS FUNCTION ADDS MONEY TO THE COURIER ACCOUNT BALANCE
  ///IT TAKES IN THE COURIER ID AND THE AMOUNT TO BE ADDED
  ///IT UPDATES THE COURIER ACCOUNT BALANCE IN THE FIREBASE DATABASE
  ///AND SENDS AN SMS TO THE COURIER TO NOTIFY THEM OF THE TRANSACTION
  ///THE SMS IS SENT USING THE SENDSMS FUNCTION FROM THE NOTIFICATION PROVIDER
  ///THE FUNCTION RETURNS A FUTURE VOID
  Future<void> addMoneyToCourierAccount(context, String courierId, double amount, String receiver, ) async {

    final CollectionReference couriersCollection = FirebaseFirestore.instance.collection('Couriers');

    try {
      // Get the document for the specified courier
      DocumentSnapshot courierDoc = await couriersCollection.doc(courierId).get();

      if (courierDoc.exists) {
        // Get the current balance
        double currentBalance = (courierDoc['CourierAccountBalance'] ?? 0.0).toDouble();

        // Calculate the new balance
        double newBalance = currentBalance + amount;

        // Update the document with the new balance
        await couriersCollection.doc(courierId).update({'CourierAccountBalance': newBalance});

        Provider.of<NotificationProvider>(context,listen: false).sendSms(receiver, 'Order Completed \n'
            'You have received GHC $amount in your MealMate account, '
            'Your Current balance is : \n GHC $newBalance');

        debugPrint('Money added to courier account');


      } else {
        debugPrint('Courier not found');
      }
    } catch (e) {
      print('Error updating account balance: $e');
    }
  }
}