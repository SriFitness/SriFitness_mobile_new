import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/login.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
        );
      },
    );
  }
}