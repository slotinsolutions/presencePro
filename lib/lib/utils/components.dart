import 'package:flutter/material.dart';
import 'package:testapp/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
class Components{
  Widget dialog(String title,String content,BuildContext context){
    return AlertDialog(

      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Colors.white,
      title: Text(title,textAlign: TextAlign.center,),
      content: Text(content,textAlign: TextAlign.center,),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
            child: Text("Cancel",style: TextStyle(color: Colors.grey),)),
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
  Widget InputBox2(TextEditingController controller,Icon icon,String hint){
    return TextField(
      style: const TextStyle(fontSize: 16),
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
          labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
          hintStyle: const TextStyle(fontSize: 16),
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

  Widget InputBox(TextEditingController controller,String hint,Icon icon){
    return TextField(
      style:const TextStyle(fontSize: 16),
      controller:controller,

      decoration: InputDecoration(
          filled: true,
          prefixIcon:icon,

          hintText: hint,

          hintStyle:const TextStyle(fontSize: 16),
          fillColor: AppColors.white,

          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),

          )
      ),
    );
  }
}