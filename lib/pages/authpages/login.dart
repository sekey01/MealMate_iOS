import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealmate_ios/pages/authpages/take_phonenumber.dart';
import 'package:provider/provider.dart';
import '../../AdminPanel/Pages/adminSplashScreen.dart';
import '../../Courier/courierLogin.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../components/CustomLoading.dart';
import '../../components/Notify.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  bool signInLoading = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _user = account;

      });
    });
  //  CheckSignedIn();
   // _googleSignIn.signInSilently(); // Auto sign-in if the user is already signed in
  }
/*  Future CheckSignedIn() async{
    if( await _googleSignIn.isSignedIn()){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    }
  }*/
  Future<void> _handleSignIn() async {
  setState(() {
    signInLoading = true;
  });
    try {

      final userCredential = await _googleSignIn.signIn();

      if (userCredential != null) {
        // Assuming userCredential contains user information
        final user = userCredential; // Replace with actual user information if needed

        Provider.of<LocalStorageProvider>(context,listen: false).storeEmail(user.email);
        Provider.of<LocalStorageProvider>(context,listen: false).storeUsername(user.displayName.toString());
        Provider.of<LocalStorageProvider>(context,listen: false).storeImageUrl(user.photoUrl.toString());



        /* print('${user.email} uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
        print(user.photoUrl);
        print(user.displayName);*/// Print user email for debugging
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TakePhoneNumber()),
        );
        setState(() {
          signInLoading = false;
        });
        Notify(context, 'Login Successfully', Colors.green);
      } else {
        setState(() {
          signInLoading = false;
        });
        // Handle the case where the sign-in was canceled by the user
        Notify(context, 'Sign-in was canceled', Colors.red);
      }
    } catch (error) {
      setState(() {
        signInLoading = false;
      });
      // Handle other potential errors
      print(error);
      Notify(context, 'Please Check Your Internet...', Colors.red);
    }
  }


  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: signInLoading ? CustomLoGoLoading(): Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///LOGO DISPLAYED HERE
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 150.w,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      RichText(text: TextSpan(
                          children: [
                            TextSpan(text: "Wel", style: TextStyle(color: Colors.black, fontSize: 25.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                            TextSpan(text: "Come !", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


                          ]
                      )),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Building the Ecosystem with the Meal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                            fontSize: 13.sp,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),







                      ///GOOGLE SIGN IN BUTTON HERE
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,),
                          onPressed: ()  {
                                     _handleSignIn();
                                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 15.sp,
                                ),
                              ),
                 Image(
                   image: AssetImage('assets/Icon/google.png'),
                   height: 50.sp,width: 40.spMin,
                 )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(

                        onTap: () async{
                          await EasyLauncher.url(url: 'https://www.google.com/', mode: Mode.platformDefault);
                        },
                        child: RichText(text: TextSpan(
                            children: [
                              TextSpan(text: "By Continuing you agree to the ",
                                  style: TextStyle(color: Colors.black, fontSize: 10.spMin,fontFamily: 'Poppins',)),
                              TextSpan(text: "Terms & Conditions",
                                  style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 10.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


                            ]
                        )),
                      ),
                      SizedBox(
                        height: 150.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " Login as ",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 10.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => AdminsplashScreen())));
                            },
                            child: Text(
                              ' Admin   /',
                              style: TextStyle(
                                fontFamily: 'Righteous',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),

                            ),
                          ),
SizedBox(width: 10.w,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => CourierLoginPage())));
                            },
                            child: Text(
                              'Courier ',
                              style: TextStyle(
                                fontFamily: 'Righteous',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ) ,
          ),
        ),
      ),
    );
  }
}


