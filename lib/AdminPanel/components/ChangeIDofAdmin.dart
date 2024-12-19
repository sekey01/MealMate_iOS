import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../Notification/notification_Provider.dart';
import '../../components/Notify.dart';
import '../../pages/authpages/login.dart';
import '../../pages/navpages/notifications.dart';
import '../OtherDetails/ID.dart';
import '../Pages/adminNotificationPage.dart';

class ChangeAdminCredentials extends StatefulWidget {
  const ChangeAdminCredentials({super.key});

  @override
  State<ChangeAdminCredentials> createState() => _ChangeAdminCredentialsState();
}

class _ChangeAdminCredentialsState extends State<ChangeAdminCredentials> {
  TextEditingController changeIdController = TextEditingController();
  TextEditingController changeEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:RichText(text: TextSpan(
            children: [
              TextSpan(text: "Admin", style: TextStyle(color: Colors.black, fontSize: 16.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous',
              )),
              TextSpan(text: "Credentials", style: TextStyle(color: Colors.redAccent, fontSize: 16.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous',
              )),


            ]
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          ///NOTIFICATION HERE
          ///
          /// THIS IS NOTIFICATION TO ALL ADMINS
          ///
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminNotice()));
              },
              icon: Badge(
                backgroundColor: Colors.green,
                label: Builder(builder: (context) {
                  Provider.of<NotificationProvider>(context, listen: false)
                      .getAdminNotifications();
                  return Consumer<NotificationProvider>(
                      builder: (context, value, child) {
                        value.getAdminNotifications();

                        return Text(
                          value.adminNotificationLength.toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      });
                }),
                child: ImageIcon(
                  AssetImage('assets/Icon/notification.png'),
                  color: Colors.blueGrey,
                  size: 25.sp,
                ),
              )),
          SizedBox(
            width: 10.w,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
      Provider.of<LocalStorageProvider>(context, listen: false)
          .storeAdminLoginState(false).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: Login(),
            ),
          ),
        );
      });},
              icon: Text('Logout', style: TextStyle(fontSize: 12.sp,fontFamily: 'Poppins',color: Colors.redAccent,fontWeight: FontWeight.bold),),
            ),
          ),

        ],
      ),
      body:

       SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Center(
               child: Padding(
                 padding: const EdgeInsets.all(28.0),
                 child: Column(
                   children: [
                     /// GET ADMIN EMAIL
                     SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Image(
                             image: AssetImage('assets/Icon/gmail.png'),
                             height: 20.h,
                             width: 20.h,
                           ),
                           SizedBox(
                             width: 10.w,
                           ),
                           SingleChildScrollView(
                             scrollDirection: Axis.horizontal,
                             child: FutureBuilder(
                                 future: Provider.of<LocalStorageProvider>(context,
                                     listen: false)
                                     .getAdminEmail(),
                                 builder: (context, snapshot) {
                                   if (snapshot.hasData) {
                                     return Text(
                                       snapshot.data.toString(),
                                       style: TextStyle(
                                           letterSpacing: 1,
                                           color: Colors.black,
                                           fontSize: 15.sp,
                                           fontFamily: 'Poppins'),
                                     );
                                   } else {
                                     return Text(
                                       'adminemail@gmail.com ',
                                       style: TextStyle(
                                         letterSpacing: 1,
                                         color: Colors.black,
                                         fontSize: 15.spMin,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     );
                                   }
                                 }),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(
                       height: 30.h,
                     ),

                     Padding(padding: EdgeInsets.only(top: 20.h),
                       child: Image(image: AssetImage('assets/images/enter_number.png'), height: 250, width: 200,),
                     ),

                     Text('Change your Admin Credentials', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.sp),),
                     SizedBox(
                       height: 20.h,
                     ),

                     ///CHANGE ID HERE
                     TextField(
                       onSubmitted: (value){
                         Provider.of<AdminId>(context,listen: false).changeId(value.toString());
                         Provider.of<AdminId>(context,listen: false).loadId();
    Notify(context, 'Id changed successfully', Colors.green);
                         setState(() {});

                       },
                       controller: changeIdController,
                       keyboardType: TextInputType.number,
                       style: TextStyle(color: Colors.black),
                       decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(color: Colors.black)),
                           hintStyle: TextStyle(
                               color: Colors.black, fontSize: 20.sp, letterSpacing: 2),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(
                                   color: Colors.black, style: BorderStyle.solid)),
                           label: Text('Enter ID '),
                           labelStyle: TextStyle(
                             color: Colors.black,
                           )),
                     ),
                     SizedBox(height: 30.h,),
         
                     ///CHANGE EMAIL HERE
                     TextField(
                       onSubmitted: (value){
                         Provider.of<LocalStorageProvider>(context,listen: false).storeAdminEmail(value.toString());
                         Provider.of<LocalStorageProvider>(context,listen: false).getAdminEmail();
                         Notify(context, 'Email changed successfully', Colors.green);
                         setState(() {});


                       },
                       controller: changeEmailController,
                       keyboardType: TextInputType.text,
                       style: TextStyle(color: Colors.deepOrange),
                       decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(color: Colors.black)),
                           hintStyle: TextStyle(
                               color: Colors.black, fontSize: 20.sp, letterSpacing: 2),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(
                                   color: Colors.black, style: BorderStyle.solid)),
                           label: Text('Enter email  '),
                           labelStyle: TextStyle(
                             color: Colors.black,
                           )),
                     ),



                   ],
                 ),
               ),
             ),
           ],
         ),
       ));
    }
  }
