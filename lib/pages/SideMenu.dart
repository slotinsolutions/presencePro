import 'package:flutter/material.dart';
import 'package:testapp/utils/colors.dart';
class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white
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

            Container(
              padding: EdgeInsets.only(left: 5,right: 5,top: 5),
              margin: EdgeInsets.only(right: 20),
              child: TextButton(
                  onPressed: () {

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
