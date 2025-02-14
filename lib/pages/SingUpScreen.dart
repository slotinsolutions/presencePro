import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testapp/main.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/ClassesList.dart';
import 'package:testapp/pages/LoginScreen.dart';
import 'package:testapp/utils/Firebase_auth_services.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/pages/ViewAttendance.dart';
import 'package:testapp/utils/theme_provider.dart';
class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  void _signup()async{
    String username = name.text;
    String usermail = email.text;
    String userpass = pass.text;
    User? user = await _auth.signUpWithEmailAndPassword(username,usermail, userpass);
    if(user!= null){
      Fluttertoast.showToast(msg: "Registered Successfully");
      Navigator.pushReplacement(      context, MaterialPageRoute(builder: (context)=>Adminhomepage(userType: "ADMIN",)));
    }
    else{
      print("some error occured");
    }
  } @override
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
                  Components().InputBox(name,"Name",Icon(Icons.person),Colors.white,Colors.black),
                  SizedBox(height: 20,),
                  Components().InputBox(email,"Email",Icon(Icons.email),Colors.white,Colors.black),
                  SizedBox(height: 20,),
                  Components().InputBox(pass,"Password",Icon(Icons.lock),Colors.white,Colors.black),
                  SizedBox(height:40,),
                  SizedBox(
                    width: screenwidth*0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgColor2),
                        onPressed: (){
                         _signup();
                        },
                        child: Text("SignUp",style: TextStyle(color: AppColors.white),)),
                  ),

                ],
              ),
            ),



            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have a Account?",style: TextStyle(color: AppColors.white,fontSize: 18),),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: (){
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginScreen()));
                  },
                    child: Text('LogIn!',style: TextStyle(color: AppColors.primary,fontSize: 18,fontWeight: FontWeight.bold),
                    )),
              ],
            )

          ],
        ),
      ),
    );
  }
}


