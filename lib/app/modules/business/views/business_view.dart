import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/core/themes/app_textstyles.dart';
import 'package:money_management/app/core/utils/sub_actionsheet.dart';

import '../controllers/business_controller.dart';

class BusinessView extends GetView<BusinessController> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final heightFactor = constraints.maxHeight / 812; // base height
        final widthFactor = constraints.maxWidth / 375; // base width
        return Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: true,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Business-Tracking',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          backgroundColor: AppColors.backgroundColor, // Ensure it's not white
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
                            // Available Balance Section

                            Padding(
                              padding:
                                  EdgeInsets.only(top: 12.0 * heightFactor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Available Balance',
                                      style: AppTextStyles.availableBalance),
                                  Obx(
                                    () => Text(
                                        '\₹${controller.availableBalance.value.toStringAsFixed(2)}',
                                        style: AppTextStyles.balanceAmount),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20 * heightFactor),
                            // Income and Expenses Cards
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0 * widthFactor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildFinanceCard(
                                    title: 'Income',
                                    value: controller.totalIncome,
                                    color: Colors.green,
                                    graphImagePath: 'assets/chart-up.png',
                                    widthFactor: widthFactor,
                                    heightFactor: heightFactor,
                                  ),
                                  _buildFinanceCard(
                                    title: 'Expenses',
                                    value: controller.totalExpenses,
                                    color: Colors.red,
                                    graphImagePath: 'assets/chart-down.png',
                                    widthFactor: widthFactor,
                                    heightFactor: heightFactor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20 * heightFactor),
                // // Tabs Section
                // _buildTabs(context, heightFactor, widthFactor),
                // SizedBox(
                //   height: 20 * heightFactor,
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22 * widthFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Business Records", // Section Title
                        style: TextStyle(
                          fontSize:
                              20 * heightFactor, // You can adjust the font size
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealColor, // Or use your theme color
                        ),
                      ),
                      Image.asset(
                        'assets/history.png',
                        height: 23 * heightFactor,
                        width: 23 * widthFactor,
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 8 * heightFactor,
                ),
                Expanded(child: Obx(() {
                  return SizedBox(
                      height: constraints.maxHeight * 0.7,
                      child: controller.recentlyAdded.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/No-Data-Animation.json',
                                      height: 120 * heightFactor,
                                      width: 120 * widthFactor),
                                  Text(
                                    'No Data Available',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(
                                    height: 30.0 * heightFactor,
                                  )
                                ],
                              ),
                            )
                          : _buildRecentlyAddedList(heightFactor, widthFactor));
                })),
              ],
            ),
          ),
          floatingActionButton: Container(
            height: 55, // Adjust height as needed
            width: 55, // Adjust width as needed
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
              borderRadius: BorderRadius.circular(30), // Circular for FAB look
              boxShadow: [
                BoxShadow(
                  color: AppColors.tealColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                AddItemNonDashboard.showFullScreenBottomSheet(
                    context: context,
                    onAddItem: (newItem) {
                      controller.addNewItem(newItem);
                    });
              },
              backgroundColor:
                  Colors.transparent, // Makes the FAB blend with container
              elevation: 0, // Removes FAB shadow since decoration handles it
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFinanceCard({
    required String title,
    required RxDouble value,
    required Color color,
    required String graphImagePath,
    required double widthFactor,
    required double heightFactor,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              blurStyle: BlurStyle.outer,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.all(6.0 * widthFactor),
        margin: EdgeInsets.symmetric(horizontal: 5 * widthFactor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15 * widthFactor,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 2 * heightFactor),
            Image.asset(
              graphImagePath,
              height: 40 * heightFactor,
              color: color,
            ),
            SizedBox(height: 2 * heightFactor),
            Obx(
              () => Text(
                '\₹${value.value.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15 * widthFactor,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recently added items list
  Widget _buildRecentlyAddedList(double heightFactor, double widthFactor) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.recentlyAdded.length,
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = controller.recentlyAdded[index];

          // Determine the color based on the category
          Color categoryColor;
          IconData categoryIcon;
          switch (item['subCategory']) {
            case 'Income':
              categoryColor = AppColors.incomeColor;
              categoryIcon = Icons.arrow_circle_up;
              break;
            case 'Expense':
              categoryColor = AppColors.expenseColor;
              categoryIcon = Icons.arrow_circle_down;
              break;
            default:
              categoryColor = Colors.grey;
              categoryIcon = Icons.help_outline;
          }

          return GestureDetector(
            onTap: () {
              // Add your navigation or action here
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(
                horizontal: 16 * widthFactor,
                vertical: 8 * heightFactor,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: GlassmorphicContainer(
                width: double.infinity,
                height: 160 * heightFactor,
                borderRadius: 16,
                blur: 20,
                alignment: Alignment.bottomCenter,
                border: 1,
                linearGradient: LinearGradient(
                  colors: [
                    Colors.grey.shade300,
                    Colors.white.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderGradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.5), Colors.grey.shade200],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16 * widthFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row for Icon, Category, and Amount
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 24 * widthFactor,
                                backgroundColor: categoryColor.withOpacity(0.2),
                                child: Icon(
                                  Icons.category,
                                  size: 20 * heightFactor,
                                  color: categoryColor,
                                ),
                              ),
                              SizedBox(width: 12 * widthFactor),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item['subCategory'],
                                    style: TextStyle(
                                      fontSize: 16 * heightFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // Text(
                                  //   item['source'].toString(),
                                  //   style: TextStyle(
                                  //     fontSize: 14 * heightFactor,
                                  //     color: Colors.black54,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "\₹${formatAmount(item['amount'])}",
                            style: TextStyle(
                              fontSize: 16 * heightFactor,
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8 * heightFactor),
                      // Row for Date and Source
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0 * widthFactor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Date
                            Text(
                              item['date'].toString(),
                              style: TextStyle(
                                fontSize: 12 * heightFactor,
                                color: Colors.grey,
                              ),
                            ),
                            // Source
                            Text(
                              "Source: ${item['source'].toString()}",
                              style: TextStyle(
                                fontSize: 12 * heightFactor,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8 * heightFactor),
                      // Description
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0 * widthFactor),
                        child: Text(
                          item['description'].toString(),
                          style: TextStyle(
                            fontSize: 14 * heightFactor,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  String formatAmount(String rawAmount) {
    try {
      // Remove commas and units
      final unitRegex =
          RegExp(r'[^\d.]'); // Matches anything that is not a digit or a dot
      String cleanedAmount = rawAmount.replaceAll(unitRegex, '');
      double numericAmount = double.parse(cleanedAmount);

      // Detect unit (e.g., "L", "M", "B") if present
      String unit = rawAmount.contains('L')
          ? 'L'
          : rawAmount.contains('M')
              ? 'M'
              : rawAmount.contains('B')
                  ? 'B'
                  : '';

      // Format the numeric part with commas and append the unit
      return "${NumberFormat("#,##0.00").format(numericAmount)} $unit".trim();
    } catch (e) {
      // Return raw amount if parsing fails
      return rawAmount;
    }
  }
}
