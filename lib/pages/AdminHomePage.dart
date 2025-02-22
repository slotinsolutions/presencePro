import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/AddAdmin.dart';
import 'package:testapp/pages/AddStudent.dart';
import 'package:testapp/pages/Admins.dart';
import 'package:testapp/pages/ClassesList.dart';
import 'package:testapp/pages/Teachers.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/theme_provider.dart';
class Adminhomepage extends StatefulWidget {
  final String userType;
  Adminhomepage({super.key,required this.userType});

  @override
  State<Adminhomepage> createState() => _AdminhomepageState();
}

class _AdminhomepageState extends State<Adminhomepage> {
  int myIndex = 0;




  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final List<Widget> _navigationitems = widget.userType=="OWNER"? [
      const Icon(Icons.home, color: Colors.white,),
      const Icon(Icons.add, color: Colors.white,),
      const Icon(Icons.school_outlined, color: Colors.white,),
      const Icon(Icons.admin_panel_settings_outlined,color: Colors.white,)

    ]:
    [
      const Icon(Icons.home, color: Colors.white,),
      const Icon(Icons.add, color: Colors.white,),
      const Icon(Icons.school_outlined, color: Colors.white,),

    ];
    List<Widget> _widgetList = widget.userType=="OWNER"?[
      ClassListScreen(userType: widget.userType,),
      const AddstudentScreen(),
      const TeachersScreen(),
      const Admins(),
    ]:
    [
      ClassListScreen(userType: widget.userType,),
      const AddstudentScreen(),
      const TeachersScreen(),
    ];
    return Scaffold(
      body: widget.userType=="ADMIN"|| widget.userType=="OWNER"?_widgetList[myIndex]:_widgetList[0],

     bottomNavigationBar: widget.userType=="ADMIN" || widget.userType=="OWNER"? CurvedNavigationBar(
        backgroundColor: themeProvider.themeColor,
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
