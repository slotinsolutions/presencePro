import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/ViewAttendance.dart';
import 'package:testapp/pages/selectType.dart';
import 'package:testapp/utils/Firebase_auth_services.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/firestore.dart';
import 'package:testapp/utils/theme_provider.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  User? _user;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;






  void _checkUserStatus() async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });


    if(_user != null){
      String user = await FirebaseAuthServices().getUserRole(_auth.currentUser!.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>user=="STUDENT"?ViewAttendanceScreen(studentid: _auth.currentUser!.uid):Adminhomepage(userType: user)));
       }
    else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Selecttype(),));
    }

  }
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3),(){
      _checkUserStatus();

    });
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeColor,
      body: Center(
        child: Lottie.asset("assets/animations/splash.json",
        width: 300,
        height: 200,
        fit: BoxFit.cover),
      ),
    );
  }
}