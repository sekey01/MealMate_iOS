import 'package:flutter/foundation.dart';

class userCollectionProvider extends ChangeNotifier {
  /// This is the provider class for the collection upload page
  /// It is used to manage the state of the collection upload page
  /// So that the user can select the collection they want to upload to for easy search functionality in the user page
  /// So that the user can select the collection they want to see to for easy search functionality in the user page
  /// Here we have a list of collections that the admin can select from,
  /// I used the value of COLLECTIONTOUPLOAD to get the collection the admin selected AND USE IT TO UPLOAD THE COLLECTION TO FIREBASE
  String collectionToRead = 'Food 🍔';
  final List<String> collectionList = [
    'Drinks 🍷',
    'Food 🍔',
    'Grocery 🛒',
    'Clothing 👗',
    'Electronics 🚃',
    'Furniture 🪑',
  ];
  final List<String> collectionImageList = [
    'assets/Icon/Drinks.png',
    'assets/Icon/Foods.png',
    'assets/Icon/Grocery.png',
    'assets/Icon/Clothing.png',
    'assets/Icon/Electronics.png',
    'assets/Icon/Furniture.png',
  ];
  int selectedIndex = 0;

  void changeIndex(int index) {
    /// This function is used to change the index of the selected collection
    /// IN THE UI WHEN THE USER SELECTS A COLLECTION, THE INDEX OF THE SELECTED COLLECTION IS CHANGED
    /// WHEN THE INDEX IS CHANGED, THE COLLECTION TO READ IS ALSO CHANGED,
    /// SO THAT THE USER CAN READ THE SELECTED COLLECTION FROM FIREBASE(
    /// in the Upload funtion, I used the value of COLLECTIONTOREAD to get the collection the USER selected AND USE IT TO READ THE COLLECTION TO FIREBASE)
    selectedIndex = index;

    /// This is the collection the USER selected
    collectionToRead = collectionList[selectedIndex];

    if (kDebugMode) {
      print(collectionToRead);
    }
    notifyListeners();
  }

  //
  // Color unselectColor = Colors.white;
  // Color selectColor = Colors.deepOrangeAccent.shade200;
//
// void switchColor() {
//   if (unselectColor == Colors.white) {
//     unselectColor = Colors.deepOrangeAccent.shade200;
//     selectColor = Colors.white;
//   } else {
//     unselectColor = Colors.white;
//     selectColor = Colors.deepOrangeAccent.shade200;
//   }
//   notifyListeners();
// }
}
