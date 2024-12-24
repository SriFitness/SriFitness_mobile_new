import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_3.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';

class MedicalInquiry2 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const MedicalInquiry2({super.key, required this.onSave});

  @override
  State<MedicalInquiry2> createState() => _MedicalInquiry2State();
}

class _MedicalInquiry2State extends State<MedicalInquiry2> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBackPain;
  String? _selectedAsthma;
  String? _selectedDiabetes;
  String? _selectedFinishedMedication;
  String? _selectedPrescribedMedtication;
  String? _selectedMigraine;
  String? _selectedSurgery;
  String? _fileName;

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data
      Map<String, dynamic> medicalInquiry2Data = {
        'backPain': _selectedBackPain,
        'asthma': _selectedAsthma,
        'diabetes': _selectedDiabetes,
        'finishedMedication': _selectedFinishedMedication,
        'prescribedMedication': _selectedPrescribedMedtication,
        'migraine': _selectedMigraine,
        'surgery': _selectedSurgery,
        'fileName': _fileName,
      };

      // Pass data to parent widget
      widget.onSave(medicalInquiry2Data);

      // Navigate to the next form
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicalInquiry3(onSave: widget.onSave)),
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
                  'Do you currently receive medical care or any of the following affect you?',
                  style: TextStyle(
                    fontSize: 14,
                    color: TColor.textcolor,
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
                const SizedBox(height: 20),
                buildDropdown(
                  label: '08 Headache or migraine?',
                  value: _selectedMigraine,
                  onChanged: (value) => setState(() {
                    _selectedMigraine = value;
                  }),
                ),
                const SizedBox(height: 20),
                buildDropdown(
                  label: '09 Do you have surgery recently?',
                  value: _selectedSurgery,
                  onChanged: (value) => setState(() {
                    _selectedSurgery = value;
                  }),
                ),
                const SizedBox(height: 20),
                buildDropdown(
                  label: 'Currently been prescribed medications?',
                  value: _selectedPrescribedMedtication,
                  onChanged: (value) => setState(() {
                    _selectedPrescribedMedtication = value;
                  }),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: 'Recently finished a course of medication?',
                  value: _selectedFinishedMedication,
                  onChanged: (value) => setState(() {
                    _selectedFinishedMedication = value;
                  }),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: 'Diabetes?',
                  value: _selectedDiabetes,
                  onChanged: (value) => setState(() {
                    _selectedDiabetes = value;
                  }),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: 'Asthma or breathing problems?',
                  value: _selectedAsthma,
                  onChanged: (value) => setState(() {
                    _selectedAsthma = value;
                  }),
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
                              builder: (context) => MedicalInquiry1(onSave: widget.onSave,)),
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