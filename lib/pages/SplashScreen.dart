import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/ViewAttendance.dart';
import 'package:testapp/pages/selectType.dart';
import 'package:testapp/utils/Firebase_auth_services.dart';
import 'package:testapp/utils/colors.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  User? _user;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;


  Future<String> getUserRole(String uid) async {

  var adminDoc = await _firestore.collection('users').doc(uid).get();
  if (adminDoc.exists) {
  return "ADMIN";
  }

  var admins = await _firestore.collection('users').get();
  for (var admin in admins.docs) {
  var teacherDoc = await _firestore
      .collection('users')
      .doc(admin.id)
      .collection('teachers')
      .doc(uid)
      .get();
  if (teacherDoc.exists) {
  return "STAFF";
  }
  }

  return "STUDENT";
  }



  void _checkUserStatus() async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });


    if(_user != null){
      String user = await getUserRole(_auth.currentUser!.uid);
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
