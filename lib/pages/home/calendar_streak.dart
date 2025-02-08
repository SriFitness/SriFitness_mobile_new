import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

class FullMonthCalendar extends StatefulWidget {
  @override
  _FullMonthCalendarState createState() => _FullMonthCalendarState();
}

class _FullMonthCalendarState extends State<FullMonthCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DateTime> _holidays = [];

  @override
  void initState() {
    super.initState();
    _fetchHolidays();
  }

  Future<void> _fetchHolidays() async {
    final response = await http.get(Uri.parse('https://api.example.com/holidays/sri-lanka/${_focusedDay.year}'));
    if (response.statusCode == 200) {
      final List<dynamic> holidaysJson = json.decode(response.body);
      setState(() {
        _holidays = holidaysJson.map((holiday) => DateTime.parse(holiday['date'])).toList();
      });
    }
  }

  bool _isHoliday(DateTime day) {
    return _holidays.any((holiday) => holiday.day == day.day && holiday.month == day.month && holiday.year == day.year);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Transform.translate(
              offset: Offset(0, -20), // Adjust the offset to move the calendar up
              child: TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _fetchHolidays();
                  });
                },
                calendarBuilders: CalendarBuilders(
                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18), // Increased font size
                      ),
                    );
                  },
                  holidayBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green, // Changed to green color
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
                holidayPredicate: _isHoliday,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                headerStyle: HeaderStyle(
                  titleCentered: true, // Center the month name
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}