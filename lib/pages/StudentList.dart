import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:testapp/pages/ViewAttendance.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
class StudentList extends StatefulWidget {
  final String className;
  final String userType;
 final String clasID;
 final String adminId;
   StudentList({super.key,required this.className,required this.userType,required this.clasID,required this.adminId});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar:  Components().appBar('CLASS ${widget.className}', AppColors.primary),
    backgroundColor: AppColors.white,
      body: Container(
        child: Padding(padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot>(

    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(widget.adminId)
        .collection('classes')
    .doc(widget.clasID)
    .collection('students')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No students found.'));
      }

      var students = snapshot.data!.docs;

      return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            var student = students[index];
            return Card(
              color: Colors.white,
              elevation: 5,
              child: ListTile(
                onLongPress: () {
                  if (widget.userType == "ADMIN") {
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return Components().dialog(
                              "Remove Student", "Student Will be Removed",
                              context);
                        });
                  }
                },
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ViewAttendanceScreen(studentid: student['studentId'],)));
                },
                title: Text(student['studentName'], style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),),
                subtitle: Text(student['rollNumber']),
                trailing: Components().showAttendancePercent(0.85, 0.4),
              ),
            );
          });
    }
      )),
      //   child: GridView.builder(
      //       gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) ,
      //       itemCount: 10,
      //       itemBuilder: (context,index){
      //
      //         return Card(
      //           color: Colors.white,
      //           elevation: 5,
      //           child: Container(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Components().showAttendancePercent(0.85,0.8),
      //                 Text("Rohit Choudhary",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      //                 Text("23350")
      //
      //               ],
      //             ),
      //           ),
      //         );
      //       }
      // ),),
      ),
    );
  }
}
