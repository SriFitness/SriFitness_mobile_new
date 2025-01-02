import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/service/shared_pref.dart';

//TODO : previous button function does not create.
//TODO : file picking not working

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

  final TextStyle _textStyle = TextStyle(
    fontSize: 16,
    color: TColor.textcolor,
  );

  bool _isSaving = false;

  //TODO : file picking not working
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
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'If Yes, please provide details',
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
                const SizedBox(height: 20),
                Text(
                  'Any other cases that prevent you from regular activities',
                  style: TextStyle(
                    fontSize: 14,
                    color: TColor.textcolor,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: _textStyle,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type your details here...',
                    contentPadding: EdgeInsets.all(10),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'If there are any other cases, please provide details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: TColor.textcolor,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO : previous button function does not create.
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.maincolor,
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