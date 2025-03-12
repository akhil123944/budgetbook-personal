import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/onboard/controllers/onboard_controller.dart';

class IntroScreen2 extends GetView<OnboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.teal.shade300],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Main Content
          LayoutBuilder(
            builder: (context, constraints) {
              final heightFactor = constraints.maxHeight / 812;
              final widthFactor = constraints.maxWidth / 375;

              return Column(
                children: [
                  // Top Section - Illustration
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Lottie.asset(
                        'assets/Managemet.json',
                        height: 300 * heightFactor,
                      ),
                    ),
                  ),

                  // Middle Section - Title and Description
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Everything',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 26.0 * widthFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                        ),
                        SizedBox(height: 16.0 * heightFactor),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Your finances, simplified and organized in one place. Take control and start managing smarter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0 * widthFactor,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: Colors.teal.shade700,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
