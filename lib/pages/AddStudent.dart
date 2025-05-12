import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/Teachers.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/utils/constants.dart';
import 'package:testapp/utils/firestore.dart';
import 'package:testapp/utils/theme_provider.dart';

class AddstudentScreen extends StatefulWidget {
  String? userType;
   AddstudentScreen({super.key,required this.userType});

  @override
  State<AddstudentScreen> createState() => _AddstudentScreenState();
}

class _AddstudentScreenState extends State<AddstudentScreen> {
   String? selectedCLass;
   final FirebaseAuth _auth = FirebaseAuth.instance;
   bool isLoading = false; // added loading

   TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password= TextEditingController();
  TextEditingController rollno= TextEditingController();
  TextEditingController rfidID= TextEditingController();
  TextEditingController beaconID= TextEditingController();
   TextEditingController adminPassword= TextEditingController();
String? ownerIdIfadmin;

   List<String> classList = [];

   @override
   void initState() {
   super.initState();

   fetchClasses();

   }
   Future<void> fetchownerifforadmin()async{
     String? fetchedownerid = await Firebase_Firestore().getOwnerIdForAdmin(_auth.currentUser!.uid);
     setState(() {
       ownerIdIfadmin = fetchedownerid;
     });
   }


   Future<void> fetchClasses() async {
   await fetchownerifforadmin();


   try {
   QuerySnapshot snapshot = await FirebaseFirestore.instance
       .collection('owners')
       .doc(widget.userType=="OWNER"?_auth.currentUser!.uid:ownerIdIfadmin)
       .collection('classes')
       .get();

   List<String> fetchedClasses = snapshot.docs.map((doc) => doc["className"] as String).toList();

   setState(() {
   classList = fetchedClasses;
   });
   } catch (e) {
   print("Error fetching classes: $e");
   }
   }

// show loading
  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // hide loader
  void hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
     String? usertype = widget.userType;
    final themeProvider = Provider.of<ThemeProvider>(context);
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:  Components().appBar("ADD STUDENT", AppColors.primary),
    backgroundColor: themeProvider.themeColor,
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
                    hint: Text("Select Class of Student",style:TextStyle(color: themeProvider.textColor) ,),
                    decoration: InputDecoration(

                      prefixIcon: Icon(Icons.menu_book_rounded,color: AppColors.primary,),
                      suffixIconColor: AppColors.primary,
                      filled: true,
                      fillColor: themeProvider.themeColor,

                      hintText: "Select Class of Student",
                      hintStyle: TextStyle(color: AppColors.primary),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    items: classList.map((String className){
                      return DropdownMenuItem(


                          value: className,

                          child: Text(className));
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedCLass=newValue;
                      });
                    },
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(20),


                  ),
                ),
                SizedBox(height: 15,),
                Components().InputBox2(name, Icon(Icons.person), "Name",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),
                Components().InputBox2(email, Icon(Icons.email), "Email Address",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: w*0.51,
                        child: Components().InputBox2(password, Icon(Icons.lock), "Password",themeProvider.themeColor,themeProvider.textColor)),

                    SizedBox(

                        width:w*0.38,
                        child: Components().InputBox2(rollno, Icon(Icons.format_list_numbered_rtl), "Roll Number",themeProvider.themeColor,themeProvider.textColor)),
                  ],
                ),
                SizedBox(height: 15,),
                Components().InputBox2(rfidID, Icon(Icons.signal_cellular_alt), "RFID Tag ID",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),
                Components().InputBox2(beaconID, Icon(Icons.bluetooth_audio), "Beacon ID",themeProvider.themeColor,themeProvider.textColor),
                SizedBox(height: 15,),
                Components().InputBox2(adminPassword, Icon(Icons.lock), "Enter $usertype Password",themeProvider.themeColor,themeProvider.textColor),

                SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                    width: w*0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary
                      ),
                        onPressed: isLoading ? null : () async {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          widget.userType=="OWNER"
                          ?await Firebase_Firestore().registerStudentAsOwner(
                              context: context,
                              ownerPassword: adminPassword.text,
                              ownerId: _auth.currentUser!.uid,
                              className: selectedCLass!,
                              studentName: name.text,
                              studentEmail: email.text,
                              studentPassword: password.text,
                              rollNumber: rollno.text,
                              rfidTagId: rfidID.text,
                              beaconId: beaconID.text):
                          await Firebase_Firestore().registerStudentAsOwner(
                              context: context,ownerPassword: adminPassword.text,
                              ownerId: ownerIdIfadmin!,
                              className: selectedCLass!,
                              studentName: name.text,
                              studentEmail: email.text,
                              studentPassword: password.text,
                              rollNumber: rollno.text,
                              rfidTagId: rfidID.text,
                              beaconId: beaconID.text);
                          setState(() {
                            name.clear();
                            email.clear();
                            password.clear();
                            rollno.clear();
                            rfidID.clear();
                            beaconID.clear();
                            adminPassword.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Student registered successfully!'),duration: Duration(milliseconds: 250),),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registration failed. Please try again later.'), duration: Duration(milliseconds: 500),),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                        },
                        child: isLoading
                            ? CircularProgressIndicator( color: Colors.white,)
                            : Text("Register Student",style: TextStyle(fontSize: 14,color: Colors.white),)),
                  ),
                )
              ],
          ),
        ),
      ),),
    );
  }
}
