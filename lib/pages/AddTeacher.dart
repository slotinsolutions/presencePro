import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testapp/utils/Firebase_auth_services.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/constants.dart';
import 'package:testapp/utils/firestore.dart';
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
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Components().appBar("ADD TEACHER", AppColors.primary),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("  Enter Teacher Details",style: TextStyle(fontSize: 30,color: AppColors.primary,fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),

                Components().InputBox2(name, Icon(Icons.person), "Name"),
                SizedBox(height: 15,),
                Components().InputBox2(email, Icon(Icons.email), "Email Address"),
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: w*0.51,
                        child: Components().InputBox2(password, Icon(Icons.lock), "Password")),

                    SizedBox(

                        width:w*0.38,
                        child: Components().InputBox2(subject, Icon(Icons.format_list_numbered_rtl), "Subject")),
                  ],
                ),
                SizedBox(height: 15,),
                Components().InputBox2(adminPassword, Icon(Icons.lock), "Enter Admin Password"),

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
                        child: Text("Register Teacher",style: TextStyle(fontSize: 14,color: Colors.white),)),

                  ),
                )
              ],
            ),
          ),
        ),),
    );
  }
}
