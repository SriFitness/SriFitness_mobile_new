import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart';
import 'package:srifitness_app/service/shared_pref.dart';

class PersonalDetails extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  const PersonalDetails({super.key, required this.onSave});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  DateTime? _selectedDate;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _telHomeController = TextEditingController();
  final TextEditingController _telMobileController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  final TextStyle _textStyle = TextStyle(
    fontSize: 16,
    color: TColor.textcolor,
  );

  final SharedPreferenceHelper _prefs = SharedPreferenceHelper();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Future<void> _loadSavedData() async {
  //   final savedData = await _prefs.getFormData(SharedPreferenceHelper.personalDetailsKey);
  //   if (savedData != null) {
  //     setState(() {
  //       _fullNameController.text = savedData['fullName'] ?? '';
  //     });
  //   }
  // }

  Future<void> _loadSavedData() async {
    final savedData = await _prefs.getFormData(SharedPreferenceHelper.personalDetailsKey);
    if (savedData != null && savedData['fullName'] != null && savedData['fullName'].toString().isNotEmpty) {
      setState(() {
        _fullNameController.text = savedData['fullName'] ?? '';
      });
    } else {
      // Clear the text field for new users
      setState(() {
        _fullNameController.text = '';
      });
    }
  }

  final Color _errorColor = Colors.red;

  void _saveForm() async {
    if (_isSaving) return;
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      try {
        Map<String, dynamic> userInfoMap = {
          'fullName': _fullNameController.text,
          'dateOfBirth': _selectedDate?.toIso8601String(),
          'gender': _selectedGender,
          'address': _addressController.text,
          'town': _townController.text,
          'telHome': _telHomeController.text,
          'telMobile': _telMobileController.text,
          'emergencyContact': _emergencyContactController.text,
        };

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Single save to fixed doc 'info'
          await FirebaseFirestore.instance
              .collection('user-details')
              .doc(user.uid)
              .collection('personal-details')
              .doc('info')
              .set(userInfoMap);

          // Save to shared preferences
          await _prefs.saveFormData(
            SharedPreferenceHelper.personalDetailsKey,
            userInfoMap
          );

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MedicalInquiry1(
                onSave: widget.onSave,
              ),
            ),
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
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Personal Details',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: TColor.defaultwhitecolor,
                  ),
                ),
                SizedBox(height: 22),
                TextFormField(
                  controller: _fullNameController,
                  style: _textStyle,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Full Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 22),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      style: _textStyle,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: Icon(Icons.calendar_today),
                        errorStyle: TextStyle(color: _errorColor),
                      ),
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : '',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 22),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: _textStyle,
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  items: ['Male', 'Female', 'Other'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender, style: _textStyle),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _addressController,
                  style: _textStyle,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _townController,
                  style: _textStyle,
                  decoration: InputDecoration(
                    labelText: 'Town',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your town';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _telHomeController,
                  style: _textStyle,
                  decoration: InputDecoration(
                    labelText: 'Tel Home',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    _PhoneNumberInputFormatter(),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your home telephone number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _telMobileController,
                  style: _textStyle,
                  decoration: InputDecoration(
                    labelText: 'Tel Mobile',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    _PhoneNumberInputFormatter(),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile telephone number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 22),
                TextFormField(
                  controller: _emergencyContactController,
                  style: _textStyle,
                  decoration: InputDecoration(
                    labelText: 'Emergency Contact',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    _PhoneNumberInputFormatter(),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an emergency contact';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
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
                        padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 11),
                      ),
                      child: _isSaving
                          ? CircularProgressIndicator()
                          : Text(
                        'Next',
                        style: TextStyle(
                            color: TColor.textcolor,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      )
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

class _PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    text = text.replaceAll(RegExp(r'[^\d]'), '');

    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}