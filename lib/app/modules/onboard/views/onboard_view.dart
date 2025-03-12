import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/onboard/views/intro_screen1.dart';
import 'package:money_management/app/modules/onboard/views/intro_screen2.dart';
import 'package:money_management/app/modules/onboard/views/intro_screen3.dart';
import 'package:money_management/app/routes/app_pages.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboard_controller.dart';

class OnboardView extends GetView<OnboardController> {
  final PageController pageController = PageController();
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heightFactor = constraints.maxHeight / 812;
        final widthFactor = constraints.maxWidth / 375;

        return Scaffold(
          body: Stack(
            children: [
              // PageView for onboarding screens
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  currentPageNotifier.value = index;
                },
                children: [
                  IntroScreen1(),
                  IntroScreen2(),
                  IntroScreen3(),
                ],
              ),

              // Bottom Navigation Section
              Positioned(
                  bottom: 50.0 * heightFactor,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder(
                    valueListenable: currentPageNotifier,
                    builder: (context, currentPage, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Skip Button
                          GestureDetector(
                            onTap: () {
                              pageController.jumpToPage(2); // Jump to last page
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: AppColors.tealColor,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0 * widthFactor,
                              ),
                            ),
                          ),

                          // SmoothPageIndicator for navigation
                          SmoothPageIndicator(
                            controller: pageController,
                            count: 3,
                            effect: JumpingDotEffect(
                              activeDotColor: AppColors.tealColor,
                              dotColor: AppColors.tealColor.withOpacity(0.4),
                              dotHeight: 10.0 * heightFactor,
                              dotWidth: 10.0 * widthFactor,
                            ),
                          ),

                          // Next/Get Started Button
                          ElevatedButton(
                            onPressed: () {
                              if (pageController.page == 2) {
                                Get.offAllNamed(
                                    Routes.HOME); // Navigate to Home
                              } else {
                                pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tealColor,
                              padding: EdgeInsets.symmetric(
                                vertical: 7.0 * heightFactor,
                                horizontal: 20.0 * widthFactor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              currentPage == 2 ? 'Start' : 'Next',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0 * widthFactor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ],
          ),
        );
      },
    );
  }
}
