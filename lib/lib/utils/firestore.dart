import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestore{


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