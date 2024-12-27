import 'dart:ui';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart' as another;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate_ios/Notification/notification_Provider.dart';
import 'package:mealmate_ios/PaymentProvider/payment_provider.dart';
import 'package:mealmate_ios/UserLocation/LocationProvider.dart';
import 'package:provider/provider.dart';
import '../authpages/login.dart';
import '../navpages/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ///check if user is logged in
  ///set this initial to true when testing on simulator since it will not have any user logged in
  bool isLoggedIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future CheckSignedIn() async {
    if (await _googleSignIn.isSignedIn()) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  initState() {
    super.initState();
    CheckSignedIn();

    _requestNotificationPermissions();
    _configureFirebaseListeners();
    _initializeLocalNotifications();
    Provider.of<LocationProvider>(context,listen: false).enableLocation();
    Provider.of<NotificationProvider>(context,listen: false).sendMessageToTopic();

  }

  void _requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission to receive notifications');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        // Handle notification tapped logic here
      },
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      // Handle notification tapped logic here
      // For example, navigate to a specific screen
    });
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotification(message.notification!);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }



  @override
  Widget build(BuildContext context) {
    return another.FlutterSplashScreen(
      duration: const Duration(seconds: 10),
      nextScreen: isLoggedIn ? const Home() : const Login(),
      backgroundColor: Colors.redAccent,
      splashScreenBody: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Meal",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous',
                            ),
                          ),
                          TextSpan(
                            text: "Mate",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: LottieBuilder.asset(
                        'assets/Icon/loading.json',
                        width: 150.w,
                        height: 100.h,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}