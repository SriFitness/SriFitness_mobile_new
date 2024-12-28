import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_3.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';

class MedicalInquiry2 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic> previousData;

  const MedicalInquiry2({super.key, required this.onSave, required this.previousData});

  @override
  State<MedicalInquiry2> createState() => _MedicalInquiry2State();
}

class _MedicalInquiry2State extends State<MedicalInquiry2> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBackPain;

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> medicalInquiry2Data = {
        'backPain': _selectedBackPain,
      };
      widget.onSave({...widget.previousData, ...medicalInquiry2Data});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MedicalInquiry3(onSave: widget.onSave, previousData: {...widget.previousData, ...medicalInquiry2Data})),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'SRI FITNESS'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  label: '07 Back/spinal pain?',
                  value: _selectedBackPain,
                  onChanged: (value) => setState(() {
                    _selectedBackPain = value;
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
