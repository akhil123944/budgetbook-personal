// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heightFactor = constraints.maxHeight / 812;
        final widthFactor = constraints.maxWidth / 375;
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              children: [
                // Top Lottie Animation
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0 * heightFactor),
                      child: Lottie.asset(
                        reverse: false,
                        // repeat: false,
                        'assets/login_animation_MM.json',
                        width: 300 * widthFactor,
                      ),
                    ),
                  ),
                ),
                // Login and Signup Forms
                Expanded(
                  // flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24 * widthFactor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 19 * widthFactor,
                                fontWeight: FontWeight.w500,
                                color: Colors.teal.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10 * heightFactor,
                        ),
                        // Mobile Field
                        TextField(
                          controller: controller.mobilecontroller,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Mobile",
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14 * widthFactor,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.teal.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                    
                        SizedBox(height: 26 * heightFactor),
                        // Login Button
                        ElevatedButton(
                          onPressed: () {
                            controller.login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            padding: EdgeInsets.symmetric(
                                vertical: 14 * heightFactor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              // fontSize: 15 * widthFactor,
                              fontWeight: FontWeight.w500,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16 * heightFactor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
