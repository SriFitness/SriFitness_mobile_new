
import 'package:flutter/material.dart';

class BMISection extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'BMI',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
ElevatedButton(
onPressed: () {},
child: Text('Edit'),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.blue,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
),
),
],
),
SizedBox(height: 16),
Card(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
child: Padding(
padding: EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'16.7',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 16),
BMIIndicator(),
SizedBox(height: 8),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('15'),
Text('18.5'),
Text('25'),
Text('30'),
Text('35'),
Text('40'),
],
),
],
),
),
),
],
);
}
}

class BMIIndicator extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Container(
height: 20,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(10),
gradient: LinearGradient(
colors: [
Colors.blue,
Colors.blue[300]!,
Colors.green[300]!,
Colors.yellow[300]!,
Colors.orange[300]!,
Colors.red[300]!,
],
),
),
child: Stack(
children: [
Positioned(
left: 40, // Calculate position based on BMI value
child: Icon(
Icons.arrow_drop_down,
color: Colors.black,
size: 30,
),
),
],
),
);
}
}