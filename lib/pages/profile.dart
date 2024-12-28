import 'package:flutter/material.dart';
import 'package:srifitness_app/widget/logout_button.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: LogoutButton(),
      ),
    );
  }
}