import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate_ios/components/Notify.dart';
import 'package:provider/provider.dart';

import '../collectionUploadModelProvider/collectionProvider.dart';

class AdminFunctions extends ChangeNotifier {
  ///THIS FUNCTION DELETES THE ITEM FROM THE COLLECTION
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

      //  print('isOnline Updated successfully');
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
      // print('Error deleting document(s): $e');
    }
  }

  ///SWITCH ALL FOOD ITEMS WITH THE SAME VENDOR ID TO ONLINE OR OFFLINE
  List<String> collections = ['Food', 'Drinks', 'Grocery', 'Snacks', 'Electronics', 'Others'];

  Future<void> SwitchAllState(BuildContext context, String id, bool isActive) async {
    for (String collection in collections) {
      final CollectionReference collectionRef = FirebaseFirestore.instance.collection(collection);
      print('Collection: $collection');

      try {
        // Query the collection for documents where 'vendorId' field matches id
        final QuerySnapshot snapshot = await collectionRef.where('vendorId', isEqualTo: id).get();
      print('Snapshot: ${snapshot.docs}');
        // Iterate through each document and update it
        for (var doc in snapshot.docs) {
          await doc.reference.update({'isActive': isActive});
        }

      } catch (e) {
        print('Error deleting document(s): $e');
      }
    }
  }












  ///THIS FUNCTION TOGGLES THE ADMINS ALL PRODUCTS ONLINE AND OFFLINE STATE
  ///BASE ON THE SELECTED COLLECTION

  Future<void> SwitchOnline(BuildContext context, String id, bool isActive) async {
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

  Future<void> SwitchSingleFoodItem(BuildContext context, String id, String imgUrl, bool isActive) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');

    try {
      // Query the collection for documents where 'vendorId' and 'imageUrl' fields match
      final QuerySnapshot snapshot = await collectionRef
          .where('vendorId', isEqualTo: id)
          .where('ProductImageUrl', isEqualTo: imgUrl)
          .limit(1)
          .get();

      // Check if any documents were found
      if (snapshot.docs.isNotEmpty) {
        // Update the first matching document
        await snapshot.docs.first.reference.update({'isActive': isActive});

        print('Document updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 20,
          content: Center(
            child: Text(
              isActive ? 'Item is Online Now ...' : 'Item is Offline Now',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: isActive ? Colors.green : Colors.red,
        ));
      } else {
        print('No matching document found');
      }
    } catch (e) {
      print('Error updating document: $e');
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
       // print('No matching documents found');
        return;
      }

      // Update each matching document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'served': isServed});
      }

     // print('isServed updated successfully');
    } catch (e) {
     // print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }



  /// THIS FUNCTION FINDS THE RIGHT ORDER IN THE ORDERS COLLECTION AND
  /// UPDATE  THE COURIER ID,
  /// IN THE USER PAGE , A FUNCTION IS THERE TO GET THE COURIER ID AND USE THE THE ID TO GET THE COURIER DETAILS
  /// IN THE COURIERS COLLECTION
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
       // print('No matching documents found');
        return;
      }

      // Update each matching document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'CourierId': CourierId});
      }

     // print('isCourier updated successfully');
    } catch (e) {
    //  print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }


  Future<void> switchIsGivenToCourierState(BuildContext context, String id, String phoneNumber, bool isCourier, DateTime time) async {
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

  Future<void>RejectOrder(BuildContext context, String id, String phoneNumber) async {
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
        await doc.reference.update({'isRejected': true});
      }
      Notify(context, 'Order Rejected', Colors.red);

      print('isRejected updated successfully');
    } catch (e) {
      print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }


}