import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NetworkImages {
  final String imageUrl;
  final String identifier;


  NetworkImages({
    required this.imageUrl,
    required this.identifier
  });

  // Factory method to create a Notification from a Map
  factory NetworkImages.fromFactory(Map<String, dynamic> data) {

    return NetworkImages(
      imageUrl: data['imageUrl'] ?? '', // Ensure 'message' key matches your data source
      identifier: data['identifier']?? ''
    );
  }
}

class NetworkImageProvider extends ChangeNotifier{

  Future<Object> getUserNetworkImage(String name) async {

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('NetworkImages')
      .where('identifier', isEqualTo: '$name')
          .get();

    final  image = snapshot.docs.map((doc) => NetworkImages.fromFactory(doc.data() as Map<String, dynamic>)).toString();

    return image;

    } catch (e) {

      print(e.toString());

      return [];
    }
  }
}