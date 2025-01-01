
import 'package:flutter/material.dart';
import 'package:srifitness_app/components/calendar_streak.dart';
import 'package:srifitness_app/components/weight_section.dart';
import 'package:srifitness_app/components/bmi_section.dart';
class DashboardScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(
'REPORT',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),
backgroundColor: Colors.transparent,
elevation: 0,
),
body: SingleChildScrollView(
padding: EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
CalendarStreak(),
SizedBox(height: 24),
WeightSection(),
SizedBox(height: 24),
BMISection(),
],
),
),
);
}
}