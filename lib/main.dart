import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/onboard.dart';
import 'package:srifitness_app/widget/colo_extension.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      // home: MedicalInquiry3(),
      home: OnBoardingView(),
      // home: ResetPassword(),
    );
  }
}

