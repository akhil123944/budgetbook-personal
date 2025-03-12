// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/app/core/themes/app_colors.dart';

// Bottom sheet code with categoryId integration
class AddItemNonDashboard {
  static void showFullScreenBottomSheet({
    required BuildContext context,
    required Function(Map<String, dynamic>) onAddItem,
  }) {
    final TextEditingController incomeAmountController =
        TextEditingController();
    final TextEditingController incomeDateController = TextEditingController();
    final TextEditingController incomeDescriptionController =
        TextEditingController();
    RxString incomeSelectedSource = ''.obs;

    final TextEditingController expenseAmountController =
        TextEditingController();
    final TextEditingController expenseDateController = TextEditingController();
    final TextEditingController expenseDescriptionController =
        TextEditingController();
    RxString expenseSelectedSource = ''.obs;

    final Map<String, IconData> incomeIcons = {
      "Gift": FontAwesomeIcons.gift,
      "Salary": FontAwesomeIcons.dollarSign,
      "Freelancing": FontAwesomeIcons.laptopCode,
      "Rental": FontAwesomeIcons.building,
      "Bonuses": FontAwesomeIcons.moneyBillWave,
      "Others": FontAwesomeIcons.ellipsisH,
    };

    final Map<String, IconData> expenseIcons = {
      "Food": FontAwesomeIcons.utensils,
      "Movie": FontAwesomeIcons.film,
      "Travel": FontAwesomeIcons.plane,
      "Shopping": FontAwesomeIcons.shoppingBag,
      "Rent": FontAwesomeIcons.home,
      "Health": FontAwesomeIcons.heartbeat,
      "Bills": FontAwesomeIcons.fileInvoiceDollar,
      "Others": FontAwesomeIcons.ellipsisH,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                double heightFactor =
                    constraints.maxHeight / 812; // Base height
                double widthFactor = constraints.maxWidth / 375; // Base width

                return SafeArea(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: Container(
                      height: constraints.maxHeight * 0.9,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          appBar: AppBar(
                            automaticallyImplyLeading: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            centerTitle: false,
                            title: Text(
                              "New Entry",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 18 * widthFactor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () => Get.back(),
                            ),
                            bottom: TabBar(
                              indicatorColor: AppColors.tealColor,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.teal,
                              unselectedLabelColor: Colors.grey,
                              labelStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 15 * widthFactor,
                              ),
                              tabs: const [
                                Tab(text: "Income"),
                                Tab(text: "Expense"),
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              _buildTabContent(
                                context: context,
                                setState: setState,
                                selectedSource: incomeSelectedSource,
                                onAddItem: onAddItem,
                                dateController: incomeDateController,
                                amountController: incomeAmountController,
                                descriptionController:
                                    incomeDescriptionController,
                                type: "Income",
                                widthFactor: widthFactor,
                                heightFactor: heightFactor,
                                icons: incomeIcons,
                              ),
                              _buildTabContent(
                                context: context,
                                setState: setState,
                                selectedSource: expenseSelectedSource,
                                onAddItem: onAddItem,
                                dateController: expenseDateController,
                                amountController: expenseAmountController,
                                descriptionController:
                                    expenseDescriptionController,
                                type: "Expense",
                                widthFactor: widthFactor,
                                heightFactor: heightFactor,
                                icons: expenseIcons,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static Widget _buildTabContent({
    required BuildContext context,
    required StateSetter setState,
    required RxString selectedSource,
    required Function(Map<String, dynamic>) onAddItem,
    required TextEditingController dateController,
    required TextEditingController amountController,
    required TextEditingController descriptionController,
    required String type,
    required double widthFactor,
    required double heightFactor,
    required Map<String, IconData> icons,
  }) {
    RxInt selectedCategoryId = (-1).obs; // Initialize with -1 (no selection)

    return Padding(
      padding: EdgeInsets.all(16.0 * widthFactor),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: icons.length,
                  itemBuilder: (context, index) {
                    final key = icons.keys.elementAt(index);
                    return Obx(() => GestureDetector(
                          onTap: () {
                            selectedCategoryId.value =
                                index; // Set the selected categoryId
                            selectedSource.value =
                                key; // Set the selected source
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedCategoryId.value == index
                                  ? AppColors.tealColor.withOpacity(0.2)
                                  : AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: FaIcon(
                                icons[key],
                                size: 26,
                                color: selectedCategoryId.value == index
                                    ? AppColors.tealColor
                                    : AppColors.blueColor,
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ),
            SizedBox(height: 16 * heightFactor),
            _buildTextField(
              controller: dateController,
              label: "Date & Time",
              hint: "Select a date and time",
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.teal),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final DateTime fullDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      dateController.text =
                          DateFormat('dd-MM-yyyy HH:mm').format(fullDateTime);
                    }
                  }
                },
              ),
              widthFactor: widthFactor,
            ),
            SizedBox(height: 16 * heightFactor),
            _buildFormattedAmountField(
              controller: amountController,
              label: "Amount",
              widthFactor: widthFactor,
            ),
            SizedBox(height: 16 * heightFactor),
            _buildTextField(
              controller: descriptionController,
              label: "Description",
              maxLines: 2,
              widthFactor: widthFactor,
            ),
            SizedBox(height: 28 * heightFactor),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isEmpty ||
                    selectedCategoryId.value == -1) {
                  _showErrorSnackBar(
                      context, "Please enter an amount and select a category.");
                } else {
                  onAddItem({
                    'subCategory': type, // Income or Expense
                    'source': selectedSource.value,
                    'date': dateController.text,
                    'amount': amountController.text,
                    'description': descriptionController.text,
                    'categoryId': selectedCategoryId.value, // Add categoryId
                  });

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0 * heightFactor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.teal,
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    int maxLines = 1,
    required double widthFactor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontSize: 15 * widthFactor,
          fontWeight: FontWeight.w300,
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  static Widget _buildFormattedAmountField({
    required TextEditingController controller,
    required String label,
    required double widthFactor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontSize: 15 * widthFactor,
          fontWeight: FontWeight.w300,
        ),
      ),
      onChanged: (value) {
        // Remove commas and other formatting to process the raw number
        final rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
        final parsedValue = int.tryParse(rawValue);
        if (parsedValue != null) {
          final formattedValue = _formatAmount(parsedValue);
          controller.value = TextEditingValue(
            text: formattedValue,
            selection: TextSelection.collapsed(
              offset: formattedValue.length,
            ),
          );
        }
      },
    );
  }

  static String _formatAmount(int amount) {
    if (amount >= 100000 && amount < 10000000) {
      // Format as Lacs
      return '${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 10000000) {
      // Format as Crores
      return '${(amount / 10000000).toStringAsFixed(2)} Cr';
    }
    // Default formatting with commas
    return NumberFormat("#,##0").format(amount);
  }


}
