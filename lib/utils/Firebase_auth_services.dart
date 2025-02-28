
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testapp/pages/AdminHomePage.dart';
import 'package:testapp/pages/ViewAttendance.dart';
import 'package:testapp/utils/firestore.dart';


class FirebaseAuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> loginUser(BuildContext context, String email, String password, String selectedRole) async {
    try {


      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      String? actualRole = await getUserRole(uid);

      if (actualRole == null) {
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(msg: 'User data not found!',
            fontSize: 18);
         return;
      }

      if (actualRole != selectedRole) {
        await FirebaseAuth.instance.signOut();
        Fluttertoast.showToast(msg: "You are not a $selectedRole! Please select the correct role.",
            fontSize: 18);

        return;
      }

      Fluttertoast.showToast(msg: "Logged in Successfully",
          fontSize: 18);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>actualRole=="STUDENT"?ViewAttendanceScreen(studentid: uid,userType: selectedRole,):Adminhomepage(userType:selectedRole)));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed: $e")));
    }
  }




  Future<User?> signUpWithEmailAndPassword(String name, String email, String password, String instituteName) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();

      String ownerId = credential.user!.uid;

      // Store owner details in Firestore
      await FirebaseFirestore.instance.collection("owners").doc(ownerId).set({
        "name": name,
        "email": email,
        "role": "OWNER",
        "ownerID": ownerId,
        "instituteName": instituteName,
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Already a User, Log In!!", toastLength: Toast.LENGTH_SHORT);
      } else {
        Fluttertoast.showToast(msg: "Sign Up Failed: ${e.message}", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: $e", toastLength: Toast.LENGTH_SHORT);
    }
    return null;
  }




  Future<String> getUserRole(String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot ownerDoc = await firestore.collection("owners").doc(uid).get();
    if (ownerDoc.exists) {
      return "OWNER";
    }

    QuerySnapshot owners = await firestore.collection("owners").get();
    for (var owner in owners.docs) {
      DocumentSnapshot adminDoc = await firestore
          .collection("owners")
          .doc(owner.id)
          .collection("admins")
          .doc(uid)
          .get();
      if (adminDoc.exists) {
        return "ADMIN";
      }

      DocumentSnapshot teacherDoc = await firestore
          .collection("owners")
          .doc(owner.id)
          .collection("teachers")
          .doc(uid)
          .get();
      if (teacherDoc.exists) {
        return "STAFF";
      }
    }

    return "STUDENT";
  }


  Future<void> signOut() async{
    try{
      await _auth.signOut();
    }
    catch (e) {
      print("some error occured");
    }}
  String? getUserName(){
    User? user =  _auth.currentUser;
    if(user!=null){
      return user.displayName;
    }
    return "No User Found";
  }
}