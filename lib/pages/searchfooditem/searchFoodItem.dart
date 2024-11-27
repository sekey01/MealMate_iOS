import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoFoodFound.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../searchFoodItemProvider/searchFoodItemFunctionProvider.dart';
import '../../UserLocation/LocationProvider.dart';
import '../detail&checkout/detail.dart';
import 'filters.dart';

class SearchFoodItem extends StatefulWidget {
  const SearchFoodItem({super.key});

  @override
  State<SearchFoodItem> createState() => _SearchFoodItemState();
}

class _SearchFoodItemState extends State<SearchFoodItem> {
  final TextEditingController searchitemController = TextEditingController();
  final searchProvider = SearchProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const Text('search'),
        titleTextStyle: TextStyle(
          fontFamily: 'Righteous',
            color: Colors.blueGrey,
            fontWeight: FontWeight.normal,
            letterSpacing: 2,
            fontSize: 20.sp),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: searchitemController,
                  style: const TextStyle(color: Colors.deepOrange),
                  decoration: InputDecoration(
                    hintText: 'Search : foodName / restaurant / location',
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    prefixIcon:  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchByFilters()));

                      }
                      ,child: const ImageIcon(AssetImage('assets/Icon/filter.png'), color: Colors.blueGrey,size: 20,)),
                    ),

                suffixIcon: IconButton(
                      onPressed: () {
                        searchitemController.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.deepOrangeAccent,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.deepOrangeAccent,
                        style: BorderStyle.solid,
                      ),
                    ),
                    label: const Text('foodName / restaurant / location'),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 10.spMin),
                  ),
                  onChanged: (value) {
                    searchProvider.searchItem = value;
                    setState(() {
                      searchProvider.searchFoodItems();
                    });
                  },
                ),
              ),
            ),

            Expanded(
              child: FutureBuilder(
                future: searchProvider.searchFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
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
                          children: [
                            SizedBox(height: 10.h,),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(text: "Search for : ", style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                                  TextSpan(text: " \" FoodName, Restaurant or location \"", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 12.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
                                ]
                            )),
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
                          return const Center(child: SingleChildScrollView(
                            child: Column(
                              children: [
                                NewSearchLoadingOutLook(),
                                NewSearchLoadingOutLook(),
                                NewSearchLoadingOutLook()

                              ],
                            ),
                          ));
                        } else if (locationSnapshot.hasError) {
                          return Center(child: Text('Error : ${locationSnapshot.error}'));
                        } else if (!locationSnapshot.hasData) {
                          return const Center(child: Text('Unable to detect location'));
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