import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Notification/notification_Provider.dart';
import '../../components/CustomLoading.dart';

class AdminNotice extends StatefulWidget {
  const AdminNotice({super.key});

  @override
  State<AdminNotice> createState() => _AdminNoticeState();
}

class _AdminNoticeState extends State<AdminNotice> {


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
        title: Text('Admin Notifications', style: TextStyle(fontSize: 20.sp, color: Colors.blueGrey, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: FutureBuilder(future: Provider.of<NotificationProvider>(context,listen: false).getAdminNotifications(),
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
                    leading: Text(notice.time, style: TextStyle(color: Colors.black, fontSize: 10.spMin,fontWeight: FontWeight.bold)),
                    title: RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 15.spMin, fontWeight: FontWeight.bold)),
                          TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.spMin, fontWeight: FontWeight.bold)),


                        ]
                    )),
                    subtitle: Text(notice.notification, style: TextStyle(color: Colors.black, fontSize: 15.sp)),
                  );
                },
              );
            }
            else{
              return Center(child: Text('No Notifications Available',style: TextStyle(color: Colors.black, fontSize: 15.spMin,fontWeight: FontWeight.bold) ));
            }
          }
      ),
    );
  }
}


