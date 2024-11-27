import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoInternet.dart';
import '../../components/Notify.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../components/userCollectionshow.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../models&ReadCollectionModel/userReadwithCollection.dart';
import '../detail&checkout/detail.dart';
import '../searchfooditem/searchFoodItem.dart';
import 'order.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    //checkInternet();
  }

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
          _hasInternet = false;
          NoInternetNotify(context, 'Check Internet Connection', Colors.red);
        });
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Search'),
        titleTextStyle: TextStyle(
          fontFamily: 'Righteous',
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          fontSize: 20.spMin,
        ),
        backgroundColor: Colors.white,
        actions: [
          SizedBox(width: 20.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchFoodItem()));
                },
                icon: ImageIcon(
                  const AssetImage('assets/Icon/Search.png'),
                  color: Colors.black,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 20.w),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderList()));
                },
                icon: ImageIcon(
                  const AssetImage('assets/Icon/Order.png'),
                  color: Colors.black,
                  size: 20.w,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              height: 70.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Consumer<userCollectionProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.collectionList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          value.changeIndex(index);
                          setState(() {});
                        },
                        child: userCollectionItemsRow(
                          value.collectionList[index],
                          value.collectionImageList[index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          _hasInternet
              ? Expanded(
            child: FutureBuilder<List<FoodItem>>(
              future: fetchFoodItems(
                Provider.of<userCollectionProvider>(context, listen: false).collectionToRead,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: NewSearchLoadingOutLook(),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              EmptyCollection(),
                              EmptyCollection(),
                              EmptyCollection(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return FutureBuilder<LatLng>(
                    future: Provider.of<LocationProvider>(context, listen: false).getPoints(),
                    builder: (context, locationSnapshot) {
                      if (locationSnapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: SizedBox(

                                height: 1000,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      NewSearchLoadingOutLook(),
                                      NewSearchLoadingOutLook(),
                                      NewSearchLoadingOutLook(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (locationSnapshot.hasError) {
                        return Center(child: Text('Error: ${locationSnapshot.error}'));
                      } else if (!locationSnapshot.hasData) {
                        return const Center(child: SingleChildScrollView(
                          child: Column(
                            children: [
                              NewSearchLoadingOutLook(),
                              NewSearchLoadingOutLook(),
                              NewSearchLoadingOutLook(),
                            ],
                          ),
                        ),);
                      } else {
                        LatLng userLocation = locationSnapshot.data!;
                        List<FoodItem> nearbyRestaurants = snapshot.data!.where((foodItem) {
                          double distance = Provider.of<LocationProvider>(context, listen: false)
                              .calculateDistance(userLocation, LatLng(foodItem.latitude, foodItem.longitude));
                          return distance <= Provider.of<LocationProvider>(context,listen: false).distanceRangeToSearch; // Check if the restaurant is within 10 km
                        }).toList();
                        return MasonryGridView.count(
                          itemCount: nearbyRestaurants.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 3,
                          itemBuilder: (context, index) {
                            final data = nearbyRestaurants[index];
                            return GestureDetector(
                              onTap: () {
                                data.isAvailable
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailedCard(
                                      paymentKey: data.paymentKey,
                                      hasCourier: data.hasCourier,
                                     productImageUrl: data.ProductImageUrl,
                                      shopImageUrl: data.shopImageUrl,
                                      restaurant: data.restaurant,
                                      foodName: data.foodName,
                                      price: data.price,
                                      location: data.location,
                                      vendorid: data.vendorId,
                                      time: data.time,
                                      latitude: data.latitude,
                                      longitude: data.longitude,
                                      adminEmail: data.adminEmail,
                                      adminContact: data.adminContact,
                                      maxDistance: data.maxDistance,
                                      vendorAccount: data.vendorAccount,
                                    ),
                                  ),
                                )
                                    : Notify(context, 'This item Is not Available Now', Colors.red);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: NewVerticalCard(
                                  data.ProductImageUrl,
                                  data.restaurant,
                                  data.foodName,
                                  data.price,
                                  data.location,
                                  data.time,
                                  data.vendorId.toString(),
                                  data.isAvailable,
                                  data.adminEmail,
                                  data.adminContact,
                                  data.maxDistance,
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
          )
              : Center(child: NoInternetConnection()),
        ],
      ),
    );
  }
}