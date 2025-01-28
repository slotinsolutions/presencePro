import 'package:flutter/material.dart';
import 'package:testapp/main.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/ClassesList.dart';
import 'package:testapp/pages/ViewAttendance.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
class changePassScreen extends StatefulWidget {
  final String userType;
  changePassScreen({super.key,required this.userType});

  @override
  State<changePassScreen> createState() => _changePassScreenState();
}

class _changePassScreenState extends State<changePassScreen> {
  TextEditingController pass= TextEditingController();
  TextEditingController confirmpass= TextEditingController();
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
                child: Icon(Icons.lock,size: 150,color: AppColors.white,),),
              Container(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Enter New Password",style: TextStyle(color: AppColors.white,fontSize: 20),),


                      ],
                    ),
                    SizedBox(height:40,),
                    Components().InputBox(pass,"Password",Icon(Icons.lock)),
                    SizedBox(height:20,),

                    Components().InputBox(confirmpass,"Confirm Password",Icon(Icons.lock)),
                    SizedBox(height:40,),
                    SizedBox(
                      width: screenwidth*0.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgColor2),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>widget.userType=="STUDENT"?ViewAttendanceScreen():Adminhomepage(userType:widget.userType,)));

                          },
                          child: Text("Change Password",style: TextStyle(color: AppColors.white),)),
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

