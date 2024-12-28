// lib/pages/login.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/pages/forgotpassword.dart';
import 'package:srifitness_app/pages/form/personal_details.dart';
import 'package:srifitness_app/pages/signup.dart';
import 'package:srifitness_app/widget/widget_support.dart';

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

  userLogin() async {
    try {
      // Signing in with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if it's the user's first login or if they need to reset password and fill out forms
      if (userCredential.user != null) {
        bool isFirstLogin = await checkFirstLogin(userCredential.user!);
        if (isFirstLogin) {
          // Navigate to PersonalDetails page for form completion
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalDetails(onSave: (data) {
                // Handle the saved data here
              }),
            ),
          );
        } else {
          // Normal flow after login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()), // or your home page
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )));
      }
    }
  }

  // Method to check if the user is logging in for the first time
  Future<bool> checkFirstLogin(User user) async {
    // Check if there's a flag or field to indicate first login in Firestore or Firebase
    // For this example, let's assume there's a field "isFirstLogin" in Firestore
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userDoc.exists && userDoc['isFirstLogin'] == true;
    } catch (e) {
      return false; // Return false if the field doesn't exist or any error happens
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
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
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
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                        prefixIcon: Icon(Icons.password_outlined)),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          email = useremailcontroller.text;
                                          password = userpasswordcontroller.text;
                                        });
                                        userLogin();
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        width: 200,
                                        decoration: BoxDecoration(
                                            color: Color(0Xffff5722),
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Center(
                                            child: Text(
                                              "LOGIN",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Poppins1',
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  ),
                                  SizedBox(
                                    height: 80.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()));
                                    },
                                    child: Text(
                                      "Don't have an account? Sign up",
                                      style: AppWidget.semiBoldTextFeildStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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