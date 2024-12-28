import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srifitness_app/pages/login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController mailcontroller = TextEditingController();
  String email = "";
  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Password Reset Email has been sent!",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user-details')
            .doc(user.uid)
            .collection('login-info')
            .doc('id')
            .update({'isPasswordReset': true});
      }
      // Delay to allow snackbar message to be read
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      if (e.code == "user-not-found") {
        errorMessage = "No user found for that email.";
      } else if (e.code == "network-request-failed") {
        errorMessage = "Network error. Please try again later.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 70.0),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Password Recovery",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Enter your mail",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 2.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: mailcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 20.0,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              resetPassword();
                            }
                          },
                          child: Text(
                            "Reset Password",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
