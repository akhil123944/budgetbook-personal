import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/auth/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:money_management/app/core/constants/app_urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_management/app/routes/app_pages.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var customerDetails = <Map<String, dynamic>>[].obs;
  final updateprofileImage = "".obs;
  var selectedImage = Rx<File?>(null);
  var incomeData = <Map<String, dynamic>>[].obs;
  var allIds = <String>[].obs;
  final Rx<File?> categoryImg = Rx<File?>(null);
  final selectedCategoryType = ''.obs;
  final categoryNameController = TextEditingController();
  final categoryTypeController = TextEditingController();

  // Move TextEditingControllers to class level

  final incomeDateController = TextEditingController();
  final incomeAmountController = TextEditingController();
  final incomeDescriptionController = TextEditingController();

  final TextEditingController expenseDateController = TextEditingController();
  final expenseAmountController = TextEditingController();
  final expenseDescriptionController = TextEditingController();

  // profile
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Ensure this is initialized

  // final selectedCategoryId = "".obs;
  final selectedTab = 0.obs;
  final storeALLID = [].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    print('HomeController initialized :${authController.token.value}');
    super.onReady();
    customerDETAILS();
    fetchFinanceDataGET();
    fetchPersonalFinance();
    print('totalIncome : ${totalIncome.value}');
    print('totalExpense : ${totalExpense.value}');
    getINCOME();
    getEXPENSE();
    fetchRecentlyAdded();
    categoriesget();
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
  // var allIds = <String>[].obs; // Stores both income & expense IDs
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

// update profile
  Future<void> updateProfile() async {
    print('🔄 updateIncome Called');

    String url = AppUrls.profilepost;

    final Map<String, dynamic> updatedData = {
      "customerId": customerDetails[0]['id'].toString(),
      "name": nameController.text.toString(),
      "email": emailController.text.toString()
    };

    print('📝 Request Data: $updatedData');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${authController.token.value}',
        },
        body: (updatedData), // ✅ Ensure correct encoding
      );

      print("📡 API Response: ${response.statusCode} | ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Income details updated successfully",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
        Get.offAllNamed(Routes.HOME);
      } else {
        print("❌ Server Response: ${response.body}");
        Get.snackbar("Error", "Failed to update income. ${response.body}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    } catch (e) {
      print("🚨 Exception: $e");
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
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

  Future<void> postIncome({required int index}) async {
    try {
      // Debug the passed parameters
      print("🔥 Selected Category ID in postIncome: $index");
      print(
          "✅ Type of index: ${index.runtimeType}"); // Confirm that it's an int

      // Check for empty inputs
      if (incomeAmountController.text.isEmpty ||
          incomeDateController.text.isEmpty ||
          incomeDescriptionController.text.isEmpty) {
        Get.snackbar("Error", "All fields are required expense",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        return;
      }

      // Prepare the request body
      final body = {
        "categoryId": index.toString(),
        "amount": incomeAmountController.text.trim(),
        "incomeDate": incomeDateController.text.trim(), // ✅ Correct key
        "description": incomeDescriptionController.text.trim(),
      };
      print("📌 Sending API request with body: $body");

      // Convert the body to a URL-encoded string
      final encodedBody = Uri(queryParameters: body).query;

      print("Request body: $encodedBody");

      final response = await http.post(
        Uri.parse(AppUrls.incomepost),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${authController.token.value}',
        },
        body: encodedBody,
      );

      final data = jsonDecode(response.body);
      print("Response data: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Income transaction added",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
        Get.offAllNamed(Routes.HOME);

        final responseData = data['data'];
        print("Response Data: $responseData");

        // Clear input fields
        incomeAmountController.clear();
        incomeDateController.clear();
        incomeDescriptionController.clear();
      } else {
        Get.snackbar("Error", "Failed to add expense: ${data['message']}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        print("Error message: ${data['message']}");
      }
    } catch (e) {
      // Add debug print to see the exact error
      print("Exception occurred: $e");
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

// post expense

  Future<void> postExpense({required int index}) async {
    try {
      // Debug the passed parameters
      print("🔥 Selected Category ID in postIncome(): $index");
      print(
          "✅ Type of index: ${index.runtimeType}"); // Confirm that it's an int

      // Check for empty inputs
      if (expenseAmountController.text.isEmpty ||
          expenseDateController.text.isEmpty ||
          expenseDescriptionController.text.isEmpty) {
        Get.snackbar("Error", "All fields are required expense",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        return;
      }

      // Prepare the request body
      final body = {
        "categoryId": index.toString(),
        "amount": expenseAmountController.text.trim(),
        "expenseDate": expenseDateController.text.trim(), // ✅ Correct key
        "description": expenseDescriptionController.text.trim(),
      };
      print("📌 Sending API request with body: $body");

      // Convert the body to a URL-encoded string
      final encodedBody = Uri(queryParameters: body).query;

      print("Request body: $encodedBody");

      final response = await http.post(
        Uri.parse(AppUrls.expensivepost),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${authController.token.value}',
        },
        body: encodedBody,
      );

      final data = jsonDecode(response.body);
      print("Response data: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Expense transaction added",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
        Get.offAllNamed(Routes.HOME);

        final responseData = data['data'];
        print("Response Data: $responseData");

        // Clear input fields
        expenseAmountController.clear();
        expenseDateController.clear();
        expenseDescriptionController.clear();
      } else {
        Get.snackbar("Error", "Failed to add expense: ${data['message']}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        print("Error message: ${data['message']}");
      }
    } catch (e) {
      // Add debug print to see the exact error
      print("Exception occurred: $e");
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      categoryImg.value = File(pickedFile.path);
      print("✅ Image picked: ${categoryImg.value!.path}");
    } else {
      print("⚠️ No image selected");
    }
  }

  Future<void> postCategories() async {
    try {
      if (selectedCategoryType.value.isEmpty) {
        Get.snackbar("Error", "Please select a category type",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        return;
      }

      Map<String, String> fields = {
        'categoryType': selectedCategoryType.value,
        'categoryName': categoryNameController.text.trim(),
      };

      List<http.MultipartFile> files = [];

      if (categoryImg.value != null && categoryImg.value!.path.isNotEmpty) {
        var imageFile = categoryImg.value!;
        print("📤 Uploading file: ${imageFile.path}");
        files.add(await http.MultipartFile.fromPath(
          'categoryImg',
          imageFile.path,
          filename: basename(imageFile.path),
        ));
      } else {
        print("⚠️ No image selected for upload");
      }

      var response = await authController.makeApiCall(
        AppUrls.categoriesPOST,
        isPost: true,
        fields: fields,
        files: files,
      );

      if (response != null && response.statusCode == 201) {
        print("✅ Category uploaded successfully: ${response.body}");
        categoryNameController.clear();
        categoryTypeController.clear();
        selectedCategoryType.value = '';
        categoryImg.value = null; // ✅ Reset image after upload

        Get.snackbar("Success", "Category added successfully",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
        Get.offNamed(Routes.HOME);
      } else {
        print("❌ Error adding category: ${response?.body}");
        Get.snackbar("Error", "Failed to add category: ${response?.body}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    } catch (e) {
      print("🚨 Exception: $e");
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  void filterDataByToday() {
    final today = DateTime.now();
    getallDATAINCOME.value = getallDATAINCOME
        .where((item) =>
            DateTime.parse(item['incomeDate']).difference(today).inDays == 0)
        .toList();
  }

  void filterDataByDate(DateTime selectedDate) {
    getallDATAINCOME.value = getallDATAINCOME
        .where((item) =>
            DateTime.parse(item['incomeDate'])
                .difference(selectedDate)
                .inDays ==
            0)
        .toList();
  }

  void filterDataByDateRange(DateTime start, DateTime end) {
    getallDATAINCOME.value = getallDATAINCOME.where((item) {
      DateTime itemDate = DateTime.parse(item['incomeDate']);
      return itemDate.isAfter(start.subtract(Duration(days: 1))) &&
          itemDate.isBefore(end.add(Duration(days: 1)));
    }).toList();
  }

// get categories
  Rx<int?> selectedCategoryINCOMEId = Rx<int?>(0); // Default to 0
  Rx<int?> selectedCategoryEXPENSEId = Rx<int?>(0);
  final catagoires = <Map<String, dynamic>>[].obs;
  final categoryTypes = <String>[].obs;

  void categoriesget() async {
    try {
      // Make API call
      final response = await authController.makeApiCall(
        AppUrls.categoriesGET,
        isGet: true,
      );

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'data' exists and is a list
        if (data['data'] is List) {
          catagoires.value = List<Map<String, dynamic>>.from(
              data['data']); // ✅ Store all category data
          categoryTypes.value = catagoires
              .map((e) => e['categoryType'].toString())
              .toSet()
              .toList(); // ✅ Store unique category types

          print('📂 Fetched Categories: $catagoires');
          print('📁 Extracted Category Types: $categoryTypes');

          Get.snackbar("Success", "Fetched categories successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green);
        }
      } else {
        print(" Error: ${response?.statusCode}");
        print("Response body: ${response?.body}");
        Get.snackbar(
            "Error", "Failed to fetch categories: ${response?.statusCode}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  // delete expense

  Future<void> deleteExpense(String id) async {
    print('🗑️ deleteExpense Called for ID: $id');

    final String url =
        "https://s2swebsolutions.in/budgetbook/api/expense/$id"; // Use dynamic ID

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
          Get.snackbar("Success", "Expense details deleted successfully",
              snackPosition: SnackPosition.BOTTOM);
          print("✅ Expense deleted successfully.");
          Get.offAllNamed(Routes.HOME);

          // Remove item from local list
          getallDATAINCOME.removeWhere((item) => item['id'].toString() == id);
        } else {
          Get.snackbar("Error",
              "Failed to delete Expense: ${responseData["message"] ?? "Unknown error"}",
              snackPosition: SnackPosition.BOTTOM,
              borderColor: AppColors.expenseColor);
          print("⚠️ API Error: ${responseData["message"]}");
        }
      } else {
        Get.snackbar("Error", "Unexpected server response",
            snackPosition: SnackPosition.BOTTOM);
        print("⚠️ Unexpected server response: ${response?.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM);
      print("⚠️ Exception: $e");
    }
  }

  var recentlyadded = <Map<String, dynamic>>[].obs;
  Future<void> fetchRecentlyAdded() async {
    print(
        "Fetching recent added data with token: ${authController.token.value}");

    try {
      final response =
          await authController.makeApiCall(AppUrls.recentadded, isGet: true);

      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          recentlyadded.value = List<Map<String, dynamic>>.from(data['data']);
        } else {
          print("Invalid data format: ${response.body}");
        }
      } else {
        print("Failed to fetch recent added data: ${response?.body}");
      }
    } catch (e) {
      print("Error fetching recent added data: $e");
    }
  }

  /// **Show Modal Bottom Sheet**
  void showIncomeExpenseModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return DefaultTabController(
            length: 2, // Two tabs: Income & Expense
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.teal),
                      ),
                      const Text(
                        "New Entry",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // TabBar with teal indicator
                  // ignore: prefer_const_constructors
                  TabBar(
                    labelColor: Colors.black, // Active Tab Color
                    unselectedLabelColor: Colors.grey, // Inactive Tab Color
                    indicatorColor: Colors.teal, // Underline color
                    indicatorWeight: 3, // Thickness of underline
                    tabs: const [
                      Tab(text: "Income"),
                      Tab(text: "Expense"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TabBarView Content
                  Expanded(child: Obx(() {
                    var baseUrl = "https://s2swebsolutions.in/budgetbook/";
                    var incomeCategories = catagoires
                        .where((cat) => cat['categoryType'] == "Income")
                        .toList();
                    var expenseCategories = catagoires
                        .where((cat) => cat['categoryType'] == "Expense")
                        .toList();

                    print("Income Categories: $incomeCategories"); // Debugging
                    print(
                        "Expense Categories: $expenseCategories"); // Debugging
                    return TabBarView(
                      children: [
                        // Income Tab
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              // Define this in your controller or state

                              Container(
                                width: double.infinity,
                                height: 260,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(8),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: incomeCategories.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == incomeCategories.length) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes.CATEGORY);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white54,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add,
                                                color: Colors.teal, size: 30),
                                          ),
                                        ),
                                      );
                                    }

                                    var category = incomeCategories[index];
                                    var categoryId = int.tryParse(
                                            category['id'].toString()) ??
                                        0;
                                    var imgUrl =
                                        "$baseUrl${category['categoryImg']}";

                                    print(
                                        "Category ID: $categoryId"); // Debugging
                                    print("Image URL: $imgUrl"); // Debugging

                                    return GestureDetector(
                                      onTap: () {
                                        selectedCategoryINCOMEId.value =
                                            categoryId;
                                        print(
                                            "Selected Category ID: ${selectedCategoryINCOMEId.value}");
                                      },
                                      child: Obx(() => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: selectedCategoryINCOMEId
                                                            .value ==
                                                        categoryId
                                                    ? Colors
                                                        .teal // Border color when selected
                                                    : Colors
                                                        .transparent, // No border when not selected
                                                width: 3, // Border width
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                imgUrl,
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
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
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey);
                                                },
                                              ),
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: incomeDateController,
                                  decoration: const InputDecoration(
                                    labelText: "Select Date & Time",
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: AppColors.primaryColor,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true, // Prevents manual text input
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if (pickedTime != null) {
                                        DateTime finalDateTime = DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          pickedTime.hour,
                                          pickedTime.minute,
                                        );

                                        String formattedDateTime =
                                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(finalDateTime);

                                        incomeDateController.text =
                                            formattedDateTime;
                                      }
                                    }
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: incomeAmountController,
                                  decoration: const InputDecoration(
                                    labelText: "Amount",
                                    prefixIcon: Icon(Icons.currency_rupee),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: incomeDescriptionController,
                                  decoration: const InputDecoration(
                                    labelText: "Description",
                                    // prefixIcon: Icon(Icons.description),
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 2,
                                ),
                              ),

                              SizedBox(
                                width: double.infinity,
                                child: // Save Button Debugging
                                    ElevatedButton(
                                  onPressed: () {
                                    print('Save btn called');
                                    print(
                                        "✅ Selected Expense Category ID: ${selectedCategoryINCOMEId.value}");

                                    int categoryIncomeId =
                                        selectedCategoryINCOMEId.value ?? 0;

                                    // Check if at least one category is selected

                                    // Post expense only if an expense category is selected
                                    if (categoryIncomeId != 0) {
                                      postIncome(index: categoryIncomeId);
                                      Get.offAllNamed(Routes.HOME);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0),
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        // Expense Tab

                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 260,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(8),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: expenseCategories.length +
                                      1, // +1 for the add button
                                  itemBuilder: (context, index) {
                                    if (index == expenseCategories.length) {
                                      // "Add Category" Button
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes
                                              .CATEGORY); // Navigate to Add Category Page
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white54,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add,
                                                color: Colors.teal, size: 30),
                                          ),
                                        ),
                                      );
                                    }

                                    var category = expenseCategories[index];
                                    var categoryId = int.tryParse(
                                            category['id'].toString()) ??
                                        0;
                                    var imgUrl =
                                        "$baseUrl${category['categoryImg']}";

                                    print(
                                        "Expense Category ID: $categoryId"); // Debugging
                                    print(
                                        "Expense Image URL: $imgUrl"); // Debugging

                                    return GestureDetector(
                                      onTap: () {
                                        selectedCategoryEXPENSEId.value =
                                            categoryId;
                                        print(
                                            "Selected Expense Category ID: ${selectedCategoryEXPENSEId.value}");
                                      },
                                      child: Obx(() => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: selectedCategoryEXPENSEId
                                                            .value ==
                                                        categoryId
                                                    ? Colors
                                                        .red // Border color when selected
                                                    : Colors
                                                        .transparent, // No border when not selected
                                                width: 3, // Border width
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                imgUrl,
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
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
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey);
                                                },
                                              ),
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: expenseDateController,
                                  decoration: const InputDecoration(
                                    labelText: "Select Date & Time",
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: AppColors.expenseColor,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true, // Prevents manual text input
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if (pickedTime != null) {
                                        DateTime finalDateTime = DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          pickedTime.hour,
                                          pickedTime.minute,
                                        );

                                        String formattedDateTime =
                                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(finalDateTime);

                                        expenseDateController.text =
                                            formattedDateTime;
                                      }
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: expenseAmountController,
                                  decoration: const InputDecoration(
                                    labelText: "Amount",
                                    prefixIcon: Icon(Icons.currency_rupee),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: expenseDescriptionController,
                                  decoration: const InputDecoration(
                                    labelText: "Description",
                                    // prefixIcon: Icon(Icons.),
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: // Save Button Debugging
                                    ElevatedButton(
                                  onPressed: () {
                                    print('Save btn called');
                                    print(
                                        "✅ Selected Expense Category ID: ${selectedCategoryEXPENSEId.value}");

                                    int categoryEXPENSEId =
                                        selectedCategoryEXPENSEId.value ?? 0;

                                    // Check if at least one category is selected

                                    // Post expense only if an expense category is selected

                                    postExpense(index: categoryEXPENSEId);
                                    Get.offAllNamed(Routes.HOME);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0),
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  })),

                  // const SizedBox(height: 20),

                  // Save Button
                ],
              ),
            ),
          );
        });
  }
}
