import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


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






}
