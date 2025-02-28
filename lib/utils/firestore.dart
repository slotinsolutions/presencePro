import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestore{




  Future<void> registerStudentAsOwner({
    required BuildContext context,
    required String ownerPassword,
    required String ownerId,
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

      // Step 1: Authenticate Owner
      User? ownerUser = auth.currentUser;
      if (ownerUser == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Owner not logged in!")));
        return;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: ownerUser.email!,
        password: ownerPassword,
      );
      await ownerUser.reauthenticateWithCredential(credential);

      // Step 2: Create Student in Firebase Authentication
      UserCredential studentCredential =
      await auth.createUserWithEmailAndPassword(
        email: studentEmail,
        password: studentPassword,
      );

      String studentId = studentCredential.user!.uid;

      // Step 3: Get Class ID based on class name
      QuerySnapshot classSnapshot = await firestore
          .collection('owners')
          .doc(ownerId)
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
          .collection('owners')
          .doc(ownerId)
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
        'studentId': studentId,
      });

      // Step 5: Re-login Owner
      await auth.signOut();
      await auth.signInWithEmailAndPassword(
          email: ownerUser.email!, password: ownerPassword);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Student Registered Successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }


   Future<String> addAdminAsOwner(String name, String email, String adminPass, String ownerPass) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentOwner = auth.currentUser;

      if (currentOwner == null) {
        return "Error: Owner not authenticated.";
      }

      String ownerId = currentOwner.uid; // Fetch the logged-in owner’s UID

      // Create a new admin account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: adminPass,
      );
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      String adminId = userCredential.user!.uid;

      // Store admin data under the correct owner in Firestore
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('admins')
          .doc(adminId)
          .set({
        'email': email,
        'name': name,
        'adminId': adminId,
        'ownerId': ownerId, // Save ownerId for reference
      });

      // Log out the newly created admin
      await auth.signOut();

      // Re-authenticate the owner
      await auth.signInWithEmailAndPassword(
        email: currentOwner.email!,
        password: ownerPass, // Owner's password for security
      );

      return "Admin added successfully by Owner";
    } catch (e) {
      return "Error: $e";
    }
  }





  Future<String> addTeacherAsOwner(
      String ownerId, String email, String password, String name, String subject, String ownerPass) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentOwner = auth.currentUser;

      // Create a new teacher account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      String teacherId = userCredential.user!.uid;

      // Store teacher data under the owner in Firestore
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('teachers')
          .doc(teacherId)
          .set({
        'email': email,
        'name': name,
        'teacherId': teacherId,
        'ownerId': ownerId,
        'subject': subject,
      });

      // Log out the newly created teacher
      await auth.signOut();

      // Re-authenticate the owner after adding the teacher
      if (currentOwner != null) {
        await auth.signInWithEmailAndPassword(
          email: currentOwner.email!,
          password: ownerPass, // ⚠ Securely handle passwords
        );
      }

      return "Teacher added successfully by Owner";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> getOwnerIdForAdmin(String adminId) async {
    try {
      QuerySnapshot owners = await FirebaseFirestore.instance.collection("owners").get();

      for (var owner in owners.docs) {
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection("owners")
            .doc(owner.id)
            .collection("admins")
            .doc(adminId)
            .get();

        if (adminDoc.exists) {
          return owner.id; // Return the ownerId
        }
      }
    } catch (e) {
      print("Error fetching ownerId: $e");
    }
    return null; // Return null if ownerId is not found
  }

  Future<String?> getOwnerIdForteacher(String teacherId) async {
    try {
      QuerySnapshot owners = await FirebaseFirestore.instance.collection("owners").get();

      for (var owner in owners.docs) {
        DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
            .collection("owners")
            .doc(owner.id)
            .collection("teachers")
            .doc(teacherId)
            .get();

        if (teacherDoc.exists) {
          return owner.id; // Return the ownerId
        }
      }
    } catch (e) {
      print("Error fetching ownerId: $e");
    }
    return null; // Return null if ownerId is not found
  }


  Future<String> addTeacherAsAdmin(
      String adminId, String email, String password, String name, String subject, String adminPass) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentAdmin = auth.currentUser;

      // Get the ownerId for the admin
      String? ownerId = await getOwnerIdForAdmin(adminId);
      if (ownerId == null) {
        return "Error: Admin's ownerId not found.";
      }

      // Create a new teacher account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      String teacherId = userCredential.user!.uid;

      // Store teacher data under the correct owner in Firestore
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('teachers')
          .doc(teacherId)
          .set({
        'email': email,
        'name': name,
        'teacherId': teacherId,
        'ownerId': ownerId,
        'adminId': adminId,
        'subject': subject,
      });

      // Log out the newly created teacher
      await auth.signOut();

      // Re-authenticate the admin after adding the teacher
      if (currentAdmin != null) {
        await auth.signInWithEmailAndPassword(
          email: currentAdmin.email!,
          password: adminPass, // ⚠ Securely handle passwords
        );
      }

      return "Teacher added successfully by Admin";
    } catch (e) {
      return "Error: $e";
    }
  }



  Future<void> createClassAsOwner(String ownerId, String className, String classTeacher) async {
    try {
      CollectionReference classesRef = FirebaseFirestore.instance
          .collection("owners")
          .doc(ownerId)
          .collection("classes");

      // Check if a class with the same name already exists
      QuerySnapshot existingClasses = await classesRef
          .where("className", isEqualTo: className)
          .get();

      if (existingClasses.docs.isNotEmpty) {
        Fluttertoast.showToast(msg: "Class with this name already exists!");
        return; // Stop execution if class already exists
      }

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