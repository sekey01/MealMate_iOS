import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../pages/detail&checkout/detail.dart';

Column horizontalCard(
    String paymentKey,
  bool hasCourier,
  String productImageUrl,
  String restaurant,
  String foodName,
  double price,
  String location,
  String time,
  String id,
    double latitude,
    double longitude,
    String adminEmail,
    int adminContact,
    int maxDistance
    ,String vendorAccount
) {
  return Column(
    children: [
      ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailedCard(
                        paymentKey: paymentKey,
                        hasCourier: hasCourier,
                         productImageUrl: productImageUrl,
                          shopImageUrl: productImageUrl,
                          restaurant: restaurant,
                          foodName: foodName,
                          price: price,
                          location: location,
                          vendorid: id,
                          time: time,
                        latitude:latitude ,
                        longitude: longitude,
                        adminEmail: adminEmail,
                        adminContact: adminContact,
                        maxDistance: maxDistance,
                        vendorAccount: vendorAccount,


                      )));
            },
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(2),
                          color: Colors.white,
                          child: productImageUrl.isEmpty
                              ? Center(
                                  child: Icon(
                                    ///NO IMAGE ICON WHEN THE IMAGE URL IS EMPTY
                                    ///
                                    Icons.image_not_supported_outlined,
                                    color: Colors.deepOrange,
                                    size: 120.sp,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(productImageUrl),
                                    height: 90.sp,
                                    width: 120.sp,
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            //Column to Shaow Name OF Restaurant,Food Name, and Price Of the Food
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),

                              ///Row for restaurant name
                              Text(
                                restaurant,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),

                              ///Row for food name
                              Text(
                                foodName,
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),

                              ///Row for price
                              Text(
                                'GHC ${price}0 ',
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),

                              ///Row for location
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: Colors.deepOrangeAccent, size: 13.sp),
                                  Text(
                                    location,
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: 12.sp,
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              ///Row for time and id
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.timelapse_rounded,
                                      color: Colors.black, size: 10.sp),
                                  Text(
                                    time,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 15.h,
                                  ),
                                  Icon(Icons.payment_outlined,
                                      color: Colors.black, size: 10.sp),
                                  Text(
                                    '  $id',
                                    style: TextStyle(
                                        letterSpacing: 3,
                                        fontSize: 10.sp,
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
        itemCount: 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    ],
  );
}
