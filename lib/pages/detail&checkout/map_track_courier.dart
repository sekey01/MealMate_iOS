import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';

class TrackCourierMap extends StatefulWidget {
  final double courierLatitude;
  final double courierLongitude;

  TrackCourierMap({required this.courierLatitude, required this.courierLongitude});

  @override
  _TrackCourierMapState createState() => _TrackCourierMapState();
}

class _TrackCourierMapState extends State<TrackCourierMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<LatLng> _routes = <LatLng>[];
  final BitmapDescriptor customMapIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: RichText(text: TextSpan(
                children: [
                  TextSpan(text: "Map-Track", style: TextStyle(color: Colors.black, fontSize: 21.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                  TextSpan(text: "Courier", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 21.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


                ]
            )),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 800.h,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FutureBuilder(
                  future: Provider.of<LocationProvider>(context, listen: false).determinePosition(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Provider.of<LocationProvider>(context, listen: false).calculateDistance(
                        LatLng(widget.courierLatitude, widget.courierLongitude),
                        LatLng(
                          Provider.of<LocationProvider>(context, listen: false).Lat,
                          Provider.of<LocationProvider>(context, listen: false).Long,
                        ),
                      );

                      return GoogleMap(
                        onTap: (argument) {
                          setState(() {
                            Provider.of<LocationProvider>(context, listen: false).Lat = argument.latitude;
                            Provider.of<LocationProvider>(context, listen: false).Long = argument.longitude;
                          });
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('Vendor'),
                            visible: true,
                            icon: customMapIcon,
                            infoWindow: InfoWindow(
                              title: 'Courier\'s Location',
                              snippet: 'Distance: ${Provider.of<LocationProvider>(context, listen: false).Distance.toStringAsFixed(3)} km',
                            ),
                            position: LatLng(widget.courierLatitude, widget.courierLongitude),
                          ),
                          Marker(
                            markerId: const MarkerId('User'),
                            visible: true,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                            infoWindow: InfoWindow(
                              title: 'Your Location',
                              snippet: 'Distance: ${Provider.of<LocationProvider>(context, listen: false).Distance.toStringAsFixed(3)} km',
                            ),
                            position: LatLng(
                              Provider.of<LocationProvider>(context, listen: false).Lat,
                              Provider.of<LocationProvider>(context, listen: false).Long,
                            ),
                          ),
                        },
                        circles: Set(),
                        polylines: Set<Polyline>.of(<Polyline>{
                          Polyline(
                            polylineId: const PolylineId('polyline_id'),
                            points: _routes,
                            color: Colors.red,
                            width: 5,
                          ),
                        }),
                        mapToolbarEnabled: true,
                        padding: const EdgeInsets.all(12),
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        fortyFiveDegreeImageryEnabled: true,
                        cloudMapId: 'mapId',
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        initialCameraPosition: CameraPosition(
                          bearing: 192.8334901395798,
                          target: LatLng(
                            Provider.of<LocationProvider>(context, listen: false).Lat,
                            Provider.of<LocationProvider>(context, listen: false).Long,
                          ),
                          tilt: 9.440717697143555,
                          zoom: 11.151926040649414,
                        ),
                      );
                    }
                    return const Center(child: CustomLoGoLoading());
                  },
                ),
              ),
            ),
          ) ,
        );

  }
}