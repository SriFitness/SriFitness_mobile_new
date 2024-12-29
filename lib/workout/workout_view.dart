import 'package:flutter/material.dart';
import 'package:srifitness_app/workout/workout_plan_section.dart';

class WorkoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Workout'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs for beginner, intermediate, advanced
          TabBarSection(),
          // Workout Plans List
          Expanded(
            child: WorkoutList(),
          ),
        ],
      ),
    );
  }
}

class TabBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Beginner', style: TextStyle(fontSize: 16)),
          Text('Intermediate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Advanced', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final List<Map<String, String>> workouts = [
    {"title": "ABS INTERMEDIATE", "time": "29 mins", "exercises": "21 exercises"},
    {"title": "CHEST INTERMEDIATE", "time": "15 mins", "exercises": "14 exercises"},
    {"title": "ARM INTERMEDIATE", "time": "26 mins", "exercises": "25 exercises"},
    {"title": "LEG INTERMEDIATE", "time": "41 mins", "exercises": "36 exercises"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return WorkoutCard(
          title: workout['title']!,
          time: workout['time']!,
          exercises: workout['exercises']!,
        );
      },
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String time;
  final String exercises;

  WorkoutCard({
    required this.title,
    required this.time,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("$time · $exercises"),
        leading: Icon(Icons.fitness_center, color: Colors.blue),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigation or details logic
        },
      ),
    );
  }
}
