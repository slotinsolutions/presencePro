import 'package:flutter/material.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/components.dart';
import 'package:testapp/pages/DailyAttendance.dart';
import 'package:testapp/pages/WeeklyAttendance.dart';
import 'package:testapp/pages/MonthlyAttendance.dart';
class ViewAttendanceScreen extends StatefulWidget {
  const ViewAttendanceScreen({super.key});

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components().appBar("PRESENCE PRO", AppColors.primary),
      body: Container(
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
                           Text("Rohit Choudhary",softWrap:true,
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
