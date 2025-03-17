import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/splash_screen/controllers/splash_screen_controller.dart';

class SplashscreenView extends GetView<SplashScreenController> {
  const SplashscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashScreenController>(); // Ensures controller is found
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/budgetbook_logo.png',
                  height: height * 0.10, fit: BoxFit.cover),
              SizedBox(height: height * 0.010),
            ],
          ),
        ),
      ),
    );
  }
}
