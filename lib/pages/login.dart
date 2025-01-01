import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/pages/forgotpassword.dart';
import 'package:srifitness_app/pages/form/personal_details.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_2.dart';
import 'package:srifitness_app/widget/widget_support.dart';
import 'package:srifitness_app/service/shared_pref.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  final _formkey = GlobalKey<FormState>();
  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();
  bool isLoading = false;

   userLogin() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      email = useremailcontroller.text;
      password = userpasswordcontroller.text;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        DocumentSnapshot loginInfo = await FirebaseFirestore.instance
            .collection('user-details')
            .doc(userCredential.user!.uid)
            .collection('login-info')
            .doc('id')
            .get();

        if (!loginInfo.exists) {
          await FirebaseFirestore.instance
              .collection('user-details')
              .doc(userCredential.user!.uid)
              .collection('login-info')
              .doc('id')
              .set({
            'isPasswordReset': false,
            'isFormSubmitted': false,
          });
          
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResetPassword()),
          );
          return;
        }

        Map<String, dynamic> data = loginInfo.data() as Map<String, dynamic>;

        if (!mounted) return;

        // Handle all combinations:
        if (data['isPasswordReset'] == true && data['isFormSubmitted'] == true) {
          // User completed everything - go straight to main app
          Navigator.pushReplacement(
            context,
             MaterialPageRoute(builder: (context) => const BottomNav()),

          );
          return;
        }
        
        if (!data['isPasswordReset']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResetPassword()),
          );
          return;
        }

        if (!data['isFormSubmitted']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalDetails(
                onSave: (personalDetails) async {
                  await FirebaseFirestore.instance
                      .collection('user-details')
                      .doc(userCredential.user!.uid)
                      .collection('personal-details')
                      .doc('info')  // Fixed doc ID
                      .set(personalDetails);
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicalInquiry1(
                        onSave: (medicalData1) async {
                          // Store in shared preferences
                          await SharedPreferenceHelper().saveFormData(
                            SharedPreferenceHelper.medicalInquiry1Key,
                            medicalData1
                          );
                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicalInquiry2(
                                previousData: medicalData1,
                                onSave: (medicalData2) async {
                                  // Continue to next form
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
          return;
        }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),


          );

      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: useremailcontroller,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }
                      if (!value.contains('@')) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: userpasswordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : userLogin,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text("Login", style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

