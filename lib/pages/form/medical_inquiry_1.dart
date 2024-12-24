// lib/pages/form/medical_inquiry_1.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_2.dart';
import 'package:srifitness_app/pages/form/personal_details.dart';
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
  String? _selectedCirculatoryProblem;
  String? _selectedBloodPressureProblem;
  String? _selectedJointMovementProblem;
  String? _selectedFeelDizzy;
  String? _selectedPregnancy;
  String? _fileName;

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data
      Map<String, dynamic> medicalInquiry1Data = {
        'heartProblem': _selectedHeartProblem,
        'circulatoryProblem': _selectedCirculatoryProblem,
        'bloodPressureProblem': _selectedBloodPressureProblem,
        'jointMovementProblem': _selectedJointMovementProblem,
        'feelDizzy': _selectedFeelDizzy,
        'pregnancy': _selectedPregnancy,
        'fileName': _fileName,
      };

      // Pass data to parent widget
      widget.onSave(medicalInquiry1Data);

      // Navigate to the next form
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicalInquiry2(onSave: widget.onSave)),
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
                Text(
                  'Do you currently or have ever suffered from any of the following conditions?',
                  style: TextStyle(
                    fontSize: 14,
                    color: TColor.textcolor,
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
                SizedBox(height: 20),
                buildDropdown(
                  label: '02 Circulatory problems?',
                  value: _selectedCirculatoryProblem,
                  onChanged: (value) => setState(() {
                    _selectedCirculatoryProblem = value;
                  }),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: '03 Blood pressure problems?',
                  value: _selectedBloodPressureProblem,
                  onChanged: (value) => setState(() {
                    _selectedBloodPressureProblem = value;
                  }),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: '04 Joint, movement problems?',
                  value: _selectedJointMovementProblem,
                  onChanged: (value) => setState(() {
                    _selectedJointMovementProblem = value;
                  }),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: '05 Feel dizzy or imbalance during exercise?',
                  value: _selectedFeelDizzy,
                  onChanged: (value) => setState(() {
                    _selectedFeelDizzy = value;
                  }),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: '06 Currently pregnant or recently given birth?',
                  value: _selectedPregnancy,
                  onChanged: (value) => setState(() {
                    _selectedPregnancy = value;
                  }),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'If Yes, please provide details ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: TColor.textcolor,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.defaultblackcolor,
                    ),
                    child: Text(
                      _fileName ?? 'Upload Image or PDF',
                      style: TextStyle(
                        color: TColor.textcolor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>PersonalDetails(onSave: widget.onSave,)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.maincolor,
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: TColor.textcolor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
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

  Future<void> _pickFile() async {
    if (kIsWeb) {
      print('File picking is not supported on the web.');
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
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