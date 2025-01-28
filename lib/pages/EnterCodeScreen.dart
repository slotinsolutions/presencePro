import 'package:flutter/material.dart';
import 'package:testapp/main.dart';
import 'package:testapp/pages/ChangePass.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
class enterCodeScreen extends StatefulWidget {
  final String userType;
   enterCodeScreen({super.key,required this.userType});

  @override
  State<enterCodeScreen> createState() => _enterCodeScreenState();
}

class _enterCodeScreenState extends State<enterCodeScreen> {
  TextEditingController code = TextEditingController();
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
                        Text("Enter Your Code",style: TextStyle(color: AppColors.white,fontSize: 20),),


                      ],
                    ),
                    SizedBox(height:40,),
                    Components().InputBox(code,"Code",Icon(Icons.code)),
                    SizedBox(height:40,),
                    SizedBox(
                      width: screenwidth*0.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgColor2),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>changePassScreen(userType: widget.userType,)));

                          },
                          child: Text("Verify",style: TextStyle(color: AppColors.white),)),
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


