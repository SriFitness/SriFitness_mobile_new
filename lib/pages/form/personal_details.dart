import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/custom_appbar.dart'; // Import for TextInputFormatter

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  DateTime? _selectedDate; // Use nullable DateTime

  final List<String> _genders = ['Male', 'Female', 'Other'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
      _selectedDate ?? DateTime.now(), // Use current date if none selected
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Define a common TextStyle
  final TextStyle _textStyle = TextStyle(
    fontSize: 16, // Set the font size here
    color: TColor.textcolor, // Use your color definition here
  );

  // Error text color
  final Color _errorColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'SRI FITNESS'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  style: _textStyle, // Apply common text style
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Full Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      style: _textStyle, // Apply common text style
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: Icon(Icons.calendar_today),
                        errorStyle: TextStyle(color: _errorColor),
                      ),
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : '', // Set empty if no date selected
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: _textStyle, // Apply common text style
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  items: _genders.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender,
                          style: _textStyle), // Apply common text style
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: _textStyle, // Apply common text style
                  decoration: InputDecoration(
                    labelText: 'Address',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: _textStyle, // Apply common text style
                  decoration: InputDecoration(
                    labelText: 'Town',
                    errorStyle: TextStyle(color: _errorColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your town';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: _textStyle, // Apply common text style
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
                const SizedBox(height: 20),
                TextFormField(
                  style: _textStyle, // Apply common text style
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
                SizedBox(height: 20),
                TextFormField(
                  style: _textStyle, // Apply common text style
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
                SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Navigate to the MedicalInquiry page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MedicalInquiry1()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        TColor.maincolor, // Set the background color
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: TColor.textcolor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
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

class _PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    // Remove any non-digit characters
    text = text.replaceAll(RegExp(r'[^\d]'), '');

    // Ensure only 10 digits are allowed
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
