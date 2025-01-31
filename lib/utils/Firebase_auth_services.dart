
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testapp/utils/firestore.dart';


class FirebaseAuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;



  Future<User?> signUpWithEmailAndPassword(String name,String email,
      String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();

      String uid = credential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "name":name,
        "email":email,
        "role":"ADMIN",
        "uid":uid
      });
       return credential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Already a User,Log In!!", toastLength: Toast.LENGTH_SHORT);
      }  else {
        Fluttertoast.showToast(msg: "Sign Up Failed: ${e.message}", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: $e", toastLength: Toast.LENGTH_SHORT);
    }

    return null;
  }
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    }  on FirebaseAuthException catch (e) {
      print('Error code: ${e.code}');
      if (e.code == "invalid-credential") {
        Fluttertoast.showToast(msg: "Incorrect email or Password", toastLength: Toast.LENGTH_SHORT);
      }  else {
        Fluttertoast.showToast(msg: "Login Failed: ${e.message}", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      print("Unexpected error: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred", toastLength: Toast.LENGTH_SHORT);
    }
    return null;
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