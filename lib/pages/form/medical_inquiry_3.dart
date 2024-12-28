import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/widget/logout_button.dart';

class MedicalInquiry3 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic> previousData;

  const MedicalInquiry3({super.key, required this.onSave, required this.previousData});

  @override
  State<MedicalInquiry3> createState() => _MedicalInquiry3State();
}

class _MedicalInquiry3State extends State<MedicalInquiry3> {
  final _formKey = GlobalKey<FormState>();
  String? _fileName;

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> medicalInquiry3Data = {
        'fileName': _fileName,
      };
      Map<String, dynamic> allData = {...widget.previousData, ...medicalInquiry3Data};
      widget.onSave(allData);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user-details')
            .doc(user.uid)
            .collection('medical-inquiries')
            .add(allData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SRI FITNESS'),
        actions: [
          LogoutButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
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
                ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.maincolor,
                  ),
                  child: Text(
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
}
