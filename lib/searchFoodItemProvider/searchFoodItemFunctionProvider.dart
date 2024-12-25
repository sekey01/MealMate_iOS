import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models&ReadCollectionModel/ListFoodItemModel.dart';

class SearchProvider extends ChangeNotifier {
  String _searchItem = '';
  String _foodCollection = 'Food ';
  String _drinksCollection = 'Drinks ';
  String _groceryCollection = 'Grocery ';
  String _snacksCollection = 'Snacks ';
  String _breakfastCollection = 'Breakfast ';
  String _othersCollection = 'Others ';
  // Default collection name

  set searchItem(String value) {
    _searchItem = value.toString();
    notifyListeners();
  }

  set collection(String value) {
    _foodCollection = value;
    notifyListeners();
  }

  Future<List<FoodItem>> searchFoodItems() async {
    if (_searchItem.isNotEmpty) {
      // Perform the two queries concurrently
      final results = await Future.wait([
        FirebaseFirestore.instance
            .collection(_foodCollection)
            .where('foodName', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('foodName', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
        FirebaseFirestore.instance
            .collection(_foodCollection)
            .where('restaurant', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('restaurant', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
        FirebaseFirestore.instance
            .collection(_drinksCollection)
            .where('foodName', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('foodName', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
        FirebaseFirestore.instance
            .collection(_groceryCollection)
            .where('foodName', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('foodName', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
        FirebaseFirestore.instance
            .collection(_groceryCollection)
            .where('restaurant', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('restaurant', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
        FirebaseFirestore.instance
            .collection(_snacksCollection)
            .where('foodName', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('foodName', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
        FirebaseFirestore.instance
            .collection(_breakfastCollection)
            .where('foodName', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('foodName', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
        FirebaseFirestore.instance
            .collection(_othersCollection)
            .where('foodName', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
            .where('foodName', isLessThan: _searchItem.toLowerCase() + 'z')
            .get(),
      ]);

      // Extract the documents from both query snapshots
      final foodNameDocs = results[0].docs;
      final restaurantDocs = results[1].docs;
      final groceryDocs = results[2].docs;
      final drinksDocs = results[3].docs;
      final snacksDocs = results[4].docs;
      final breakfastDocs = results[5].docs;
      final othersDocs = results[6].docs;

      // Combine the documents and remove duplicates
      final combinedDocs =
          [...foodNameDocs, ...restaurantDocs, ...groceryDocs, ...breakfastDocs,...snacksDocs, ...othersDocs, ...drinksDocs].toSet().toList();

      // Map the combined documents to FoodItem objects
      final combinedResults = combinedDocs
          .map((doc) =>
              FoodItem.fromMap(doc.data(), doc.id))
          .toList();

      // For debugging
     // print('Search results: ${combinedResults.length} items found');
      for (final foodItem in combinedResults) {
        print(foodItem.foodName);
      }

      return combinedResults;
    } else {
      return [];
    }
  }
}
