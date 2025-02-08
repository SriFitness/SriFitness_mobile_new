import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:srifitness_app/pages/home/bmi_section.dart';
import 'package:srifitness_app/pages/home/calendar_streak.dart';
import 'dart:ui';

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

  // Store attendance in Firestore with timestamp
  Future<void> storeAttendance(String userId, DateTime scanTime) async {
    try {
      await FirebaseFirestore.instance
          .collection('user-details')
          .doc(userId)
          .collection('attendance') // Sub-collection for attendance entries
          .add({
        'scan_time': scanTime,
        'date': scanTime.toLocal().toIso8601String().split('T').first,
      });
      print('Attendance successfully recorded!');
    } catch (e) {
      print('Error recording attendance: $e');
    }
  }
  // Show QR Code Dialog
  void showQRDialog(BuildContext context, String userId) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
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
                    data: userId,
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
              padding: const EdgeInsets.only(left: 12, right: 16, top: 5, bottom: 8),
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

                        // Save attendance to Firestore
                        await storeAttendance(userId, scanTime);

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
