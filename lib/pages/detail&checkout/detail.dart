import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:mealmate_ios/pages/detail&checkout/payment_unsuccessful.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../AdminPanel/OtherDetails/incomingOrderProvider.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../PaymentProvider/paystack_payment.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoFoodFound.dart';
import '../../components/Notify.dart';
import '../../components/mainCards/custom_carousel.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import '../../models&ReadCollectionModel/cartmodel.dart';
import '../../models&ReadCollectionModel/sendOrderFunctionProvider.dart';
import '../../theme/styles.dart';
import '../searchfooditem/searchFoodItem.dart';
import 'orderSent.dart';

class DetailedCard extends StatefulWidget {
  final String productImageUrl;
  final String shopImageUrl;
  final String restaurant;
  final String paymentKey;
  final bool hasCourier;
  final String foodName;
  final double price;
  final String location;
  final String vendorid;
  final String time;
  final double latitude;
  final double longitude;
  final String adminEmail;
  final int adminContact;
  final int maxDistance;
  final String vendorAccount;



  DetailedCard({
    required this.productImageUrl,
    required this.shopImageUrl,
    required this.paymentKey,
    required this.hasCourier,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.location,
    required this.vendorid,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.adminEmail,
    required this.adminContact,
    required this.maxDistance,
    required this.vendorAccount,

  });

  @override



  _DetailedCardState createState() => _DetailedCardState();
}

class _DetailedCardState extends State<DetailedCard> {

  Future<List<FoodItem>> fetchSimilarFoodItems(List<String> collections, String vendorId) async {
    List<FoodItem> allFoodItems = [];
    try {
      for (String collection in collections) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(collection)
            .where('vendorId', isEqualTo: vendorId)
            .get();
        List<FoodItem> foodItems = snapshot.docs
            .map((doc) => FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        allFoodItems.addAll(foodItems);
      }
      return allFoodItems;
    } catch (e) {
      print("Error fetching food items: $e");
      return [];
    }
  }



  //CUSTOM ICON FOR VENDOR LOCATION
  late BitmapDescriptor customMapIcon;
  Future<BitmapDescriptor> _loadCustomIcon(BuildContext context) async {
    final ImageConfiguration configuration = createLocalImageConfiguration(context, size: const Size(40, 40));
    setState(() async {
      customMapIcon =  await BitmapDescriptor.asset(configuration, 'assets/Icon/VendorLocation.png');
    });
    return await BitmapDescriptor.asset(configuration, 'assets/Icon/VendorLocation.png');
  }


  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();


  //CREATE POLYLINE
  List<LatLng> _routes = [];
  Future<List<LatLng>> _getRoutes () async{
    final points = await Provider.of<LocationProvider> (context,listen: false).getRouteCoordinates(
    LatLng(Provider.of<LocationProvider> (context,listen: false).Lat, Provider.of<LocationProvider> (context,listen: false).Long),
    LatLng(widget.latitude, widget.longitude));
    setState(() {
      _routes = points;
    });
    return points;

  }

  /// CHECKOUT INITIATED OR NOT
bool checkOutInitiated = false;


  double overAllPrice = 0.00;
  late double deliveryFee;
  TextEditingController messageController = TextEditingController();




  @override
  void initState() {
    super.initState();
    //Load Custom Icon
    _loadCustomIcon(context);

    //Calculate Distance Between Customer And Vendor
    Provider.of<LocationProvider>(context, listen: false).calculateDistance(
      LatLng(widget.latitude, widget.longitude),
      LatLng(Provider.of<LocationProvider>(context, listen: false).Lat, Provider.of<LocationProvider>(context, listen: false).Long),
    );

    // Get The Best Route From Vendor To Customer
    _getRoutes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            SizedBox(height: 30.h),
            /// FOOD IMAGE IN CONTANER
            ///
            Stack(
              children: [
                ///IMAGE CONTAINER
                Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                    ),
                  ),
                  height: 195.h,
                  width: double.infinity,
                  child: widget.productImageUrl.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.deepOrange,
                            size: 120.sp,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                          child: CustomCarousel(shopImageUrl: widget.shopImageUrl, productImageUrl: widget.productImageUrl)
                    /*Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(widget.productImageUrl),
                            height: 90.h,
                            width: 120.w,
                          )*/,
                        ),
                ),
                ///BACK ICON
                Positioned(
                    top: 5,
                    left: 10,
                    child: Container(
                      height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.arrow_back_outlined, color: Colors.black,)),
                        ))),
                ///SEARCH ICON
                Positioned(
                    top: 5,
                    right: 10,
                    child: Container(
                        height: 30.h,
                        width: 35.h,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchFoodItem(),
                                ),
                              );
                            },
                            icon: const ImageIcon(
                              AssetImage('assets/Icon/Search.png'),
                              color: Colors.black,
                            ),
                          ),

                        ))),

/// FAVOURITE
                Positioned(
                  top: 5,
                  right: 140,
                  child:  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Badge(
                      backgroundColor: Colors.red,
                      label: Consumer<CartModel>(
                          builder: (context, value, child) => Text(
                            value.cart.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      child: const ImageIcon(
                        AssetImage('assets/Icon/favourite.png'),
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                                      ),
                    ),
                  ),),
/// SEND GMAIL
                Positioned(
                    top: 5,
                    right: 70,
                    child: Container(
                        height: 30.h,
                        width: 35.h,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () async{
                              ///THIS IS THE GMAIL FUNCTION TO SEND A MESSAGE TO THE VENDOR
                              EasyLauncher.email(
                                  email: widget.adminEmail,
                                  subject: 'Order for ${widget.foodName} from ${widget.restaurant}',
                                  body: 'Hello, I would like to make an order for ${widget.foodName} from ${widget.restaurant} \n'
                                      'I would like to know if you have any allergies or specifications for the food. \n'
                                      'Thank you');

                            },
                            icon: Image(
                              image: const AssetImage('assets/Icon/gmail.png'),
                              height: 30.h,
                              width: 30.w,
                            ),
                          ),

                        ))),
/// DISCOUNTED PRICE
                Positioned(
                    top: 140.h,
                    left: 0.w,
                    child:  Container(
                      height: 25.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           ImageIcon(const AssetImage('assets/Icon/discount.png'), color: Colors.red, size: 20.sp,),
                            RichText(text: TextSpan(
                            children: [
                              TextSpan(text: " - ${(widget.price*0.1).toStringAsFixed(2)}%", style: TextStyle( fontFamily: 'Righteous',color: Colors.red, fontSize:12.sp,fontWeight: FontWeight.bold)),
                              TextSpan(text: " Discounted", style: TextStyle(color: Colors.black, fontSize: 8.sp, fontFamily: 'Righteous',)),


                            ]
                                            )),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
            SizedBox(height: 10.h),

          ],
        ),
      ),

      bottomSheet: BottomSheet(
          elevation: 6,
          onClosing: (){},
          builder: (context) {
            return Container(
              height: 500.h,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade50,
                    Colors.grey.shade50,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Center(
                child:SingleChildScrollView(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),


                    /// RESTAURANT ICON AND NAME
                    ///
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 5.sp),
                          Text(
                            toTitleCase(widget.restaurant),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 15.sp,
                                fontFamily: 'Righteous',
                                color: Colors.black,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),

                   // SizedBox(height: 10.h),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,

                    ),


                    /// DELIVERY FEE , AVERAGE TIME AND FOOD PRICE
                    ///
                    ///
                    ///
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,

                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  ImageIcon(
                                    const AssetImage('assets/Icon/delivery.png'),
                                    color: Colors.black,
                                    size: 30.sp,
                                  ),
                                  Text('Delivery fee',style: TextStyle(color: Colors.grey,fontSize: 10.sp,fontWeight: FontWeight.bold),)
                                ],
                              ),
                              ImageIcon(
                                const AssetImage('assets/Icon/cedi.png'),
                                color: Colors.red,
                                size: 15.sp,
                              ),
                              Builder(
                                builder: (context) {


                                  ///Delivery fee is GHC 10.00  per km, so i multiplied it by the distance between the vendor and buyer
                                  ///

                                   deliveryFee = Provider.of<LocationProvider>(context, listen: false).Distance * 10;
                                  return Text(
                                    deliveryFee.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.red,
                                      // fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 15.sp,
                                        //decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black,
                                        //letterSpacing: 2,
                                        fontWeight: FontWeight.w600,
                                        ),

                                  );
                                }
                              ),
                              SizedBox(width: 10.sp,),
                              ///DELIVERY TIME
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  RichText(text: TextSpan(
                                      children: [
                                        TextSpan(text: widget.time, style: TextStyle(fontFamily: 'Popins',color: Colors.black, fontSize: 16.sp, )),
                                        TextSpan(text: " mins", style: TextStyle(fontFamily: 'Righteous',color: Colors.deepOrangeAccent, fontSize: 15.sp,)),
                                      ]
                                  )),
                                  Text('Avg delivery time',style: TextStyle(color: Colors.grey,fontSize: 10.sp,fontFamily: 'Popins',fontWeight: FontWeight.bold),)
                                ],
                              ),
                          SizedBox(width: 10.sp,),


                              ///PRICE OF FOOD HERE
                              ///
                              ///
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  ImageIcon(
                                    const AssetImage('assets/Icon/food.png'),
                                    color: Colors.black,
                                    size: 25.sp,
                                  ),
                                  Text('Price..',style: TextStyle(color: Colors.grey,fontSize: 10.sp,fontWeight: FontWeight.bold/*fontFamily: 'Popins'*/),)
                                ],
                              ),

                              ImageIcon(
                                const AssetImage('assets/Icon/cedi.png'),
                                color: Colors.red,
                                size: 15.sp,
                              ),
                          Text(widget.price.toStringAsFixed(2),
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15.sp,
                                          //decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.black,
                                          //letterSpacing: 2,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),

                                    )

                            ],
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: 10.h),




                    ///FOOD NAME
                    ///

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          SizedBox(width: 10.sp,),

                          ImageIcon(const AssetImage('assets/Icon/restaurant.png'), color: Colors.black, size: 20.sp,),

                          SizedBox(width: 10.sp,),
                          Text(
                            widget.foodName,
                            style:
                            TextStyle(
                              //fontFamily: 'Popins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: 15.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),



                    SizedBox(height: 10.h),


                     /// VENDOR LOCATION
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),



                           ImageIcon(const AssetImage('assets/Icon/VendorLocation.png'), color: Colors.black, size: 25.sp,),

                            SizedBox(width: 10.h),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                ///Display Location
                                Text(
                                  toTitleCase(widget.location),
                                  style: TextStyle(
                                    fontFamily: 'Righteous',
                                    color: Colors.blueGrey,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    letterSpacing: 3,
                                  ),
                                ),

                                //Get Vendor Location with Lat and Lng
                                FutureBuilder(
                                    future:
                                    Provider.of<LocationProvider>(context, listen: false).getAddressFromLatLng(widget.latitude, widget.longitude),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(snapshot.data.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.sp)),
                                        );
                                      }
                                      return Text(
                                        'locating Vendor...',
                                        style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.normal,fontSize: 10.spMin),
                                      );
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),


                    /// SIMILAR PRODUCTS BY THIS VENDOR
                    /// SIMILAR PRODUCTS BY THIS VENDOR
                    Padding(padding: const EdgeInsets.only(left: 5, right: 5,top: 15),
                      child: Text('Similar Products by this Vendor', style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),),
                    Container(
                     // color: Colors.white,
                      width: double.infinity,
                      height: 170.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: FutureBuilder<List<FoodItem>>(
                        future: fetchSimilarFoodItems( ["Food 🍔", "Drinks 🍷", "Clothing 👗"], widget.vendorid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: NewSearchLoadingOutLook());
                              },
                              scrollDirection: Axis.horizontal,
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: EmptySimilarProducts());
                              },
                              scrollDirection: Axis.horizontal,
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final foodItem = snapshot.data![index];
                                return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {

                                        foodItem.isAvailable?Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailedCard(
                                                      paymentKey: foodItem.paymentKey,
                                                      hasCourier: foodItem.hasCourier,

                                                      productImageUrl:
                                                      foodItem.ProductImageUrl,
                                                      shopImageUrl: foodItem.shopImageUrl,
                                                      restaurant:
                                                      foodItem.restaurant,
                                                      foodName:
                                                      foodItem.foodName,
                                                      price: foodItem.price,
                                                      location:
                                                      foodItem.location,
                                                      vendorid:
                                                      foodItem.vendorId,
                                                      time: foodItem.time,
                                                      latitude: foodItem.latitude,
                                                      longitude: foodItem.longitude,
                                                      adminEmail: foodItem.adminEmail,
                                                      adminContact: foodItem.adminContact,
                                                      maxDistance: foodItem.maxDistance,
                                                      vendorAccount: foodItem.vendorAccount,
                                                    ))):Notify(context, 'This item is not Available now', Colors.red);
                                      },
                                      child: NewVerticalCard(foodItem.ProductImageUrl, foodItem.restaurant, foodItem.foodName,
                                          foodItem.price, foodItem.location, foodItem.time, foodItem.vendorId,
                                          foodItem.isAvailable, foodItem.adminEmail,foodItem.adminContact, foodItem.maxDistance),
                                    ));
                              },
                              scrollDirection: Axis.horizontal,
                            );
                          }
                        },
                      ),
                    ),



                    /// CALL BUTTON, SMS MESSAGE FUNCTIONALITY, WHATSAPP FUNCTIONALITY
                    Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 5, right: 5,top: 15),
                          child: Text('Take Note: ', style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),),),
                        ///TEXT TO ALERT USER TO CALL VENDOR IF ANY ALLERGIES
                        Padding(padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(' Do you have any allergies ? '
                              'Or would you like to give specification to what you\'re Ordering ?...\n'
                              'Please call us now Or Leave a message in the Comment box.',

                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600
                            ),),),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            ///WHATSAPP BUTTON
                            GestureDetector(
                              onTap: () async{
                                ///THIS IS THE WHATSAPP FUNCTION TO SEND A MESSAGE TO THE VENDOR
                                EasyLauncher.sendToWhatsApp(
                                    phone: '+233${widget.adminContact}',
                                    message: 'Hello, I would like to make an order for ${widget.foodName} from ${widget.restaurant} \n'
                                        'I would like to know if you have any allergies or specifications for the food. \n'
                                        'Thank you');
                              },
                              child: Column(
                                children: [
                                  Image(image: const AssetImage('assets/Icon/whatsapp.png'), height: 30.h, width: 30.w,),
                                  Text('Whatsapp', style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            SizedBox(width: 30.w),

                            ///CALL BUTTON
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: ()  async{
                                ///THIS IS THE CALL FUNCTION TO CALL THE VENDOR
                                EasyLauncher.call(number: widget.adminContact.toString());
                              },
                              child: Text(
                                'Call Us',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'Righteous', fontSize: 15.sp,letterSpacing: 2),
                              ),
                            ),

                            SizedBox(width: 30.w),



                            ///SMS BUTTON
                            GestureDetector(
                              onTap: () async{
                                ///THIS IS THE SMS FUNCTION TO SEND A MESSAGE TO THE VENDOR
                                EasyLauncher.sms(number: widget.adminContact.toString());
                              },
                              child: Column(
                                children: [
                                  Image(image: const AssetImage('assets/Icon/sms.png'), height: 30.h, width: 30.w,),
                                  Text('SMS', style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ],
                    ),




                    Row(
                      ///ROW FOR TIME AND PHONE NUMBER
                      ///
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ///ROW FOR TIME AND ITS ICON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              const AssetImage('assets/Icon/clock.png'),
                              color: Colors.redAccent,
                              size: 30.sp,
                            ),
                            SizedBox(width: 10.w),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(text: "${widget.time} mins\n", style: TextStyle(
                                      fontFamily: 'Righteous',color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                                  TextSpan(text: "Delivery", style: TextStyle(color: Colors.grey, fontSize: 15.sp, )),


                                ]
                            )),
                            const SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(width: 15.w),

                        ///ROW FOR PHONE NUMBER AND ITS ICON
                        GestureDetector(
                          onTap: () async{
                            ///THIS IS THE CALL FUNCTION TO CALL THE VENDOR
                            EasyLauncher.call(number: widget.adminContact.toString());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                const AssetImage('assets/Icon/call.png'), size: 26.sp,color: Colors.red,
                              ),
                              SizedBox(width: 10.w),
                              RichText(text: TextSpan(
                                  children: [
                                    TextSpan(text: '+233${widget.adminContact}\n', style: TextStyle( fontFamily: 'Righteous',color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                                    TextSpan(text: "Call Us", style: TextStyle(color: Colors.grey, fontSize: 15.sp,)),


                                  ]
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),



                    ///TOTAL PRICE
                    ///
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Total: GH',style: TextStyle(color: Colors.black,fontFamily: 'Popins',fontWeight: FontWeight.bold,fontSize: 20),),
                        ImageIcon(const AssetImage('assets/Icon/cedi.png'),
                  color: Colors.black,
                  size: 20.sp,
                ),

                        Consumer<CartModel>(
                          builder: (context, CartModel, child) {
                            overAllPrice = CartModel.getQuantity * widget.price;
                            return Text(
                               overAllPrice.toStringAsFixed(2),
                              style: TextStyle(
                                fontFamily: 'Righteous',
                                color: Colors.red,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ///ADD TO FAVOURITE BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<CartModel>(
                          builder: (context, value, child) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              value.add(CartFood(
                                imgUrl: widget.productImageUrl,
                                restaurant: widget.restaurant,
                                foodName: widget.foodName,
                                price: widget.price,
                                location: widget.location,
                                time: widget.time,
                                vendorId: widget.vendorid,
                                isAvailable: false,
                                adminEmail: widget.adminEmail,
                                adminContact: widget.adminContact,
                                maxDistance: widget.maxDistance,
                                id: widget.vendorid,



                              ));

                              Alert(
                                context: context,
                                style: const AlertStyle(
                                  backgroundColor: Colors.transparent,
                                  alertPadding: EdgeInsets.all(88),
                                  isButtonVisible: true,
                                  descStyle: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  ),
                                ),
                                desc: "Food added to Favourites",
                                buttons: [
                                  DialogButton(
                                    child: const CardLoading(
                                      height: 25,
                                      child: Text(
                                        '  Okay  ',
                                        style: TextStyle(color: Colors.deepOrange,  fontFamily: 'Righteous',
                                        ),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 100,
                                  ),
                                ],
                              ).show();
                            },
                            child: const Text(
                              'Add to Favourite',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Consumer<CartModel>(
                      builder: (context, value, child) => Container(
                        margin: const EdgeInsets.all(10),
                       // height: 700.h,
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 5),

                              ///INCREMENT AND DECREEMENT BUTTONS
                              ///
                              ///
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      value.decrementQuantity();
                                    },
                                    child: Material(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(7),
                                      elevation: 3,
                                      child: Text(
                                        '  -  ',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    elevation: 3,
                                    child: Text(
                                      value.getQuantity.toString(),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  GestureDetector(
                                    onTap: () {
                                      value.incrementQuantity();
                                    },
                                    child: Material(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(7),
                                      elevation: 3,
                                      child: Text(
                                        '  +  ',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),


                                      ///MAP
                              ///
                              ///
                              FutureBuilder<BitmapDescriptor>(
    future: _loadCustomIcon(context),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return const Center(child: Text('Error loading icon'));
    }
else if (snapshot.hasData) {
      customMapIcon = snapshot.data!;
    }
    return const Text('...', style: TextStyle(
    color: Colors.black,
    ),);
    }),

                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  ///MAP CONATAINER
                                  child:  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black,
                                              style: BorderStyle.solid)),
                                      height: 170.h,
                                      width: double.infinity,

                                      ///MAP HERE
                                      ///
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FutureBuilder(

                                            future: Provider.of<LocationProvider>(context,
                                                listen: false)
                                                .determinePosition(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                ///Run the get distance function here
                                                Provider.of<LocationProvider>(context,listen: false).calculateDistance(
                                                    LatLng(widget.latitude, widget.longitude),
                                                    LatLng(Provider.of<LocationProvider>(context, listen: false).Lat, Provider.of<LocationProvider>(context, listen: false).Long));

                                                /// RETURN THE MAP
                                                return GoogleMap(
                                                  onTap: (argument) {
                                              setState(() {
                                                //get current points
                                                Provider.of<LocationProvider>(context,listen: false).Lat = argument.latitude;
                                                Provider.of<LocationProvider>(context,listen: false).Long = argument.longitude;
                                              });
                                                  },


                                                  markers: {
                                                    ///MARKER FOR VEENDOR LOCATION ON THE MAP
                                                    Marker(
                                                        markerId: const MarkerId('Vendor'),
                                                        visible: true,
                                                        icon: customMapIcon,
                                                        infoWindow: InfoWindow(

                                                          title: 'Vendor\'s Location',
                                                          snippet: 'Distance: ${Provider.of<LocationProvider>(context, listen: false).Distance.toStringAsFixed(3)} km',),
                                                        position: LatLng(
                                                            widget.latitude,
                                                            widget.longitude)),
                                                    ///MARKER FOR USER LOCATION ON THE MAP
                                                    Marker(
                                                        markerId: const MarkerId('User'),
                                                        visible: true,
                                                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue.sp),
                                                        infoWindow: InfoWindow(
                                                          title: 'Your Location',
                                                          snippet: 'Distance: ${Provider.of<LocationProvider>(context, listen: false).Distance.toStringAsFixed(3)} km',),
                                                        position: LatLng(
                                                            Provider.of<LocationProvider>(context, listen: false).Lat,
                                                            Provider.of<LocationProvider>(context, listen: false).Long)),
                                                  },
                                                  circles: Set(),
                                                  polylines:  Set<Polyline>.of(<Polyline>{
                                                    Polyline(
                                                      polylineId: const PolylineId('polyline_id'),
                                                      points: _routes,
                                                      color: Colors.red,
                                                      // Set your desired color
                                                      width: 5, // Set your desired width
                                                    ),
                                                  }),
                                                  mapToolbarEnabled: true,
                                                  padding: const EdgeInsets.all(12),
                                                  scrollGesturesEnabled: true,
                                                  zoomControlsEnabled: true,
                                                  myLocationEnabled: true,
                                                  myLocationButtonEnabled: true,
                                                  fortyFiveDegreeImageryEnabled: true,
                                                  cloudMapId: 'mapId',
                                                  mapType: MapType.normal,
                                                  onMapCreated:
                                                      (GoogleMapController controller) {
                                                    _controller.complete(_controller
                                                    as FutureOr<GoogleMapController>?);
                                                  },
                                                  initialCameraPosition: CameraPosition(
                                                    bearing: 192.8334901395798,
                                                    target: LatLng(
                                                        Provider.of<LocationProvider>(
                                                            context,
                                                            listen: false)
                                                            .Lat,
                                                        Provider.of<LocationProvider>(
                                                            context,
                                                            listen: false)
                                                            .Long),
                                                    tilt: 9.440717697143555,
                                                    zoom: 11.151926040649414,
                                                  ),
                                                );
                                              }
                                              return const Center(child: CustomLoGoLoading());
                                            }),
                                      ),

                                    ),
                                ),
                              ),

                              SizedBox(height: 10.h),
                              ///USER TELEPHONE NUMBER
                              Builder(
                                  builder: (context) {
                                    Provider.of<LocalStorageProvider>(context, listen: false).getPhoneNumber();
                                    return Text(
                                      " Your Telephone: ${Provider.of<LocalStorageProvider>(context, listen: false).phoneNumber}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        //fontWeight: FontWeight.bold,
                                        fontFamily: 'Righteous',
                                      ),
                                    );
                                  }
                              ),

                              /// TEXTFIELDFOR USER TO ENTER EXTRA INFORMATION
                              ///
                              ///
                              ///
                              Padding(padding: const EdgeInsets.all(8),
                                child: Text(' Make sure your number below is correct and Active '
                                    'Vendor can call you to confirm your order... ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey.shade800,
                                      fontFamily: 'Popins'
                                  ),),),

                              SizedBox(height: 10.h,),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextField(
                                  maxLines: 3,
                                  enableSuggestions: true,
                                  scrollPadding: const EdgeInsets.all(8),
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey.shade100,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey.shade100,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    label: const Text('Leave a message for Vendor/Courier ... \n - Landmark\n - Delivery Instructions\n - etc',),
                                    labelStyle: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12.sp,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    hintText: ' - Leave a message for Us  or other details here...\n - Landmark\n - Delivery Instructions\n - etc'
                                               '\n - Make sure your number is correct and active',
                                    hintStyle: TextStyle(

                                      color: Colors.blueGrey.shade300,
                                      fontSize: 11.sp,
                                    ),

                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide( color: Colors.black, style: BorderStyle.solid),
                                    ),
                                  ),
                                  controller: messageController,
                                ),
                              ),

                              SizedBox(height: 15.h),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Swipe to Checkout', style: TextStyle(color: Colors.green, fontSize: 20.sp, fontWeight: FontWeight.bold, fontFamily: 'Righteous'),),
      ),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(!widget.hasCourier?'make sure payment is done within 45 seconds after swipe': 'Pay to the Courier when he arrives',
                                 textAlign: TextAlign.center,
                                 style: TextStyle(color: Colors.red, fontSize: 12.spMin, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                             ),

                              /// SINCE VENDDOR HAS NO COURIER ,
                              /// THEN FOOD/PRODUCT PRICE IS SENT TO MEALMATE(which will be sent to the vendor by mealmate later...)
                              /// AND THE DELIVERY FEE IS GIVEN TO THE COURIER WHEN HE ARRIVES

                              Padding(padding: const EdgeInsets.all(8),
                                child: !widget.hasCourier?LiteRollingSwitch(
                                  /// SINCE VENDDOR HAS NO COURIER ,
                                  /// THEN FOOD/PRODUCT PRICE IS SENT TO MEALMATE(which will be sent to the vendor by mealmate later...)
                                  /// AND THE DELIVERY FEE IS GIVEN TO THE COURIER WHEN HE ARRIVES
                                  value: checkOutInitiated,
                                  width: 220.sp,
                                  textOn: 'CheckOut',
                                  textOnColor: Colors.white,
                                  textOff: 'CheckOut',
                                  textOffColor: Colors.white,
                                  colorOn: CupertinoColors.activeGreen,
                                  colorOff: Colors.redAccent,
                                  iconOn: Icons.done,
                                  iconOff: Icons.shopping_cart_checkout_outlined,
                                  textSize: 20.0,
                                  onChanged: (bool state) {

                                  },
                                  onTap: ()  {

                                    ///Get the Time
                                    DateTime time = DateTime.now();

                                    if (Provider.of<LocalStorageProvider>(context,listen: false).phoneNumber.isNotEmpty && Provider.of<LocationProvider>(context, listen: false).determinePosition().toString().isNotEmpty)
                                    {

                                      Alert(context: context,
                                        style: const AlertStyle(
                                          backgroundColor: Colors.white,
                                        ),
                                        content: WaitingPayment(),
                                      ).show();
                                       Provider.of<PaystackPaymentProvider>(context, listen: false).
                                      startPayment(context,  overAllPrice.toInt(), widget.vendorid).then((result){
                                        if(result.success){
                                          Provider.of<SendOrderProvider>(context, listen: false).sendOrder(OrderInfo(
                                            time: time,
                                            foodName: widget.foodName,
                                            quantity: Provider.of<CartModel>(context,
                                                listen: false)
                                                .getQuantity,
                                            price: widget.price,
                                            message: messageController.text.toString(),
                                            Latitude: Provider.of<LocationProvider>(
                                                context,
                                                listen: false)
                                                .Lat,
                                            Longitude: Provider.of<LocationProvider>(
                                                context,
                                                listen: false)
                                                .Long,
                                            phoneNumber:
                                            Provider.of<LocalStorageProvider>(
                                                context,
                                                listen: false)
                                                .phoneNumber,
                                            vendorId: widget.vendorid,
                                            served: false,
                                            courier: false,
                                            delivered: false,
                                            adminEmail: widget.adminEmail,
                                            adminContact: widget.adminContact,
                                            CourierContact: '',
                                            CourierId: 0,
                                            CourierName: '',
                                            VendorAccount: widget.paymentKey,
                                          )).then((_){
                                            ///END EMAIL TO ALERT VENDOR FUNCTION OF NEW ORDER
                                            ///SEND EMAIL TO VENDOR
                                            Provider.of<IncomingOrdersProvider>(context, listen: false).sendEmail(widget.adminEmail, widget.foodName);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OrderSent(
                                                  deliveryFee: deliveryFee,
                                                    vendorId: widget.vendorid,
                                                    time: time,
                                                    restaurant: widget.restaurant,
                                                    adminEmail: widget.adminEmail,
                                                    adminContact: widget.adminContact),
                                              ),
                                            );
                                          });
                                        }
                                        else{
                                          Notify(context, 'Payment Failed', Colors.red);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentUnsuccessful()));
                                        }

                                      });





                                    }
                                    else {
                                      Notify(context, 'Please add Telephone number',
                                          Colors.red);
                                      checkOutInitiated = false;
                                    }
                                  },
                                  onDoubleTap: () {},
                                  onSwipe: ()   {
                                    Alert(context: context,
                                      style: const AlertStyle(
                                        backgroundColor: Colors.white,
                                      ),
                                      content: WaitingPayment(),
                                    ).show();

                                    ///Get the Time
                                    DateTime time = DateTime.now();
                                    checkOutInitiated = false;

                                    if (Provider.of<LocalStorageProvider>(context,listen: false).phoneNumber.isNotEmpty && Provider.of<LocationProvider>(context, listen: false).determinePosition().toString().isNotEmpty)
                                    {
                                       Provider.of<PaystackPaymentProvider>(context, listen: false).
                                      startPayment(context,overAllPrice.toInt(),widget.vendorid).then((result){
                                        if(result.success){
                                          Provider.of<SendOrderProvider>(context, listen: false).sendOrder(OrderInfo(
                                            time: time,
                                            foodName: widget.foodName,
                                            quantity: Provider.of<CartModel>(context,
                                                listen: false)
                                                .getQuantity,
                                            price: widget.price,
                                            message: messageController.text.toString(),
                                            Latitude: Provider.of<LocationProvider>(
                                                context,
                                                listen: false)
                                                .Lat,
                                            Longitude: Provider.of<LocationProvider>(
                                                context,
                                                listen: false)
                                                .Long,
                                            phoneNumber:
                                            Provider.of<LocalStorageProvider>(
                                                context,
                                                listen: false)
                                                .phoneNumber,
                                            vendorId: widget.vendorid,
                                            served: false,
                                            courier: false,
                                            delivered: false,
                                            adminEmail: widget.adminEmail,
                                            adminContact: widget.adminContact,
                                            CourierContact: '',
                                            CourierId: 0,
                                            CourierName: '',
                                            VendorAccount: '',
                                          )).then((_){
                                            ///END EMAIL TO ALERT VENDOR FUNCTION
                                            Provider.of<IncomingOrdersProvider>(context, listen: false).sendEmail(widget.adminEmail, widget.foodName);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OrderSent(
                                                    deliveryFee: deliveryFee,
                                                    vendorId: widget.vendorid,
                                                    time: time,
                                                    restaurant: widget.restaurant,
                                                    adminEmail: widget.adminEmail,
                                                    adminContact: widget.adminContact),
                                              ),
                                            );
                                          });
                                        }
                                        else{
                                          Notify(context, 'Payment Failed', Colors.red);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentUnsuccessful()));
                                        }

                                      });





                                    }
                                    else {
                                      Notify(context, 'Please add Telephone number',
                                          Colors.red);
                                      checkOutInitiated = false;
                                    }
                                  },
                                ):
                                ///SINCE VENDOR HAS COURIER
                                ///THEN FOOD/PRODUCT PRICE + DELIVERY FEE IS SENT TO THE COURIER WHEN HE ARRIVES
                                ///
                                LiteRollingSwitch(
                                  //initial value
                                  value: checkOutInitiated,
                                  width: 250.sp,
                                  textOn: 'Cash On Delivery',
                                  textOnColor: Colors.white,
                                  textOff: 'Cash On Delivery',
                                  textOffColor: Colors.white,
                                  colorOn: CupertinoColors.activeGreen,
                                  colorOff: Colors.redAccent,
                                  iconOn: Icons.done,
                                  iconOff: Icons.shopping_cart_checkout_outlined,
                                  textSize: 20.0,
                                  onChanged: (bool state) {

                                  },
                                  onTap: ()  {
                                    ///Get the Time on ios
                                    DateTime time = DateTime.now();

                                    if (Provider.of<LocalStorageProvider>(context,listen: false).phoneNumber.isNotEmpty && Provider.of<LocationProvider>(context, listen: false).determinePosition().toString().isNotEmpty)
                                    {
                                      Provider.of<SendOrderProvider>(context, listen: false).sendOrder(OrderInfo(
                                        time: time,
                                        foodName: widget.foodName,
                                        quantity: Provider.of<CartModel>(context,
                                            listen: false)
                                            .getQuantity,
                                        price: widget.price,
                                        message: messageController.text.toString(),
                                        Latitude: Provider.of<LocationProvider>(
                                            context,
                                            listen: false)
                                            .Lat,
                                        Longitude: Provider.of<LocationProvider>(
                                            context,
                                            listen: false)
                                            .Long,
                                        phoneNumber:
                                        Provider.of<LocalStorageProvider>(
                                            context,
                                            listen: false)
                                            .phoneNumber,
                                        vendorId: widget.vendorid,
                                        served: false,
                                        courier: false,
                                        delivered: false,
                                        adminEmail: widget.adminEmail,
                                        adminContact: widget.adminContact,
                                        CourierContact: '',
                                        CourierId: 0,
                                        CourierName: '',
                                        VendorAccount: '',
                                      )).then((_){
                                        ///END EMAIL TO ALERT VENDOR FUNCTION
                                        Provider.of<IncomingOrdersProvider>(context, listen: false).sendEmail(widget.adminEmail, widget.foodName);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderSent(
                                                deliveryFee: '0.00',
                                                vendorId: widget.vendorid,
                                                time: time,
                                                restaurant: widget.restaurant,
                                                adminEmail: widget.adminEmail,
                                                adminContact: widget.adminContact),
                                          ),
                                        );
                                      });

                                    }
                                    else {
                                      Notify(context, 'Please add Telephone number',
                                          Colors.red);
                                      checkOutInitiated = false;
                                    }
                                  },
                                  onDoubleTap: () {},
                                  onSwipe: (){
                                    ///Get the Time
                                    DateTime time = DateTime.now();

                                    if (!Provider.of<LocalStorageProvider>(context,listen: false).phoneNumber.isEmpty || Provider.of<LocationProvider>(context, listen: false).determinePosition().toString().isEmpty)
                                    {
                                      Provider.of<SendOrderProvider>(context, listen: false).sendOrder(OrderInfo(
                                        time: time,
                                        foodName: widget.foodName,
                                        quantity: Provider.of<CartModel>(context,
                                            listen: false)
                                            .getQuantity,
                                        price: widget.price,
                                        message: messageController.text.toString(),
                                        Latitude: Provider.of<LocationProvider>(
                                            context,
                                            listen: false)
                                            .Lat,
                                        Longitude: Provider.of<LocationProvider>(
                                            context,
                                            listen: false)
                                            .Long,
                                        phoneNumber:
                                        Provider.of<LocalStorageProvider>(
                                            context,
                                            listen: false)
                                            .phoneNumber,
                                        vendorId: widget.vendorid,
                                        served: false,
                                        courier: false,
                                        delivered: false,
                                        adminEmail: widget.adminEmail,
                                        adminContact: widget.adminContact,
                                        CourierContact: '',
                                        CourierId: 0,
                                        CourierName: '',
                                        VendorAccount: '',
                                      )).then((_){
                                        ///END EMAIL TO ALERT VENDOR FUNCTION
                                        Provider.of<IncomingOrdersProvider>(context, listen: false).sendEmail(widget.adminEmail, widget.foodName);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderSent(
                                                deliveryFee: '0.00',
                                                vendorId: widget.vendorid,
                                                time: time,
                                                restaurant: widget.restaurant,
                                                adminEmail: widget.adminEmail,
                                                adminContact: widget.adminContact),
                                          ),
                                        );
                                      });

                                    }
                                    else {
                                      Notify(context, 'Please add Telephone number',
                                          Colors.red);
                                      checkOutInitiated = false;
                                    }
                                  },
                                ),),




                            ],
                          ),
                        ),
                      ),
                    ),




                    
                    
                    
                  ],
                )
                ),
            ),
            );
          }
    ),

    );
  }
}
