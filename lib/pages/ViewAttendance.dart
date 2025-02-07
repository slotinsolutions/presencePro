import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/pages/SideMenu.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/pages/DailyAttendance.dart';
import 'package:testapp/pages/WeeklyAttendance.dart';
import 'package:testapp/pages/MonthlyAttendance.dart';
class ViewAttendanceScreen extends StatefulWidget {
  final String studentid;
  const ViewAttendanceScreen({super.key,required this.studentid});

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  GlobalKey<ScaffoldState> _drawerkey = GlobalKey();



  @override
  void initState() {
    super.initState();
    fetchStudentData(widget.studentid);

    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> fetchStudentData(String studentId) async {


    try {
      QuerySnapshot adminsSnapshot = await FirebaseFirestore.instance.collection('users').get();

      for (var admin in adminsSnapshot.docs) {
        QuerySnapshot classesSnapshot = await admin.reference.collection('classes').get();

        for (var classDoc in classesSnapshot.docs) {
          DocumentSnapshot studentDoc =
          await classDoc.reference.collection('students').doc(studentId).get();

          if (studentDoc.exists) {
            setState(() {
              studentData = studentDoc.data() as Map<String, dynamic>;
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
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      key: _drawerkey,
      drawer: SideMenu(),
      backgroundColor: Colors.white,
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
      ), body:isLoading==true? Center(
        child: CircularProgressIndicator(color: AppColors.primary,),
      ):Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(

              children: [
               Card(
                 color: Colors.white,

                 elevation: 5,
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("Welcome,",style: TextStyle(fontSize: 25,color: AppColors.black),),
                           Text(studentData?['studentName'],softWrap:true,
                               overflow: TextOverflow.visible,

                               style: TextStyle(fontSize: 30,fontWeight:FontWeight.w500,color: AppColors.bgColor2)),
                         ],),

                       Column(
                           mainAxisSize: MainAxisSize.min,

                           children: [
                             Components().showAttendancePercent(0.85,1),
                             Text("Overall",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)


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
