import 'package:flutter/material.dart';

class DayButton extends StatelessWidget {
  final String day;
  final VoidCallback onPressed;

  DayButton({required this.day, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      onPressed: onPressed,
      child: Text(
        day,
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
