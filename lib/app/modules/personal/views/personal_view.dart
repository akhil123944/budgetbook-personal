// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management/app/core/constants/app_urls.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/core/themes/app_textstyles.dart';
import 'package:money_management/app/modules/personal/controllers/personal_controller.dart';
import 'package:money_management/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';

class PersonalView extends GetView<PersonalController> {
  const PersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    return
     LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final heightFactor = constraints.maxHeight / 812; // base height
        final widthFactor = constraints.maxWidth / 375; // base width
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Personal-Tracking',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.tealColor,
          ),
          backgroundColor: AppColors.backgroundColor,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  child: Container(
                    height: 220 * heightFactor,
                    width: double.infinity,
                    color: AppColors.tealColor,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0 * heightFactor),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 12.0 * heightFactor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Available Balance',
                                    style: AppTextStyles.availableBalance,
                                  ),
                                  Obx(
                                    () => Text(
                                      '₹${controller.totalIncome.value}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15 * widthFactor,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20 * heightFactor),
                            //
                            Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0 * widthFactor,
                                ),
                                child: Obx(
                                  () {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.PERSONALDATAGETINCOME);
                                          },
                                          child: Container(
                                            height: 100 * heightFactor,
                                            width: 150 * widthFactor,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // Rounded corners
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0,
                                                      4), // Adds a subtle shadow
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.all(
                                                12 * widthFactor),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40 * heightFactor,
                                                  width: 40 * widthFactor,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      'assets/chart-up.png',
                                                      height: 35 * heightFactor,
                                                      // width: 25 * widthFactor,
                                                      color: Colors
                                                          .green, // Makes the icon green
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 4 * heightFactor),
                                                Text(
                                                  '₹${controller.totalIncome.value.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 18 * widthFactor,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.PERSONALDATAGETIEXPENSE);
                                          },
                                          child: Container(
                                            height: 100 * heightFactor,
                                            width: 150 * widthFactor,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // Rounded corners
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0,
                                                      4), // Adds a subtle shadow
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.all(
                                                12 * widthFactor),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40 * heightFactor,
                                                  width: 40 * widthFactor,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      'assets/chart-down.png',
                                                      height: 35 * heightFactor,
                                                      // width: 25 * widthFactor,
                                                      color: Colors
                                                          .red, // Makes the icon green
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 4 * heightFactor),
                                                Text(
                                                  '₹${controller.totalExpense.value}',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 18 * widthFactor,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20 * heightFactor),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22 * widthFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Recent Records",
                        style: TextStyle(
                          fontSize: 20 * heightFactor,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealColor,
                        ),
                      ),
                      Image.asset(
                        'assets/history.png',
                        height: 23 * heightFactor,
                        width: 23 * widthFactor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8 * heightFactor),
                Expanded(
                  child: Obx(() {
                    if (controller.recentlyadded.isEmpty) {
                      return Center(
                        // Return this widget if data is empty
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/No-Data-Animation.json',
                              height: 120 * heightFactor,
                              width: 120 * widthFactor,
                            ),
                            const Text(
                              'No Data Available',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 30.0 * heightFactor),
                          ],
                        ),
                      );
                    } else {
                      return _buildRecentlyAddedList(heightFactor, widthFactor);
                    }
                  }),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.tealColor,
                  AppColors.tealColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.transparent,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.tealColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                controller.showIncomeExpenseModal(context);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Recently added items list
  Widget _buildRecentlyAddedList(double heightFactor, double widthFactor) {
    return Obx(() {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: controller.recentlyadded.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: 10 * widthFactor, vertical: 8 * heightFactor),
          itemBuilder: (context, index) {
            final item = controller.recentlyadded[index];

            Color categoryColor;
            switch (item['categoryType']) {
              case 'Income':
                categoryColor = Colors.green;
                break;
              case 'Expense':
                categoryColor = Colors.red;
                break;
              case 'Savings':
                categoryColor = Colors.blue;
                break;
              case 'Loans':
                categoryColor = Colors.purple;
                break;
              default:
                categoryColor = Colors.grey;
            }
            // Construct the full image URL
            String baseUrl =
                "https://s2swebsolutions.in/budgetbook/"; // Replace with actual base URL
            String imageUrl =
                item['categoryImg'] != null && item['categoryImg'].isNotEmpty
                    ? baseUrl + item['categoryImg'].toString()
                    : '';
            return GestureDetector(
              onTap: () {
                // Action on tap
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10 * heightFactor),
                padding: EdgeInsets.all(12 * widthFactor),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20 * widthFactor,
                      backgroundColor: categoryColor.withOpacity(0.2),
                      child: imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(20 * widthFactor),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 40 * widthFactor,
                                height: 40 * widthFactor,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const CircularProgressIndicator(
                                      strokeWidth: 2);
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/loan.png',
                                    width: 100 * widthFactor,
                                    height: 100 * heightFactor,
                                  );
                                },
                              ),
                            )
                          : const Icon(Icons.image,
                              color: Colors.grey, size: 24), // Placeholder icon
                    ),
                    SizedBox(width: 12 * widthFactor),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\₹ ${item['amount'].toString()}',
                            style: TextStyle(
                              fontSize: 16 * heightFactor,
                              fontWeight: FontWeight.w700,
                              color: categoryColor,
                            ),
                          ),
                          Text(
                            item['description'],
                            style: TextStyle(
                              fontSize: 13 * heightFactor,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4 * heightFactor),
                          Text(
                            item['incomeDate'] ?? "No date available",
                            style: TextStyle(
                              fontSize: 12 * heightFactor,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10 * widthFactor),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.PERSONAL_EDIT,
                          arguments: {
                            'id': item['id'].toString(),
                          },
                        );
                        print('edit ${item['id']}');
                      },
                      icon: Icon(Icons.edit,
                          color: AppColors.tealColor, size: 20 * heightFactor),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Confirm Deletion",
                          middleText:
                              "Are you sure you want to delete this income?",
                          textConfirm: "Yes",
                          textCancel: "No",
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            controller.deleteIncome(
                                item['id'].toString()); // Pass the ID
                            Get.offAllNamed(Routes.HOME); // Close the dialog
                          },
                        );
                      },
                      icon: Icon(Icons.delete_forever,
                          color: AppColors.expenseColor,
                          size: 20 * heightFactor),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

}
