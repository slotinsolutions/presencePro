import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/firestore.dart';
import 'package:testapp/utils/theme_provider.dart';
class Addadmin extends StatefulWidget {
  const Addadmin({super.key});

  @override
  State<Addadmin> createState() => _AddadminState();
}
TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password= TextEditingController();
TextEditingController ownerPassword= TextEditingController();


class _AddadminState extends State<Addadmin> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeProvider.themeColor,
      appBar: Components().appBar("ADD ADMIN", AppColors.primary),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("  Enter Admin Details",style: TextStyle(fontSize: 30,color:themeProvider.textColor,fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),

                Components().InputBox2(name, Icon(Icons.person), "Name",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),
                Components().InputBox2(email, Icon(Icons.email), "Email Address",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),
              Components().InputBox2(password, Icon(Icons.lock), "Password",themeProvider.themeColor,themeProvider.textColor),



                SizedBox(height: 15,),
                Components().InputBox2(ownerPassword, Icon(Icons.lock), "Enter Owner Password",themeProvider.themeColor,themeProvider.textColor),

                SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                    width: w*0.7,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary
                        ),
                        onPressed: ()async{
                          String result = await Firebase_Firestore()
                              .addAdminAsOwner( name.text,email.text, password.text, ownerPassword.text);


                          Fluttertoast.showToast(msg: result, toastLength: Toast.LENGTH_SHORT);
                          Navigator.pop(context);

                        },
                        child: Text("Register Admin",style: TextStyle(fontSize: 14,color:themeProvider.themeColor),)),

                  ),
                )
              ],
            ),
          ),
        ),),
    );
  }
}
