import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../components/CustomLoading.dart';
import '../../components/Notify.dart';
import '../OtherDetails/ID.dart';
import 'adminHome.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool isLoading = false;
  bool waiting = false;

  Future<void> adminSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Notify(context, 'Please fill All fields', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save login state
      await Provider.of<LocalStorageProvider>(context, listen: false).storeAdminLoginState(true);

      // If we reach here, sign in was successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => adminHome()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        default:
          errorMessage = 'Wrong Credentials, make sure you are connected';
      }
      Notify(context, errorMessage, Colors.red);
      print('Error during sign in: ${e.code} - ${e.message}');
    } catch (e) {
      Notify(context, 'Wrong Credentials', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
/*  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await Provider.of<LocalStorageProvider>(context, listen: false).getAdminLoginState();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => adminHome()),
      );
    }
  }*/

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: isLoading
                            ? CustomLoGoLoading()
                            : Image(
                                image: AssetImage("assets/images/logo.png"),
                                height: 150,
                                width: 150,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Admin",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Righteous'
                                ),
                              ),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Righteous'
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _emailController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent


            ),
                              ),
                              prefixIcon: Icon(
                                  Icons.supervised_user_circle_rounded,
                                  color: Colors.deepOrangeAccent


            ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent


            ),
                              ),
                              hintText: "Restaurant ID / Email",
                              hintStyle:
                                  TextStyle(color: Colors.blueGrey


            )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent


            ),
                              ),
                              prefixIcon: Icon(
                                  Icons.password_sharp,
                                  color: Colors.deepOrangeAccent


            ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.deepOrangeAccent


            ),
                              ),
                              hintText: "Restaurant Key / Password",
                              hintStyle:
                                  TextStyle(color: Colors.blueGrey


            )),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black


            ),
                          onPressed: () {
                            Provider.of<AdminId>(context, listen: false).loadId();
                            adminSignIn();
                          }, //_signInWithEmailAndPassword,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              letterSpacing: 2,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              fontFamily: 'Righteous'
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot your restaurant Credentials ?",
                            style: TextStyle(color: Colors.black,fontFamily: 'Poppins'),
                          ),
                          TextButton(
                            onPressed: () {

                            },
                            child: Text(
                              ' Call Us for Verification...',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent


            ,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
