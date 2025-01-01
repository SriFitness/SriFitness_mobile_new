
import 'package:flutter/material.dart';

class CalendarStreak extends StatelessWidget {
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
WeekCalendar(),
SizedBox(height: 16),
Row(
children: [
Icon(Icons.local_fire_department, color: Colors.red),
SizedBox(width: 8),
Text(
'Day Streak',
style: TextStyle(
color: Colors.grey[600],
fontSize: 16,
),
),
SizedBox(width: 8),
Text(
'0',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
],
),
],
),
),
);
}
}

class WeekCalendar extends StatelessWidget {
@override
Widget build(BuildContext context) {
final now = DateTime.now();
final days = List.generate(7, (index) {
final date = now.subtract(Duration(days: now.weekday - index - 1));
return date;
});

return Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
for (var day in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
Text(
day,
style: TextStyle(
color: Colors.grey[600],
fontWeight: FontWeight.w500,
),
),
// Add date numbers below
],
);
}
}