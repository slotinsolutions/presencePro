import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/pages/SideMenu.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/pages/DailyAttendance.dart';
import 'package:testapp/pages/WeeklyAttendance.dart';
import 'package:testapp/pages/MonthlyAttendance.dart';
import 'package:testapp/utils/theme_provider.dart';
class ViewAttendanceScreen extends StatefulWidget {
  final String studentid;
  String? userType;
 ViewAttendanceScreen({super.key,required this.studentid,required this.userType});

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  String? ownerid;
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  GlobalKey<ScaffoldState> _drawerkey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? instituteName;


  @override
  void initState() {
    super.initState();

    fetchInstituteName();

    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> fetchInstituteName() async {
    await fetchStudentData(widget.studentid);
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          instituteName = docSnapshot["instituteName"];
        });
      } else {
        print("Owner not found.");
      }
    } catch (e) {
      print("Error fetching institute name: $e");
    }
  }
  Future<void> fetchStudentData(String studentId) async {


    try {
      QuerySnapshot ownersSnapshot = await FirebaseFirestore.instance.collection('owners').get();

      for (var owner in ownersSnapshot.docs) {
        QuerySnapshot classesSnapshot = await owner.reference.collection('classes').get();

        for (var classDoc in classesSnapshot.docs) {
          DocumentSnapshot studentDoc =
          await classDoc.reference.collection('students').doc(studentId).get();

          if (studentDoc.exists) {
            setState(() {
              studentData = studentDoc.data() as Map<String, dynamic>;
              ownerid = owner.id;
              isLoading = false;
            });
            return;
          }
        }
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student not found!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      key: _drawerkey,
      drawer: SideMenu(),
      backgroundColor: themeProvider.themeColor,
      appBar:  AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title:  Text("$instituteName",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),

        leading: IconButton(onPressed: (){
          _drawerkey.currentState?.openDrawer();
        },
            icon: Icon(Icons.menu,color: Colors.white,)),
      ),
      body:isLoading==true? Center(
        child: CircularProgressIndicator(color: AppColors.primary,),
      ):Container(
        color: themeProvider.themeColor,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(

              children: [
               Card(
                 color: themeProvider.themeColor,

                 elevation: 5,
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           widget.userType=="STUDENT"?Text("Welcome,",style: TextStyle(fontSize: 25,color: themeProvider.textColor),):SizedBox(),
                           Text(studentData?['studentName'],softWrap:true,
                               overflow: TextOverflow.visible,

                               style: TextStyle(fontSize: 30,fontWeight:FontWeight.w500,color: AppColors.bgColor2)),
                         ],),

                       Column(
                           mainAxisSize: MainAxisSize.min,

                           children: [
                             Components().showAttendancePercent(0.85,1),
                             Text("Overall",style: TextStyle(fontSize: 18,color: themeProvider.textColor,fontWeight: FontWeight.w500),)


                           ],
                       ),


                       SizedBox(height: 30,),


                     ],
                   ),
                 ),
               ),
                SizedBox(height: 30,),
                Container(

                  child: TabBar(
                    labelStyle: TextStyle(
                      fontSize: 20,fontWeight: FontWeight.w500
                    ),
                    controller: _tabController,
                    labelColor: AppColors.primary, // Selected tab text color (App color)
                    unselectedLabelColor: Colors.grey, // Unselected tab text color
                    indicatorColor: Colors.transparent, // Remove the indicator line
                    tabs: const[
                      Tab(text: "Daily",), // Tab for Daily
                      Tab(text: "Weekly"), // Tab for Weekly
                      Tab(text: "Monthly"), // Tab for Monthly
                    ],
                  ),
                ),

                Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        children: [
                          DailyAttendance(),

                         WeeklyAttendance(),
                          MonthlyAttendance()
                        ])
                )

              ],
            ),
        ),
      ),
    );
  }
}
