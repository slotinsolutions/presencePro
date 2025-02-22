import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/AddAdmin.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/theme_provider.dart';
class Admins extends StatefulWidget {
  const Admins({super.key});

  @override
  State<Admins> createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  @override
  List<Map<String, String>> admins = [
    {"name": "John Doe", "email": "johndoe@example.com"},
    {"name": "Jane Smith", "email": "janesmith@example.com"},
    {"name": "Michael Brown", "email": "michaelbrown@example.com"},
    {"name": "Emily Davis", "email": "emilydavis@example.com"},
  ];
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return  Scaffold(
        appBar:  Components().appBar("ADMINS", AppColors.primary),
        backgroundColor: themeProvider.themeColor,
        floatingActionButton:FloatingActionButton(
          splashColor: AppColors.primary,
          backgroundColor: AppColors.primary,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Addadmin()));
          },
          child: Icon(Icons.add,color: Colors.white,),),

        body: Padding(
            padding: EdgeInsets.all(8),
            child:ListView.builder(
                    itemCount:admins.length,
                    itemBuilder: (builder,index){
                      var admin = admins[index];
                      return Card(
                        elevation: 5,
                        color: themeProvider.themeColor,
                        child: ListTile(
                          onLongPress: (){
                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return  Components().dialog("Remove Admin", "Admin Will be Removed", context);

                                });
                          },
                          title: Text(admin['name']!,style: TextStyle(color: themeProvider.textColor),),
                          subtitle: Text(admin['email']!,style: TextStyle(color: themeProvider.textColor)),
                          ),
                      );


              },
            )
        )
    );
  }
}
