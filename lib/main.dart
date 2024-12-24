import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/bottomnav.dart';
import 'package:srifitness_app/pages/form/personal_details.dart';
import 'package:srifitness_app/pages/login.dart';
import 'package:srifitness_app/pages/onboard.dart';
import 'package:srifitness_app/service/shared_pref.dart';
import 'package:srifitness_app/widget/colo_extension.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
          brightness: Brightness.dark, // You can choose between dark or light
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
      // home: FutureBuilder(
      //   future: _checkLoginStatus(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     } else {
      //       return snapshot.data == true ? BottomNav() : Login();
      //     }
      //   },
      // ),
      home: Login(),
    );
  }

  Future<bool> _checkLoginStatus() async {
    String? email = await SharedPreferenceHelper().getUserEmail();
    String? password = await SharedPreferenceHelper().getUserPassword();
    if (email != null && password != null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}


