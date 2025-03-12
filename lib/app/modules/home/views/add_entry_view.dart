import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddEntryView extends GetView {
  const AddEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for input fields
    final TextEditingController amountController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController sourceController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final RxString selectedCategory = "Income".obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Entry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Category Chips
            Obx(
              () => Wrap(
                spacing: 8.0,
                children: ["Income", "Expenses", "Loans", "Savings"].map((category) {
                  final bool isSelected = selectedCategory.value == category;
                  return GestureDetector(
                    onTap: () {
                      selectedCategory.value = category;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.teal : Colors.grey,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Date Picker
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date & Time",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
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
                        dateController.text = DateFormat('dd-MM-yyyy HH:mm').format(fullDateTime);
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Amount Field
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),
            const SizedBox(height: 16.0),

            // Save Button

            ElevatedButton(
              onPressed: () {
                if (dateController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  // Collect and print the entered data
                  final Map<String, dynamic> data = {
                    'category': selectedCategory.value,
                    'date': dateController.text,
                    'amount': double.tryParse(amountController.text) ?? 0,
                    'source': sourceController.text,
                    'note': noteController.text,
                    'description': descriptionController.text,
                  };
                  
                  Get.snackbar(
                    "Entry Saved",
                    "Your entry for ${data['category']} has been saved.",
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  // Clear fields after saving
                  amountController.clear();
                  dateController.clear();
                  sourceController.clear();
                  noteController.clear();
                  descriptionController.clear();
                } else {
                  Get.snackbar(
                    "Incomplete Data",
                    "Please fill all required fields.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
