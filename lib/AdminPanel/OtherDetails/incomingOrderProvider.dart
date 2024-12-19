import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import 'package:http/http.dart' as http;
import 'package:emailjs/emailjs.dart' as emailjs;


class IncomingOrdersProvider extends ChangeNotifier {
  int OrderedIndex = 0;
  int InCompleteOrderedIndex = 0;
  String TotalPrice = '0.00';

  final _connectivity = Connectivity();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamController<List<OrderInfo>> _ordersController = StreamController<List<OrderInfo>>.broadcast();
  StreamController<List<OrderInfo>> _CompletedordersController = StreamController<List<OrderInfo>>.broadcast();

  IncomingOrdersProviderNotification() {
    _initializeFCM();
  }

  void _initializeFCM() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      // Save the token to your server or use it as needed
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print('Received a message while in the foreground!');
     // print('Message data: ${message.data}');
      if (message.notification != null) {
       _firebaseMessaging.subscribeToTopic('new_order');
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! $message.data');
    });
  }


  void sendEmail(String VendorEmail, String Content) async {
    try {
      await emailjs.send(
        'service_x7yk07n',
        'template_duflkkc',
        {
          'to_email': '$VendorEmail',
          'from_name': 'MealMate',
          'message': 'There is a new Order...',
          'to_name': 'Vendor',
        },
        const emailjs.Options(
            publicKey: 'o59sVSZoIT_TM0LMr',
            privateKey: 'KkaL6qxaFA5k_058CBTVp',
            limitRate: const emailjs.LimitRate(
              //id: 'app',
              throttle: 10000,


            )),
      );
      print('SUCCESS!');
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        print('ERROR... $error');
      }
      print(error.toString());
    }
  }


  Future<bool> _checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Stream<List<OrderInfo>> fetchOrders(String id) {
    _startFetchingOrders(id);
    return _ordersController.stream;
  }

  void _startFetchingOrders(String id) async {
    int retryCount = 0;
    const maxRetries = 1;
    const retryDelay = Duration(seconds: 60);

    while (true) {
      try {
        if (!await _checkConnectivity()) {
          throw SocketException('No internet connection');
        }

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('OrdersCollection')
            .where('vendorId', isEqualTo: id)
            .where('delivered', isEqualTo: false)
            .get();

        List<OrderInfo> orders = snapshot.docs
            .map((doc) {
          try {
            return OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id);

          } catch (e) {
            return null;
          }
        })
            .where((order) => order != null)
            .cast<OrderInfo>()
            .toList();

        if (orders.length > InCompleteOrderedIndex) {
          _firebaseMessaging.subscribeToTopic('new_order');
          //send firebase notification
            _firebaseMessaging.getToken().then((token) {
              //send notification to this token

              print("FCM Token: $token");
              // Save the token to your server or use it as needed
            });
        }

        InCompleteOrderedIndex = orders.length;
        _ordersController.add(orders);

        retryCount = 0;
        await Future.delayed(Duration(seconds: 45));
      } catch (e) {
        if (e is SocketException || e is FirebaseException || e is FormatException) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _ordersController.addError('Failed to fetch orders after $maxRetries attempts');
            return;
          }
          await Future.delayed(retryDelay);
        } else {
          _ordersController.addError('An unexpected error occurred: $e');
          return;
        }
      }
    }
  }


  Stream<List<OrderInfo>> fetchCompleteOrders(String id) {
    _startFetchingCompleteOrders(id);
    return _CompletedordersController.stream;
  }

  void _startFetchingCompleteOrders(String id) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 45);

    while (true) {
      try {
        if (!await _checkConnectivity()) {
          throw SocketException('No internet connection');
        }

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('OrdersCollection')
            .where('vendorId', isEqualTo: id)
            .where('delivered', isEqualTo: true)
            .get();

        List<OrderInfo> orders = snapshot.docs
            .map((doc) {
          try {
            return OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          } catch (e) {
            return null;
          }
        })
            .where((order) => order != null)
            .cast<OrderInfo>()
            .toList();

        OrderedIndex = orders.length;
        _CompletedordersController.add(orders);
        retryCount = 0;
        await Future.delayed(Duration(seconds: 60));
      } catch (e) {
        if (e is SocketException || e is FirebaseException || e is FormatException) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _CompletedordersController.addError('Failed to fetch orders after $maxRetries attempts');
            return;
          }
          await Future.delayed(retryDelay);
        } else {
          _CompletedordersController.addError('An unexpected error occurred: $e');
          return;
        }
      }
    }
  }

  @override
  void dispose() {
    _ordersController.close();
    super.dispose();
  }
}