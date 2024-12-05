import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoFoodFound.dart';
import '../../components/Notify.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../detail&checkout/detail.dart';

class InitPageSearch extends StatefulWidget {
  const InitPageSearch({super.key, required this.searchCollection, required this.Title});
  final String Title ;
final String searchCollection;
  @override
  State<InitPageSearch> createState() => _InitPageSearchState();
}

class _InitPageSearchState extends State<InitPageSearch> {

  Future<List<FoodItem>> fetchFoodItems(String collection) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collection).get();
      return snapshot.docs.map((doc) => FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      print("Error fetching food items: $e");
      return [];
    }
  }
/*
  void checkInternet() async {
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status != InternetStatus.connected) {
        setState(() {
          //_hasInternet = false;
          NoInternetNotify(context, 'Check Internet Connection', Colors.red);
        });
      }
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.spMin,
            color: Colors.blueGrey,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(widget.Title),
        titleTextStyle: TextStyle(
          fontFamily: 'Righteous',
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 20.sp),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: fetchFoodItems(widget.searchCollection),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: NewSearchLoadingOutLook(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/Icon/route.png'),height: 50.h,width: 70.w,),
                        Text(' ${snapshot.error}', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
                        Text('Enable Location in your Settings',style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),)
                      ],
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: noFoodFound(),
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
                          LatLng userLocation = locationSnapshot.data!;
                          List<FoodItem> nearbyRestaurants = foodItems.where((foodItem) {
                            double distance = Provider.of<LocationProvider>(context, listen: false)
                                .calculateDistance(userLocation, LatLng(foodItem.latitude, foodItem.longitude));
                            return distance <= Provider.of<LocationProvider>(context,listen: false).distanceRangeToSearch; // Check if the restaurant is within 10 km
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
