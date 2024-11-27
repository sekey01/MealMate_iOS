import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'adminHome.dart';
import 'adminlogin.dart';

class AdminsplashScreen extends StatefulWidget {
  const AdminsplashScreen({super.key});

  @override
  State<AdminsplashScreen> createState() => _AdminsplashScreenState();
}

class _AdminsplashScreenState extends State<AdminsplashScreen> {

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await Provider.of<LocalStorageProvider>(context, listen: false).getAdminLoginState();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => adminHome()),
      );
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoginStatus();
  }
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      backgroundColor: Colors.white,
      duration: Duration(seconds: 5),
      nextScreen: AdminLogin(),
    splashScreenBody: Center(
            child: Padding(
                            padding: const EdgeInsets.all(8.0),
                      child:  Center(
                      child: Builder(
                          builder: (context) {

                         return  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
             children: [
                              Center(child: Image(image: AssetImage('assets/Announcements/OrderNow.png'), height: 250.h, width: double.infinity.w)),
                             RichText(text: TextSpan(
              children: [
                TextSpan(text: "Vendor", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                TextSpan(text: "Panel", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


                   ]
           )),
    Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: LottieBuilder.asset('assets/Icon/loading.json', width: 150.w,height: 100.h,),
                 ),

                ],
         );
        }
       ),
    ),
    )),

    );
  }
}
