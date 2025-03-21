import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/app/core/constants/app_urls.dart';
import 'package:money_management/app/modules/auth/controllers/auth_controller.dart';
import 'package:money_management/app/modules/home/controllers/home_controller.dart';
import 'package:money_management/app/routes/app_pages.dart';
// import 'package:http/http.dart' as http;

class PersonalEditController extends GetxController {
  TextEditingController categoryIdController = TextEditingController(text: "");
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var getallDATAINCOME = <Map<String, dynamic>>[].obs;
  var getallDATAEXPENSE = <Map<String, dynamic>>[].obs;

  final AuthController authController = Get.find<AuthController>();
  // final PersonalController personalController = Get.find<PersonalController>();
  final HomeController homeController = Get.find<HomeController>();

  Future<void> pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Format Date and Time together
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format as "YYYY-MM-DD HH:MM AM/PM"
        final formattedDateTime = "${pickedDate.toLocal()}".split(' ')[0] +
            " ${pickedTime.format(context)}";

        dateController.text = formattedDateTime;
      }
    }
  }

  Future<void> updateIncome() async {
    print('🔄 updateIncome Called');

    final String? id = Get.arguments?['id'];
    if (id == null || id.isEmpty) {
      Get.snackbar("Error", "Invalid ID", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    print('🆔 ID: $id');

    final String url = "https://s2swebsolutions.in/budgetbook/api/income/$id";

    final Map<String, dynamic> updatedData = {
      "categoryId": categoryIdController.text.trim(),
      "amount": amountController.text.trim(),
      "description": descriptionController.text.trim(),
      "incomeDate": dateController.text.trim(),
    };

    print('📝 Request Data: $updatedData');

    try {
      final response = await authController.makeApiCall(
        url,
        isPost: true,
        body: updatedData, // ✅ Ensure correct encoding
      );

      print("API Response: ${response?.statusCode} | ${response?.body}");

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        // Get.snackbar("Success", "Income details updated successfully",
        //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
        // Get.offAllNamed(Routes.HOME);
        Get.back();
      } else {
        print(" Server Response: ${response?.body}");
        // Get.snackbar("Error", "Failed to update income. ${response.body}",
        //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    } catch (e) {
      print(" Exception: $e");
      // Get.snackbar("Error", "Something went wrong: $e",
      //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> updateExpense() async {
    print('✏️ updateExpense Called');

    // Retrieve the ID passed to the edit page
    final id = Get.arguments['id'];

    if (id == null || id.isEmpty) {
      Get.snackbar("Error", "Invalid ID", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    print('🆔 ID: $id');

    final String url = "https://s2swebsolutions.in/budgetbook/api/expense/$id";

    final Map<String, dynamic> updatedData = {
      "categoryId": categoryIdController.text.trim(),
      "amount": amountController.text.trim(),
      "description": descriptionController.text.trim(),
      "expenseDate": dateController.text.trim(),
    };

    print("📡 Updating Expense at URL: $url");
    print("📝 Request Data: $updatedData");
    print("🔑 Token: ${authController.token.value}");

    try {
      // Make API call using makeApiCall()
      final response = await authController.makeApiCall(
        url,
        isPost: true,
        body: updatedData,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["status"] == "Success") {
          // Get.snackbar("Success", "Expense details updated successfully",
          //     snackPosition: SnackPosition.BOTTOM);
          print("✅ Expense updated successfully.");

          // Refresh the data in the PersonalController after update
          // personalController.mergeData();
          // Get.offAllNamed(Routes.HOME);
          Get.back();
        } else {
          // Get.snackbar("Error",
          //     "Failed to update expense: ${responseData["message"] ?? "Unknown error"}",
          //     snackPosition: SnackPosition.BOTTOM);
          print("⚠️ API Error: ${responseData["message"]}");
        }
      } else {
        // Get.snackbar("Error", "Unexpected server response",
        //     snackPosition: SnackPosition.BOTTOM);
        print("⚠️ Unexpected server response: ${response?.statusCode}");
      }
    } catch (e) {
      // Get.snackbar("Error", "Something went wrong: $e",
      //     snackPosition: SnackPosition.BOTTOM);
      print("⚠️ Exception: $e");
    }
  }

// get Incomedata
  var isLoading = true.obs;
  var selectedItem = {}.obs;
  Future<void> fetchIncomeData(String id) async {
    try {
      final response = await authController.makeApiCall(
        AppUrls.indivisualINCOME,
        isGet: true,
      );

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data.containsKey('data') && data['data'] is List) {
          List<Map<String, dynamic>> incomeList =
              List<Map<String, dynamic>>.from(data['data']);
          // Find the specific item by ID
          var item = incomeList.firstWhere((element) => element['id'] == id,
              orElse: () => {});

          if (item.isNotEmpty) {
            selectedItem.value = item;
            categoryIdController.text = item['categoryId'] ?? "";
            amountController.text = item['amount']?.toString() ?? "";
            descriptionController.text = item['description'] ?? "";
            dateController.text =
                item['incomeDate'] ?? item['expenseDate'] ?? "";
          }
        }
      }
    } catch (e) {
      print("Error fetching income data: $e");
    } finally {
      isLoading.value = false;
    }
  }

// get Expensedta
  var selectedItemExpense = {}.obs;
  Future<void> fetchExpenseData(String id) async {
    try {
      final response = await authController.makeApiCall(
        AppUrls.indivisualexpense,
        isGet: true,
      );

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data.containsKey('data') && data['data'] is List) {
          List<Map<String, dynamic>> incomeList =
              List<Map<String, dynamic>>.from(data['data']);
          // Find the specific item by ID
          var item = incomeList.firstWhere((element) => element['id'] == id,
              orElse: () => {});

          if (item.isNotEmpty) {
            selectedItem.value = item;
            categoryIdController.text = item['categoryId'] ?? "";
            amountController.text = item['amount']?.toString() ?? "";
            descriptionController.text = item['description'] ?? "";
            dateController.text =
                item['incomeDate'] ?? item['expenseDate'] ?? "";
          }
        }
      }
    } catch (e) {
      print("Error fetching income data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments?['id']; // Get ID from navigation

    if (id != null) {
      print("Selected ID: $id");
      fetchIncomeData(id);
      fetchExpenseData(id);
    }
  }

  @override
  void onClose() {
    categoryIdController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    
    super.onClose();
  }
}
