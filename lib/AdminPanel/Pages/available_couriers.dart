import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Courier/courier_model.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/Notify.dart';
import '../../components/mainCards/verticalCard.dart';

class CouriersAvailable extends StatefulWidget {
  const CouriersAvailable({super.key});

  @override
  State<CouriersAvailable> createState() => _CouriersAvailableState();
}



List<CourierModel> nearbyCouriers = [];

Future<List<CourierModel>> getNearbyCouriers(BuildContext context, double maxDistance) async {
  List<CourierModel> nearbyCouriers = [];
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('Couriers')
        .where('isCourierOnline', isEqualTo: true)
        .get();

    LatLng currentLocation = await Provider.of<LocationProvider>(context, listen: false).getPoints();

    for (var doc in querySnapshot.docs) {
      CourierModel courier = CourierModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      LatLng courierLocation = LatLng(courier.CourierLatitude, courier.CourierLongitude);
      double distance = Provider.of<LocationProvider>(context, listen: false).calculateDistance(currentLocation, courierLocation);

      if (distance <= Provider.of<LocationProvider>(context, listen: false).distanceRangeToSearch) {
print(courier.CourierLatitude);
        nearbyCouriers.add(courier);

      }
    }

    return nearbyCouriers;
  } catch (e) {
    Notify(context, 'Error retrieving courier details', Colors.red);
    print('Error retrieving courier details: $e');
    return [];
  }
}

//Stream function


class _CouriersAvailableState extends State<CouriersAvailable> {

  late final customMapIcon;
  Future<BitmapDescriptor> _loadCustomIcon(BuildContext context) async {
    final ImageConfiguration configuration = createLocalImageConfiguration(context, size: Size(40, 40));
  //  setState(() async {
     // customMapIcon =  await BitmapDescriptor.asset(configuration, 'assets/Icon/courier.png');
   // });
    return await BitmapDescriptor.asset(configuration, 'assets/Icon/courier.png', imagePixelRatio: 3.5);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCustomIcon(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {

              });
            },
            icon: Icon(Icons.refresh_outlined),
            color: Colors.blueGrey,
          ),
        ],
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Available",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
              TextSpan(
                text: "Couriers",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CourierModel>>(
        future: getNearbyCouriers(context, 20.0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomLoGoLoading(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'No Courier Available',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            List<CourierModel> couriers = snapshot.data!;
            if (couriers.isEmpty) {
              return Center(
                child: Text(
                  'No Courier Available',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: couriers.length,
              itemBuilder: (context, index) {
                CourierModel courier = couriers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey.shade100,
                          Colors.white,

                        ],
                      ),
                      color: Colors.deepOrange.shade100,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30.r,
                            backgroundImage: NetworkImage(courier.CourierPictureUrl),
                          ),
                          title: Text(
                            courier.CourierName,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              fontFamily: 'Righteous',
                            ),
                          ),
                          subtitle: Text(
                            courier.CourierEmail,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          trailing: Lottie.asset('assets/Icon/online.json', height: 50.h, width: 50.w),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Call Or Text the courier if he is on his way to deliver another order or ready to pick up your order',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            ///COURIER VEHICLE
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Vehicle: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Righteous',
                                    ),
                                  ),
                                ),
                                Text(
                                  courier.CourierVehicle,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ///COURIER VEHICLE NUMBER
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Vehicle No: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Righteous',
                                    ),
                                  ),
                                ),
                                Text(
                                  courier.CourierVehicleNumber,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ///COURIER CONTACT
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    EasyLauncher.sendToWhatsApp(
                                      phone: '+233${courier.CourierContact}',
                                      message: 'Hello, Can you deliver my order to a buyer?',
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage('assets/Icon/whatsapp.png'),
                                        height: 30.h,
                                        width: 30.w,
                                      ),
                                      Text(
                                        'Whatsapp',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 30.w),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    EasyLauncher.call(number: courier.CourierContact.toString());
                                  },
                                  child: Text(
                                    'Call Courier',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Righteous',
                                      fontSize: 15.sp,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30.w),
                                GestureDetector(
                                  onTap: () async {
                                    EasyLauncher.sms(number: courier.CourierContact.toString());
                                  },
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage('assets/Icon/sms.png'),
                                        height: 30.h,
                                        width: 30.w,
                                      ),
                                      Text(
                                        'SMS',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No Courier Available',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
          showDragHandle: true, isScrollControlled: true, enableDrag: true, isDismissible: true, shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
              context: context, builder: (context){
            return Container(
              height: 500.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
                child: FutureBuilder<List<CourierModel>>(future: getNearbyCouriers(context, 10),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50.h,),
                            CustomLoGoLoading(),
                            Text('Loading couriers', style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Righteous',
                            ),),
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(child: Text('Error loading icon',));
                      } else if (snapshot.hasData) {
                        final nearbyCouriers = snapshot.data!;

                        return gmaps.GoogleMap(

                          onCameraMove: (gmaps.CameraPosition cameraPosition) {
                            //print(cameraPosition.target);
                          },
                          mapToolbarEnabled: true,

                          mapType: gmaps.MapType.normal,
                          initialCameraPosition: gmaps.CameraPosition(
                            target: gmaps.LatLng(5.6037, -0.1870),
                            zoom: 11.5,
                          ),
                          myLocationButtonEnabled: true,
                          compassEnabled: true,
                          myLocationEnabled: true,

                          markers: nearbyCouriers
                              .map(
                                (courier) => gmaps.Marker(
                              icon: gmaps.AssetMapBitmap('assets/Icon/courier.png',height: 40,width: 40),
                              markerId: gmaps.MarkerId(courier.CourierName),
                              position: gmaps.LatLng(courier.CourierLatitude, courier.CourierLongitude),
                              infoWindow: gmaps.InfoWindow(
                                title: courier.CourierName,
                                snippet: courier.CourierContact.toString(),
                              ),
                            ),
                          )
                              .toSet(),
                        );
                      }
                      return Text('No couriers available', style: TextStyle(
                        color: Colors.black,
                      ),);
                    }
                )
              /*gmaps.GoogleMap(
            initialCameraPosition: gmaps.CameraPosition(
              target: gmaps.LatLng(5.6037, -0.1870),
              zoom: 15,
            ),
            markers: nearbyCouriers
                .map(
                  (courier) => gmaps.Marker(
                icon: customMapIcon,
                markerId: gmaps.MarkerId(courier.CourierName),
                position: gmaps.LatLng(courier.CourierLatitude, courier.CourierLongitude),
                infoWindow: gmaps.InfoWindow(
                  title: courier.CourierName,
                  snippet: courier.CourierContact.toString(),
                ),
              ),
            )
                .toSet(),
          )*/
            );
          });
        },
        backgroundColor: Colors.black,
        child: Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.map_outlined, color: Colors.white, size: 30.sp,),
        ),
      ),

    );
  }
}