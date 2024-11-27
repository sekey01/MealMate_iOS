
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate_ios/components/CustomLoading.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../Courier/courierInit.dart';
import '../../Courier/courier_model.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import '../../components/Notify.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;


class TrackOrder extends StatefulWidget {
  final String vendorId;
  final DateTime time;
  final String restaurant;
  final adminEmail;
  final adminContact;
  const TrackOrder({super.key,required this.vendorId,required this.time, required this.restaurant, required this.adminEmail,required this.adminContact} );

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {

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
        .where('delivered', isEqualTo: false )
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
      .where('delivered', isEqualTo:false )
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
            TextSpan(text: "Tracking ", style: TextStyle(color: Colors.black, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
            TextSpan(text: "Order ...", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous') ,),


          ]
      )),centerTitle: true,backgroundColor: Colors.white,titleTextStyle: const TextStyle(color: Colors.blueGrey, fontSize: 20, fontWeight: FontWeight.bold),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<OrderInfo>(
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
              else if (snapshot.hasError){return const Center(child: Text('Please wait while we connect you...'),);
              }
              else if (!snapshot.hasData ) {
                return const Center(
                  child: Text('Can not Track Order, call the restaurant ...'),
                );
              } else {
            final Order = snapshot.data;

              return Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
             ///MEALMATE HERE
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(const AssetImage('assets/Icon/cedi.png'),size: 20.sp,color: Colors.deepOrangeAccent,),
                        Text( '${Order?.price.toString()}''0', style: TextStyle(color: Colors.black, fontSize: 15.spMin, fontWeight: FontWeight.bold)),

                      ],
                    ),
                  ),

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Text('Tap here to Call Vendor ', style:TextStyle(color: Colors.blueGrey, fontSize: 15.sp, fontFamily: 'Poppins') ,),
                            ImageIcon(const AssetImage('assets/Icon/customer-service.png'),size: 25.sp,color: Colors.green,)
                          ],
                        ),
                      ),
                    ),
                  ),
            const Text('Order In progress...', style: TextStyle(color: Colors.blueGrey, fontSize: 25, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),

                  ///LOADER
                  const Padding(padding: EdgeInsets.all(16), child: CustomLoGoLoading(),),

                  StreamBuilder<int>(
                    stream: countdownTimer(90), // Countdown from 60 seconds
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Starting...',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RichText(textAlign: TextAlign.center,text: TextSpan(
                              children: [
                                TextSpan(text: " Order will be served in :  ", style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp,)),
                                TextSpan(text: "${snapshot.data} seconds \n ", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
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
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Text('Loading Courier Details...', style: TextStyle(color: Colors.grey,fontSize: 10,fontFamily: 'Poppins'),);
                        } else if (snapshot.hasError){
                          return const Text('Error Loading Courier Details...', style: TextStyle(color: Colors.red,fontSize: 10,fontFamily: 'Poppins'),);
                        } else if (!snapshot.hasData){
                          return const Text('Courier Will Call you soon...', style: TextStyle(color: Colors.red,fontSize: 10,fontFamily: 'Poppins'),);
                        } else {
                          final courier = snapshot.data as CourierModel;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(courier.CourierPictureUrl),
                                  onBackgroundImageError: (exception, stackTrace) {
                                     const CircleAvatar(
                                      backgroundImage: AssetImage('assets/Icon/courier.png'),
                                    );
                                  },
                                ),
                                title: Text('Name: ${courier.CourierName}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),),
                                subtitle: Text('No: ${courier.CourierVehicleNumber}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),),
                                trailing: TextButton(onPressed: () async{
                                  EasyLauncher.call(number: courier.CourierContact.toString());
                                }, child: const Text('Call Now', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)),
                              )
                            ],
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



            Material(  borderRadius: BorderRadius.circular(10),
                color: Colors.green,
                elevation: 3,
                child: TextButton(onPressed: (){
                  if(
                  Order.courier && Order.served
                  ){
                    switchDelivered(context, widget.vendorId,Provider.of<LocalStorageProvider>(context, listen: false).phoneNumber,).then((value) {

                      Alert(
                        context: context,
                        style: AlertStyle(
                          backgroundColor: Colors.deepOrangeAccent,
                          alertPadding: const EdgeInsets.all(88),
                          isButtonVisible: true,
                          descStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        desc: "Do you want to store order ? ",
                        buttons: [
                          DialogButton(
                            onPressed: () {
                              Provider.of<LocalStorageProvider>(context,listen: false).addOrder( StoreOrderLocally(id:widget.restaurant , item: Order.foodName, price: Order.price,time: DateTime.timestamp().toString()));
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);


                              // print('DATA STORED');
                            },
                            width: 100.w,
                            child: const Text('Yes', style: TextStyle(color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ).show();
                    });
                    Notify(context, 'Thanks for Using MealMate 😊', Colors.green);


                  } else{
                    Notify(context, 'Order Not received yet', Colors.red);
                  }




                }, child: const Text('Order Received', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 1,fontFamily: 'Righteous'),))),


            SizedBox(height: 30.h,)




                ],),
            );}
            }),
          ],
        ),
      ),


    );
  }
}
