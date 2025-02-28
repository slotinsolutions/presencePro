import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/AddAdmin.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/theme_provider.dart';
class Admins extends StatefulWidget {
  String? userType;
   Admins({super.key,required this.userType});

  @override
  State<Admins> createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

@override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return Scaffold(
      appBar:  Components().appBar("ADMINS", AppColors.primary),
      backgroundColor: themeProvider.themeColor,
      floatingActionButton:FloatingActionButton(
        splashColor: AppColors.primary,
        backgroundColor: AppColors.primary,
        onPressed: ()async{
          bool result = await
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Addadmin()));
       if(result){
         setState(() {

         });
       }

        },
        child: Icon(Icons.add,color: Colors.white,),),

      body: Padding(
          padding: EdgeInsets.all(8),
          child:StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('owners')
                .doc(_auth.currentUser!.uid)
                .collection('admins')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading admins"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No admins found"));
              }

              List<QueryDocumentSnapshot> admins = snapshot.data!.docs;

              return ListView.builder(
                  itemCount:admins.length,
                  itemBuilder: (builder,index){
                    var admin =admins[index];
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
                        title: Text(admin['name'],style: TextStyle(color: themeProvider.textColor),),
                        subtitle: Text(admin['email'],style: TextStyle(color: themeProvider.textColor)),
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
