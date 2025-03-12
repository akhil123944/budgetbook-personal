import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/routes/app_pages.dart';
import '../controllers/pie_charts_controller.dart';

class PieChartsView extends GetView<PieChartsController> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double heightFactor = constraints.maxHeight / 812; // Base height
        double widthFactor = constraints.maxWidth / 375; // Base width
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Get.offAllNamed(Routes.HOME);
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.whiteColor,
              ),
            ),
            title: Text(
              'Total Income & Expense',
              style: TextStyle(
                fontSize: 18 * widthFactor,
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.teal,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Income Section
                    SizedBox(height: 6 * heightFactor),
                    Text(
                      "Income Chart",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22 * widthFactor,
                        fontWeight: FontWeight.w400,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 8 * heightFactor),
                    SizedBox(
                      height: 300 * heightFactor,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 3),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, animationValue, child) {
                          return PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: 40 * animationValue,
                                  title:
                                      'Personal\n${(40 * animationValue).toInt()}%',
                                  color: Colors.orange,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 30 * animationValue,
                                  title:
                                      'Business\n${(30 * animationValue).toInt()}%',
                                  color: Colors.blueAccent,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 20 * animationValue,
                                  title:
                                      'Loans\n${(20 * animationValue).toInt()}%',
                                  color: Colors.green,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 10 * animationValue,
                                  title:
                                      'Savings\n${(10 * animationValue).toInt()}%',
                                  color: Colors.purple,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              sectionsSpace: 5,
                              centerSpaceRadius: 50,
                              centerSpaceColor: Colors.white,
                              borderData: FlBorderData(show: false),
                              startDegreeOffset: 180,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12 * heightFactor),
                    Text(
                      "Expense Chart",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22 * widthFactor,
                        fontWeight: FontWeight.w400,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 12 * heightFactor),
                    SizedBox(
                      height: 300 * heightFactor,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 3),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, animationValue, child) {
                          return PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: 50 * animationValue,
                                  title:
                                      'Personal\n${(50 * animationValue).toInt()}%',
                                  color: Colors.redAccent,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 20 * animationValue,
                                  title:
                                      'Business\n${(20 * animationValue).toInt()}%',
                                  color: Colors.lightBlue,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 15 * animationValue,
                                  title:
                                      'Loans\n${(15 * animationValue).toInt()}%',
                                  color: Colors.deepOrangeAccent                                                                       ,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: 15 * animationValue,
                                  title:
                                      'Savings\n${(15 * animationValue).toInt()}%',
                                  color: Colors.indigo,
                                  radius: 80,
                                  titleStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12 * widthFactor,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              sectionsSpace: 5,
                              centerSpaceRadius: 50,
                              centerSpaceColor: Colors.white,
                              borderData: FlBorderData(show: false),
                              startDegreeOffset: 180,
                            ),
                          );
                        },
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
  }
}
