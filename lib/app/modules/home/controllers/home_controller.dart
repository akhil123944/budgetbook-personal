import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/modules/auth/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:money_management/app/core/constants/app_urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_management/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var customerDetails = <Map<String, dynamic>>[].obs;
  final updateprofileImage = "".obs;
  var selectedImage = Rx<File?>(null);
  var incomeData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    print('HomeController initialized :${authController.token.value}');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    customerDETAILS();
    fetchFinanceDataGET();
    fetchPersonalFinance();
    print('totalIncome : ${totalIncome.value}');
    print('totalExpense : ${totalExpense.value}');
    getEXPENSE();
    getEXPENSE();
  }

  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;

  Future<void> fetchPersonalFinance() async {
    try {
      final response = await authController
          .makeApiCall(AppUrls.personalincomeandexpense, isGet: true);

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data.containsKey('data')) {
          // Extract correct income & expense values
          final financeData = data['data'];
          print("personal get view:${financeData}");
          totalIncome.value =
              double.tryParse(financeData['income'].toString()) ?? 0.0;
          totalExpense.value =
              double.tryParse(financeData['expense'].toString()) ?? 0.0;

          Get.snackbar("Success", "Data fetched successfully");
        } else {
          Get.snackbar("Error", "Invalid data format");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch finance data");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  // ✅ Fetch Income Data

  var getallDATAINCOME = <Map<String, dynamic>>[].obs;
  var getallDATAEXPENSE = <Map<String, dynamic>>[].obs;
  var allIds = <String>[].obs; // Stores both income & expense IDs
  var mergedData = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> fetchFinanceDataGET() async {
    isLoading(true);
    await getINCOME();
    await getEXPENSE();
    mergeData();
    isLoading(false);
    print("this is home fethed data : ${mergedData.value}");
  }
// get income and expense mergeData

  Future<void> getINCOME() async {
    print("Fetching income with token: ${authController.token.value}");

    final response =
        await authController.makeApiCall(AppUrls.allINCOME, isGet: true);

    if (response != null && response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data.containsKey('data') && data['data'] is List) {
        getallDATAINCOME.value = List<Map<String, dynamic>>.from(data['data']);

        List<String> incomeIds = data['data']
            .where((item) => item != null && item['id'] != null)
            .map<String>((item) => item['id'].toString())
            .toList();

        // allIds.addAll(incomeIds); // Add income IDs to allIds
      }
    } else {
      print("Failed to fetch income: ${response?.body}");
    }
  }

  Future<void> getEXPENSE() async {
    print("Fetching expense with token: ${authController.token.value}");

    final response =
        await authController.makeApiCall(AppUrls.allexpense, isGet: true);

    if (response != null && response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data.containsKey('data') && data['data'] is List) {
        getallDATAEXPENSE.value = List<Map<String, dynamic>>.from(data['data']);

        List<String> expenseIds = data['data']
            .where((item) => item != null && item['id'] != null)
            .map<String>((item) => item['id'].toString())
            .toList();

        allIds.addAll(expenseIds); // Add expense IDs to allIds
      }
    } else {
      print("Failed to fetch expense: ${response?.body}");
    }
  }

  void mergeData() {
    List<Map<String, dynamic>> combinedList = [];
    combinedList.addAll(getallDATAINCOME);
    combinedList.addAll(getallDATAEXPENSE);
    combinedList.shuffle(); // Randomize order
    mergedData.value = combinedList;

    print("This is merged data: ${mergedData.value}");
    print("All stored IDs (Income + Expense): ${allIds.value}");
  }

//  get customer details

  void customerDETAILS() async {
    print(
        "Fetching customer details with token: ${authController.token.value}");

    final response =
        await authController.makeApiCall(AppUrls.customerdetails, isGet: true);

    try {
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Customer profile view: $data");

        if (data != null && data.containsKey('data')) {
          if (data['data'] is List) {
            // ✅ If it's a list, store it directly
            customerDetails.value =
                List<Map<String, dynamic>>.from(data['data']);
          } else if (data['data'] is Map<String, dynamic>) {
            // ✅ If it's a single object, convert it to a list
            customerDetails.value = [data['data']];
          }
          print("Updated Customer Data: ${customerDetails.value}");
          Get.snackbar("Success", "Customer data fetched successfully");
        } else {
          Get.snackbar("Error", "Invalid response from customer API");
        }
      } else {
        print("Error fetching customer details: ${response?.body}");
        Get.snackbar("Error", "Failed to fetch customer details");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar(
          "Error", "An error occurred while fetching customer details");
    }
  }

// update profileimage

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
      uploadImage();
    } else {
      Get.snackbar("Cancelled", "No image selected");
    }
  }

  // Upload the selected image

  Future<void> uploadImage() async {
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image first");
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrls.profileImgupdate),
    );

    request.headers.addAll({
      "Authorization": "Bearer ${authController.token.value}",
    });

    request.files.add(await http.MultipartFile.fromPath(
      'profileImg',
      selectedImage.value!.path,
    ));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile image updated successfully");
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar("Error", "Failed to update profile image");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  // logout

  Future<void> logout() async {
    final response =
        await authController.makeApiCall(AppUrls.logout, isPost: true);

    try {
      if (response != null && response.statusCode == 200) {
        Get.snackbar("Success", "Logged out successfully");
        authController.token.value = ""; // Clear token after logout
        Get.offAllNamed(Routes.LOGIN);
        print("Logout success: ${response.body}");
      } else {
        print("Logout failed: ${response?.body}");
        Get.snackbar("Error", "Failed to log out. Please try again.");
      }
    } catch (e) {
      print("Logout exception: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  void logoutcustomer() {
    Get.defaultDialog(
      title: "Logout",
      titleStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent,
      ),
      content: const Column(
        children: [
          Text(
            "Are you sure you want to log out?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 20),
        ],
      ),
      radius: 15,
      barrierDismissible: false, // Prevents accidental dismissal
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text("Logout"),
        ),
      ],
    );
  }

// delete income

  Future<void> deleteIncome(String id) async {
    print('🗑️ deleteIncome Called for ID: $id');

    final String url =
        "https://s2swebsolutions.in/budgetbook/api/income/$id"; // Use dynamic ID

    print("📡 Deleting Income at URL: $url");
    print("🔑 Token: ${authController.token.value}");

    try {
      final response = await authController.makeApiCall(
        url,
        isDelete: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["status"] == "Success") {
          Get.snackbar("Success", "Income details deleted successfully",
              snackPosition: SnackPosition.BOTTOM);
          print("✅ Income deleted successfully.");

          // Remove item from local list
          getallDATAINCOME.removeWhere((item) => item['id'].toString() == id);
        } else {
          Get.snackbar("Error",
              "Failed to delete income: ${responseData["message"] ?? "Unknown error"}",
              snackPosition: SnackPosition.BOTTOM);
          print("API Error: ${responseData["message"]}");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM);
      print("⚠️ Exception: $e");
    }
  }
}
