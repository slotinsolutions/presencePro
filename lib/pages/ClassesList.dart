import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:testapp/pages/StudentList.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/constants.dart';
import 'package:testapp/utils/firestore.dart';
import 'SideMenu.dart';

class ClassListScreen extends StatefulWidget {
  late String userType;
   ClassListScreen({super.key,required this.userType});

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  TextEditingController classname = TextEditingController();
  TextEditingController classTeacherName = TextEditingController();
  GlobalKey<ScaffoldState> _drawerkey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? adminId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAdminId();
  }


  Future<void> fetchAdminId() async{
    String? fetchedAdminId = await Firebase_Firestore().getAdminIdForCurrentTeacher();
    setState(() {
      adminId = fetchedAdminId;
    });
  }

  void showCustomDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),

            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  Enter Class Details",style: TextStyle(fontSize: 30,color: AppColors.primary,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),

                  Components().InputBox2(classname, Icon(Icons.menu_book), "Class Name"),
                  SizedBox(height: 15,),
                  Components().InputBox2(classTeacherName, Icon(Icons.person), "Class Teacher Name"),

                  SizedBox(height: 30,),
                  Center(
                    child: SizedBox(
                        width: 250,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary
                          ),
                          onPressed: (){
                            Firebase_Firestore().createClass(_auth.currentUser!.uid,classname.text, classTeacherName.text);
                            Navigator.pop(context);
                          },
                          child: Text("Create Class",style: TextStyle(fontSize: 14,color: Colors.white),)),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      key: _drawerkey,
      drawer: SideMenu(),
      backgroundColor: AppColors.white,


      floatingActionButton:widget.userType=="ADMIN"?FloatingActionButton(
        splashColor: AppColors.primary,
          backgroundColor: AppColors.primary,
          onPressed: (){
          showCustomDialog(context);
           },
          child: Icon(Icons.add,color: Colors.white,),):SizedBox(),


      appBar:  AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title:  Text("Presence Pro",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),

        leading: IconButton(onPressed: (){
          _drawerkey.currentState?.openDrawer();
        },
            icon: Icon(Icons.menu,color: Colors.white,)),
      ),



      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(


          children: [

            Column(
              children: [
                Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey

                  )

                ),

                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Welcome,",style: TextStyle(fontSize: 25,color: AppColors.black),),
                            Text(_auth.currentUser!.displayName??"Default User",softWrap:true,
                                overflow: TextOverflow.visible,

                                style: TextStyle(fontSize: 30,fontWeight:FontWeight.w500,color: AppColors.bgColor2)),
                          ],),



                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
              ],
            ),


            Expanded(
              child: Padding(padding: EdgeInsets.all(8),
              child:StreamBuilder (

    stream:  FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userType=="ADMIN"?_auth.currentUser!.uid:adminId)
        .collection("classes")
        .orderBy("createdAt", descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData ||snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }


      if (snapshot.data!.docs.isEmpty) {
        return Center(child: Text("no Classes found"));
      }

      var classDocs = snapshot.data!.docs;
      return ListView.builder(
          itemCount: classDocs.length,
          itemBuilder: (context, index) {
            var classData = classDocs[index].data();
            return Card(
              color: Colors.white,
              elevation: 5,
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          StudentList(className: classData['className'],
                            userType: widget.userType,clasID: classData["classId"],adminId: widget.userType=="ADMIN"?_auth.currentUser!.uid:adminId!,)));
                },

                title: Text(classData["className"], style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary),),
                subtitle: Text(classData["classTeacher"]),
                trailing: Text('${Constants().present[index]}/50'),
              ),
            );
          }
      );
    }
              )

                ),
            ),
          ],
        ),
      ),
    );
  }
}
