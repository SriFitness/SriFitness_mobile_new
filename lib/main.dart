import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:srifitness_app/models/cart_model.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/pages/form/personal_details.dart';
import 'package:srifitness_app/pages/form/medical_inquiry_1.dart';
import 'package:srifitness_app/pages/login.dart';
import 'package:srifitness_app/pages/forgotpassword.dart';
import 'package:srifitness_app/widget/colo_extension.dart';
import 'package:srifitness_app/workout/workout_plan_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRI Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: TColor.maincolor,
          onPrimary: TColor.defaultwhitecolor,
          secondary: TColor.mainshadowcolor,
          onSecondary: TColor.defaultblackcolor,
          error: Colors.red,
          onError: TColor.defaultwhitecolor,
          background: TColor.backgroundcolor,
          onBackground: TColor.textcolor,
          surface: TColor.backgroundcolor,
          onSurface: TColor.textcolor,
        ),
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            User user = snapshot.data!;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('user-details')
                  .doc(user.uid)
                  .collection('login-info')
                  .doc('id')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null) {
                      bool isPasswordReset = data['isPasswordReset'] ?? false;
                      bool isFormSubmitted = data['isFormSubmitted'] ?? false;

                      if (!isPasswordReset) {
                        return const ResetPassword();
                      } else if (!isFormSubmitted) {
                        return PersonalDetails(onSave: (personalDetails) => _savePersonalDetails(context, personalDetails));
                      } else {
                        return const BottomNav();
                      }
                    } else {
                      return const Login();
                    }
                  } else {
                    return const Login();
                  }
                }
              },
            );
          } else {
            return const Login();
          }
        }
      },
    );
  }

  void _savePersonalDetails(BuildContext context, Map<String, dynamic> personalDetails) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user-details')
          .doc(user.uid)
          .collection('personal-details')
          .add(personalDetails);
      await FirebaseFirestore.instance
          .collection('user-details')
          .doc(user.uid)
          .collection('login-info')
          .doc('id')
          .update({'isFormSubmitted': true});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicalInquiry1(onSave: (medicalInquiries) => _saveMedicalInquiries(context, medicalInquiries))),
      );
    }
  }

  void _saveMedicalInquiries(BuildContext context, Map<String, dynamic> medicalInquiries) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user-details')
          .doc(user.uid)
          .collection('medical-inquiries')
          .add(medicalInquiries);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),

      );
    }
  }
}
