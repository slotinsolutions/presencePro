import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testapp/main.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/ClassesList.dart';
import 'package:testapp/pages/SingUpScreen.dart';
import 'package:testapp/pages/ViewAttendance.dart';
import 'package:testapp/utils/Firebase_auth_services.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/pages/ForgetPasswordPage.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/theme_provider.dart';
class loginScreen extends StatefulWidget {
  final String userType;
   loginScreen({super.key,required this.userType});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _auth = FirebaseAuthServices();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();




  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
               width: 600,
              height: 100,

              decoration: const BoxDecoration(
                color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage('assets/images/presencepro.png'),
                      fit: BoxFit.fitWidth
                  )
              ),),
            Container(
              child: Column(
                children: [
                  Components().InputBox(email,"Email",Icon(Icons.mail),Colors.white,Colors.black),
                  SizedBox(height: 20,),
                  Components().InputBox(pass,"Password",Icon(Icons.lock),Colors.white,Colors.black),
                  SizedBox(height:40,),
                  SizedBox(
                    width: screenwidth*0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgColor2),
                        onPressed: (){
                          FirebaseAuthServices().loginUser(context, email.text, pass.text, widget.userType); },
                        child: Text("Login",style: TextStyle(color: AppColors.white),)),
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>forgetPassScreen(userType: widget.userType,)));
                    },
                      child: Text('Forget Password?',style: TextStyle(color: AppColors.white,fontSize: 18),
                      )),
                ],
              ),
            ),



            widget.userType =="OWNER"?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have a Account?",style: TextStyle(color: AppColors.white,fontSize: 18),),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>signUpScreen()));
                  },
                    child: Text('SignUp!',style: TextStyle(color: AppColors.primary,fontSize: 18,fontWeight: FontWeight.bold),
                    )),
              ],
            ):
                SizedBox()

          ],
        ),
      ),
    );
  }
}



