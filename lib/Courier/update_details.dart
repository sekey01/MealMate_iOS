import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../components/Notify.dart';

class UpdateDetails extends StatefulWidget {
  const UpdateDetails({super.key});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  final _formKey = GlobalKey<FormState>();
 // TextEditingController _usernameController = TextEditingController();
  TextEditingController _courierIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 20.h),
              child: Image(image: AssetImage('assets/images/enter_number.png'), height: 250, width: 200,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,

                      child: Column(
                        children: [
                        /*  Text('Update  Username', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),),
                          Padding(padding: EdgeInsets.all(8),
                            child: TextField(

                              style: TextStyle(color: Colors.black),
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  hintText: 'Change Username',
                                  hintStyle: TextStyle(color: Colors.blueGrey),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.sp),
                                      borderSide: BorderSide(color: Colors.grey)),
                                  fillColor: Colors.deepOrange.shade50,
                                  filled: true),
                              onSubmitted: (value) {
                                setState(() {
                                  Provider.of<LocalStorageProvider>(context,
                                      listen: false)
                                      .storeUsername(_usernameController.text);
                                });
                                _usernameController.clear();

                                setState(() {
                                  Notify(context, 'username saved', Colors.green);

                                });

                              },
                            ),
                          ),*/
                          SizedBox(height: 30.h,),
                          Text('Update  Courier ID', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _courierIdController,
                              onFieldSubmitted: (value){
                                if (_formKey.currentState?.validate() ?? false) {

                                  Provider.of<LocalStorageProvider>(context,listen: false).storeCourierID(value);
                                  Notify(context, 'Courier Id Changed successfully', Colors.green);

                                }

                              },
                              maxLength: 10,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.sp),
                              keyboardType: TextInputType.numberWithOptions(),

                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,

                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: BorderSide(color: Colors.deepOrangeAccent)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent),
                                  ),
                                  label: Text('Enter ID : 112234455 '),
                                  labelStyle: TextStyle(color: Colors.blueGrey,fontSize: 15.sp,)),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '   This field cannot be empty';
                                }
                                //if phone number is not up to 10 digits
                                if (value.length < 10 || value.length > 10) {
                                  return 'ID must be 10 digits';
                                }
                                return null; // return null if the input is valid
                              },

                            ),
                          ),
                        ],
                      ),

                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
