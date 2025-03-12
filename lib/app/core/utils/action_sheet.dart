import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/app/core/themes/app_colors.dart';

class AddItemLoan {
  static void showFullScreenBottomSheet({
    required BuildContext context,
    required Function(Map<String, dynamic>) onAddItem,
  }) {
    final TextEditingController BorrowAmountController =
        TextEditingController();
    final TextEditingController BorrowDateController = TextEditingController();
    final TextEditingController BorrowDescriptionController =
        TextEditingController();
    RxString BorrowSelectedSource = ''.obs;

    final TextEditingController PayLoanAmountController =
        TextEditingController();
    final TextEditingController PayLoanDateController = TextEditingController();
    final TextEditingController PayLoanDescriptionController =
        TextEditingController();
    RxString PayLoanSelectedSource = ''.obs;

    final Map<String, List<String>> categorySources = {
      "Borrow": [
        "Personal",
        "Business",
        "Gold Loan",
        "Home loan",
        "Credit/Finance-Cards",
        "Others"
      ],
      "PayLoan": [
        "Personal",
        "Business",
        "Gold Loan",
        "Home Loan",
        "Credit/Finance-Cards",
        "Others",
      ],
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
                              "Loan Management",
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
                                Tab(text: "Borrow"),
                                Tab(text: "PayLoan"),
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              _buildTabContent(
                                context: context,
                                setState: setState,
                                selectedSource: BorrowSelectedSource,
                                categorySources: categorySources["Borrow"]!,
                                onAddItem: onAddItem,
                                dateController: BorrowDateController,
                                amountController: BorrowAmountController,
                                descriptionController:
                                    BorrowDescriptionController,
                                type: "Borrow",
                                widthFactor: widthFactor,
                                heightFactor: heightFactor,
                              ),
                              _buildTabContent(
                                context: context,
                                setState: setState,
                                selectedSource: PayLoanSelectedSource,
                                categorySources: categorySources["PayLoan"]!,
                                onAddItem: onAddItem,
                                dateController: PayLoanDateController,
                                amountController: PayLoanAmountController,
                                descriptionController:
                                    PayLoanDescriptionController,
                                type: "PayLoan",
                                widthFactor: widthFactor,
                                heightFactor: heightFactor,
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
    required List<String> categorySources,
    required Function(Map<String, dynamic>) onAddItem,
    required TextEditingController dateController,
    required TextEditingController amountController,
    required TextEditingController descriptionController,
    required String type,
    required double widthFactor,
    required double heightFactor,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.0 * widthFactor),
      child: SingleChildScrollView(child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value:
                  selectedSource.value.isNotEmpty ? selectedSource.value : null,
              items: categorySources
                  .map((source) => DropdownMenuItem<String>(
                        value: source,
                        child: Text(
                          source,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 15 * widthFactor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedSource.value = value ?? ""; // Update the selectedSource
              },
              decoration: InputDecoration(
                labelText: "Type of Loan",
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 15 * widthFactor,
                  fontWeight: FontWeight.w300,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16 * heightFactor),
            _buildTextField(
              controller: dateController,
              label: "Date & Time",
              hint: "Distribution Date",
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
              label: "Loan Amount",
              widthFactor: widthFactor,
            ),
            SizedBox(height: 16 * heightFactor),
            _buildFormattedAmountField(
              controller: amountController,
              label: "Intrest Rate%",
              widthFactor: widthFactor,
            ),
            SizedBox(height: 16 * heightFactor),
            _buildFormattedAmountField(
              controller: amountController,
              label: "Repayement Date",
              widthFactor: widthFactor,
            ),
            SizedBox(height: 16 * heightFactor),
            _buildFormattedAmountField(
              controller: amountController,
              label: "Loan Term",
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
                if (amountController.text.isEmpty) {
                  _showErrorSnackBar(context, "Please enter an amount.");
                } else {
                  onAddItem({
                    'subCategory': type, // Borrow or PayLoan
                    'source': selectedSource.value,
                    'date': dateController.text,
                    'amount': amountController.text,
                    'description': descriptionController.text,
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
              child: Text(
                "Save",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      })),
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
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$',
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
}
