import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoFoodFound.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import '../OtherDetails/AdminFunctionsProvider.dart';
import '../OtherDetails/ID.dart';
import '../OtherDetails/incomingOrderProvider.dart';

class IncomingOrders extends StatefulWidget {
  const IncomingOrders({super.key});

  @override
  State<IncomingOrders> createState() => _IncomingOrdersState();
}

class _IncomingOrdersState extends State<IncomingOrders> {
  final Completer<GoogleMapController> _Usercontroller = Completer<GoogleMapController>();
  final formKey = GlobalKey<FormState>();
  final courierIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String adminId = Provider.of<AdminId>(context, listen: false).id;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 3,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios), color: Colors.blueGrey,),
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  RichText(text: TextSpan(
            children: [
              TextSpan(text: "InComing", style: TextStyle(color: Colors.black, fontSize: 20.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
              TextSpan(text: "Orders", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


            ]
        )),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {}); // Refresh the page
            },
            icon: ImageIcon(AssetImage('assets/Icon/refresh.png'), color: Colors.blueGrey,size:30,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<OrderInfo>>(
          stream: Provider.of<IncomingOrdersProvider>(context, listen: false).fetchOrders(adminId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: NewSearchLoadingOutLook(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Center(child: Text('Error: Try again later')));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: noFoodFound(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final Orders = snapshot.data![index];
                  return Badge(
                    alignment: Alignment.topCenter,
                    backgroundColor: Orders.delivered?Colors.green:Colors.red,
                    label: Text(Orders.delivered?' Order Completed': 'Incomplete Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'Righteous',),),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Orders.delivered ? Colors.green : Colors.red,
                        shadowColor: Colors.green,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ExpansionTile(leading: RichText(text: TextSpan(
                              children: [
                                TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 15.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                                TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.spMin,fontWeight: FontWeight.bold, fontFamily: 'Righteous',)),


                              ]
                          )),
                            shape: Border.all(color: Colors.black),
                            textColor: Colors.black,
                            collapsedBackgroundColor: Colors.white,
                            collapsedTextColor: Colors.black,
                            backgroundColor: Colors.white,
                            trailing: Text(
                              "Quantity: ${Orders.quantity}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Righteous',
                              ),
                            ),
                            title: Text(
                              ' ${Orders.foodName} ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10.sp),
                            ),
                            subtitle: Text(
                              '${Orders.time}',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10.sp),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: FutureBuilder(
                                    future: Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .getAddressFromLatLng(Orders.Latitude, Orders.Longitude),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                    
                                        return Text(snapshot.data.toString(),
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold


                      ,
                                                fontSize: 10.sp));
                                      }
                                      return Text(
                                        'Getting location of buyer...',
                                        style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp),
                                      );
                                    }),
                              ),
                              ListTile(

                                trailing: Text(
                                  '${Orders.vendorId}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                      color: Colors.black,
                                  fontStyle: FontStyle.italic),
                                ),
                                title: Text('Latitude : '' ${Orders.Latitude.toString()}' ,style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                                subtitle: Text('Longitude  : ''${Orders.Longitude.toString()}', style: TextStyle(color: Colors.black, fontSize: 15.sp,fontWeight: FontWeight.bold)),

                              ),
                              ListTile(
                                titleTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                title: GestureDetector(
                                  onTap: () async{
                                    /// This function will take the Buyer's phone number and call the buyer
                                    await EasyLauncher.call(number: Orders.phoneNumber.toString());
                                  },
                                  child: Text('Buyer Tel:  ''${Orders.phoneNumber}',
                                    style: TextStyle(color: Colors.black, fontSize: 12.sp, ),
                                  ),
                                ),
                                subtitle: Text(
                                  'Comment : ''${Orders.message}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10.spMin),
                                ),
                                trailing: Text(
                                  'Total Price: GHC${Orders.price}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.spMin,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ///GOOGLE MAP HERE 
                              ///
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    height: 250.spMin,
                                    width: double.infinity,
                                    child: GoogleMap(
                                      markers: {
                                        Marker(
                                            markerId: MarkerId('User'),
                                            visible: true,
                                            position: LatLng(
                                                Orders.Latitude, Orders.Longitude
                                                ))
                                      },
                                      //liteModeEnabled: true,
                                      compassEnabled: true,
                                      mapToolbarEnabled: true,
                                      padding: EdgeInsets.all(12),
                                      scrollGesturesEnabled: true,
                                      zoomControlsEnabled: true,
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: true,
                                      mapType: MapType.normal,
                                      onMapCreated: (GoogleMapController controller) {
                                        _Usercontroller.complete(_Usercontroller
                                            as FutureOr<GoogleMapController>?);
                                      },
                                      gestureRecognizers: Set(),
                                      initialCameraPosition: CameraPosition(
                                        bearing: 192.8334901395799,
                                        target: LatLng(
                                          Orders.Latitude,
                                          Orders.Longitude,
                                        ),
                                        tilt: 9.440717697143555,
                                        zoom: 11.151926040649414,
                                      ),
                                    )),
                              ),
                    SizedBox(height: 10,),

                    //TEXTFIEILD TO TAKE COURIER ID
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: formKey,

                                  child: TextFormField(
                                    controller: courierIdController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter Courier ID';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Courier ID',
                                      labelText: 'Courier ID',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,

                                    onChanged: (value){
                                      if (formKey.currentState!.validate()) {
                                        Provider.of<AdminFunctions>(context, listen: false).UpdateCourier(context, Orders.vendorId, Orders.phoneNumber,int.parse(value));
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (formKey.currentState!.validate()) {
                                        Provider.of<AdminFunctions>(context, listen: false).UpdateCourier(context, Orders.vendorId, Orders.phoneNumber,int.parse(value));
                                                }
                                    },

                                  ),
                                ),
                              ),




                    /// ROW FOR SERVED AND COURIER
                              ///
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        LiteRollingSwitch(
                          //initial value
                          value: Orders.served,
                          width: 120.spMin,
                          textOn: 'Served',
                          textOnColor: Colors.white,
                          textOff: 'Not-Served',
                          textOffColor: Colors.white,
                          colorOn: CupertinoColors.activeGreen,
                          colorOff: Colors.redAccent,
                          iconOn: Icons.done,
                          iconOff: Icons.remove_circle_outline,
                          textSize: 8.0,
                          onChanged: (bool state) {
                            //print('Served');
                            Provider.of<AdminFunctions>(context, listen: false).switchServedFood(context,Orders.vendorId , Orders.phoneNumber, state,);
                 //   print(Orders.vendorId);
                 //   print(Orders.phoneNumber);
                            ///Use it to manage the different states
                            //print('Current State of SWITCH IS: $state');
                          },
                          onTap: () {
                          },
                          onDoubleTap: () {},
                          onSwipe: () {},
                        ), LiteRollingSwitch(
                          //initial value
                          value: Orders.courier,
                          width: 120.spMin,
                          textOn: 'Courier',
                          textOnColor: Colors.white,
                          textOff: 'N-Courier',
                          textOffColor: Colors.white,
                          colorOn: CupertinoColors.activeGreen,
                          colorOff: Colors.redAccent,
                          iconOn: Icons.done,
                          iconOff: Icons.remove_circle_outline,
                          textSize: 8.0,
                          onChanged: (bool state) {

                            if(formKey.currentState!.validate()){

                              Provider.of<AdminFunctions>(context, listen: false).switchIsGivenToCourierState(context,Orders.vendorId , Orders.phoneNumber, state, Orders.time).then((_){
                                Provider.of<AdminFunctions>(context, listen: false).UpdateCourier(context, Orders.vendorId, Orders.phoneNumber,int.parse(courierIdController.text));
                              });
                              print('Given to Courier');
                              courierIdController.clear();
                            }



                            ///Use it to manage the different states
                            //print('Current State of SWITCH IS: $state');
                          },
                          onTap: () {
                          },
                          onDoubleTap: () {},
                          onSwipe: () {},
                        ),
                      ],),
                    ),
                    
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
