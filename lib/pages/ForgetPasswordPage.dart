import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testapp/main.dart';
import 'package:testapp/pages/checkEmail.dart';
import 'package:testapp/utils/colors.dart';

import 'package:testapp/utils/components.dart';
class forgetPassScreen extends StatefulWidget {
  final String userType;
  forgetPassScreen({super.key,required this.userType});

  @override
  State<forgetPassScreen> createState() => _forgetPassScreenState();
}

class _forgetPassScreenState extends State<forgetPassScreen> {
  TextEditingController emailcontroller = TextEditingController();
 final FirebaseAuth _auth = FirebaseAuth.instance;

  void resetPassword() async {
    String email = emailcontroller.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your email",
          fontSize: 18);

      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Checkemail()));
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}",
          fontSize: 18);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.bgColor2,
              AppColors.bgColor,

            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
             child: Icon(Icons.email_outlined,size: 150,color: AppColors.white,),),
            Container(
              child: Column(
                children: [
                  Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Enter Your Email",style: TextStyle(color: AppColors.white,fontSize: 20),),
                      Text("We'll send a Password Reset Link",style: TextStyle(color: AppColors.white,fontSize: 20)),

                    ],
                  ),
                  SizedBox(height:40,),
                  Components().InputBox(emailcontroller,"Email",Icon(Icons.email)),
                  SizedBox(height:40,),
                   SizedBox(
                    width: screenwidth*0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgColor2),
                        onPressed: (){
                          resetPassword();
                         
                        },
                        child: Text("Send Email",style: TextStyle(color: AppColors.white),)),
                  ),

                ],
              ),
            ),





          ],
        ),
      )
    );
  }
}


