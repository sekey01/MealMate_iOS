import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminCollectionProvider extends ChangeNotifier {
  /// This is the provider class for the collection upload page
  /// It is used to manage the state of the collection upload page
  /// So that the user can select the collection they want to upload to for easy search functionality in the user page
  /// So that the user can select the collection they want to see to for easy search functionality in the user page
  /// Here we have a list of collections that the admin can select from,
  /// I used the value of COLLECTIONTOUPLOAD to get the collection the admin selected AND USE IT TO UPLOAD THE COLLECTION TO FIREBASE
  String collectionToUpload = 'Food 🍔';
  final List<String> collectionList = [
    'Food 🍔',
    'Drinks 🍷',
    'Grocery 🛒',
    'Clothing 👗',
    'Electronics 🚃',
    'Furniture 🪑',
  ];
  int selectedIndex = 0;

  void changeIndex(int index) {
    /// This function is used to change the index of the selected collection
    /// IN THE UI WHEN THE ADMIN SELECTS A COLLECTION, THE INDEX OF THE SELECTED COLLECTION IS CHANGED
    /// WHEN THE INDEX IS CHANGED, THE COLLECTION TO UPLOAD IS ALSO CHANGED,
    /// SO THAT THE ADMIN CAN UPLOAD THE SELECTED COLLECTION TO FIREBASE(
    /// in the Upload funtion, I used the value of COLLECTIONTOUPLOAD to get the collection the admin selected AND USE IT TO UPLOAD THE COLLECTION TO FIREBASE)
    selectedIndex = index;

    /// This is the collection the admin selected
    collectionToUpload = collectionList[index];

    //String selectedCollection = collectionList[index];
    if (kDebugMode) {
      print(collectionToUpload);
    }
    notifyListeners();
  }

  Color unselectColor = Colors.white;
  Color selectColor = Colors.deepOrangeAccent.shade200;
  //
  // void switchColor() {
  //   if (unselectColor == Colors.white) {
  //     unselectColor = Colors.deepOrangeAccent


  //     selectColor = Colors.white;
  //   } else {
  //     unselectColor = Colors.white;
  //     selectColor = Colors.deepOrangeAccent.shade200;
  //   }
  //   notifyListeners();
  // }
}
