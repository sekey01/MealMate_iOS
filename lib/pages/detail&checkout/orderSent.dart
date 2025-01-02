import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate_ios/pages/detail&checkout/track_Order.dart';

class OrderSent extends StatefulWidget {
  final String vendorId;
  final DateTime time;
  final String restaurant;
  final adminEmail;
  final adminContact;
  final deliveryFee;
  final isCashOnDelivery;
  final latitude;
  final longitude;
  const OrderSent({super.key,
    required this.vendorId,
    required this.time,
    required this.restaurant,
    required this.adminEmail,
    required this.adminContact,
    required this.deliveryFee,
    required this.isCashOnDelivery,
    required this.latitude,
    required this.longitude,
  } );

  @override
  State<OrderSent> createState() => _OrderSentState();
}

class _OrderSentState extends State<OrderSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Image(image: AssetImage('assets/images/logo.png'), height: 250,width: 150,),

                SizedBox(height: 30,),
                LottieBuilder.asset('assets/Icon/success.json', height: 200, width: 200),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    " Order Sent ...",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Center(child: Text('Please don\'t leave the order tracking page Until order is received ...', style: TextStyle(fontSize: 15.sp,color: Colors.red,),textAlign: TextAlign.center,)),
                SizedBox(
                  height: 30,
                ),
                Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green,
                  elevation: 3,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TrackOrder(
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          isCashOnDelivery:widget.isCashOnDelivery,
                          vendorId: widget.vendorId,
                          time: widget.time,
                          restaurant: widget.restaurant,
                          adminEmail: widget.adminEmail,
                          adminContact: widget.adminContact,
                          deliveryFee: widget.deliveryFee,)));
                      },
                      child: Text(
                        'Track Order Now',
                        style: TextStyle(
                            fontFamily: 'Righteous',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}