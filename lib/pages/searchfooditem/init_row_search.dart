import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoFoodFound.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../detail&checkout/detail.dart';

class InitRowSearch extends StatefulWidget {
  const InitRowSearch({super.key, required this.searchItem});
  final String searchItem;
  @override
  State<InitRowSearch> createState() => _InitRowSearchState();
}

String _foodCollection = 'Food 🍔';
String _drinksCollection = 'Drinks 🍷';
String _groceryCollection = 'Grocery 🛒';
Future<List<FoodItem>> searchFoodItems(String _searchItem) async {
  if (_searchItem.isNotEmpty) {
    // Perform the queries concurrently
    final results = await Future.wait([
      FirebaseFirestore.instance
          .collection(_foodCollection)
          .where('foodName', isGreaterThanOrEqualTo: _searchItem.toLowerCase())
          .where('foodName', isLessThan: _searchItem.toLowerCase() + 'z')
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
    ]);

    // Extract the documents from the query snapshots
    final foodNameDocs = results[0].docs;
    final drinksFoodNameDocs = results[1].docs;
    final groceryFoodNameDocs = results[2].docs;

    // Combine the documents and remove duplicates
    final combinedDocs = [
      ...foodNameDocs,
      ...drinksFoodNameDocs,
      ...groceryFoodNameDocs,
    ].toSet().toList();

    // Map the combined documents to FoodItem objects
    final combinedResults = combinedDocs
        .map((doc) => FoodItem.fromMap(doc.data(), doc.id))
        .toList();

    return combinedResults;
  } else {
    return [];
  }
}

class _InitRowSearchState extends State<InitRowSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                future: searchFoodItems(widget.searchItem),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: NewSearchLoadingOutLook(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('An error occurred: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            noFoodFound(),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final foodItems = snapshot.data as List<FoodItem>;
                    return FutureBuilder<LatLng>(
                      future: Provider.of<LocationProvider>(context, listen: false).getPoints(),
                      builder: (context, locationSnapshot) {
                        if (locationSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: SingleChildScrollView(
                            child: Column(
                              children: [
                                NewSearchLoadingOutLook(),
                                NewSearchLoadingOutLook(),
                                NewSearchLoadingOutLook()
                              ],
                            ),
                          ));
                        } else if (locationSnapshot.hasError) {
                          return Center(child: Text('Error: ${locationSnapshot.error}'));
                        } else if (!locationSnapshot.hasData) {
                          return Center(child: Text('Unable to determine location'));
                        } else {
                          LatLng userLocation = LatLng(Provider.of<LocationProvider>(context, listen: false).Lat, Provider.of<LocationProvider>(context, listen: false).Long);
                          List<FoodItem> nearbyRestaurants = foodItems.where((foodItem) {
                            double distance = Provider.of<LocationProvider>(context, listen: false)
                                .calculateDistance(userLocation, LatLng(foodItem.latitude, foodItem.longitude));
                            return distance <= 10; // Check if the restaurant is within 10 km
                          }).toList();

                          return ListView.builder(
                            itemCount: nearbyRestaurants.length,
                            itemBuilder: (context, index) {
                              final foodItem = nearbyRestaurants[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedCard(
                                          paymentKey: foodItem.paymentKey,
                                          hasCourier: foodItem.hasCourier,
                                          productImageUrl: foodItem.ProductImageUrl,
                                          shopImageUrl: foodItem.shopImageUrl,
                                          restaurant: foodItem.restaurant,
                                          foodName: foodItem.foodName,
                                          price: foodItem.price,
                                          location: foodItem.location,
                                          vendorid: foodItem.vendorId,
                                          time: foodItem.time,
                                          latitude: foodItem.latitude,
                                          longitude: foodItem.longitude,
                                          adminEmail: foodItem.adminEmail,
                                          adminContact: foodItem.adminContact,
                                          maxDistance: foodItem.maxDistance,
                                          vendorAccount: foodItem.vendorAccount,
                                        ),
                                      ),
                                    );
                                  },
                                  child: NewVerticalCard(
                                    foodItem.ProductImageUrl,
                                    foodItem.restaurant,
                                    foodItem.foodName,
                                    foodItem.price,
                                    foodItem.location,
                                    foodItem.time,
                                    foodItem.vendorId.toString(),
                                    foodItem.isAvailable,
                                    foodItem.adminEmail,
                                    foodItem.adminContact,
                                    foodItem.maxDistance,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}