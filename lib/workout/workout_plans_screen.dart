import 'package:flutter/material.dart';


class WorkoutPlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Workout Plans'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Beginner'),
              Tab(text: 'Intermediate'),
              Tab(text: 'Advanced'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WorkoutList(difficulty: 'Beginner'),
            WorkoutList(difficulty: 'Intermediate'),
            WorkoutList(difficulty: 'Advanced'),
          ],
        ),
      ),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final String difficulty;
  
  const WorkoutList({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // children: [
      //   WorkoutCard(
      //     title: '$difficulty Full Body',
      //     time: '30 min',
      //     exercises: '12 exercises',
      //   ),
      //   WorkoutCard(
      //     title: '$difficulty Core',
      //     time: '20 min',
      //     exercises: '8 exercises',
      //   ),
      // ],
    );
  }
}