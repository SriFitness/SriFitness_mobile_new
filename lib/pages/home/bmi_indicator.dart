import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BMIIndicator extends StatelessWidget {
  final double bmi;

  BMIIndicator({required this.bmi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: bmi < 18.5 ? bmi : 18.5,
                      title: '',
                      radius: 100,
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: bmi >= 18.5 && bmi < 25 ? bmi - 18.5 : 25 - 18.5,
                      title: '',
                      radius: 100,
                    ),
                    PieChartSectionData(
                      color: Colors.yellow,
                      value: bmi >= 25 && bmi < 30 ? bmi - 25 : 30 - 25,
                      title: '',
                      radius: 100,
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: bmi >= 30 && bmi < 35 ? bmi - 30 : 35 - 30,
                      title: '',
                      radius: 100,
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: bmi >= 35 ? bmi - 35 : 40 - 35,
                      title: '',
                      radius: 100,
                    ),
                  ],
                  centerSpaceRadius: 50,
                  sectionsSpace: 0,
                ),
              ),
              Center(
                child: Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Underweight'),
            Text('Normal'),
            Text('Overweight'),
            Text('Obesity'),
          ],
        ),
      ],
    );
  }
}