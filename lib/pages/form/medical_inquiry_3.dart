import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_2.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/pages/form/personal_details.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/pages/bottomnav.dart';

class MedicalInquiry3 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const MedicalInquiry3({super.key, required this.onSave});

  @override
  State<MedicalInquiry3> createState() => _MedicalInquiry3State();
}

class _MedicalInquiry3State extends State<MedicalInquiry3> {
  final _formKey = GlobalKey<FormState>();
  String? _fileName;

  final TextEditingController _fullNameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _telHomeController = TextEditingController();
  final TextEditingController _telMobileController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  bool? _selectedHeartProblem;
  bool? _selectedCirculatoryProblem;
  bool? _selectedBloodPressureProblem;
  bool? _selectedJointMovementProblem;
  bool? _selectedFeelDizzy;
  bool? _selectedPregnancy;

  bool? _selectedBackPain;
  bool? _selectedAsthma;
  bool? _selectedDiabetes;
  bool? _selectedFinishedMedication;
  bool? _selectedPrescribedMedtication;
  bool? _selectedMigraine;
  bool? _selectedSurgery;

  final TextStyle _textStyle = TextStyle(
    fontSize: 16,
    color: TColor.textcolor,
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _townController.dispose();
    _telHomeController.dispose();
    _telMobileController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
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
              children: [
                // Form fields go here
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data from all three forms
      Map<String, dynamic> medicalInquiry3Data = {
        'fileName': _fileName,
        // Add other form data here
      };

      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Create a Firestore batch
        WriteBatch batch = FirebaseFirestore.instance.batch();

        try {
          // Add personal details to the batch
          DocumentReference personalDetailsRef = FirebaseFirestore.instance
              .collection('user-details')
              .doc(userId)
              .collection('personal-details')
              .doc();
          batch.set(personalDetailsRef, {
            'fullName': _fullNameController.text,
            'dateOfBirth': _selectedDate?.toIso8601String(),
            'gender': _selectedGender,
            'address': _addressController.text,
            'town': _townController.text,
            'telHome': _telHomeController.text,
            'telMobile': _telMobileController.text,
            'emergencyContact': _emergencyContactController.text,
          });

          // Add medical inquiry 1 data to the batch
          DocumentReference medicalInquiry1Ref = FirebaseFirestore.instance
              .collection('user-details')
              .doc(userId)
              .collection('medical-inquiries')
              .doc();
          batch.set(medicalInquiry1Ref, {
            'heartProblem': _selectedHeartProblem,
            'circulatoryProblem': _selectedCirculatoryProblem,
            'bloodPressureProblem': _selectedBloodPressureProblem,
            'jointMovementProblem': _selectedJointMovementProblem,
            'feelDizzy': _selectedFeelDizzy,
            'pregnancy': _selectedPregnancy,
            'fileName': _fileName,
          });

          // Add medical inquiry 2 data to the batch
          DocumentReference medicalInquiry2Ref = FirebaseFirestore.instance
              .collection('user-details')
              .doc(userId)
              .collection('medical-inquiries')
              .doc();
          batch.set(medicalInquiry2Ref, {
            'backPain': _selectedBackPain,
            'asthma': _selectedAsthma,
            'diabetes': _selectedDiabetes,
            'finishedMedication': _selectedFinishedMedication,
            'prescribedMedication': _selectedPrescribedMedtication,
            'migraine': _selectedMigraine,
            'surgery': _selectedSurgery,
            'fileName': _fileName,
          });

          // Add medical inquiry 3 data to the batch
          DocumentReference medicalInquiry3Ref = FirebaseFirestore.instance
              .collection('user-details')
              .doc(userId)
              .collection('medical-inquiries')
              .doc();
          batch.set(medicalInquiry3Ref, medicalInquiry3Data);

          // Commit the batch
          await batch.commit();

          // Navigate to the bottomnav page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        } catch (e) {
          // Handle the error and show a message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit data: $e')),
          );
        }
      } else {
        // Handle the case where the user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
      }
    }
  }
}