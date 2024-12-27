import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate_ios/AdminPanel/Pages/uploads.dart';
import 'package:provider/provider.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../Notification/notification_Provider.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/CustomLoading.dart';
import '../../components/NoInternet.dart';
import '../../components/Notify.dart';
import '../../components/mainCards/promotion_ads_card.dart';
import '../OtherDetails/AdminFunctionsProvider.dart';
import '../OtherDetails/ID.dart';
import '../OtherDetails/incomingOrderProvider.dart';
import '../collectionUploadModelProvider/collectionProvider.dart';
import '../components/ChangeIDofAdmin.dart';
import '../components/adminCollectionRow.dart';
import 'Completed_Orders_Page.dart';
import 'IncomingOrdersPage.dart';
import 'UploadModel.dart';
import 'adminNotificationPage.dart';
import 'available_couriers.dart';

class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController foodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController adminContactController = TextEditingController();
  TextEditingController paymentKeyController = TextEditingController();

  int maxDistance = 0;
  bool hasCourier = false;
  late int numberOfOrders;

  File? _productImage;
  File? _shopImage;
  String shopImageUrl = '';
  String productImageUrl = '';

  ///PROFILE IMAGE PICKER  HERE
  Future<void> _pickProductImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });

      try {
        String fileName =
            '${DateTime.timestamp().toString()}/${DateTime.now().microsecondsSinceEpoch}';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(File(_productImage!.path));
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          productImageUrl = downloadUrl;

          print(productImageUrl);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 20.sp,
          content: Center(
            child: Text(
              '$e',
              style: TextStyle(color: Colors.deepOrange, fontSize: 20),
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
        ));
        // if (kDebugMode) {
        //   print("Failed to upload image: $e");
        // }
      }
    }
  }

  ///ID CARD IMAGE PICKER
  Future<void> _pickShopImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _shopImage = File(pickedFile.path);
      });

      try {
        String fileName =
            '${DateTime.timestamp().toString()}/${DateTime.now().microsecondsSinceEpoch}';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(File(_shopImage!.path));
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          shopImageUrl = downloadUrl;

          print(shopImageUrl);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 20.sp,
          content: Center(
            child: Text(
              '$e',
              style: TextStyle(color: Colors.deepOrange, fontSize: 20),
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
        ));
        // if (kDebugMode) {
        //   print("Failed to upload image: $e");
        // }
      }
    }
  }

  /// UPLOAD FOOD ITEMS FUNCTION HERE
  Future<void> uploadFood(UploadModel food) async {
    try {
      _isLoading = true;

      final db = FirebaseFirestore.instance.collection(
          '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');
      await db.add(food.toMap());
      Notify(context, 'Item Uploaded Successfully', Colors.green);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ///print(e.toString());
      Notify(context, 'Upload Unsuccessful', Colors.red);
    }
  }

  ///BOOL TO CHECK FOR INTERNET
  ///
  bool _hasInternet = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NotificationProvider>(context, listen: false)
        .subscribeToTopic('vendors');
  }

  Widget build(BuildContext context) {
    //   Provider.of<IncomingOrdersProvider>(context,listen: false).sendMessageToToken( 'title', 'body');

    // Provider.of<IncomingOrdersProvider>(context,listen: false).IncomingOrdersProviderNotification();
    final String adminId = Provider.of<AdminId>(context, listen: false).adminID;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Welcome",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  )),
              TextSpan(
                text: "",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ])),

        // centerTitle: true,
        elevation: 3,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IncomingOrders()));
            },
            child: Badge(
              backgroundColor: Colors.green,
              label: StreamBuilder(
                  stream: Provider.of<IncomingOrdersProvider>(context,
                          listen: false)
                      .fetchOrders(adminId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text(
                          'Updating',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 8.sp,
                              fontStyle: FontStyle.italic),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Center(
                              child: Text(
                        '🔃',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      )));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No Order Detected',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 8.sp,
                              fontStyle: FontStyle.italic),
                        ),
                      );
                    } else {
                      return Text(
                        snapshot.data!.length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp),
                      );
                    }
                  }),
              child: ImageIcon(
                AssetImage('assets/Icon/Order.png'),
                size: 25.sp,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// ICON BUTTON TO SHOW THE LIST OF COMPLETED ORDERS
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompletedOrders()));
                },
                child: Badge(
                  backgroundColor: Colors.green,
                  label: StreamBuilder(
                      stream: Provider.of<IncomingOrdersProvider>(context,
                              listen: false)
                          .fetchCompleteOrders(adminId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text(
                              '...',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8.sp,
                                  fontStyle: FontStyle.italic),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Center(
                                  child: Text(
                            '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          )));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8.sp,
                                  fontStyle: FontStyle.italic),
                            ),
                          );
                        } else {
                          return Text(
                            snapshot.data!.length.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp),
                          );
                        }
                      }),
                  child: Image(image: AssetImage('assets/Icon/Orders.png'),
                    height: 25.h,width: 25.w,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),

              /// ICON BUTTON TO SHOW THE LIST OF ADMINS UPLOADS
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Uploaded()));
                },
                icon: ImageIcon(
                  AssetImage('assets/Icon/uploads.png'),
                  size: 24.sp,
                  color: Colors.redAccent,
                ),
              ),



              ///ICON BUTTON CHANGE THE ID OF ADMIN
              /// IT OPENS BUTTOMSHEETVIEW TO CHANGE THE ID
              ///
              ///
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeAdminCredentials()));
                },
                icon: Icon(
                  Icons.edit_note,
                  color: Colors.blueGrey,
                  size: 30.sp,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ///LOCATION OF THE ADMIN
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage('assets/Icon/map.png'),
                          height: 20.h,
                          width: 20.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                              future: Provider.of<LocationProvider>(context,
                                  listen: false)
                                  .determinePosition(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString(),
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.sp));
                                }
                                return Text(
                                  'locating you...',
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 10.spMin,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),

              ///ROW OF BUTTONS TO SHOW THE ONLINE STATUS OF THE FOOD
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Column(
                       children: [

                         ///TOGGLE BUTTON TO SHOW FOOD IS ONLINE
                         _hasInternet
                             ? LiteRollingSwitch(
                           //initial value
                           value: false,
                           width: 100.w,
                           textOn: 'Online',
                           textOnColor: Colors.white,
                           textOff: 'Offline',
                           textOffColor: Colors.white,
                           colorOn: CupertinoColors.activeGreen,
                           colorOff: Colors.redAccent,
                           iconOn: Icons.done,
                           iconOff: Icons.remove_circle_outline,
                           textSize: 12.0,
                           onChanged: (bool state) {
                             /// print(Provider.of<AdminId>(context, listen: false).id);

                             setState(() {
                               //  Provider.of<IncomingOrdersProvider>(context, listen: false).fetchOrders(Provider.of<AdminId>(context).id);

                               Provider.of<AdminFunctions>(context, listen: false)
                                   .SwitchAllState(
                                   context,
                                   Provider.of<AdminId>(context, listen: false)
                                       .id,
                                   state);
                             });

                             ///Use it to manage the different states
                             //print('Current State of SWITCH IS: $state');
                           },
                           onTap: () {},
                           onDoubleTap: () {},
                           onSwipe: () {},
                         )
                             : NoInternetConnection(),
                         Text(
                           'Restaurant Online Status',
                           style: TextStyle(color: Colors.black, fontSize: 8.sp),
                         ),
                       ],
                     ),
                     Column(
                       children: [
                         InkWell(
                           onTap: () {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => CouriersAvailable()));
                           },
                           child: Badge(
                             backgroundColor: Colors.green,
                             label: Lottie.asset('assets/Icon/online.json',
                                 height: 20.h, width: 20.w),
                             child: ImageIcon(
                                AssetImage('assets/Icon/courier.png'),
                                size: 50.sp,
                                color: Colors.black,
                             ),
                           ),
                         ),
                          Text(
                            'Available Couriers',
                            style: TextStyle(color: Colors.black, fontSize: 8.sp),
                          ),
                       ],
                     ),

                   ],
                 ),




                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Upload Food Items Bellow',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.blueGrey,
                      fontFamily: 'Righteous'),
                ),

                /*  _isLoading ? NewSearchLoadingOutLook() : initAdminCard(),*/
                SizedBox(
                  height: 10.h,
                ),


                ///IMAGE PICKER (SHOP PICTURE AND ID CARD)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///PICK YOUR IMAGE OF THE PRODUCT
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickProductImage();

                              ///IMAGE PICKER FUNCTION HERE
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _productImage != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image.file(
                                            height: 50.h,
                                            width: 50.h,
                                            _productImage!,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image(
                                            image: const AssetImage(
                                                'assets/Icon/restaurant.png'),
                                            height: 50.h,
                                            width: 50.h,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Text('Product Image',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickShopImage();

                              ///IMAGE PICKER FUNCTION HERE
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(35),
                                color: Colors.white,
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: _shopImage != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Image.file(
                                              height: 50.h,
                                              width: 50.w,
                                              _shopImage!,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Image(
                                              image: const AssetImage(
                                                  'assets/Icon/VendorLocation.png'),
                                              height: 50.h,
                                              width: 50.h,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text('Shop Image',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  /// COLUMN THAT TAKES ALL THE TEXTFIELDS
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),

                            ///TEXTFIELD FOR MERCHANT ID
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                controller: idController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  labelText: 'Vendor ID',
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Vendor ID',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter ID';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            ///PAYMENT KEY/ACCOUNT
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                controller: paymentKeyController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  labelText: 'Payment Key',
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Payment Key',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Payment Key';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(
                              height: 20.h,
                            ),

                            ///TEXTFIELD FOR MERCHANT ADMINCONTACT
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                controller: adminContactController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  labelText: 'Admin Contact',
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Admin Contact',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Your Contact';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            ///TEXTFIELD FOR RESTAURANT NAME
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: restaurantController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'restaurant name',
                                  hintText: ' restaurant name',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Restaurant Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            ///TEXTFIELD FOR TIME
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: timeController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'time',
                                  hintText: ' time',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            ///TEXTFIELD FOR LOCATION
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: locationController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'location',
                                  hintText: ' location',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter location';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            ///DROPDOWN BUTTON FOR MAX DISTANCE
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                  dropdownColor: Colors.white,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select if you have a Courier';
                                    }
                                    return null;
                                  },
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.deepOrange.shade50,
                                    label: Text(
                                      'Do you have a Courier ?',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    hintText: 'Do you have a Courier ?',
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepOrange, width: 2.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: false,
                                      child: const Text(
                                          'I don\'t have a Courier'),
                                      onTap: () {
                                        setState(() {
                                          hasCourier = false;
                                        });
                                      },
                                    ),
                                    DropdownMenuItem(
                                      value: true,
                                      child: Text('I have a Courier'),
                                      onTap: () {
                                        setState(() {
                                          hasCourier = true;
                                        });
                                      },
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      maxDistance = int.parse(value.toString());
                                    });
                                  }),
                            ),

                            SizedBox(
                              height: 20.h,
                            ),

                            ///TEXTFIELD FOR FOODNAME
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: foodNameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'food name',
                                  enabled: true,
                                  hintText: 'food name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Food Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            ///TEXTFIELD FOR PRICE
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                controller: priceController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelText: 'price',
                                  hintText: 'price',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.deepOrange)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Price';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                ///ROW OF BUTTONS TO SELECT THE FOOD COLLECTION YOU WAN TO UPLOAD

                Text(
                  'Please Select Collection bellow before Uploading Product and to view your uploads',
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                ///COLLECTION FOR THE TYPE OF PRODUCT TO BE UPLOADED

                Container(
                  height: 50,
                  width: double.infinity,
                  child: Consumer<AdminCollectionProvider>(
                      builder: (context, value, child) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.collectionList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    value.changeIndex(index);
                                  });
                                },
                                child: adminCollectionItemsRow(
                                    value.collectionList[index]));
                          },
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),

                /// CONTAINER TO SHOW/DISPLAY SELECTED COLLECTION
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Upload to : ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: Provider.of<AdminCollectionProvider>(context,
                                listen: false)
                                .collectionToUpload,
                            style: TextStyle(
                                fontFamily: 'Righteous',
                                letterSpacing: 1,
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),

                SizedBox(
                  height: 20.h,
                ),

                ///UPLOAD FUNCTION FOR ADMIN
                SizedBox(
                  width: 200.w,
                  height: 50.h,
                  child: _isLoading
                      ? NewSearchLoadingOutLook()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent),
                          onPressed: () {
                            if (_formkey.currentState!.validate() &&
                                _shopImage?.path != null &&
                                _productImage?.path != null) {
                              uploadFood(UploadModel(
                                latitude: Provider.of<LocationProvider>(context,
                                        listen: false)
                                    .Lat
                                    .toDouble(),
                                longitude: Provider.of<LocationProvider>(
                                        context,
                                        listen: false)
                                    .Long
                                    .toDouble(),
                                isAvailable: true,
                                shopImageUrl: shopImageUrl,
                                ProductImageUrl: productImageUrl,
                                hasCourier: hasCourier,
                                restaurant: restaurantController.text
                                    .toLowerCase()
                                    .trim(),
                                foodName: foodNameController.text
                                    .toLowerCase()
                                    .trim(),
                                price:
                                    double.parse(priceController.text.trim()),
                                location: locationController.text
                                    .toLowerCase()
                                    .trim(),
                                time: timeController.text.trim(),
                                vendorId: idController.text.trim(),
                                adminEmail: Provider.of<LocalStorageProvider>(
                                        context,
                                        listen: false)
                                    .adminEmail,
                                adminContact:
                                    int.parse(adminContactController.text),
                                maxDistance: maxDistance,
                                paymentKey: paymentKeyController.text.trim(),
                              )).then((_) {
                                ///clearing the text fields
                                idController.clear();
                                restaurantController.clear();
                                foodNameController.clear();
                                priceController.clear();
                                locationController.clear();
                                timeController.clear();
                                adminContactController.clear();
                                paymentKeyController.clear();
                                setState(() {
                                  _productImage = null;
                                  _shopImage = null;
                                });
                              });
                            } else {
                              Notify(
                                  context,
                                  'Please pick an image and fill all fields ',
                                  Colors.red);
                            }
                          },
                          child: Text(
                            'Upload Food',
                            style: TextStyle(
                              fontFamily: 'Righteous',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),

                SizedBox(
                  height: 30.h,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        backgroundColor: Colors.black,
        child: Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
