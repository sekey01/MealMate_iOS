import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Notification/notification_Provider.dart';
import '../../components/CustomLoading.dart';

class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey,)),
         title: Text('Notifications', style: TextStyle(fontSize: 20.sp, color: Colors.blueGrey, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: FutureBuilder(future: Provider.of<NotificationProvider>(context, listen: true).getUserNotifications(),
          builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: NewSearchLoadingOutLook());
        }
            else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final notice = snapshot.data![index];

                  return ListTile(
                    leading:CircleAvatar(
                      radius: 20.sp,
                      backgroundColor: Colors.deepOrangeAccent,
                      child: Icon(Icons.notifications_active, color: Colors.white,size: 20.sp,),
                    ),
                    title: RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
                          TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
                          TextSpan(text: "      ${notice.time}", style: TextStyle(color: Colors.black, fontSize: 10.sp,fontFamily: 'Poppins')),


                        ]
                    )),
                    subtitle: Text(notice.notification, style: TextStyle(color: Colors.black, fontSize: 12.sp)),

                  );
                },
              );
            }
else{
  return Center(child: Text('No Notifications Available',style: TextStyle(color: Colors.black, fontSize: 10.spMin, fontWeight: FontWeight.bold) ));
            }
      }
      ),
    );
  }
}


