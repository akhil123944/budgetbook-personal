import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import '../controllers/personal_edit_controller.dart';

class PersonalEditView extends GetView<PersonalEditController> {
  const PersonalEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
        ),
        title: const Text(
          'Update / Delete',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(controller.categoryIdController, "Category ID",
                  Icons.category),
              const SizedBox(height: 12),
              _buildTextField(
                  controller.amountController, "Amount", Icons.attach_money,
                  isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(controller.descriptionController, "Description",
                  Icons.description,
                  maxLines: 3),
              const SizedBox(height: 12),
              _buildTextField(
                  controller.dateController, "Date", Icons.calendar_today,
                  isReadOnly: true, onTap: () {
                controller.pickDateTime(context);
              }),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        );
      }),
    );
  }

  /// Reusable TextField Widget
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isReadOnly = false,
      bool isNumber = false,
      int maxLines = 1,
      Function()? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon),
      ),
      onTap: onTap,
    );
  }

  /// Save Button
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          controller.updateIncome();
          print("income updated : ${controller.updateIncome()}");

          controller.updateExpense();
          print("income updated : ${controller.updateExpense()}");
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Save",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
