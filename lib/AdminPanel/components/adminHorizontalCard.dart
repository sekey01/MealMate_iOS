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
            height: 160.h,
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
                    width: 20.w,
                  ),
                  Container(
                    height: 200.h,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //Column to Shaow Name OF Restaurant,Food Name, and Price Of the Food
                      children: [
                        SizedBox(
                          height: 5,
                        ),

                        ///Row for restaurant name
                        Text(
                          restaurant,
                          style: TextStyle(
                              fontSize: 10.sp,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
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
                          height: 5.h,
                        ),

                        ///Row for price
                        Text(
                          'GHC $price 0 ',
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
                                  color: Colors.deepOrangeAccent),
                            ),
                          ],
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
                                  fontSize: 8.sp,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            Icon(Icons.payment_outlined,
                                color: Colors.black, size: 10.sp),
                            Text(
                              '  $id',
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

                                  title:
                                  ' Are you sure you want to delete this food ?',

                                  content: Center(
                                    child: CardLoading(
                                        height: 20.h,
                                        child: Consumer<AdminFunctions>(
                                          builder: (context, value, child) =>
                                              TextButton(
                                                  onPressed: () {
                                                    value.deleteItem(
                                                        context, ProductImageUrl);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Yes',style: TextStyle(
                                                    fontFamily: 'Righteous',
                                                    fontWeight: FontWeight.bold,
                                                  ),)),
                                        )),
                                  ),
                                  style: AlertStyle(
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
                                  fontFamily: 'Righteous',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent),
                            )),
                        LiteRollingSwitch(

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