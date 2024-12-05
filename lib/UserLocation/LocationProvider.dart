import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  final int distanceRangeToSearch = 100000000;
  final String googleMapsApiKey = 'AIzaSyCO2v58cOsSM5IKXwyGa172U_YHrmRK9ks';
   double Lat = 0.0 ;
   double Long = 0.0;

  Future<String> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    /* print(position.longitude);
    print(position.latitude);*/

    // Get the address from the coordinates using Google Maps API
    String location = await getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    //print(location);

    return location;
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    Lat = lat;
    Long = lng;
    /* print(Lat);
    print(Long);*/

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final String address = data['results'][0]['formatted_address'] +
            '  ' +
            data['results'][0]['address_components'][1]['long_name'];

        return address;
      } else {
        return 'No address available';
      }
    } else {
      return 'Failed to get address';
    }
  }





  bool isFareDistance = true;
  late double Distance;

  double calculateDistance(LatLng point1, LatLng point2) {
    const double R = 6371; // Radius of the Earth in kilometers

    // Convert degrees to radians
    double lat1Rad = point1.latitude * pi / 180;
    double lon1Rad = point1.longitude * pi / 180;
    double lat2Rad = point2.latitude * pi / 180;
    double lon2Rad = point2.longitude * pi / 180;

    // Differences in coordinates
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    // Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    double distance = R * c;
    Distance = distance;
    //print('Distance is $Distance km');

    if (distance > 30) {
      isFareDistance = false;
     // print('Greater than 30km');
    } else {
      isFareDistance = true;
      //print('Less than 30km');
    }

    return distance;
  }


  Future<LatLng> getPoints() async {
    await determinePosition();
    return LatLng(Lat, Long);}




  //// GETING THE ROUTE BETWEEN VENDOR AND CUSTOMER
  Future<List<LatLng>> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$googleMapsApiKey';
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    List<LatLng> points = [];
    if (values["status"] == "REQUEST_DENIED") {
      print("API key is invalid");
    } else {
      values["routes"].forEach((route) {
        route["legs"].forEach((leg) {
          leg["steps"].forEach((step) {
            points.add(LatLng(step["start_location"]["lat"], step["start_location"]["lng"]));
            points.add(LatLng(step["end_location"]["lat"], step["end_location"]["lng"]));
          });
        });
      });
    }
    return points;
  }



  Future<void> enableLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
      return;
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isLocationServiceEnabled) {
        await Geolocator.openLocationSettings();
      }
    }
  }



}


