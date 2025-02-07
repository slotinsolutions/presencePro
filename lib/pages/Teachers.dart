import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/pages/AddTeacher.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/constants.dart';
class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  Components().appBar("TEACHERS", AppColors.primary),
      backgroundColor: AppColors.white,
        floatingActionButton:FloatingActionButton(
          splashColor: AppColors.primary,
          backgroundColor: AppColors.primary,
          onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>AddteacherScreen()));
          },
          child: Icon(Icons.add,color: Colors.white,),),

        body: Padding(
          padding: EdgeInsets.all(8),
          child:StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .collection('teachers')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading teachers"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No teachers found"));
              }

              List<QueryDocumentSnapshot> teachers = snapshot.data!.docs;

              return ListView.builder(
                  itemCount:teachers.length,
                  itemBuilder: (builder,index){
                    var teacher = teachers[index];
                    return Card(
                      elevation: 5,
                      color: Colors.white,
                      child: ListTile(
                        onLongPress: (){
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return  Components().dialog("Remove Teacher", "Teacher Will be Removed", context);

                              });
                        },
                        title: Text(teacher['name']),
                        subtitle: Text(teacher['email']),
                        trailing: Text(teacher['subject']),
                      ),
                    );
                  });
              ;
            },
          )
    )
    );
  }
}
