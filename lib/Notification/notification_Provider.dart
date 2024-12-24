import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Notification {
  final String notification;
  final String time;

  Notification({
    required this.notification,
    required this.time
  });

  // Factory method to create a Notification from a Map
  factory Notification.fromFactory(Map<String, dynamic> data) {
    return Notification(
      notification: data['notification'] ?? '', // Ensure 'message' key matches your data source
      time: data['time'] ?? '' ,
    );
  }
}

class NotificationProvider extends ChangeNotifier{

  int userNotificationLength = 0 ;
  int adminNotificationLength = 0 ;


  Future<List<Notification>> getUserNotifications() async {

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Notifications')
          .get();

      List<Notification> notifications = snapshot.docs
          .map((doc) => Notification.fromFactory(doc.data() as Map<String, dynamic>))
          .toList();
      userNotificationLength = notifications.length;
      return notifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }


  Future<List<Notification>> getAdminNotifications() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('AdminNotifications')
          .get();

      List<Notification> adminNotifications = snapshot.docs
          .map((doc) => Notification.fromFactory(doc.data() as Map<String, dynamic>))
          .toList();

      adminNotificationLength = adminNotifications.length;
      return adminNotifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }


  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      print('Subscribed to $topic');
    } catch (e) {
      print('Failed to subscribe to $topic: $e');
    }
  }

  Future<void> sendMessageToTopic() async{
    try{

      await FirebaseMessaging.instance.sendMessage(
        to: 'all_users',
        data: {
          'title': 'New Notification',
          'body': 'New Notification',
        },

      );
      print('Message sent');
    }catch(e){
      debugPrint(e.toString());
    }
  }




  //send message with mNotify
  Future<void> sendSms(String to, String content) async {
    final String url = '${dotenv.env['SMS_URL']}';
    final String apiKey = '${dotenv.env['SMS_API_KEY']}';
    final String toNumber = to;
    final String message = content;
    final String senderId = 'MealMate';

    final Uri uri = Uri.parse('$url?key=$apiKey&to=$toNumber&msg=${Uri.encodeComponent(message)}&sender_id=$senderId');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        print('Message sent successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to send message: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

}

