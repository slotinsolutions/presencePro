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
          child: ListView.builder(
            itemCount:Constants().teachercount,
              itemBuilder: (builder,index){
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
                    title: Text("Teacher Name"),
                    subtitle: Text("teacher@gmail.com"),
                      trailing: Text("Subject:ABC"),
                  ),
                );
              }),
    )
    );
  }
}
