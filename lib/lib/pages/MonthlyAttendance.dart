import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testapp/utils/colors.dart';

class MonthlyAttendance extends StatefulWidget {
  @override
  _MonthlyAttendanceState createState() => _MonthlyAttendanceState();
}

class _MonthlyAttendanceState extends State<MonthlyAttendance> {

  final DateTime _focusedDay = DateTime.now();


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
                      borderRadius: BorderRadius.circular(10)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style:const TextStyle(
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                outsideBuilder: (context,day,focusedDay){
                  return Container();
                }


              ),

              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              availableGestures: AvailableGestures.all,
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(fontSize:18,fontWeight: FontWeight.bold),

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

