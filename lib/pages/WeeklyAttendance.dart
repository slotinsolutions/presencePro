import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:testapp/utils/colors.dart';

class WeeklyAttendance extends StatefulWidget {
  @override
  _WeeklyAttendanceState createState() => _WeeklyAttendanceState();
}

class _WeeklyAttendanceState extends State<WeeklyAttendance> {

  DateTime _focusedDay = DateTime.now();


  String getAttendanceStatus(DateTime day) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(Duration(days: 1));
    if (day.year == today.year && day.month == today.month && day.day == today.day) {
      return 'Present';
    }else if(day.isAfter(today)){
      return "Future";
    }
    else if (day.year == yesterday.year && day.month == yesterday.month && day.day == yesterday.day) {
      return 'Absent';
    } else if (day.weekday == DateTime.sunday) {
      return 'Holiday';
    } else {
      return 'Holiday';
    }
  }

  Color getBackgroundColor(String status) {
    switch (status) {
      case 'Present':
        return AppColors.bgColor;
      case 'Absent':
        return Colors.red.shade100;
      case 'Holiday':
        return Colors.blue.shade100;
      case 'Future':
        return Colors.transparent;
      default:
        return Colors.white;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.black,
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
                        borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colors.black,
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
                titleTextStyle: TextStyle(fontSize:18,fontWeight: FontWeight.bold),
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ],
        ),
      );

  }
}

