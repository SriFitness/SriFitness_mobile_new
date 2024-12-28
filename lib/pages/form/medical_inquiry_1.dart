import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_2.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';

class MedicalInquiry1 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const MedicalInquiry1({super.key, required this.onSave});

  @override
  State<MedicalInquiry1> createState() => _MedicalInquiry1State();
}

class _MedicalInquiry1State extends State<MedicalInquiry1> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedHeartProblem;

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> medicalInquiry1Data = {
        'heartProblem': _selectedHeartProblem,
      };
      widget.onSave(medicalInquiry1Data);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MedicalInquiry2(onSave: widget.onSave, previousData: medicalInquiry1Data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'SRI FITNESS'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Medical Inquiry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: TColor.defaultwhitecolor,
                  ),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: '01 Heart problems?',
                  value: _selectedHeartProblem,
                  onChanged: (value) => setState(() {
                    _selectedHeartProblem = value;
                  }),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.maincolor,
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: TColor.textcolor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: TColor.textcolor),
        border: OutlineInputBorder(),
      ),
      value: value,
      items: ['Yes', 'No'].map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select an option';
        }
        return null;
      },
    );
  }
}
