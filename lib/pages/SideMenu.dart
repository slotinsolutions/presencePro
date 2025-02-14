import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/customerSupport.dart';
import 'package:testapp/pages/profile.dart';
import 'package:testapp/utils/Firebase_auth_services.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/theme_provider.dart';
import 'selectType.dart';
class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  final _auth = FirebaseAuthServices();
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: themeProvider.themeColor,
      child: Container(
        decoration: BoxDecoration(
            color: themeProvider.themeColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primary,
                child: Container(
                  width: 600,
                  height: 100,

                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage('assets/images/presencepro.png'),
                          fit: BoxFit.fitWidth
                      )
                  ),),),
            ListTile(
              leading: Icon(Icons.brightness_6, color: themeProvider.textColor),
              title: Text(
                themeProvider.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
                style: TextStyle(color: themeProvider.textColor),
              ),
              onTap: () {
                themeProvider.toggleTheme();
              },
            ),

            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              margin: EdgeInsets.only(right: 20),
              child: TextButton(
                  onPressed: () async {

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));


                  }, child: Row(
                children: [
                  Icon(Icons.person,color: themeProvider.textColor,size: 24),
                  SizedBox(width: 10,),
                  Text("Profile",style:TextStyle(color:themeProvider.textColor,fontSize: 18))
                ],
              )
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              margin: EdgeInsets.only(right: 20),
              child: TextButton(
                  onPressed: () async {

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Customersupport()));


                  }, child: Row(
                children: [
                  Icon(Icons.call,color: themeProvider.textColor,size: 24),
                  SizedBox(width: 10,),
                  Text("Customer Support",style:TextStyle(color: themeProvider.textColor,fontSize: 18))
                ],
              )
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              margin: EdgeInsets.only(right: 20),
              child: TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Fluttertoast.showToast(msg: "Signed out Successfully",
                        fontSize: 18);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Selecttype()));


                  }, child: Row(
                children: [
                  Icon(Icons.outbond_outlined,color: Colors.red,size: 24),
                  SizedBox(width: 10,),
                  Text("Log Out",style:TextStyle(color: Colors.red,fontSize: 18))
                ],
              )
              ),
            ),



          ],
        ),
      ),

    );
  }
}

class _auth {
}
