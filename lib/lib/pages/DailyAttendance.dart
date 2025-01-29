import 'package:flutter/material.dart';
import 'package:testapp/utils/colors.dart';

class DailyAttendance extends StatefulWidget {
  @override
  _DailyAttendanceState createState() => _DailyAttendanceState();
}

class _DailyAttendanceState extends State<DailyAttendance> {
  DateTime selectedDate = DateTime.now();

   final Map<String, String> attendanceData = {
    DateTime.now().toString().split(' ')[0]: "Present",
    DateTime.now()
        .subtract(Duration(days: 1))
        .toString()
        .split(' ')[0]: "Absent",
  };


  String defaultStatus = "Holiday";

   String getAttendanceStatus() {
    final dateKey = selectedDate.toString().split(' ')[0];
    return attendanceData[dateKey] ?? defaultStatus;
  }


  Color getAttendanceColor(String status) {
    if (status == "Present") return AppColors.bgColor;
    if (status == "Absent") return Colors.red;
    return Colors.orange;
  }


  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceStatus = getAttendanceStatus();
    final attendanceColor = getAttendanceColor(attendanceStatus);

    return Container(
      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _changeDate(-1),  ),
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (selectedDate.isBefore(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))) {
                      _changeDate(1);
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 20),


            Container(
              color: Colors.transparent,
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Today's Attendance",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),


                      CircleAvatar(
                        radius: 50,
                        backgroundColor: attendanceColor.withOpacity(0.1),
                        child: Icon(
                          attendanceStatus == "Present"
                              ? Icons.check_circle
                              : attendanceStatus == "Absent"
                              ? Icons.cancel
                              : Icons.block,
                          color: attendanceColor,
                          size: 50,
                        ),
                      ),
                      SizedBox(height: 20),


                      Text(
                        attendanceStatus,
                        style: TextStyle(
                          fontSize: 22,
                          color: attendanceColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),


                      Text(
                        attendanceStatus == "Present"
                            ? "Marked at 9:30 AM"
                            : attendanceStatus == "Absent"
                            ? "No attendance marked"
                            : "Holiday",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
