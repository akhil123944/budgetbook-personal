import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/home/controllers/home_controller.dart';

class EditProfile extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.backgroundColor),
        ),
        centerTitle: true,
        backgroundColor: AppColors.tealColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.customerDetails.isEmpty) {
          return const Center(child: Text("No customer data available"));
        }

        final customer = controller.customerDetails[0];

        // Populate controllers with fetched data
        controller.nameController.text = customer['name'] ?? '';
        controller.emailController.text = customer['email'] ?? '';
        controller.phoneController.text = customer['phone'] ?? '';

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: customer['profileImg'] != null &&
                                customer['profileImg'].isNotEmpty
                            ? NetworkImage(
                                "https://s2swebsolutions.in/budgetbook/${customer['profileImg']}")
                            : const AssetImage('assets/man.png')
                                as ImageProvider,
                        child: customer['profileImg'] == null
                            ? const Icon(Icons.person,
                                size: 60, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: controller.pickImage,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.tealColor,
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Profile Form
                buildTextField(
                    "Full Name", Icons.person, controller.nameController),
                const SizedBox(height: 15),
                buildTextField(
                    "Email", Icons.email, controller.emailController),
                const SizedBox(height: 15),
                buildTextField(
                    "Phone Number", Icons.phone, controller.phoneController,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () {
                          controller.updateProfile();
                        }, // Ensure this function is in your controller
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColors.tealColor,
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Helper function to create text fields
  Widget buildTextField(
      String label, IconData icon, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.tealColor),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
