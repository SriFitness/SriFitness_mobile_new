import 'package:flutter/material.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyWorkouts = [
      {'name': 'Push-Ups', 'duration': 10, 'description': 'Do 3 sets of 15 push-ups.'},
      {'name': 'Jumping Jacks', 'duration': 5, 'description': 'Perform 50 jumping jacks.'},
      {'name': 'Plank', 'duration': 3, 'description': 'Hold the plank position for 3 minutes.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: dummyWorkouts.length,
        itemBuilder: (context, index) {
          final workout = dummyWorkouts[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(workout['name'] as String),
              subtitle: Text('Duration: ${workout['duration']} minutes'),
              onTap: () {
                _showWorkoutDetails(context, workout);
              },
            ),
          );
        },
      ),
    );
  }

  void _showWorkoutDetails(BuildContext context, Map<String, dynamic> workout) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(workout['name'] as String),
          content: Text(workout['description'] as String),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}