import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testapp/utils/colors.dart';
import 'package:testapp/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonthlyAttendance extends StatefulWidget {
  @override
  _MonthlyAttendanceState createState() => _MonthlyAttendanceState();
}

class _MonthlyAttendanceState extends State<MonthlyAttendance> {
  final DateTime _focusedDay = DateTime.now();
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2101, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              daysOfWeekVisible: true,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  String status = getAttendanceStatus(day);
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: getBackgroundColor(status),
                      shape: BoxShape.rectangle,
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
                      shape: BoxShape.rectangle,
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
                outsideBuilder: (context, day, focusedDay) {
                  return Container();
                },
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              availableGestures: AvailableGestures.all,
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(fontSize: 18, color: themeProvider.textColor, fontWeight: FontWeight.bold),
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
