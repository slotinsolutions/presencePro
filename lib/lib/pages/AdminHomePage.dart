import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:testapp/pages/AddStudent.dart';
import 'package:testapp/pages/ClassesList.dart';
import 'package:testapp/pages/Teachers.dart';
import 'package:testapp/utils/colors.dart';
class Adminhomepage extends StatefulWidget {
  final String userType;
  Adminhomepage({super.key,required this.userType});

  @override
  State<Adminhomepage> createState() => _AdminhomepageState();
}

class _AdminhomepageState extends State<Adminhomepage> {
  int myIndex = 0;


  final List<Widget> _navigationitems = [
    const Icon(Icons.home, color: Colors.white,),
    const Icon(Icons.add, color: Colors.white,),
    const Icon(Icons.school_outlined, color: Colors.white,),

  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetList = [
      ClassListScreen(userType: widget.userType,),
      const AddstudentScreen(),
      const TeachersScreen(),
    ];
    return Scaffold(
      body: widget.userType=="ADMIN"?_widgetList[myIndex]:_widgetList[0],

     bottomNavigationBar: widget.userType=="ADMIN"? CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: AppColors.primary,
        height: 55,
        items: _navigationitems,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },

      ):
     SizedBox()
    );
  }
}
