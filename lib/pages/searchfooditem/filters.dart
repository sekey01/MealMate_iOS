import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'init_row_search.dart';

class SearchByFilters extends StatefulWidget {
  const SearchByFilters({super.key});

  @override
  State<SearchByFilters> createState() => _SearchByFiltersState();
}
List filters = ['fufu','jollof', 'rice', 'beans', 'yam', 'plantain', 'moi moi', 'akara', 'pasta', 'spaghetti', 'noodles', 'pizza', 'shawarma', 'burger'];

class _SearchByFiltersState extends State<SearchByFilters> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [

            SizedBox(height: 40.h,),
            RichText(text: TextSpan(
                children: [
                  TextSpan(text: "filters : ", style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                  TextSpan(text: " \" seamlessly access your product ... \"", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 12.sp, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
                ]
            )),
        Expanded(child: ListView.builder(itemCount: filters.length ,itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => InitRowSearch(searchItem: filters[index],)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(10),

                ),
                child: ListTile(
                  title: Text(filters[index], style: TextStyle(color: Colors.black,fontSize: 15.sp,fontFamily: 'Poppins'),),
                //  trailing: Icon(Icons.arrow_forward_ios,color: Colors.black,size: 15.sp,),
                ),
              ),
            ),
          );
        }),)
          ],
        ),
      ),
    );
  }
}
