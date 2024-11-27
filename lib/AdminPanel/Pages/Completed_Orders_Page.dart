import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoFoodFound.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import '../OtherDetails/ID.dart';
import '../OtherDetails/incomingOrderProvider.dart';


class CompletedOrders extends StatefulWidget {
  const CompletedOrders({super.key});

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  @override
  Widget build(BuildContext context) {

    final  adminId = Provider.of<AdminId>(context, listen: false).id;
     String TotalPrice = Provider.of<IncomingOrdersProvider>(context, listen: false).TotalPrice;
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
              TextSpan(text: "Completed", style: TextStyle(color: Colors.black, fontSize: 18.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
              TextSpan(text: "Orders", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 17.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


            ]
        )),
        actions: [
          SizedBox(width: 10.w,),

          RichText(text: TextSpan(
              children: [
                TextSpan(text: "GHC", style: TextStyle(color: Colors.black, fontSize: 15.sp,fontWeight: FontWeight.bold)),
                TextSpan(text:' ${TotalPrice}''', style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
              ]
          )),
          SizedBox(width: 10.w,),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<OrderInfo>>(
          stream: Provider.of<IncomingOrdersProvider>(context, listen: false).fetchCompleteOrders(adminId),
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
                  //function to get the total price of the orders in the list
                  final totalPrice = snapshot.data?.fold(0, (previousValue, element) => previousValue + element.price.toInt());
                  Provider.of<IncomingOrdersProvider>(context, listen: false).TotalPrice = totalPrice.toString();
                  return Badge(
                    alignment: Alignment.topCenter,
                    backgroundColor: Orders.delivered?Colors.green:Colors.red,
                    label: Text(Orders.delivered ? ' Order Completed': 'Incomplete Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'Righteous',),),
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
