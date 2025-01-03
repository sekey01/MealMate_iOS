
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Courier/courier_model.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import '../../Notification/notification_Provider.dart';
import '../../PaymentProvider/payment_provider.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/Notify.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'map_track_courier.dart';


class TrackOrder extends StatefulWidget {
  final String vendorId;
  final DateTime time;
  final String restaurant;
  final adminEmail;
  final adminContact;
  final double deliveryFee;
  final bool isCashOnDelivery;
  final latitude;
  final longitude;
  const TrackOrder({super.key,
    required this.isCashOnDelivery,
    required this.vendorId,
    required this.time,
    required this.restaurant,
    required this.adminEmail,
    required this.adminContact,
    required this.deliveryFee,
    required this.latitude,
    required this.longitude,
  } );

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {

  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  TextEditingController _feedbackController = TextEditingController();
  String courierContact = '';
  String courierId = '';
  Stream<int> countdownTimer(int start) async* {
    for (int i = start; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
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

  Stream<OrderInfo> trackOrder(String id, String phoneNumber, DateTime time) {
    return FirebaseFirestore.instance
        .collection('OrdersCollection')
        .where('vendorId', isEqualTo: id)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .where('delivered', isEqualTo: false ,)
        .where('isRejectedRefunded', isEqualTo: false)
        .where('Latitude', isEqualTo: widget.latitude)
        .where('Longitude', isEqualTo: widget.longitude)

    ///token id is the Id given to every user when he or she signs up or logs in
    ///
    //.Where('tokenid',isEqualTo: tokenid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return OrderInfo.fromMap(doc.data(), doc.id);
      } else {
        throw Exception("No matching order found");

      }
    })
        .handleError((error) {
      print("Error in stream: $error");
      throw error; // Re-throw the error to be handled by StreamBuilder
    })
        .where((orderInfo) => orderInfo != null); // This line is technically unnecessary now, but kept for safety
  }

  /// THIS CHANGES TOGGLES THE BOOL OF DELIVERED TO TRUE AND CHANGES THE INCOMPLETE ORDER FROM THE ADMIN TO TRUE AND ALERTS THE ADMIN THAT THE BUYER HAS RECEIVED
  /// THE FOOD OR ITEM 😊😊😊😊😊😊😊😊😊
  Future<void> switchDelivered(BuildContext context, String id, String phoneNumber, ) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('OrdersCollection');

    try {
      // First, get the documents that match the criteria
      QuerySnapshot querySnapshot = await collectionRef
          .where('vendorId', isEqualTo: id)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .where('delivered', isEqualTo:false)
          //.where('isRejected', isEqualTo: false)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        print('No matching documents found');
        return;
      }

      // Update each matching document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'delivered': true});
      }

      print('isDelivered updated successfully');
    } catch (e) {
      print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: RichText(text: TextSpan(
          children: [
            TextSpan(text: "Tracking", style: TextStyle(color: Colors.black, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
            TextSpan(text: "Order ...", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous') ,),


          ]
      )),centerTitle: true,backgroundColor: Colors.white,titleTextStyle: const TextStyle(color: Colors.blueGrey, fontSize: 20, fontWeight: FontWeight.bold),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              child: StreamBuilder<OrderInfo>(
                ///
                ///
                ///
                /// I HAVE TO MOVE THE ADMIN ID HERE IN ORDER TO GET ACCESS TO THE ACTUAL DOCUMENT
                ///
                /// ALSO DON'T FORGET TO ADD THE TOKEN ID FOR MORE ACCURACY
                ///
                ///
                ///
                ///
                  stream: trackOrder(widget.vendorId,Provider.of<LocalStorageProvider>(context, listen: false)
                      .phoneNumber, widget.time),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting )
                    { return const Center(child: Text('Collecting Updates...', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 20),));
                    }
                    else if (snapshot.hasError){
                      if(kDebugMode){
                        print('Error: ${snapshot.error}');
                      }

                      return Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(' please refresh page or Call vendor now...',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                          SizedBox(height: 20.h,),
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(text: 'Feed', style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
                                TextSpan(text:'Back', style: TextStyle(color: Colors.redAccent, fontSize: 16.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
                              ]
                          )),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: _feedbackController ,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 12.sp
                              ),
                              maxLines: 5,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: 'FeedBack info',
                                labelText: 'your feedback helps us to serve you better ...',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextButton(onPressed: () async {
                              await Provider.of<NotificationProvider>(context,listen: false).sendSms('0553767177', _feedbackController.text.toString());
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);

                            }, child:Text('Send FeedBack',style: TextStyle(color: Colors.white),)),
                          ),

                          SizedBox(
                            height: 30.h,
                          ),

                          ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                          )
                          ,onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);

                          }, child: const Text('Go Back', style: TextStyle(color: Colors.white, fontFamily: 'Righteous'),),

                          )],
                      ),);
                    }
                    else if (!snapshot.hasData ) {
                      return const Center(
                        child: Text('Can not Track Order, call the restaurant ...',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                      );
                    } else {
                      final Order = snapshot.data!;

                      return Center(

                        child: Order.isRejected && !Order.isRejectedRefunded ?Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 150.h,),

                            ///ORDER REJECTED
                            ///
                            ///
                            ///
                            const Text('Order Rejected', style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),
                            const Text('Call the vendor for more info', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),

                            ValueListenableBuilder(valueListenable: isLoading, builder: (context, value, child){
                              return value ? Column(
                                children: [
                                  SizedBox(height: 100.h,),

                                  CustomLoGoLoading(),
                                  Text('Please Wait ...', style: TextStyle(color: Colors.green, fontSize: 16.spMin, fontWeight: FontWeight.bold),),
                                ],
                              ) : Column(
                                children: [

                                  SizedBox(height: 30.h,),
                                  widget.isCashOnDelivery ? Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green,
                                    elevation: 3,
                                    child: TextButton(onPressed: () async{
                                      isLoading.value = true;
                                      await Provider.of<PaymentProvider>(context, listen: false).requestRefund(context, widget.vendorId, widget.deliveryFee, Order.phoneNumber, widget.adminContact.toString(), widget.latitude,widget.longitude);
                                      isLoading.value = false;
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }, child: const Text('Request Refund', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Righteous'),)),
                                  ) : const Text('Thank you', style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),

                                ],
                              );
                            }),




                          ],
                        )  :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ///AMOUNT TO PAY COURIER
                            ///BUTTON TO CALL VENDOR
                            ///
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.isCashOnDelivery? Column(
                                    children: [
                                      const Text('Amount to pay Courier', style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 10, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),
                                      Row(
                                        children: [
                                          ImageIcon(const AssetImage('assets/Icon/cedi.png'),size: 20.sp,color: Colors.deepOrangeAccent,),
                                          Text( '${widget.deliveryFee.truncateToDouble()}', style: TextStyle(color: Colors.black, fontSize: 20.spMin, fontWeight: FontWeight.bold, fontFamily: 'Righteous'),),
                                        ],
                                      ),
                                    ],
                                  ) : Lottie.asset('assets/Icon/online.json',height: 50.h,width: 40.w),

                                  ///VENDOR CONTACT
                                  ///
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async{
                                        ///THIS IS THE CALL FUNCTION TO CALL THE VENDOR
                                        EasyLauncher.call(number: widget.adminContact.toString());
                                      },
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [

                                            Text('Call Vendor ', style:TextStyle(color: Colors.blueGrey, fontSize: 14.sp, fontFamily: 'Poppins') ,),
                                            ImageIcon(const AssetImage('assets/Icon/customer-service.png'),size: 25.sp,color: Colors.green,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            const Text('Order In progress...', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),

                            StreamBuilder<int>(
                              stream: countdownTimer(90), // Countdown from 60 seconds
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text(
                                    'Starting...',
                                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                                  );
                                } else if (snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: RichText(textAlign: TextAlign.center,text: TextSpan(
                                        children: [
                                          TextSpan(text: " Order will be served in :  ", style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp,)),
                                          TextSpan(text: "${snapshot.data} seconds \n ", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),
                                          TextSpan(text: "if the Order Served  Icon is not ticked green, try calling the vendor ", style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp,fontFamily: 'Poppins')),


                                        ]
                                    )),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}',
                                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return const Text(
                                    'Done!',
                                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            ),
                            /// ORDER RECEIVED
                            const Padding(padding: EdgeInsets.all(8),
                              child: ImageIcon(AssetImage(('assets/Icon/orderReceived.png'),), size: 80,color: Colors.green,),
                            ),
                            Text('Order Sent', style: TextStyle(color: Colors.green, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.h,),
                            const Icon(Icons.arrow_downward, color: Colors.green,),
                            //SizedBox(height: 10.h,),

                            ///ORDER SERVED
                            Padding(padding: const EdgeInsets.all(8),
                              child: ImageIcon(const AssetImage(('assets/Icon/orderServed.png'),), size: Order!.served?80:30,color:Order.served?Colors.green: Colors.grey,),
                            ),
                            Text('Order Served', style: TextStyle(color: Order.served?Colors.green: Colors.grey, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.h,),
                            Icon(Icons.arrow_downward, color: Order.served?Colors.green: Colors.grey,),
                            // SizedBox(height: 10.h,),

                            /// ORDER GIVEN TO COURIER
                            Padding(padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ImageIcon(const AssetImage(('assets/Icon/courier.png'),), size: 30,color:Order.courier?Colors.green: Colors.grey,),
                                      Order.courier ? TextButton(onPressed: (){


                                      }, child: const Image(image: AssetImage('assets/Icon/map.png',))): TextButton(onPressed: (){
                                        Notify(context, "Waiting to track Courier", Colors.red);
                                      }, child: const Text('Track Courier', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                  const Text('Courier details will be displayed soon ...', style: TextStyle(color: Colors.grey,fontSize: 10,fontFamily: 'Poppins'),),
                                ],
                              ),
                            ),
                            !Order.courier?Text(' Courier will get to your location soon...', style: TextStyle(color: Order.courier?Colors.green: Colors.grey, fontSize: 10.spMin, fontWeight: FontWeight.bold),):

                            FutureBuilder(future: getCourierDetails(context, Order.CourierId.toString()),
                                builder: (context, snapshot){
                                  //generate time to display the current time and wherether ids m or pm
                                  final String time = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString() + ' ' + (DateTime.now().hour > 12 ? 'PM' : 'AM');
                                  // final String time = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString() ;
                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return const Text('Loading Courier Details...', style: TextStyle(color: Colors.grey,fontSize: 10,fontFamily: 'Poppins'),);
                                  } else if (snapshot.hasError){
                                    return const Text('Error Loading Courier Details...', style: TextStyle(color: Colors.red,fontSize: 10,fontFamily: 'Poppins'),);
                                  } else if (!snapshot.hasData){
                                    return const Text('Courier Will Call you soon...', style: TextStyle(color: Colors.red,fontSize: 10,fontFamily: 'Poppins'),);
                                  } else {
                                    final courier = snapshot.data as CourierModel;
                                    courierContact = courier.CourierContact.toString();
                                    courierId = courier.CourierId;
                                    return  GestureDetector(
                                      onTap: (){
                                        showBottomSheet(context: (context),showDragHandle: true,enableDrag: true,backgroundColor: Colors.blueGrey.shade100, builder: (context){
                                          return Container(
                                            height: 250.h,
                                            color: Colors.blueGrey.shade100,

                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [

                                                  Container(
                                                    height: 50.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [

                                                        Icon(Icons.location_history, color: Colors.white,),
                                                        const Text('Courier Details', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Poppins', letterSpacing: 1),),
                                                        Container(
                                                          height: 20.h,
                                                          width: 80.w,
                                                          decoration: BoxDecoration(
                                                            color: Colors.blueGrey,
                                                            borderRadius: BorderRadius.circular(30),
                                                          ),
                                                          child:  Center(child: Text(time, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child: Column(
                                                      children: [

                                                        ///COURIER DETAILS
                                                        ListTile(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                          leading: CircleAvatar(
                                                            backgroundImage: NetworkImage(courier.CourierPictureUrl),
                                                            onBackgroundImageError: (exception, stackTrace) {
                                                              const CircleAvatar(
                                                                backgroundImage: AssetImage('assets/Icon/courier.png'),
                                                              );
                                                            },
                                                          ),
                                                          title: Text('Name: ${courier.CourierName}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),),
                                                          subtitle: Text('Vehicle N0: ${courier.CourierVehicleNumber}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),),

                                                          ///CALL BUTTON
                                                          ///WHEN PRESSED CALLS THE COURIER
                                                          ///THE COURIER NUMBER IS STORED IN THE COURIER MODEL
                                                          trailing: TextButton(onPressed: () async{
                                                            EasyLauncher.call(number: courier.CourierContact.toString());
                                                          }, child: LottieBuilder.asset('assets/Icon/online.json', height: 20, width: 20,)),
                                                        ),

                                                        ///BUTTONS TO TRACK COURIER AND CALL COURIER
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            TextButton(onPressed: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> TrackCourierMap(
                                                                courierLatitude: courier.CourierLatitude,
                                                                courierLongitude: courier.CourierLongitude,
                                                              )));
                                                            }, child: const Text('Track On Map', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)),
                                                            TextButton(onPressed: (){
                                                              EasyLauncher.call(number: courier.CourierContact.toString());
                                                            }, child: const Text('Call Now', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)),
                                                          ],
                                                        ),

                                                        ///YOUR LOCATION
                                                        ListTile(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                          leading: Icon(Icons.map_outlined, color: Colors.blueGrey,),
                                                          title: Text('Your Current Location is :', style: const TextStyle(color: Colors.black, fontSize: 15,fontFamily: 'Poppins' ),),
                                                          subtitle:
                                                          ///LOCATION DISPLAYED HERE
                                                          ///
                                                          SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 20),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Icon(Icons.location_on_outlined, size: 20.spMin,color: Colors.blueGrey,),
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
                                                                                    fontSize: 12.spMin)),
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
                                                          ),
                                                        ),
                                                        ///A NOTE TO USER TO REPORT ALL ISSUE TO MEALMATE
                                                        GestureDetector(
                                                          onTap: () async{
                                                            await EasyLauncher.call(number: '055 376 7177');
                                                          },
                                                          child: ListTile(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                            ),
                                                            leading: const Icon(Icons.report, color: Colors.red,),
                                                            title: const Text('Report any issue to MealMate', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                                                            subtitle: const Text('We are here to help you...', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                                                            trailing: TextButton(onPressed: () async{
                                                              await EasyLauncher.call(number: '055 376 7177');
                                                            }, child: const Icon(Icons.call,color: Colors.red,),
                                                            ),),
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 20,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Center(child: Text('Show Courier  Details', style: TextStyle(color: Colors.white,fontSize: 10,fontFamily: 'Poppins'),)),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            SizedBox(height: 10.h,),
                            Icon(Icons.arrow_downward, color: Order.courier?Colors.green: Colors.grey,),
                            //SizedBox(height: 10.h,),

                            /// ORDER COMPLETE
                            Padding(padding: const EdgeInsets.all(8),
                              child: ImageIcon(const AssetImage(('assets/Icon/orderComplete.png'),), size: Order.delivered?80:30,color: Order.delivered?Colors.green: Colors.grey,),
                            ),
                            Text(' Order Delivered ', style: TextStyle(color: Order.delivered?Colors.green: Colors.grey, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
                            SizedBox(height: 20.h,),

                            ValueListenableBuilder(
                                valueListenable: isLoading,
                                builder: (context, value, child) {
                                  return  value ? Column(
                                    children: [
                                      CustomLoGoLoading(),
                                      Text('Please Wait ...', style: TextStyle(color: Colors.green, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
                                    ],
                                  ) : Material(  borderRadius: BorderRadius.circular(10),
                                      color: Colors.green,
                                      elevation: 3,
                                      child: TextButton(onPressed: ()  async{
                                        if(
                                        Order.courier && Order.served
                                        ){
                                          isLoading.value = true ;
                                          await Provider.of<PaymentProvider>(context,listen: false).addMoneyToCourierAccount(context, courierId, widget.deliveryFee.truncateToDouble() , courierContact).then((_)  async {
                                            await Provider.of<LocalStorageProvider>(context,listen: false).addOrder( StoreOrderLocally(id:widget.restaurant , item: Order.foodName, price: Order.price,time: DateTime.timestamp().toString()));
                                            await switchDelivered(context, widget.vendorId,Provider.of<LocalStorageProvider>(context, listen: false).phoneNumber);

                                          });

                                          Notify(context, 'Thanks for Using MealMate 😊', Colors.green);


                                        } else{
                                          Notify(context, 'Order Not received yet', Colors.red);
                                        }




                                      }, child: const Text('Order Received', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 1,fontFamily: 'Righteous'),)));
                                }
                            ),





                            SizedBox(height: 30.h,)




                          ],) ,
                      );}
                  }),
            ),

          ],
        ),
      ),


    );
  }
}