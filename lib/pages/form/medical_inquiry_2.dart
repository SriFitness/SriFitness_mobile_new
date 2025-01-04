import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_3.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/service/shared_pref.dart';

//TODO : previous button function does not create.

class MedicalInquiry2 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic> previousData;

  const MedicalInquiry2({
    super.key, 
    required this.onSave,
    required this.previousData,
  });

  @override
  State<MedicalInquiry2> createState() => _MedicalInquiry2State();
}

class _MedicalInquiry2State extends State<MedicalInquiry2> {
  final _formKey = GlobalKey<FormState>();
  final _prefs = SharedPreferenceHelper();
  String? _selectedBackPain;
  String? _selectedAsthma;
  String? _selectedDiabetes;
  String? _selectedFinishedMedication;
  String? _selectedPrescribedMedtication;
  String? _selectedMigraine;
  String? _selectedSurgery;
  String? _fileName;

  bool _isSaving = false;



  // void _clearFormData() {
  //   setState(() {
  //     _selectedBackPain = null;
  //     _selectedAsthma = null;
  //     _selectedDiabetes = null;
  //     _selectedFinishedMedication = null;
  //     _selectedPrescribedMedtication = null;
  //     _selectedMigraine = null;
  //     _selectedSurgery = null;
  //     _fileName = null;
  //   });
  // }

  Future<void> _loadSavedData() async {
    try {

      final savedData = await _prefs.getFormData(SharedPreferenceHelper.medicalInquiry2Key);
      if (savedData == null || savedData.isEmpty) {

        return;
      }

      // Check if this is first time form access
      final isFirstAccess = await _prefs.getFormData('medical2FirstAccess');
      if (isFirstAccess == null) {
        // _clearFormData();
        await _prefs.saveFormData('medical2FirstAccess', {'accessed': true});
        return;
      }

      setState(() {
        _selectedBackPain = savedData['backPain'];
        _selectedAsthma = savedData['asthma'];
        _selectedDiabetes = savedData['diabetes'];
        _selectedFinishedMedication = savedData['finishedMedication'];
        _selectedPrescribedMedtication = savedData['prescribedMedication'];
        _selectedMigraine = savedData['migraine'];
        _selectedSurgery = savedData['surgery'];
        _fileName = savedData['fileName'];
      });
    } catch (e) {
      // _clearFormData();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();

  }

  void _saveForm() async {
    if (_isSaving) return;
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      try {
        Map<String, dynamic> medicalInquiry2Data = {
          'backPain': _selectedBackPain,
          'asthma': _selectedAsthma,
          'diabetes': _selectedDiabetes,
          'finishedMedication': _selectedFinishedMedication,
          'prescribedMedication': _selectedPrescribedMedtication,
          'migraine': _selectedMigraine,
          'surgery': _selectedSurgery,
          'fileName': _fileName,
          'timestamp': DateTime.now().toIso8601String(),
        };

        // Combine with previous data
        Map<String, dynamic> combinedData = {
          ...widget.previousData,
          ...medicalInquiry2Data,
        };

        // Save to shared preferences
        await _prefs.saveFormData(
          SharedPreferenceHelper.medicalInquiry2Key,
          medicalInquiry2Data
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalInquiry3(
              onSave: widget.onSave,
              previousData: combinedData,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  void _navigateToPrevious() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalInquiry1(
          onSave: widget.onSave,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'SRI FITNESS'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Do you currently receive medical care or any of the following affect you?',
                  style: TextStyle(
                    fontSize: 17,
                    color: TColor.textcolor,
                  ),
                ),
                SizedBox(height: 20),
                buildDropdown(
                  label: 'Back/spinal pain?',
                  value: _selectedBackPain,
                  onChanged: (value) => setState(() {
                    _selectedBackPain = value;
                  }),
                ),
                const SizedBox(height: 20),
                buildDropdown(
                  label: 'Headache or migraine?',
                  value: _selectedMigraine,
                  onChanged: (value) => setState(() {
                    _selectedMigraine = value;
                  }),
                ),
                const SizedBox(height: 20),
                buildDropdown(
                  label: 'Do you have surgery recently?',
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
                SizedBox(height: 47),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO : PREVIOUS BUTTON METHOD ... ?
                    ElevatedButton(
                      onPressed: _isSaving ? null : _navigateToPrevious,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.maincolor,
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                      ),
                      child: _isSaving
                          ? CircularProgressIndicator()
                          : Text(
                        'Previous',
                        style: TextStyle(
                          color: TColor.textcolor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.maincolor,
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                      ),
                      child: _isSaving
                          ? CircularProgressIndicator()
                          : Text(
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
}