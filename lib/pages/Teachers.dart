import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/AddTeacher.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/constants.dart';
import 'package:testapp/utils/firestore.dart';
import 'package:testapp/utils/theme_provider.dart';
class TeachersScreen extends StatefulWidget {
  final String userType;
  const TeachersScreen({super.key,required this.userType});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? ownerIdIfadmin;

  @override
  void initState() {
    super.initState();

    fetchownerifforadmin();

  }
  Future<void> fetchownerifforadmin()async{
    String? fetchedownerid = await Firebase_Firestore().getOwnerIdForAdmin(_auth.currentUser!.uid);
    setState(() {
      ownerIdIfadmin = fetchedownerid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar:  Components().appBar("TEACHERS", AppColors.primary),
      backgroundColor: themeProvider.themeColor,
        floatingActionButton:FloatingActionButton(
          splashColor: AppColors.primary,
          backgroundColor: AppColors.primary,
          onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>AddteacherScreen(userType:widget.userType)));
          },
          child: Icon(Icons.add,color: Colors.white,),),

        body: Padding(
          padding: EdgeInsets.all(8),
          child:StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('owners')
                .doc(widget.userType=="OWNER"?_auth.currentUser!.uid:ownerIdIfadmin)
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
                      color: themeProvider.themeColor,
                      child: ListTile(
                        onLongPress: (){
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return  Components().dialog("Remove Teacher", "Teacher Will be Removed", context);

                              });
                        },
                        title: Text(teacher['name'],style: TextStyle(color: themeProvider.textColor),),
                        subtitle: Text(teacher['email'],style: TextStyle(color: themeProvider.textColor)),
                        trailing: Text(teacher['subject'],style: TextStyle(color: themeProvider.textColor)),
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
