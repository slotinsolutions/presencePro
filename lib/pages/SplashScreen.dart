import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/selectType.dart';
import 'package:testapp/utils/colors.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  User? _user;
  void _checkUserStatus(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
    if(_user != null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Adminhomepage(userType: "ADMIN")),);
    }
    else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Selecttype(),));
    }

  }
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 4),(){
      _checkUserStatus();

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(),
    );
  }
}
