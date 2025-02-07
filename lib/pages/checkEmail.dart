import 'package:flutter/material.dart';
import 'package:testapp/utils/colors.dart';
class Checkemail extends StatefulWidget {
  const Checkemail({super.key});

  @override
  State<Checkemail> createState() => _CheckemailState();
}

class _CheckemailState extends State<Checkemail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.bgColor2,
                AppColors.bgColor,

              ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Icon(Icons.link,size: 150,color: AppColors.white,),),
                Container(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Check Your Inbox",style: TextStyle(color: AppColors.white,fontSize: 20),),
                          Text("We've sent a Password Reset Link",style: TextStyle(color: AppColors.white,fontSize: 20)),

                        ],
                      ),


                    ],
                  ),
                ),





              ],
            ),
          ),
        )
    );
  }
}

