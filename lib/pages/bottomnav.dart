import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/home.dart';
import 'package:srifitness_app/pages/marketplace.dart';
import 'package:srifitness_app/pages/profile.dart';
import 'package:srifitness_app/pages/workout.dart';



class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late MarketPlace marketPlace;
  late WorkoutView workoutView;
  late Profile profile;

  @override
  void initState() {
    homepage = Home();
    marketPlace = MarketPlace();
    workoutView = WorkoutView();
    profile = Profile();
    pages = [homepage, marketPlace, workoutView, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.fitness_center_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
