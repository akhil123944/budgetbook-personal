import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:money_management/app/core/constants/app_urls.dart';
import 'package:money_management/app/modules/auth/controllers/auth_controller.dart';
import 'package:money_management/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    print('this is token from profile :${authController.token.value}');
  }

  void postcustomer() async {
    String customerId = authController.customerId.value.toString();
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    Map<String, dynamic> requestBody = {
      'customerId': customerId,
    };

    if (name.isNotEmpty) requestBody['name'] = name;
    if (email.isNotEmpty) requestBody['email'] = email;

    try {
      final response = await http.post(
        Uri.parse(AppUrls.customerprofile),
        headers: {"Authorization": "Bearer ${authController.token.value}"},
        body: (requestBody),
      );

      print("📥 Response Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ API Response: $data');
        Get.snackbar("Success", "Profile updated successfully",
            backgroundColor: Colors.green);
        Get.offAllNamed(Routes.HOME);
      } else {
        print('⚠ Response Body: ${response.body}');
        Get.snackbar("Error", "Failed to update profile. Try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Try again.");
    }
  }
}
