import 'package:flutter/material.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({Key? key}) : super(key: key);

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Workout'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          WorkoutList(difficulty: 'Beginner'),
          WorkoutList(difficulty: 'Intermediate'),
          WorkoutList(difficulty: 'Advanced'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Add WorkoutList widget
class WorkoutList extends StatelessWidget {
  final String difficulty;

  const WorkoutList({Key? key, required this.difficulty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Replace with actual workout count
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$difficulty Workout ${index + 1}'),
          subtitle: Text('30 mins'),
          leading: Icon(Icons.fitness_center),
          onTap: () {
            // Handle workout selection
          },
        );
      },
    );
  }
}
