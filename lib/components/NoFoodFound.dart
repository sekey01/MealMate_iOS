import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Container noFoodFound() {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: 80.h,
        ),
        Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 150, width: 200,),
        SizedBox(
          height: 20.h,
        ),
    RichText(text: TextSpan(
        children: [
          TextSpan(text: " No Product", style: TextStyle(color: Colors.black, fontSize: 20.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
          TextSpan(text: " Found", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),


        ]
    )),
      ],
    ),
  );
}

Container EmptyHistory() {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
      Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 150, width: 200,),
        SizedBox(
          height: 10.h,
        ),
        RichText(text: TextSpan(
            children: [
              TextSpan(text: " Empty", style: TextStyle(color: Colors.black, fontSize: 20.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
              TextSpan(text: " History", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
            ]
        )),      ],
    ),
  );
}

Container EmptyFavourite() {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: 100.h,
        ),
        Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 150, width: 200,),
        SizedBox(
          height: 10.h,
        ),
        RichText(text: TextSpan(
            children: [
              TextSpan(text: " Empty", style: TextStyle(color: Colors.black, fontSize: 20.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
              TextSpan(text: " Favourites", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
            ]
        )),      ],
    ),
  );
}

Container EmptySimilarProducts(){
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 150.h, width: 150.w,),

      ],
    ),
  );
}