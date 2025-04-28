import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeeklyAttendance extends StatefulWidget {
  @override
  _WeeklyAttendanceState createState() => _WeeklyAttendanceState();
}

class _WeeklyAttendanceState extends State<WeeklyAttendance> {
  DateTime _focusedDay = DateTime.now();
  Set<String> presentDateStrings = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      final studentId = FirebaseAuth.instance.currentUser?.uid;

      if (studentId == null) return;

      // Step 1: Find the student in Firestore
      final ownerSnapshot = await FirebaseFirestore.instance.collection('owners').get();

      for (final ownerDoc in ownerSnapshot.docs) {
        final classSnapshot = await ownerDoc.reference.collection('classes').get();
        for (final classDoc in classSnapshot.docs) {
          final studentDoc = await classDoc.reference.collection('students').doc(studentId).get();
          if (studentDoc.exists) {
            final presentSnapshot = await studentDoc.reference.collection('presentDates').get();
            setState(() {
              presentDateStrings = presentSnapshot.docs.map((doc) => doc.id).toSet();
              isLoading = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      print("Error fetching attendance: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String getAttendanceStatus(DateTime day) {
    final dateKey = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    final today = DateTime.now();
    final isFuture = day.isAfter(today);

    if (day.weekday == DateTime.sunday) {
      return 'Holiday';
    }

    if (isFuture) {
      return 'Future';
    }

    if (presentDateStrings.contains(dateKey)) {
      return 'Present';
    }

    return 'Absent';
  }

  Color getBackgroundColor(String status) {
    switch (status) {
      case 'Present':
        return AppColors.bgColor;
      case 'Absent':
        return Colors.red.shade100;
      case 'Holiday':
        return Colors.blueGrey[300]!;
      case 'Future':
        return Colors.transparent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      color: themeProvider.themeColor,
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2101, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.week,
            daysOfWeekVisible: true,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                String status = getAttendanceStatus(day);
                return Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: getBackgroundColor(status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                String status = getAttendanceStatus(day);
                return Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: getBackgroundColor(status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            availableCalendarFormats: const {
              CalendarFormat.week: 'Week',
            },
            availableGestures: AvailableGestures.all,
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ],
      ),
    );
  }
}
