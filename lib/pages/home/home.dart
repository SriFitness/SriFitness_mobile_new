import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:srifitness_app/pages/home/bmi_section.dart';
import 'package:srifitness_app/pages/home/calendar_streak.dart';

class Home extends StatelessWidget {
  // Function to get the logged-in user's unique ID from Firebase
  String getLoggedInUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return "No user logged in";
    }
  }

  // Show QR Code Dialog
  void showQRDialog(BuildContext context, String userId) {
    String qrData =
        '{"uid": "$userId", "gym": "gym001", "timestamp": "${DateTime.now().toIso8601String()}"}';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  color: Colors.white,
                  child: PrettyQr(
                    data: qrData,
                    size: 250,
                    roundEdges: true,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 16, top: 5, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Welcome to SRI Fitness App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.qr_code, size: 38, color: Colors.white),
                    onPressed: () async {
                      String userId = getLoggedInUserId();
                      if (userId != "No user logged in") {
                        DateTime scanTime = DateTime.now();
                        // Show the QR code dialog
                        showQRDialog(context, userId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No user logged in')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            FullMonthCalendar(),
            const SizedBox(height: 8),
            BMISection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class QRCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text("User not logged in"));
    }

    // QR Code Data
    final qrData =
        '{"uid": "${user.uid}", "gym": "gym001", "timestamp": "${DateTime.now().toIso8601String()}"}';

    return Scaffold(
      appBar: AppBar(title: Text("My QR Code")),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
