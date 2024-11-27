import 'package:flutter/material.dart';

void Notify(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 20,
      content: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),
        ),
      ),
      backgroundColor: color,
    ),
  );
}

void NoInternetNotify(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(

    SnackBar(
      dismissDirection: DismissDirection.startToEnd,

      duration: Duration(seconds: 15),
      elevation: 20,
      content: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),
        ),
      ),
      backgroundColor: color,

    ),
  );
}
