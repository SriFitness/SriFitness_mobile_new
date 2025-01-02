import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_2.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/service/shared_pref.dart';

//TODO: PREVIOUS BUTTON

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
  final _prefs = SharedPreferenceHelper();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final savedData = await _prefs.getFormData(SharedPreferenceHelper.medicalInquiry1Key);
    if (savedData != null) {
      setState(() {
        _selectedHeartProblem = savedData['heartProblem'];
      });
    }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
//TODO: PREVIOUS BUTTON
                        ElevatedButton(
                        // onPressed: _isSaving ? null : _saveForm,
                          onPressed: () {
                            //TODO: THIS FUNCTION WILL BE CALLED WHEN THE BUTTON IS PRESSED
                        },
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
                            fontSize:18,
                          ),
                        ),
                        ),
                      ],
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
                                fontSize:18,
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