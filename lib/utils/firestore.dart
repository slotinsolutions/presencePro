import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestore{


  Future<void> registerStudent({
    required BuildContext context,
    required String adminPassword,
    required String className,
    required String studentName,
    required String studentEmail,
    required String studentPassword,
    required String rollNumber,
    required String rfidTagId,
    required String beaconId,
  }) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Step 1: Authenticate Admin First
      User? adminUser = auth.currentUser;
      if (adminUser == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Admin not logged in!")));
        return;
      }

      // Re-authenticate Admin
      AuthCredential credential = EmailAuthProvider.credential(
        email: adminUser.email!,
        password: adminPassword,
      );
      await adminUser.reauthenticateWithCredential(credential);

      String adminId = adminUser.uid;

      // Step 2: Create Student in Firebase Authentication
      UserCredential studentCredential =
      await auth.createUserWithEmailAndPassword(
        email: studentEmail,
        password: studentPassword,
      );

      String studentId = studentCredential.user!.uid;

      // Step 3: Get Class ID based on class name
      QuerySnapshot classSnapshot = await firestore
          .collection('users')
          .doc(adminId)
          .collection('classes')
          .where('className', isEqualTo: className)
          .limit(1)
          .get();

      if (classSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Class not found!")));
        return;
      }

      String classId = classSnapshot.docs.first.id;

      // Step 4: Store Student Data in Firestore
      await firestore
          .collection('users')
          .doc(adminId)
          .collection('classes')
          .doc(classId)
          .collection('students')
          .doc(studentId)
          .set({
        'studentName': studentName,
        'studentEmail': studentEmail,
        'rollNumber': rollNumber,
        'rfidTagId': rfidTagId,
        'beaconId': beaconId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Step 5: Re-login Admin
      await auth.signOut();
      await auth.signInWithEmailAndPassword(
          email: adminUser.email!, password: adminPassword);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student Registered Successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

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