import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../collectionUploadModelProvider/collectionProvider.dart';

class AdminFunctions extends ChangeNotifier {
  Future<void> deleteItem(BuildContext context, String imgUrl) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');

    try {
      // Query the collection for documents where 'imageUrl' field matches imgUrl
      final QuerySnapshot snapshot =
      await collectionRef.where('imageUrl', isEqualTo: imgUrl).get();

      // Iterate through each document and delete it
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print('isOnline Updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        content: Center(
          child: Text(
            'Item Successfully Deleted...',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print('Error deleting document(s): $e');
    }
  }


  ///THIS FUNCTION TOGGLES THE ADMINS ALL PRODUCTS ONLINE AND OFFLINE

  Future<void> SwitchOnline(BuildContext context, int id, bool isActive) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');

    try {
      // Query the collection for documents where 'imageUrl' field matches imgUrl
      final QuerySnapshot snapshot =
      await collectionRef.where('vendorId', isEqualTo: id).get();

      // Iterate through each document and update it
      for (var doc in snapshot.docs) {
        await doc.reference.update({'isActive': isActive});
      }

      print('Document(s) Updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        content: Center(
          child: Text(
            isActive ? 'You\'re Online Now ...' : 'You\'re Offline Now',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: isActive ? Colors.green : Colors.red,
      ));
    } catch (e) {
      print('Error deleting document(s): $e');
    }
  }


  /// THIS FUNCTION SWITCH THE SERVED TO TRUE

  Future<void> switchServedFood(BuildContext context, String id, String phoneNumber, bool isServed) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('OrdersCollection');

    try {
      // First, get the documents that match the criteria
      QuerySnapshot querySnapshot = await collectionRef
          .where('vendorId', isEqualTo: id)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .where('delivered',isEqualTo: false)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        print('No matching documents found');
        return;
      }

      // Update each matching document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'served': isServed});
      }

      print('isServed updated successfully');
    } catch (e) {
      print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }

  Future<void> UpdateCourier(BuildContext context, String id, String phoneNumber, int CourierId,) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('OrdersCollection');

    try {
      // First, get the documents that match the criteria
      QuerySnapshot querySnapshot = await collectionRef
          .where('vendorId', isEqualTo: id)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .where('delivered', isEqualTo: false)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        print('No matching documents found');
        return;
      }

      // Update each matching document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'CourierId': CourierId});
      }

      print('isCourier updated successfully');
    } catch (e) {
      print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }


  Future<void> switchCourier(BuildContext context, String id, String phoneNumber, bool isCourier, DateTime time) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('OrdersCollection');

    try {
      // First, get the documents that match the criteria
      QuerySnapshot querySnapshot = await collectionRef
          .where('vendorId', isEqualTo: id)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .where('delivered',isEqualTo: false)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        print('No matching documents found');
        return;
      }

      // Update each matching document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'courier': isCourier});
      }

      print('isCourier updated successfully');
    } catch (e) {
      print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }

/*///BELLOW IS THE FUNCTION TO FREQUENTLY UPDATE THE ADMIN ON INCOMING ORDERS
///
  Future<List<OrderInfo>> IncomingOrders(String collection) async {
    int retryCount = 3;
    int attempt = 0;
    while (attempt < retryCount) {
      try {
        QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
        return snapshot.docs.map((doc) => OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      } on SocketException catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          print("Internet Problem: $e");
          return [];
        }
        await Future.delayed(Duration(seconds: 2)); // wait before retrying
      } catch (e) {
        print("Error fetching food items: $e");
        return [];
      }
    }
    return [];
  }
  */
}