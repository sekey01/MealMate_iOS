import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../components/Notify.dart';
import 'courierInit.dart';

Future<bool> authenticateUser(BuildContext context, String CourierId) async {
  try {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the 'CourierId' collection for the document with matching ID
    QuerySnapshot querySnapshot = await firestore
        .collection('Couriers')
        .where('CourierId', isEqualTo: CourierId)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      Notify(context, 'Verified', Colors.green);
      return true;
    } else {
      Notify(context, 'Not Verified', Colors.red);
      return false;
    }
  } catch (e) {
    Notify(context, 'Please make sure you\'re Connected', Colors.red);
    print('Error authenticating user: $e');
    return false;
  }
}

// Example usage in a StatefulWidget
class CourierLoginPage extends StatefulWidget {
  @override
  _CourierLoginPageState createState() => _CourierLoginPageState();
}

class _CourierLoginPageState extends State<CourierLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController CourierIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
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
                text: "Courier",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
              TextSpan(
                text: "Verification",
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children:[
                Padding(
                  padding: EdgeInsets.only(top:10),
                  child: LottieBuilder.asset('assets/Icon/courier.json',height: 300.h,width: 200.h,),

                ),
                Positioned(
                  top: 10,
                    left: 50,
                    child: Image(image: AssetImage('assets/images/logo.png'),height: 150,width: 150,))

              ]
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "Please enter your ", style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
                          TextSpan(text: "Courier ID", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
                          TextSpan(text: " in Order to continue...", style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),



                        ]
                    )),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Courier Id';
                        }
                        return null;
                      },
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      controller: CourierIdController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.deepOrange.shade50,
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: 'Courier Id',
                        hintText: 'Enter Courier Id for verification',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      elevation: 3,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),

                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isAuthenticated = await authenticateUser(context, CourierIdController.text.toString());
                        if (isAuthenticated) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourierInit(),
                            ),
                          );
                        }
                      }
                      CourierIdController.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Clock In !',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Righteous',
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}