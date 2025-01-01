import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/service/shared_pref.dart';

class MedicalInquiry3 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic> previousData;

  const MedicalInquiry3({
    super.key,
    required this.onSave,
    required this.previousData,
  });

  @override
  State<MedicalInquiry3> createState() => _MedicalInquiry3State();
}

class _MedicalInquiry3State extends State<MedicalInquiry3> {
  final _formKey = GlobalKey<FormState>();
  final _prefs = SharedPreferenceHelper();
  String? _fileName;
  bool _isSaving = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png'],
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  void _saveForm() async {
    if (_isSaving) return;
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      try {
        Map<String, dynamic> medicalInquiry3Data = {
          'fileName': _fileName,
          'timestamp': DateTime.now().toIso8601String(),
        };

        // Combine all form data
        Map<String, dynamic> allMedicalData = {
          ...widget.previousData,
          ...medicalInquiry3Data,
        };

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Add new document for each submission
          await FirebaseFirestore.instance
              .collection('user-details')
              .doc(user.uid)
              .collection('medical-inquiries')
              .add(allMedicalData);

          // Set form submitted flag
          await FirebaseFirestore.instance
              .collection('user-details')
              .doc(user.uid)
              .collection('login-info')
              .doc('id')
              .update({'isFormSubmitted': true});

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        }
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
                  '03 Upload Medical Documents',
                  style: TextStyle(
                    fontSize: 16,
                    color: TColor.textcolor,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.maincolor,
                  ),
                  child: Text(
                    _fileName ?? 'Select File',
                    style: TextStyle(color: TColor.textcolor),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.maincolor,
                      ),
                      child: _isSaving
                          ? CircularProgressIndicator()
                          : Text(
                              'Submit',
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