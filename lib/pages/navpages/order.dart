import 'dart:convert';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import '../../components/NoFoodFound.dart';
import '../../components/mainCards/mealPayCard.dart';
import '../detail&checkout/orderSent.dart';


class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Order List'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Righteous',
          color: Colors.blueGrey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
        backgroundColor: Colors.white,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              height: 25.h,
              width: 80.w,
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Handle deposit to wallet
                  });
                },
                child: Text(
                  'Deposit +',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MatePayCard(
                  'Coming Soon',
                  ' XXXX - 0123',
                  Provider.of<LocalStorageProvider>(context, listen: true).userName,
                  Provider.of<LocalStorageProvider>(context, listen: true).phoneNumber.toString(),
                  '0.00',
                ),
              );
            }),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Meal",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Righteous',
                        ),
                      ),
                      TextSpan(
                        text: "Mate",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Righteous',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),

                Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // Handle delete all
                      });
                    },
                    child: Text(
                      'Delete all',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 250.h,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),

          ),
        ),
        child: Expanded(
          child: FutureBuilder<List<StoreOrderLocally>>(
            future: Provider.of<LocalStorageProvider>(context, listen: true).loadOrders(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final storedOrder = snapshot.data![index];
                    final storedOrderNumber = index + 1;
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          iconColor: Colors.black,
                          collapsedBackgroundColor: Colors.grey.shade200,
                          leading: Text(
                            'Order : $storedOrderNumber',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.spMin,
                            ),
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Meal",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.spMin,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "Mate",
                                  style: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: 15.spMin,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          children: [
                            Text(
                              storedOrder.item,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.spMin,
                              ),
                            ),
                            Text(
                              storedOrder.id,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.spMin,
                              ),
                            ),
                            Text(
                              'GHC ${storedOrder.price.toString()}0',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.spMin,
                              ),
                            ),
                            Text(
                              storedOrder.time.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.spMin,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EmptyHistory(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}