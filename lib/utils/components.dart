import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:testapp/utils/theme_provider.dart';
class Components{
  Widget dialog(String title,String content,BuildContext context){
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AlertDialog(

      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: themeProvider.themeColor,
      title: Text(title,textAlign: TextAlign.center,style: TextStyle(color: themeProvider.textColor),),
      content: Text(content,textAlign: TextAlign.center,style: TextStyle(color: themeProvider.textColor),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
            child: Text("Cancel",style: TextStyle(color:themeProvider.textColor),)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary
          ),
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("Remove",style: TextStyle(color: Colors.white),))
      ],

    ); }
  Widget InputBox2(TextEditingController controller,Icon icon,String hint,Color themecolor,Color textColor){
    return TextField(
      style: TextStyle(fontSize: 16,color: textColor),
      controller:controller ,

      decoration: InputDecoration(
          prefixIcon: icon ,
          prefixIconColor: AppColors.primary,
          focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primary)
          ),
          hintText: hint,
          labelText: hint,
          labelStyle:  TextStyle(fontSize: 16,color: textColor),
          hintStyle: TextStyle(fontSize: 16,color: textColor),
          fillColor: Colors.cyan.shade50,

          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(20),


          )
      ),
    );
  }
  Widget showAttendancePercent(double percent,double size){
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        CircularPercentIndicator(radius: 50.0*size,
        lineWidth: 8.08*size,
          linearGradient: LinearGradient(colors: [
            AppColors.bgColor2,
            AppColors.bgColor,

          ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
          animation: true,
          percent: percent,
          center: Text("${(percent*100).toStringAsFixed(1)}%",style: TextStyle(fontSize: 22*size,fontWeight: FontWeight.bold),),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.grey[300]!,

        ),

        ],
    );
  }

  PreferredSizeWidget appBar(String title,Color color){
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: color,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
      ),
      title:  Text(title,style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),
    );
  }

  Widget InputBox(TextEditingController controller,String hint,Icon icon,Color themecolor,Color textColor){
    return TextField(
      style: TextStyle(fontSize: 16,color: textColor),
      controller:controller,

      decoration: InputDecoration(
          filled: true,
          prefixIcon:icon,


          hintText: hint,

          hintStyle:TextStyle(fontSize: 16,color: textColor),
          fillColor: themecolor,

          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),

          )
      ),
    );
  }
}