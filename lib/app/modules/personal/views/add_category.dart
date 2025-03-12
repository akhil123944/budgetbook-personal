import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/personal/controllers/personal_controller.dart';

class Category extends GetView<PersonalController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.introCardsColor,
              )),
          title: const Text("Add Category",
              style: TextStyle(
                color: (Colors.white),
              ))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Type Input
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedCategoryType.value.isNotEmpty
                      ? controller.selectedCategoryType.value
                      : null, // ✅ Ensures it's a valid String? value
                  decoration: InputDecoration(
                    labelText: "Category Type",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: controller.categoryTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedCategoryType.value =
                          value; // ✅ Correct assignment
                    }
                  },
                )),

            const SizedBox(height: 15),

            // Category Name Input
            TextFormField(
              controller: controller.categoryNameController,
              decoration: InputDecoration(
                labelText: "Category Name",
                prefixIcon: const Icon(Icons.category),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Image Picker
            Obx(() => GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: controller.categoryImg.value != null
                        ? Image.file(controller.categoryImg.value!,
                            fit: BoxFit.cover)
                        : const Center(
                            child: Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey)),
                  ),
                )),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => controller.postCategories(),
                // icon: const Icon(Icons.add, size: 20),
                label: const Text("save", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
