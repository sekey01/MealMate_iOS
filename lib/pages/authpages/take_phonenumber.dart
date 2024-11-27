import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../navpages/home.dart';

class TakePhoneNumber extends StatefulWidget {
  const TakePhoneNumber({super.key});

  @override
  State<TakePhoneNumber> createState() => _TakePhoneNumberState();
}
final _formKey = GlobalKey<FormState>();
TextEditingController phoneNumberController = TextEditingController();

class _TakePhoneNumberState extends State<TakePhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: RichText(text: TextSpan(
            children: [
              TextSpan(text: "Add", style: TextStyle(color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
              TextSpan(text: "Telephone", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


            ]
        )),

        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: AssetImage('assets/images/enter_number.png'),height: 200.sp,width: 200.sp,),
          /// Text telling user to enter phone number because it is required to order food
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Center(
                  child:RichText(text: TextSpan(
                      children: [
                        TextSpan(text: "Please enter your ", style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
                        TextSpan(text: "active", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
                        TextSpan(text: " phone number to continue...", style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),



                      ]
                  )),
                ),
              ),
              ///TEXTFORMFIELD   HERE
              Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
          
                  child: TextFormField(
                    controller: phoneNumberController,
                    onFieldSubmitted: (value){
                      Provider.of<LocalStorageProvider>(context,listen: false).storePhoneNumber(value);
          
                    },
                    maxLength: 10,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.sp),
                    keyboardType: TextInputType.numberWithOptions(),
          
                    decoration: InputDecoration(
                        prefixIcon:
                        Icon(Icons.phone, color: Colors.red),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.deepOrangeAccent)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "Enter number: 0542169225 ",
                        hintStyle: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,fontWeight: FontWeight.normal)),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '   This field cannot be empty';
                      }
                      //if phone number is not up to 10 digits
                      if (value.length < 10 || value.length > 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null; // return null if the input is valid
                    },
          
                  ),
          
                ),
              ),
          SizedBox(height: 40.h,),
              SizedBox(
                width: 250.w,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,),
                  onPressed: ()  {
          
                    if (_formKey.currentState?.validate() ?? false) {
                      Provider.of<LocalStorageProvider>(context,listen: false).storePhoneNumber(phoneNumberController.text);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          
                    }
          
                  },
                  child: Text(
                    "Continue ",
                    style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.white,
                      fontFamily:  'Righteous',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h,),
            ],
          ),
        ),
      ),
    );
  }
}
