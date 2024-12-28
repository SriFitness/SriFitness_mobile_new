import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';

class PersonalDetails extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const PersonalDetails({super.key, required this.onSave});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> userInfoMap = {
        'fullName': _fullNameController.text,
      };
      widget.onSave(userInfoMap);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user-details')
            .doc(user.uid)
            .collection('personal-details')
            .add(userInfoMap); // Create a sub-collection and add the document
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MedicalInquiry1(onSave: widget.onSave)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'SRI FITNESS'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Personal Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: TColor.defaultwhitecolor,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  style: TextStyle(fontSize: 16, color: TColor.textcolor),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Full Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}