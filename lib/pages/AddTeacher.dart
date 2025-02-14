import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testapp/utils/Firebase_auth_services.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/constants.dart';
import 'package:testapp/utils/firestore.dart';
import 'package:testapp/utils/theme_provider.dart';
class AddteacherScreen extends StatefulWidget {
  const AddteacherScreen({super.key});

  @override
  State<AddteacherScreen> createState() => _AddteacherScreenState();
}

class _AddteacherScreenState extends State<AddteacherScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController subject= TextEditingController();
  TextEditingController adminPassword= TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeProvider.themeColor,
      appBar: Components().appBar("ADD TEACHER", AppColors.primary),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("  Enter Teacher Details",style: TextStyle(fontSize: 30,color:themeProvider.textColor,fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),

                Components().InputBox2(name, Icon(Icons.person), "Name",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),
                Components().InputBox2(email, Icon(Icons.email), "Email Address",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: w*0.51,
                        child: Components().InputBox2(password, Icon(Icons.lock), "Password",themeProvider.themeColor,themeProvider.textColor)),

                    SizedBox(

                        width:w*0.38,
                        child: Components().InputBox2(subject, Icon(Icons.format_list_numbered_rtl), "Subject",themeProvider.themeColor,themeProvider.textColor)),
                  ],
                ),
                SizedBox(height: 15,),
                Components().InputBox2(adminPassword, Icon(Icons.lock), "Enter Admin Password",themeProvider.themeColor,themeProvider.textColor),

                SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                    width: w*0.7,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary
                        ),
                        onPressed: ()async{
                          if(name.text.isEmpty ||email.text.isEmpty || password.text.isEmpty ||subject.text.isEmpty||adminPassword.text.isEmpty){
                            Fluttertoast.showToast(msg: "All Fields are Required", toastLength: Toast.LENGTH_SHORT);

                          }
                          String result = await Firebase_Firestore().addTeacher(_auth.currentUser!.uid, email.text, password.text, name.text,subject.text,adminPassword.text);
                          Fluttertoast.showToast(msg: result, toastLength: Toast.LENGTH_SHORT);


                          Navigator.pop(context);
                        },
                        child: Text("Register Teacher",style: TextStyle(fontSize: 14,color:themeProvider.themeColor),)),

                  ),
                )
              ],
            ),
          ),
        ),),
    );
  }
}
