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
                SizedBox(height: 20,),
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
                ),

                Divider(color: Colors.grey, ),
                SizedBox(height: 5,),


                if (widget.userType == "STUDENT")
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                  ),

                  onPressed: () async {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      final studentId = user?.uid;

                      if (studentId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Student not logged in.')),
                        );
                        return;
                      }

                      // Loop by all owners
                      final ownersSnapshot = await FirebaseFirestore.instance.collection('owners').get();
                      bool studentFound = false;

                      for (var ownerDoc in ownersSnapshot.docs) {
                        String ownerId = ownerDoc.id;

                        // Loop by all classes for owner
                        final classesSnapshot = await FirebaseFirestore.instance
                            .collection('owners')
                            .doc(ownerId)
                            .collection('classes')
                            .get();

                        for (var classDoc in classesSnapshot.docs) {
                          String classId = classDoc.id;

                          // Check if student exists
                          final studentDoc = await FirebaseFirestore.instance
                              .collection('owners')
                              .doc(ownerId)
                              .collection('classes')
                              .doc(classId)
                              .collection('students')
                              .doc(studentId)
                              .get();

                          if (studentDoc.exists) {
                            final studentData = studentDoc.data()!;
                            String studentName = studentData['studentName'];
                            String rollNumber = studentData['rollNumber'];

                            String todayDate = DateTime.now().toIso8601String().split("T")[0];

                            // Check already marked
                            final presentDateDoc = await FirebaseFirestore.instance
                                .collection('owners')
                                .doc(ownerId)
                                .collection('classes')
                                .doc(classId)
                                .collection('students')
                                .doc(studentId)
                                .collection('presentDates')
                                .doc(todayDate)
                                .get();

                            if (presentDateDoc.exists) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Attendance already marked for today.')),
                              );
                              return;
                            }

                            // Mark attendance
                            await FirebaseFirestore.instance
                                .collection('owners')
                                .doc(ownerId)
                                .collection('classes')
                                .doc(classId)
                                .collection('students')
                                .doc(studentId)
                                .collection('presentDates')
                                .doc(todayDate)
                                .set({
                              'name': studentName,
                              'rollNumber': rollNumber,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Attendance marked successfully!')),
                            );

                            studentFound = true;
                            break;
                          }
                        }

                        if (studentFound) break;
                      }

                      if (!studentFound) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Student not found in any class.')),
                        );
                      }
                    } catch (e) {
                      print("Error marking attendance: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to mark attendance.')),
                      );
                    }
                  },


                  icon: Icon(Icons.check_circle_outline,color: Colors.white, size: 23,),
                  label: Text("I'm Present",
                    style:TextStyle(color: Colors.white, fontSize:23),
                  ),
                ),


              ],
            ),
        ),
      ),
    );
  }
}
