import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/forgotpassword.dart';
import 'package:srifitness_app/pages/login.dart';
import 'package:srifitness_app/widget/colo_extension.dart';


class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final Size media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.backgroundcolor,
      body: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Center content of the page
              Expanded(
                child: Center(
                  child: Container(
                    width: media.width *
                        0.8, // Set width to a percentage of the screen width
                    height: media.height *
                        0.5, // Set height to a percentage of the screen height
                    child: Image.asset(
                      "images/logo_Sri.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Spacer to move the button slightly up
              SizedBox(height: 20), // Adjust this value as needed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPassword()),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 20,
                        color: TColor.textcolor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      // Set button background color to maincolor
                      minimumSize: Size(media.width * 0.8,
                          50), // Adjust button width and height
                      backgroundColor: TColor.mainshadowcolor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 20), // Adjust this value to add more space if needed
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
