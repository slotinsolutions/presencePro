import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/theme_provider.dart';

class DailyAttendance extends StatefulWidget {
  @override
  _DailyAttendanceState createState() => _DailyAttendanceState();
}

class _DailyAttendanceState extends State<DailyAttendance> {
  DateTime selectedDate = DateTime.now();
  String attendanceStatus = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendanceStatus();
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
      attendanceStatus = "Loading...";
      isLoading = true;
    });
    fetchAttendanceStatus();
  }

  Future<void> fetchAttendanceStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = selectedDate.toString().split(' ')[0];

    try {
      final owners = await FirebaseFirestore.instance.collection('owners').get();
      for (var owner in owners.docs) {
        final classes = await owner.reference.collection('classes').get();
        for (var classDoc in classes.docs) {
          final studentsRef = classDoc.reference.collection('students');
          final query = await studentsRef.where('studentEmail', isEqualTo: user.email).get();
          if (query.docs.isNotEmpty) {
            final studentDoc = query.docs.first;
            final presentDateDoc = await studentDoc.reference
                .collection('presentDates')
                .doc(today)
                .get();

            setState(() {
              if (presentDateDoc.exists) {
                attendanceStatus = "Present";
              } else if (selectedDate.weekday == DateTime.sunday) {
                attendanceStatus = "Holiday";
              } else {
                attendanceStatus = "Absent";
              }
              isLoading = false;
            });
            return;
          }
        }
      }
      setState(() {
        attendanceStatus = "Absent";
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
      setState(() {
        attendanceStatus = "Error";
        isLoading = false;
      });
    }
  }

  Color getAttendanceColor(String status) {
    if (status == "Present") return AppColors.bgColor;
    if (status == "Absent") return Colors.red;
    if (status == "Holiday") return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final attendanceColor = getAttendanceColor(attendanceStatus);

    return Container(
      color: themeProvider.themeColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _changeDate(-1),
                ),
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    fontSize: 18,
                    color: themeProvider.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (selectedDate.isBefore(
                        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
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
                color: themeProvider.themeColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Attendance Status",
                        style: TextStyle(
                          fontSize: 18,
                          color: themeProvider.textColor,
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
                              : attendanceStatus == "Holiday"
                              ? Icons.block
                              : Icons.error,
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
                            ? "Marked"
                            : attendanceStatus == "Absent"
                            ? "No attendance marked"
                            : attendanceStatus == "Holiday"
                            ? "Sunday"
                            : "Unable to fetch",
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