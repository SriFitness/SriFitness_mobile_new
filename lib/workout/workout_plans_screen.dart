import 'package:flutter/material.dart';
import 'package:srifitness_app/widget/workout_card.dart';
import 'package:srifitness_app/widget/workout_day.dart';

class WorkoutPlansScreen extends StatefulWidget {
  @override
  _WorkoutPlansScreenState createState() => _WorkoutPlansScreenState();
}

class _WorkoutPlansScreenState extends State<WorkoutPlansScreen> {
  int selectedDayIndex = 0;

  final List<Map<String, String>> workouts = [
    {
      'title': 'Chest Workout',
      'description': 'A great workout for building chest muscles.',
      'imageUrl': 'images/chest_workout.jpg',
    },
    {
      'title': 'Back Workout',
      'description': 'Strengthen your back with these exercises.',
      'imageUrl': 'images/biceps_workout.jpg',
    },
    {
      'title': 'Leg Workout',
      'description': 'Build strong legs with this workout.',
      'imageUrl': 'images/legs_workout.jpg',
    },
    {
      'title': 'Arm Workout',
      'description': 'Tone your arms with these exercises.',
      'imageUrl': 'assets/images/arm_workout.jpg',
    },
    {
      'title': 'Shoulder Workout',
      'description': 'Build strong shoulders with this workout.',
      'imageUrl': 'assets/images/shoulder_workout.jpg',
    },
    {
      'title': 'Abs Workout',
      'description': 'Get a strong core with these exercises.',
      'imageUrl': 'assets/images/abs_workout.jpg',
    },
    {
      'title': 'Cardio Workout',
      'description': 'Burn calories with this cardio workout.',
      'imageUrl': 'assets/images/cardio_workout.jpg',
    },
    {
      'title': 'Full Body Workout',
      'description': 'A complete workout for your entire body.',
      'imageUrl': 'assets/images/full_body_workout.jpg',
    },
    {
      'title': 'Yoga Workout',
      'description': 'Relax and stretch with this yoga routine.',
      'imageUrl': 'assets/images/yoga_workout.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plans'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return DayButton(
                  day: 'Day-${index + 1}',
                  onPressed: () {
                    setState(() {
                      selectedDayIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
          Expanded(
            child: WorkoutList(
              difficulty: 'Day-${selectedDayIndex + 1}',
              workouts: workouts,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final String difficulty;
  final List<Map<String, String>> workouts;

  WorkoutList({required this.difficulty, required this.workouts});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: workouts.map((workout) {
        return WorkoutCard(
          title: workout['title']!,
          description: workout['description']!,
          imageUrl: workout['imageUrl']!,
        );
      }).toList(),
    );
  }
}
