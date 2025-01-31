import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestore{

  Future<String?> getAdminIdForCurrentTeacher() async {
    String teacherId = FirebaseAuth.instance.currentUser!.uid; // Get current teacher's UID

     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'ADMIN')
        .get();

    for (var adminDoc in querySnapshot.docs) {
      String adminId = adminDoc.id;

       DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(adminId)
          .collection('teachers')
          .doc(teacherId)
          .get();

      if (teacherDoc.exists) {
        return adminId;
      }
    }

    return null;
  }



  Future<String> addTeacher(String adminId, String email, String password, String name, String subject,String adminPass) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentAdmin = auth.currentUser;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      String teacherId = userCredential.user!.uid;


      await FirebaseFirestore.instance
          .collection('users')
          .doc(adminId)
          .collection('teachers')
          .doc(teacherId)
          .set({
        'email': email,
        'name': name,
        'teacherId': teacherId,
        'adminId': adminId,
        'subject': subject,
      });


      if (currentAdmin != null) {
        await auth.signInWithEmailAndPassword(
          email: currentAdmin.email!,
          password: adminPass, // ⚠ Store securely or prompt for re-login
        );
      }

      return "Teacher added successfully";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> createClass(String adminId, String className, String classTeacher) async {
    try {
       CollectionReference classesRef = FirebaseFirestore.instance
          .collection("users")
          .doc(adminId)
          .collection("classes");

      String classId = Uuid().v4();


      await classesRef.doc(classId).set({
        "className": className,
        "classId": classId,
        "classTeacher": classTeacher,
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("Class created with ID: $classId");
      Fluttertoast.showToast(msg: "Class created successfully!");
    } catch (e) {
      print("Error creating class: $e");
      Fluttertoast.showToast(msg: "Error creating class");
    }
  }

}