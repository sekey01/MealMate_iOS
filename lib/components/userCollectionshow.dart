import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

userCollectionItemsRow(item, String collectionImageList) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: GestureDetector(
      child: Container(
        height: 80.h,
        /* decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),*/
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: AssetImage(collectionImageList),
                  height: 30.h,
                  width: 35.w,
                )),
            Text(
              item,
              style: TextStyle(fontSize: 10.sp, color: Colors.black),
            )
          ],
        ),
      ),
    ),
  );
}
