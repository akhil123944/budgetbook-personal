import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/personal/controllers/personal_controller.dart';
import 'package:money_management/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';

class Incomedata extends GetView<PersonalController> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heightFactor = constraints.maxHeight / 812; // base height
        final widthFactor = constraints.maxWidth / 375; // base width
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.backgroundColor,
                )),
            title: const Text(
              'Personal Income Data',
              style: TextStyle(color: AppColors.backgroundColor),
            ),
            centerTitle: true,
          ),
          body: Obx(() {
            if (controller.getallDATAINCOME.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/No-Data-Animation.json',
                      height: 120,
                      width: 120,
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
                    const SizedBox(height: 30.0),
                  ],
                ),
              );
            } else {
              return _buildRecentlyAddedList(heightFactor, widthFactor);
            }
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showFilterSheet(context),
            backgroundColor: AppColors.backgroundColor,
            child: TextButton.icon(
              onPressed: () {},
              label: const Text(
                'filter',
                style: TextStyle(color: AppColors.backgroundColor),
              ),
              icon: Icon(Icons.filter_list, color: AppColors.tealColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentlyAddedList(double heightFactor, double widthFactor) {
    return Obx(() {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: controller.getallDATAINCOME.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: 10 * widthFactor, vertical: 8 * heightFactor),
          itemBuilder: (context, index) {
            final item = controller.getallDATAINCOME[index];

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
                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey.shade300,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                  );
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
                          titleStyle:
                              const TextStyle(color: AppColors.expenseColor),
                          middleText:
                              "Are you sure you want to delete this income?",
                          textConfirm: "Yes",
                          cancelTextColor: AppColors.tealColor,
                          textCancel: "No",
                          confirmTextColor: AppColors.expenseColor,
                          buttonColor: AppColors.backgroundColor,
                          onConfirm: () {
                            controller.deleteIncome(item['id'].toString());
                            Get.back();
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

  /// 🔹 Show Filter Bottom Sheet
  void showFilterSheet(BuildContext context) {
    DateTime? selectedDate;
    DateTime? startDate;
    DateTime? endDate;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.today, color: Colors.blue),
              title: const Text("Today"),
              onTap: () {
                controller.filterDataByToday();
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: AppColors.tealColor),
              title: const Text("Select a Date"),
              onTap: () async {
                selectedDate = await _pickDate(context);
                if (selectedDate != null) {
                  controller.filterDataByDate(selectedDate!);
                }
                Get.back();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.date_range, color: AppColors.expenseColor),
              title: const Text("Select Date Range"),
              onTap: () async {
                startDate = await _pickDate(context);
                if (startDate != null) {
                  endDate = await _pickDate(context);
                  if (endDate != null) {
                    controller.filterDataByDateRange(startDate!, endDate!);
                  }
                }
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Date Picker Function
  Future<DateTime?> _pickDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }
}
