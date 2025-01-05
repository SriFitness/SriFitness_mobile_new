import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/pages/forgotpassword.dart';
import 'package:srifitness_app/pages/form/personal_details.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_2.dart';
import 'package:srifitness_app/pages/signup.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/widget/widget_support.dart';
import 'package:srifitness_app/service/shared_pref.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false; // Password visibility
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
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1F1F1F),
                          Color(0xFF1F1F1F),
                        ])),
              ),
              Container(
                margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFF56200),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Text(""),
              ),
              Container(
                margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                        child: Image.asset(
                          "images/logo_Sri.png",
                          width: MediaQuery.of(context).size.width / 3,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(
                      height: 50.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                              color: Color(0xFFE96A25),
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Text(
                                    "Login",
                                    style: AppWidget.HeadlineTextFeildStyle(),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  TextFormField(
                                    controller: useremailcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter E-mail';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                        prefixIcon: Icon(Icons.email_outlined)),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  TextFormField(
                                    controller: userpasswordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Password';
                                      }
                                      return null;
                                    },
                                    obscureText: !_isPasswordVisible, // Toggle visibility
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                      prefixIcon: Icon(Icons.password_outlined),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : userLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: TColor.mainshadowcolor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: isLoading
                                          ? CircularProgressIndicator()
                                          : Text("Login",
                                          style: TextStyle(fontSize: 18 , color: Colors.black)
                                        ,
                                      ),
                                    ),
                                  ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

