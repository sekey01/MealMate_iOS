import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../theme/styles.dart';


Material verticalCard(
  String productImageUrl,
  String restaurant,
  String foodName,
  double price,
  String location,
  String time,
  String vendorId,
  bool isAvailable,
    String adminEmail,
    int adminContact,
) {
  return Material(
    borderRadius: BorderRadius.circular(10),
    shadowColor: Colors.black,
    color: Colors.black,
    elevation: 3,
    child: Container(
      height: 200.h,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Badge(
              ///BADGE TO DISPLAY DISCOUNT ON FOOD
              alignment: Alignment.topCenter,
              backgroundColor: isAvailable ? Colors.green : Colors.red,
              label: Text(
                isAvailable ? 'Online' : 'UnAvailable',
                style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 8.spMin,
                    fontWeight: FontWeight.bold),
              ),
              child: Container(
                color: Colors.white,
                height: 100.h,
                width: 180.h,
                margin: EdgeInsets.all(5),
                //margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                child: productImageUrl.isEmpty
                    ? Center(
                        child: Icon(
                          ///NO IMAGE ICON WHEN THE IMAGE URL IS EMPTY
                          ///
                          Icons.image_not_supported_outlined,
                          color: Colors.deepOrange,
                          size: 120.spMin,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(productImageUrl),
                          height: 90.h,
                          width: 120.w,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          ///ROW FOR RESTAURANT NAME AND ICON
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///ICON FOR RESTAURANT
                Icon(
                  Icons.food_bank_outlined,
                  color: Colors.redAccent,
                  size: 10.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  ///NAME OF RESTAURANT
                  '$restaurant',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                      fontSize: 9.sp,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),

          ///ROW FOR FOOD NAME AND ICON
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///ICON FOR FOOD
                Icon(
                  Icons.restaurant_outlined,
                  color: Colors.deepOrangeAccent,
                  size: 10.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  ///NAME OF FOOD
                  '$foodName',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                      fontSize: 10.sp,
                      letterSpacing: 2,
                      //fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
///PRICE OF FOD
    RichText(text: TextSpan(
        children: [
          TextSpan(text: "GHC  ", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 10.spMin, fontWeight: FontWeight.bold)),
          TextSpan(text: '$price 0', style: TextStyle(color: Colors.black, fontSize: 10.spMin, fontWeight: FontWeight.bold)),


        ]
    )),

          //Row for location
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.deepOrangeAccent,
                size: 10.h,
              ),
              Text(
                ///LOCATION OF RESTAURANT
                ' $location ',
                style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 10.spMin,
                    overflow: TextOverflow.ellipsis,
                    letterSpacing: 1),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///
              Icon(
                size: 10.spMin,
                Icons.timelapse_rounded,
                color: Colors.deepOrange,
              ),
              Text('  $time  ',
                  style: TextStyle(
                      fontSize: 8.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 10.h,),

              Icon(
                size: 10.spMin,
                Icons.phone_callback_rounded,
                color: Colors.deepOrange,
              ),
              Text(
                /// CONTACT OF VENDOR
                ///
                ' $adminContact',
                style: TextStyle(
                    fontSize: 10.spMin,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

///
///
///
Container NewVerticalCard(
    String productImageUrl,
    String restaurant,
    String foodName,
    double price,
    String location,
    String time,
    String vendorId,
    bool isAvailable,
    String adminEmail,
    int adminContact,
    int maxDistance,
    ) {
  final deliveryFee = (price * 0.2).toStringAsFixed(2);
  return Container(
    height: 200.h,
    width: 250.w,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [

            productImageUrl.isEmpty
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
              child: ImageFiltered(
                imageFilter: isAvailable?ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0) : ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Image(

                  fit: BoxFit.fill,
                  image: NetworkImage(productImageUrl),
            
                  height: 120.h,
                  width: 250.w,
                ),
              ),
            ),

            Positioned(
                right: 15,
                bottom: 10,
                child: Container(
                  height: 30,
                  width: 50,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/Icon/cedi.png'),
                      color: Colors.black,
                      size: 10.sp,
                    ),
                    Text(price.toStringAsFixed(2), style: TextStyle(color: Colors.redAccent, fontSize: 8.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),
                  ],
                ),
              ),
            )),
            Positioned(
                top: 60,
                left: 50,
                bottom: 50,

                child: isAvailable? Text(''):Text(' Food / Courier not available', style: TextStyle(color: Colors.white, fontSize: 10.sp,fontWeight: FontWeight.bold),
            )),

            Positioned(
                top: 10,
                left: 20,
                child: Container(
              height: 25,
              width: 40,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text('- 10%', style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),
            )),
          ],
        ),
        SizedBox(
          height: 2,
        ),
        ///ROW FOR RESTAURANT NAME AND ICON
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            ///NAME OF RESTAURANT
            toTitleCase(restaurant),
            style: TextStyle(

              fontFamily: 'Poppins',
                overflow: TextOverflow.ellipsis,
                fontSize: 12.sp,
                //letterSpacing: 1,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ),

        ///ROW FOR FOOD NAME AND ICON
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             ImageIcon(
                AssetImage('assets/Icon/delivery.png'),
                color: Colors.black,
                size: 20.sp,
             ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                'GH',
                style: TextStyle(
                  fontFamily: 'Righteous',
                  fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12.sp,
                   // letterSpacing: 2,
                    //fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
              ImageIcon(
                AssetImage('assets/Icon/cedi.png'),
                color: Colors.red,
                size: 10.sp,
              ),
              Text(
                '$deliveryFee',
                style: TextStyle(
                 // fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12.sp,
decoration: TextDecoration.lineThrough,
decorationColor: Colors.black,
                    //letterSpacing: 2,
                    //fontWeight: FontWeight.w600,
                    color: Colors.black),

              ),

              SizedBox(
                width: 10.w
              ),
              ImageIcon(
                AssetImage('assets/Icon/clock.png'),
                color: Colors.black,
                size: 20.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                '10-20 mins',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  //fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 10.sp,
                    //letterSpacing: 2,
                    //fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
            ],
          ),
        ),

      ],
    ),
  );
}


/// NO COURIER FOUND WIDGET
///
///
Center NoCouriersFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [


        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Lottie.asset('assets/Icon/courier.json', height: 200.h, width: 200.w),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "No " ,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
              TextSpan(
                text: "Couriers ",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
              TextSpan(
                text: "Available",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),

            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'No courier is available at the moment, please check back later',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
        )
      ],
    ),
  );
}

/// PAYMENT VERIFICATION LOADING
///
///
Center WaitingPayment() {
  Stream<int> countdownTimer(int start) async* {
    for (int i = start; i >= 0; i--) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //logo hewe
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Image.asset('assets/images/logo.png', height: 100.h, width: 150.w),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Lottie.asset('assets/Icon/loading.json', height: 200.h, width: 200.w),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text('Please don\'t leave this page ', style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins'),),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: RichText(textAlign: TextAlign.center,text: TextSpan(
              children: [
                TextSpan(text: " Verifying  ", style: TextStyle(color: Colors.blueGrey, fontSize: 15.sp,fontFamily: 'Righteous')),
                TextSpan(text: "Payment...", style: TextStyle(color: Colors.blueGrey, fontSize: 15.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
                TextSpan(text: "... ", style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp,fontFamily: 'Poppins')),
              ]
          )),
        ),
        StreamBuilder<int>(
          stream: countdownTimer(60), // Countdown from 60 seconds
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                'Wait...',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              );
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(textAlign: TextAlign.center,text: TextSpan(
                    children: [
                      TextSpan(text: " Time Remaining :  ", style: TextStyle(color: Colors.black, fontSize: 10.sp,fontFamily: 'Poppins')),
                      TextSpan(text: "${snapshot.data} seconds \n ", style: TextStyle(color: Colors.red, fontSize: 15.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
                      TextSpan(text: "... ", style: TextStyle(color: Colors.red, fontSize: 10.sp,fontFamily: 'Poppins')),
                    ]
                )),
              );
            } else if (snapshot.data == 0) {
              Navigator.pop(context);
              return Text(
                'Doe: ${snapshot.data}',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              );
            } else {
              return Text(
                'Done!',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              );
            }
          },
        ),
      ],
    ),
  );
}



class InitRow extends StatelessWidget {
  const InitRow({
    super.key, required this.imageUrl, required this.name,
  });
final String imageUrl;
final String name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5),
      child: Container(
        height: 70.h,
        width: 70.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 2,
              //blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 1,right: 1),
              child: ClipRRect(borderRadius:BorderRadius.circular(10) ,child: Image(image: AssetImage(imageUrl),height: 60,width: 50,)),
            ),
            RichText(text: TextSpan(
                children: [
                  TextSpan(text: "$name ", style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
                  TextSpan(text: "...", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 10.sp, fontWeight: FontWeight.bold,fontFamily: 'poppins',)),


                ]
            ))
          ],
        ),
      ),
    );
  }
}
