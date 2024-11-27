import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models&ReadCollectionModel/cartmodel.dart';
import '../pages/searchfooditem/init_row_search.dart';
Padding cartList(
    String imgUrl, String restaurant, String foodName, double price, int index) {
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: ExpansionTile(
      minTileHeight: 70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textColor: Colors.black,
      collapsedBackgroundColor: Colors.deepOrange.shade50,
      collapsedTextColor: Colors.black,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.blueGrey.shade50,
      leading: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            imgUrl,
            height: 60,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
      ),
      title: Text(
        ' $restaurant ',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp, fontFamily: 'Poppins'),
      ),
      subtitle: Text(
        '$foodName',
        style: TextStyle(
            fontWeight: FontWeight.w300, fontSize: 10, fontFamily: 'Poppins'),
      ),
      children: <Widget>[
        Consumer<CartModel>(builder: (context, value, child) {
          return ListTile(
            subtitle: IconButton(
              onPressed: () {
                value.removeAt(index);
              },
              icon: Text(
                'Remove',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            title: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => InitRowSearch(searchItem: foodName,)));
              },
              icon: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 110.w,),
                  Text('Buy now', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                  Icon(Icons.ads_click_outlined, color: Colors.deepOrangeAccent, size: 20.sp,)
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );
}