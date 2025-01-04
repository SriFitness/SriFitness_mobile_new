import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_2.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/service/shared_pref.dart';


class MedicalInquiry1 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  const MedicalInquiry1({super.key, required this.onSave});

  @override
  State<MedicalInquiry1> createState() => _MedicalInquiry1State();
}

class _MedicalInquiry1State extends State<MedicalInquiry1> {
  final _formKey = GlobalKey<FormState>();
  final _prefs = SharedPreferenceHelper();
  String? _selectedHeartProblem;
  String? _selectedCirculatoryProblem;
  String? _selectedBloodPressureProblem;
  String? _selectedJointMovementProblem;
  String? _selectedFeelDizzy;
  String? _selectedPregnancy;
  String? _fileName;
  bool _isSaving = false;


  // void _clearFormData() {
  //   setState(() {
  //     _selectedHeartProblem = null;
  //     _selectedCirculatoryProblem = null;
  //     _selectedBloodPressureProblem = null;
  //     _selectedJointMovementProblem = null;
  //     _selectedFeelDizzy = null;
  //     _selectedPregnancy = null;
  //     _fileName = null;
  //   });
  // }

  Future<void> _loadSavedData() async {
    try {
      final savedData = await _prefs.getFormData(SharedPreferenceHelper.medicalInquiry1Key);

      if (savedData == null || savedData.isEmpty) {
        // _clearFormData();
        return;
      }

      // Check if this is first time form access
      final isFirstAccess = await _prefs.getFormData('isFirstAccess');
      if (isFirstAccess == null) {
        // _clearFormData();
        await _prefs.saveFormData('isFirstAccess', {'accessed': true});
        return;
      }

      setState(() {
        _selectedHeartProblem = savedData['heartProblem'];
        _selectedCirculatoryProblem = savedData['circulatoryProblem'];
        _selectedBloodPressureProblem = savedData['bloodPressureProblem'];
        _selectedJointMovementProblem = savedData['jointMovementProblem'];
        _selectedFeelDizzy = savedData['feelDizzy'];
        _selectedPregnancy = savedData['pregnancy'];
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
        Map<String, dynamic> medicalInquiry1Data = {
          'heartProblem': _selectedHeartProblem,
          'timestamp': DateTime.now().toIso8601String(),
          'circulatoryProblem': _selectedCirculatoryProblem,
          'bloodPressureProblem': _selectedBloodPressureProblem,
          'jointMovementProblem': _selectedJointMovementProblem,
          'feelDizzy': _selectedFeelDizzy,
          'pregnancy': _selectedPregnancy,
          'fileName': _fileName,
        };

        // Save to shared preferences
        await _prefs.saveFormData(
          SharedPreferenceHelper.medicalInquiry1Key,
          medicalInquiry1Data
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalInquiry2(
              onSave: widget.onSave,
              previousData: medicalInquiry1Data,
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
                  'Medical Inquiry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: TColor.defaultwhitecolor,
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  'Do you currently or have ever suffered from any of the following conditions?',
                  style: TextStyle(
                    fontSize: 16,
                    color: TColor.textcolor,
                  ),
                ),
                SizedBox(height: 25),
                buildDropdown(
                  label: 'Heart problems?',
                  value: _selectedHeartProblem,
                  onChanged: (value) => setState(() {
                    _selectedHeartProblem = value;
                  }),
                ),
                SizedBox(height: 24),
                buildDropdown(
                  label: 'Circulatory problems?',
                  value: _selectedCirculatoryProblem,
                  onChanged: (value) => setState(() {
                    _selectedCirculatoryProblem = value;
                  }),
                ),
                SizedBox(height: 24),
                buildDropdown(
                  label: 'Blood pressure problems?',
                  value: _selectedBloodPressureProblem,
                  onChanged: (value) => setState(() {
                    _selectedBloodPressureProblem = value;
                  }),
                ),
                SizedBox(height: 24),
                buildDropdown(
                  label: 'Joint, movement problems?',
                  value: _selectedJointMovementProblem,
                  onChanged: (value) => setState(() {
                    _selectedJointMovementProblem = value;
                  }),
                ),
                SizedBox(height: 24),
                buildDropdown(
                  label: 'Feel dizzy or imbalance during exercise?',
                  value: _selectedFeelDizzy,
                  onChanged: (value) => setState(() {
                    _selectedFeelDizzy = value;
                  }),
                ),
                SizedBox(height: 24),
                buildDropdown(
                  label: 'Currently pregnant or recently given birth?',
                  value: _selectedPregnancy,
                  onChanged: (value) => setState(() {
                    _selectedPregnancy = value;
                  }),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'If Yes, please provide details ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: TColor.textcolor,
                    ),
                  ),
                ),
                SizedBox(height: 12),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
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
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: pick file method to upload image or pdf file  (not working)
  Future<void> _pickFile() async {
    try {
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File picking is not supported on web')),
        );
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validate file extension
        final extension = file.extension?.toLowerCase();
        if (!['jpg', 'jpeg', 'png', 'pdf'].contains(extension)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a valid image or PDF file')),
          );
          return;
        }

        // Check file size (limit to 10MB)
        if (file.size > 10 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File size should be less than 10MB')),
          );
          return;
        }

        setState(() {
          _fileName = file.name;
        });




        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully: ${file.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  // Future<void> _pickFile() async {
  //   if (kIsWeb) {
  //     print('File picking is not supported on the web.');
  //     return;
  //   }
  //
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
  //   );
  //
  //   if (result != null && result.files.isNotEmpty) {
  //     setState(() {
  //       _fileName = result.files.single.name;
  //     });
  //   }
  // }
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