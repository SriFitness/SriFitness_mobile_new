import 'package:flutter/material.dart';
import 'package:srifitness_app/components/calendar_streak.dart';
import 'package:srifitness_app/components/weight_section.dart';
import 'package:srifitness_app/components/bmi_section.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome to SRI Fitness App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CalendarStreak(),
            SizedBox(height: 24),
            WeightSection(),
            SizedBox(height: 24),
            BMISection(),
            // Add more sections here
          ],
        ),
      ),
    );
  }
}