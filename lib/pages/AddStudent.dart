import 'package:flutter/material.dart';
import 'package:testapp/pages/Teachers.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/constants.dart';

class AddstudentScreen extends StatefulWidget {
  const AddstudentScreen({super.key});

  @override
  State<AddstudentScreen> createState() => _AddstudentScreenState();
}

class _AddstudentScreenState extends State<AddstudentScreen> {
   String? selectedCLass;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController rollno= TextEditingController();
  TextEditingController rfidID= TextEditingController();
  TextEditingController beaconID= TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:  Components().appBar("ADD STUDENT", AppColors.primary),
    backgroundColor: AppColors.white,
      body: Padding(
          padding: EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("  Enter Student Details",style: TextStyle(fontSize: 30,color: AppColors.primary,fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.bgColor2
                    ),
                    borderRadius: BorderRadius.circular(20)

                  ),
                  child: DropdownButtonFormField(
                    value: selectedCLass,
                    decoration: InputDecoration(

                      prefixIcon: Icon(Icons.menu_book_rounded,color: AppColors.primary,),
                      suffixIconColor: AppColors.primary,
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: "Select Class of Student",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    items: Constants().classes.map((String Type){
                      return DropdownMenuItem(

                          value: Type,
                          child: Text(Type));
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedCLass=newValue;
                      });
                    },


                  ),
                ),
                SizedBox(height: 15,),
                Components().InputBox2(name, Icon(Icons.person), "Name"),
                SizedBox(height: 15,),
                Components().InputBox2(email, Icon(Icons.email), "Email Address"),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: w*0.51,
                        child: Components().InputBox2(password, Icon(Icons.lock), "Password")),

                    SizedBox(

                        width:w*0.38,
                        child: Components().InputBox2(rollno, Icon(Icons.format_list_numbered_rtl), "Roll Number")),
                  ],
                ),
                SizedBox(height: 15,),
                Components().InputBox2(rfidID, Icon(Icons.signal_cellular_alt), "RFID Tag ID"),
                SizedBox(height: 15,),
                Components().InputBox2(beaconID, Icon(Icons.bluetooth_audio), "Beacon ID"),
                SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                    width: w*0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary
                      ),
                        onPressed: (){

                        },
                        child: Text("Register Student",style: TextStyle(fontSize: 14,color: Colors.white),)),
                  ),
                )
              ],
          ),
        ),
      ),),
    );
  }
}
