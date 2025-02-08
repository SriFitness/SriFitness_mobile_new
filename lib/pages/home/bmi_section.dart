import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srifitness_app/widget/colo_extension.dart';

class BMISection extends StatefulWidget {
  const BMISection({super.key});

  @override
  _BMISectionState createState() => _BMISectionState();
}

class _BMISectionState extends State<BMISection> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  double _bmi = 0.0;
  String _bmiCategory = '';

  void _calculateBMI() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text);

    if (_weightUnit == 'lbs') {
      weight = weight * 0.453592; // convert lbs to kg
    }
    if (_heightUnit == 'inches') {
      height = height * 2.54; // convert inches to cm
    }

    height = height / 100; // convert cm to meters
    setState(() {
      _bmi = weight / (height * height);
      _bmiCategory = _getBMICategory(_bmi);
    });
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'BMI Calculator',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.maincolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Calculate',
                    style: TextStyle(color: TColor.textcolor,fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.black12,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextField(
                            controller: _weightController,
                            decoration: const InputDecoration(
                              labelText: 'Weight',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          DropdownButton<String>(
                            value: _weightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                _weightUnit = newValue!;
                              });
                            },
                            items: <String>['kg', 'lbs']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: Colors.black12,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              labelText: 'Height',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          DropdownButton<String>(
                            value: _heightUnit,
                            onChanged: (String? newValue) {
                              setState(() {
                                _heightUnit = newValue!;
                              });
                            },
                            items: <String>['cm', 'inches']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _bmi.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _bmiCategory,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            BMIIndicator(bmi: _bmi),
          ],
        ),
      ),
    );
  }
}

class BMIIndicator extends StatelessWidget {
  final double bmi;

  BMIIndicator({required this.bmi});

  @override
  Widget build(BuildContext context) {
    double minBMI = 15.0;
    double maxBMI = 40.0;
    double barWidth = MediaQuery.of(context).size.width - 64; // Adjust for padding
    double leftPosition = ((bmi - minBMI) / (maxBMI - minBMI)) * barWidth;

    // Ensure the cursor stays within the bounds of the gradient bar
    if (leftPosition < 0) leftPosition = 0;
    if (leftPosition > barWidth) leftPosition = barWidth;

    return Column(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: const LinearGradient(
              colors: [
                Colors.blue, // Underweight
                Colors.green, // Normal
                Colors.yellow, // Overweight
                Colors.orange, // Obesity
                Colors.red, // Severe Obesity
              ],
              stops: [0.0, 0.3, 0.5, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: leftPosition,
                top: -30, // Position the cursor above the color bar
                child: Column(
                  children: [
                    const Icon(
                      CupertinoIcons.arrowtriangle_down_fill,
                      color: Colors.black,
                      size: 50, // Increased size
                    ),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        const Row(
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