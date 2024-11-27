import 'package:flutter/material.dart';

adminCollectionItemsRow(item) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$item',
            style: TextStyle(
                color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}
