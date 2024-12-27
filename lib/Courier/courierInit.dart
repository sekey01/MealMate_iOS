import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate_ios/Courier/trackbuyer.dart';
import 'package:mealmate_ios/Courier/update_details.dart';
import 'package:provider/provider.dart';

import '../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../UserLocation/LocationProvider.dart';
import '../components/CustomLoading.dart';
import '../components/Notify.dart';
import '../components/mainCards/promotion_ads_card.dart';
import 'courier_model.dart';

class CourierInit extends StatefulWidget {
  const CourierInit({super.key,});

  @override
  State<CourierInit> createState() => _CourierInitState();
}

Future<CourierModel?> getCourierDetails(BuildContext context, String courierId) async {
  try {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the 'CourierId' collection for the document with matching ID
    QuerySnapshot querySnapshot = await firestore
        .collection('Couriers')
        .where('CourierId', isEqualTo: courierId)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      Notify(context, 'Courier found', Colors.green);
      // Create a CourierModel from the document data
      var doc = querySnapshot.docs.first;
      CourierModel courier = CourierModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      return courier;
    } else {
      Notify(context, 'Courier not found', Colors.red);
      return null;
    }
  } catch (e) {
    Notify(context, 'Error retrieving courier details', Colors.red);
    print('Error retrieving courier details: $e');
    return null;
  }
}

Future<void> switchCourierOnlineStatus(String courierId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the 'CourierId' collection for the document with matching CourierId
    QuerySnapshot querySnapshot = await firestore
        .collection('Couriers')
        .where('CourierId', isEqualTo: courierId)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      bool currentStatus = doc['isCourierOnline'] ?? false;

      // Update the isCourierOnline field with the toggled value
      await doc.reference.update({'isCourierOnline': !currentStatus});
      print('Courier online status updated successfully');
    } else {
      print('Courier not found');
    }
  } catch (e) {
    print('Error updating courier online status: $e');
  }
}

class _CourierInitState extends State<CourierInit> {

  bool _isDisposed = false;
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> updateCourierLocation(String courierId) async {
    // Ensure the function exits early if not needed
    if (courierId.isEmpty) {
      Notify(context, "Add your ID", Colors.red);
      return;
    }

    // Avoid unnecessary updates if the widget is disposed
    if (_isDisposed) return;

    try {
      // Determine position once and store the values
      LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.determinePosition();  // Ensure this is awaited if async
      double lat = locationProvider.Lat;
      double long = locationProvider.Long;

      // Firestore reference
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference docRef = firestore.collection('Couriers').doc(courierId);

      // Check if the courier document exists and update it
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.update({
          'CourierLatitude': lat,
          'CourierLongitude': long,
        });
        print('Courier location updated successfully');
      } else {
        print('Error: Courier document does not exist');
      }
    } catch (e) {
      // Log the error, can be more specific based on error type
      print('Error updating courier location: $e');
    }

    // Call the function again after 10 seconds, but ensure this doesn't cause recursion issues
    if (!_isDisposed) {
      Timer(Duration(seconds: 30), () async {
        print('Updating Location...');
        await updateCourierLocation(courierId);
      });
    }
  }




  final _formKey = GlobalKey<FormState>();
  final TextEditingController LatitudeController = TextEditingController();
  final TextEditingController LongitudeController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///I RUN THE DETERMINE LOCATION HERE TO GET THE LAT AND LONG QUICKLY
    Provider.of<LocationProvider>(context, listen: false).determinePosition();
    Provider.of<LocalStorageProvider>(context, listen: false).getCourierID();

}

  @override
  Widget build(BuildContext context) {

//updateCourierLocation(CourierID);

    return  Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios), color: Colors.blueGrey,),
        backgroundColor: Colors.white,
        title: RichText(text: TextSpan(
            children: [
              TextSpan(text: "Courier", style: TextStyle(color: Colors.black, fontSize: 20.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
              TextSpan(text: "Panel", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),

            ]
        )),
        centerTitle: true,
        actions: [
       Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           IconButton(onPressed: (){},
               icon: Icon(Icons.online_prediction_outlined, color: CupertinoColors.activeGreen,size: 33,)),
           InkWell(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateDetails()));
               },
               child: ImageIcon(AssetImage('assets/Icon/refresh.png'),size: 30.sp,color: Colors.blueGrey,)),
         ],
       ),
          SizedBox(width: 20.w,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///LOCATION DISPLAYED HERE
                ///
                ///
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.location_on_outlined, size: 20.sp,color: Colors.blueGrey,),
                      FutureBuilder(
                          future:
                          Provider.of<LocationProvider>(context, listen: false).determinePosition(),
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
                                        fontSize: 12.sp)),
                              );
                            }
                            return Text(
                              'locating you...',
                              style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.normal,fontSize: 10.spMin),
                            );
                          }),
                    ],
                  ),
                ),

                ///FUTURE BUILDER TO GET COURIER DETAILS
                ///
                ///

                Builder(
                  builder: (context) {
                    return FutureBuilder(future: getCourierDetails(context,Provider.of<LocalStorageProvider>(context,listen: false).courierId),
                            builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return NewSearchLoadingOutLook();
                    }
                    if(snapshot.hasError){
                      return Text('Error: ${snapshot.error}');
                    }
                    if(snapshot.hasData){
                      CourierModel courier = snapshot.data as CourierModel;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(radius: 30.r,backgroundImage: NetworkImage(courier.CourierPictureUrl),),
                                title: Text(courier.CourierName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp,fontFamily: 'Righteous'),),
                                subtitle: Text(courier.CourierEmail,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 10.sp, fontFamily: 'Poppins'),),
                                trailing: courier.isCourierOnline ? LottieBuilder.asset('assets/Icon/online.json', height: 50.h, width: 30.w,): Icon(Icons.offline_bolt, color: Colors.red),

                              ),

                              ListTile(
                                leading: Text('ACC :', style: TextStyle(fontFamily: 'Righteous', fontSize: 12.sp),),
                                title: Text('GHC ' + courier.CourierAccountBalance.toStringAsFixed(2),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15.sp,fontFamily: 'Poppins'),),
                              ),

                              ListTile(
                                leading: Icon(Icons.phone_android_outlined, color: Colors.blueGrey,),
                                title: Text('+233' + courier.CourierContact.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp,fontFamily: 'Poppins'),),
                                subtitle: Text('Contact',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 12.sp, fontFamily: 'Poppins'),),

                              ),
                              ListTile(
                                leading: Icon(Icons.connect_without_contact, color: Colors.blueGrey,),
                                title: LiteRollingSwitch(
                                  //initial value
                                  value: courier.isCourierOnline,
                                  width: 250.w,
                                  textOn: 'Online',
                                  textOnColor: Colors.white,
                                  textOff: 'Offline',
                                  textOffColor: Colors.white,
                                  colorOn: CupertinoColors.activeGreen,
                                  colorOff: Colors.redAccent,
                                  iconOn: Icons.done,
                                  iconOff: Icons.remove_circle_outline,
                                  textSize: 20.0,
                                  onChanged: (bool state) {
                                    switchCourierOnlineStatus(courier.CourierId);
                                  },
                                  onTap: () {

                                  },
                                  onDoubleTap: () {},
                                  onSwipe: () {},
                                ),
                                subtitle: Text('   Toggle to switch Online and Offline',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 12.sp, fontFamily: 'Poppins'),),

                              ),

                            ],
                          ),
                        ),
                      );
                    }
                    return Text('No data');
                        });
                  }
                ),




               // initCourierCard(),
                SizedBox(height: 10.h,),
                Padding(padding: EdgeInsets.only(top: 20,bottom: 20),
                    child: PromotionAdsCard(
                      image: 'assets/Announcements/OrderNow.png',
                      heading:'Welcome to Courier Panel',
                      content: 'Track buyer by entering the phone number and the latitude and longitude of the buyer',
                      contentColor: Colors.white70,
                      headingColor: Colors.white,
                      backgroundColor: Colors.redAccent,

                    )),

                SizedBox(height: 20.h,),



SizedBox(height: 20.h,),
                ///TRACK BUYER ROUTE ALERT
                ///
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Track Buyer',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous',
                            ),
                          ),
                          TextSpan(
                            text: ' Route',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous',
                            ),
                          ),

                          TextSpan(
                            text: ' By Entering:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous',
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                ///FORM TO TRACK BUYER
            Form(
                key: _formKey,
                child: Column(
              children: [
                ///TEXTFIELD FOR BUYER PHONE NUMBER
                Padding(
                    padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          double? phoneNumber = double.tryParse(value);
                          if (phoneNumber == null) {
                            return 'Please enter a valid number';
                          }
                          if (phoneNumber < 0 ) {
                            return 'Phone number must be positive';
                          }
                          //if phone number is not up to 10 digits
                          if (value.length < 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: PhoneNumberController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                          hintStyle: TextStyle(color: Colors.black),
                          //label: Text('Restaurant Name'),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Receiver\'s Phone Number',
                          hintText: ' Telephone Number',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent


                            ),),))),

                ///TEXTFIELD FOR LATITUDE
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter latitude';
                          }
                          double? longitude = double.tryParse(value);
                          if (longitude == null) {
                            return 'Please enter a valid number';
                          }
                          if (longitude < -180 || longitude > 180) {
                            return 'Latitude must be between -180 and 180';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: LatitudeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                          hintStyle: TextStyle(color: Colors.black),
                          //label: Text('Restaurant Name'),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Latitude',
                          hintText: ' Latitude',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent


                            ),),))),

                ///TEXTFIELD FOR LONGITUDE
                Padding(
                    padding: const EdgeInsets.only(left: 8,top: 16,right: 8),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter longitude';
                          }
                          double? longitude = double.tryParse(value);
                          if (longitude == null) {
                            return 'Please enter a valid number';
                          }
                          if (longitude < -180 || longitude > 180) {
                            return 'Longitude must be between -180 and 180';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: LongitudeController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.deepOrange.shade50,
                            hintStyle: TextStyle(color: Colors.black),
                            //label: Text('Restaurant Name'),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'Longitude',
                            hintText: ' Longitude',

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent)
                            ))
                    )
                ),
                SizedBox(height: 20.h,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>
                              TrackBuyer(
                                  phoneNumber: int.parse(PhoneNumberController.text.toString()),
                                  Latitude: double.parse(LatitudeController.text.toString()),
                                  Longitude: double.parse(LongitudeController.text.toString())))
                      );

                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Track Route ',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'Righteous', letterSpacing: 2),),
                  ),

                ),
                SizedBox(height: 50.h,),

              ],
            )),





              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Id = Provider.of<LocalStorageProvider>(context,listen: false).courierId;
          updateCourierLocation(Id);
        },
        child: Icon(Icons.refresh_outlined),
        backgroundColor: Colors.white,
      ),
    );
  }
}
