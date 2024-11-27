import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

Widget NoInternetConnection() {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/Icon/no_internet.json',height: 130,width: 200,),
          SizedBox(height: 20.h,),
  Text( "Unstable Internet Connection ", style: TextStyle(color: Colors.red, fontSize: 15.sp, fontWeight: FontWeight.normal, fontFamily: 'Righteous'),),
          SizedBox(height: 10.h,),
          Text( "Please check your internet connection and try again", style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),)
  ,
        ],
      ),
    ),
  );
}
