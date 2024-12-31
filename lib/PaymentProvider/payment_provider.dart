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
  Future<void> addMoneyToCourierAccount(context, String courierId,
      double amount, String receiver,) async {
    final CollectionReference couriersCollection = FirebaseFirestore.instance
        .collection('Couriers');

    try {
      // Get the document for the specified courier
      DocumentSnapshot courierDoc = await couriersCollection.doc(courierId)
          .get();

      if (courierDoc.exists) {
        // Get the current balance
        double currentBalance = (courierDoc['CourierAccountBalance'] ?? 0.0)
            .toDouble();

        // Calculate the new balance
        double newBalance = currentBalance + amount;

        // Update the document with the new balance
        await couriersCollection.doc(courierId).update(
            {'CourierAccountBalance': newBalance});

        Provider.of<NotificationProvider>(context, listen: false).sendSms(
            receiver, 'Order Completed \n'
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


  ///   ///THIS FUNCTION ADDS MONEY TO THE VENDOR ACCOUNT BALANCE
//   ///IT TAKES IN THE COURIER ID AND THE AMOUNT TO BE ADDED
//   ///IT UPDATES THE COURIER ACCOUNT BALANCE IN THE FIREBASE DATABASE
//   ///AND SENDS AN SMS TO THE VENDOR TO NOTIFY THEM OF THE TRANSACTION
//   ///THE SMS IS SENT USING THE SENDSMS FUNCTION FROM THE NOTIFICATION PROVIDER
//   ///THE FUNCTION RETURNS A FUTURE VOID

  Future<void> addMoneyToVendorAccount(BuildContext context, String vendorId,
      double amount, String receiver) async {
    final CollectionReference vendorsCollection = FirebaseFirestore.instance
        .collection('Vendors');

    try {
      // Get the document for the specified vendor
      DocumentSnapshot vendorDoc = await vendorsCollection.doc(vendorId).get();

      if (vendorDoc.exists) {
        // Get the current balance
        double currentBalance = (vendorDoc['vendorAccountBalance'] ?? 0.0)
            .toDouble();

        // Calculate the new balance
        double newBalance = currentBalance + amount;

        // Update the document with the new balance
        await vendorsCollection.doc(vendorId).update(
            {'vendorAccountBalance': newBalance});

        await Provider.of<NotificationProvider>(context, listen: false).sendSms(
            receiver, ' You have a new Order,'
            'Transaction Successful \n'
            'You have received GHC $amount in your MealMate Vendor account, from this Order,'
            'MealMate will take 15% of the total amount as commission,'
            'Your current balance is: \n GHC $newBalance');

        print('Money added to vendor account');
      } else {
        debugPrint('Vendor not found');
      }
    } catch (e) {
      print('Error updating account balance: $e');
    }
  }


  Future<void> addMoneyToVendorAccountCashOnDelivery(BuildContext context,
      String vendorId, double amount, String receiver) async {
    final CollectionReference vendorsCollection = FirebaseFirestore.instance
        .collection('Vendors');

    try {
      // Get the document for the specified vendor
      DocumentSnapshot vendorDoc = await vendorsCollection.doc(vendorId).get();

      if (vendorDoc.exists) {
        // Get the current balance
        double currentBalance = (vendorDoc['vendorAccountBalance'] ?? 0.0)
            .toDouble();

        // Calculate the new balance
        double newBalance = currentBalance + amount;

        // Update the document with the new balance
        await vendorsCollection.doc(vendorId).update(
            {'vendorAccountBalance': newBalance});

        await Provider.of<NotificationProvider>(context, listen: false).sendSms(
            receiver, ' You have a new Order,'
            'It is Cash on Delivery \n'
            'Therefore,money will be added to your MealMate Vendor account, but MealMate will take a commission of 10% , which will be '
            'deducted from total sales  \n'
            'Your current balance is: \n GHC $newBalance');

        print('Money added to vendor account');
      } else {
        debugPrint('Vendor not found');
      }
    } catch (e) {
      print('Error updating account balance: $e');
    }
  }

  ///REQUEST REFUND FUNCTION

  Future<void> requestRefund(BuildContext context, String vendorId, double amount, String userNumber, String vendorNumber) async {
    final CollectionReference vendorsCollection = FirebaseFirestore.instance
        .collection('Vendors');

    try {
      // Get the document for the specified vendor
      DocumentSnapshot vendorDoc = await vendorsCollection.doc(vendorId).get();

      if (vendorDoc.exists) {
        // Get the current balance
        double currentBalance = (vendorDoc['vendorAccountBalance'] ?? 0.0)
            .toDouble();

        // Calculate the new balance
        double newBalance = currentBalance - amount;

        // Update the document with the new balance
        await vendorsCollection.doc(vendorId).update(
            {'vendorAccountBalance': newBalance});

        await Provider.of<NotificationProvider>(context, listen: false).sendSms(
            userNumber, 'You have requested a refund,'
            'Transaction Pending \n'
            'MealMate will refund to your account in 24 hrs,'
        );

        await Provider.of<NotificationProvider>(context, listen: false).sendSms(
            vendorNumber, 'Rejected Order,\n'
            'Refunding rejected Order to Buyer \n'
            'MealMate will refund to buyers account \n'
            'Your current balance is: \n GHC ${newBalance.toStringAsFixed(2)}'
        );

        debugPrint('Money added to vendor account');
      } else {
        debugPrint('Vendor not found');
      }
    } catch (e) {
      print('Error updating account balance: $e');
    }
  }
}
