import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../OtherDetails/AdminFunctionsProvider.dart';

ListView adminHorizontalCard(String ProductImageUrl, String restaurant, String location,
    String foodName, double price, String id, String time, bool isAvailable) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 140.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Badge(
                    alignment: Alignment.topCenter,
                    textStyle:
                    TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                    textColor: Colors.white,
                    label: Text(
                      (isAvailable) ? 'Online' : 'Not Available',
                    ),
                    backgroundColor: (isAvailable) ? Colors.green : Colors.red,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      color: Colors.white,

                      ///I CHECKED WHETHERE THE IMAGE URL IS EMPTY AND INDICATE THE UPLOADER
                      ///
                      ///
                      child: ProductImageUrl.isEmpty
                          ? Center(
                        child: Icon(
                          ///NO IMAGE ICON WHEN THE IMAGE URL IS EMPTY
                          ///
                          Icons.image_not_supported_outlined,
                          color: Colors.deepOrange,
                          size: 100.sp,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(ProductImageUrl),
                          height: 100.h,
                          width: 150.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Container(
                    height: 150.h,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //Column to Shaow Name OF Restaurant,Food Name, and Price Of the Food
                      children: [


                        ///Row for food name
                        Text(
                          foodName,
                          style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),

                        ///Row for price
                        Text(
                          'GHC${price.toStringAsFixed(2)} ',
                          style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87),
                        ),


                        ///Row for location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.deepOrangeAccent, size: 10.sp),
                            Text(
                              location,
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),


                        ///THE BUTTON THAT DELETES THE FOOD ITEM
                        ///
                        ///
                        TextButton(
                            onPressed: () {
                              Alert(
                                  context: context,
                                  // type: AlertType.warning,

                                  title: 'Delete Item ? ' ,

                                  content: Center(
                                    child: Consumer<AdminFunctions>(
                                      builder: (context, value, child) =>
                                          TextButton(
                                              onPressed: () {
                                                value.deleteItem(
                                                    context, ProductImageUrl);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes',style: TextStyle(

                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                              ),)),
                                    ),
                                  ),
                                  style: AlertStyle(
                                      titleStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),

                                      animationDuration:
                                      Duration(milliseconds: 500),
                                      alertPadding: EdgeInsets.all(66),
                                      backgroundColor: Colors.white,
                                      animationType: AnimationType.shrink))
                                  .show();
                            },
                            child: Text(
                              'Remove Item',
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 10.sp,
                                  fontFamily: 'Righteous',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                            )),
                        LiteRollingSwitch(
                          width: 100.w,
                          textOnColor: Colors.white,
                          textOn: 'Online',
                          textOff: 'Offline',
                          colorOn: (isAvailable) ? Colors.green : Colors.red,
                          value: isAvailable,
                          onTap: (){},
                          onSwipe: (){},
                          onChanged: (value){

                            Provider.of<AdminFunctions>(context, listen: false).SwitchSingleFoodItem(context, id, ProductImageUrl,value );
                            print(value);

                          },
                          onDoubleTap: (){},
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    },
    itemCount: 1,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
  );
}