import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();


  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword() async {


    try {
      User? user = _auth.currentUser;

      if (user == null) {
        Fluttertoast.showToast(msg: "User not found. Please log in again.",
            fontSize: 18);

        return;
      }

      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPasswordController.text);

      Fluttertoast.showToast(msg:"Password changed successfully!",
          fontSize: 18);

      // Clear input fields after successful password change
      currentPasswordController.clear();
      newPasswordController.clear();
    } catch (error) {
      Fluttertoast.showToast(msg:"Error: ${error.toString()}",
          fontSize: 18);

    }
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:  Components().appBar("Change Password", AppColors.primary),
    backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Components().InputBox2(currentPasswordController, Icon(Icons.lock), "Current Password"),
              SizedBox(height: 15,),
              Components().InputBox2(newPasswordController, Icon(Icons.lock), "New Password"),
              SizedBox(height: 30,),
              Center(
                child: SizedBox(
                  width: w*0.7,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary
                      ),
                      onPressed: ()async{
                        await changePassword();


                      },
                      child: Text("Change Password",style: TextStyle(fontSize: 14,color: Colors.white),)),
                ),
              )
            ],

          ),
        ),
      ),

    );
  }
}
