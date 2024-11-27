import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/CustomLoading.dart';
import '../../components/NoFoodFound.dart';
import '../../components/cartlist.dart';
import '../../models&ReadCollectionModel/cartmodel.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Favourites',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: [
              Badge(
                backgroundColor: Colors.black,
                label: Consumer<CartModel>(
                    builder: (context, value, child) => Text(
                      value.cart.length.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                child: ImageIcon(
                  AssetImage('assets/Icon/favourite.png'),
                  size: 30,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(
                width: 30,
              )
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: value.cart.isEmpty
                  ? Center(child: EmptyFavourite()) // Display EmptyCollection if cart is empty
                  : ListView.builder(
                  itemCount: value.cart.length,
                  itemBuilder: (context, index) {
                    final CartFood food = value.cart[index];
                    return cartList(
                        food.imgUrl, food.restaurant, food.foodName, food.price, index);
                  }),
            ),
          ),
        ));
  }
}