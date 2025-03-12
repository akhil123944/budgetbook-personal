import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:money_management/app/core/constants/app_urls.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/routes/app_pages.dart';

class AuthController extends GetxController {
  @override
  void onInit() {
    print('AuthController initialized :${token.value}');
    super.onInit();
    loadTokens();
    Future.delayed(const Duration(seconds: 4), () {
      checkSession();
    });
    loadSession();
    print("refresh token is loading:$loadTokens");
  }

  final mobilecontroller = TextEditingController();
  final otp = "".obs;
  final customerId = ''.obs;

// resend otp
  final resendOTP = "".obs;
  // refresh token
  final refreshToken = "".obs;
  final storage = GetStorage();

  final otpcontroller = TextEditingController();
  final token = "".obs;

  // login number

  void login() async {
    final phone = mobilecontroller.text.trim();
    print("Final Phone: '$phone'");

    if (phone.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      Get.snackbar("Error", "Enter a valid 10-digit mobile number",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final url = Uri.parse(AppUrls.phone);
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {'phone': phone};

    print("API URL: $url");
    print("Sending: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          Get.snackbar("Error", "Empty response from server",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
        mobilecontroller.clear();

        final data = jsonDecode(response.body);
        otp.value = data["data"]['OTP'] ?? "";

        customerId.value =
            data['data']['id'] ?? ''; // Get customerId from response

        print("Parsed Data: $data");
        print(otp);
        print("CusID:$customerId");

        if (data['status'] == "Success") {
          Get.snackbar(
            "OTP:$otp",
            data["message"] ?? "OTP sent successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.tealColor,
            colorText: AppColors.whiteColor,
            duration: const Duration(seconds: 10),
          );
          Get.toNamed(Routes.OTPVERIFY);
        } else {
          Get.snackbar("Error", data["message"] ?? "Something went wrong!",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar("Server Error", "Unexpected error: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Failed to connect. Please try again later.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

// login otp

// ✅ OTP Verification Method

  void verifyOtp() async {
    String otp = otpcontroller.text.trim();
    if (otp.isEmpty || customerId.value.isEmpty) {
      Get.snackbar("Error", "OTP or Customer ID is missing.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      // Make API call
      final response = await http.post(
        Uri.parse(AppUrls.verifyotp),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: ({
          'customerId':
              customerId.value.toString(), // Ensure it's passed as String
          'otp': otp,
        }),
      );

      print("OTP: $otp");
      print("CustomerId: ${customerId.value}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for successful token response
        if (data.containsKey('token') && data.containsKey('refresh_token')) {
          token.value = data['token'];
          refreshToken.value = data['refresh_token'];
          String userStatus = data['data']
              ['status']; // Assuming 'status' is part of the response

          otpcontroller.clear();
          saveSession(customerId.value, token.value, refreshToken.value);

          // Navigate based on status
          if (userStatus == "2") {
            Get.offAllNamed(Routes.HOME); // Go to Home if status == 2
          } else if (userStatus == "1") {
            Get.offAllNamed(Routes.PROFILE); // Go to Profile if status == 1
          } else {
            Get.snackbar("Error", "Unknown status. Please contact support.",
                snackPosition: SnackPosition.BOTTOM);
          }

          Get.snackbar("Success", "Verified Successfully.",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar("Error", "Something went wrong. Please try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to verify OTP. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

// resend otp

  void resendotp() async {
    final url = Uri.parse(AppUrls.resendotp);
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {'customerId': customerId.value.toString()};

    print("API URL: $url");
    print("Sending: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          Get.snackbar("Error", "Empty response from server",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        final data = jsonDecode(response.body);
        resendOTP.value = data["data"]['OTP'] ?? "";

        customerId.value =
            data['data']['id'] ?? ''; // Get customerId from response

        print("Parsed Data: $data");
        print(resendOTP);
        print("CusID:$customerId");

        if (data['status'] == "Success") {
          Get.snackbar("Resend-OTP:$resendOTP",
              data["message"] ?? "OTP sent successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.tealColor,
              colorText: AppColors.whiteColor,
              duration: const Duration(seconds: 15));
          Get.toNamed(Routes.OTPVERIFY);
        } else {
          Get.snackbar("Error", data["message"] ?? "Something went wrong!",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar("Server Error", "Unexpected error: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Failed to connect. Please try again later.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  //  Load tokens from storage
  void loadTokens() {
    token.value = storage.read("token") ?? "";
    refreshToken.value = storage.read("refreshToken") ?? "";
    customerId.value = storage.read("customerId") ?? "";
  }

  // Save tokens
  void saveTokens(String newToken, String newRefreshToken, String id) {
    storage.write("token", newToken);
    storage.write("refreshToken", newRefreshToken);
    storage.write("customerId", id);

    print("Tokens Saved:");
    print("Token: ${storage.read('token')}");
    print(" Refresh Token: ${storage.read('refreshToken')}");
    print(" Customer ID: ${storage.read('customerId')}");
  }

  //  Refresh token
  Future<bool> refreshAuthToken() async {
    if (refreshToken.value.isEmpty) {
      print('🚫 No refresh token found. Cannot refresh.');
      return false;
    }

    print(' Attempting to refresh token...');
    try {
      final response = await http.post(
        Uri.parse(AppUrls.refresfToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"refreshToken": refreshToken.value}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['accessToken'] != null && data['refreshToken'] != null) {
          saveTokens(
              data['accessToken'], data['refreshToken'], customerId.value);
          print(' Token refreshed successfully.');
          return true;
        } else {
          print(' Invalid refresh response. Logging out.');
          logout();
        }
      } else {
        print('Refresh token request failed: ${response.statusCode}');
        logout();
      }
    } catch (e) {
      print(' Refresh token error: $e');
    }

    return false;
  }

//  Save Session
  Future<void> saveSession(String id, String authToken, String refresh) async {
    if (id.isNotEmpty && authToken.isNotEmpty && refresh.isNotEmpty) {
      await storage.write('customerId', id);
      await storage.write('token', authToken);
      await storage.write('refreshToken', refresh);

      // Verify storage
      print(
          "✅ Session Saved: ID=${storage.read('customerId')}, Token=${storage.read('token')}, RefreshToken=${storage.read('refreshToken')}");
    } else {
      Get.snackbar("Error", "Session data is incomplete. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

//  Load Session
  void loadSession() {
    print(" Loading session from storage...");
    print(" Stored Customer ID: ${storage.read('customerId')}");
    print(" Stored Token: ${storage.read('token')}");
    print(" Stored Refresh Token: ${storage.read('refreshToken')}");

    customerId.value = storage.read('customerId') ?? '';
    token.value = storage.read('token') ?? '';
    refreshToken.value = storage.read('refreshToken') ?? '';

    print(" After loading session...");
    print(" Loaded Customer ID: ${customerId.value}");
    print(" Loaded Token: ${token.value}");
    print("Loaded Refresh Token: ${refreshToken.value}");
  }

//  Check Session on App Start
  void checkSession() {
    var savedCustomerId = storage.read('customerId');
    var savedToken = storage.read('token');
    var savedRefreshToken = storage.read('refreshToken');
    var isFirstlaunch = storage.read('firstLaunche') ?? true;

    print(" Checking Session...");
    print(" Saved Customer ID: $savedCustomerId");
    print("Saved Token: $savedToken");
    print("Saved Refresh Token: $savedRefreshToken");

    if (savedCustomerId != null &&
        savedToken != null &&
        savedRefreshToken != null) {
      customerId.value = savedCustomerId;
      token.value = savedToken;
      refreshToken.value = savedRefreshToken;

      if (Get.currentRoute != Routes.HOME) {
        print("🔒 Session found, redirecting to Dashboard...");
        Get.offAllNamed(Routes.HOME);
      }
    } else {
      if (Get.currentRoute != Routes.LOGIN) {
        print("🚫 No session found, redirecting to Login...");
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }

  /// **🔹 Logout & Clear Session**
  void logout() {
    storage.remove('customerId');
    storage.remove('token');
    storage.remove('refreshToken');
    customerId.value = "";
    token.value = "";
    refreshToken.value = "";

    print("Session Cleared! Redirecting to Login...");
    Get.offAllNamed(Routes.LOGIN);
  }

// token expires
  bool isTokenExpired(String token) {
    if (token.isEmpty) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      print('Token parsing error: $e');
      return true;
    }
  }

  Future<http.Response?> makeApiCall(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body, // Updated to dynamic for flexibility
    bool isGet = false,
    bool isPost = false,
    bool isPut = false,
    bool isDelete = false,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) async {
    if (isTokenExpired(token.value)) {
      print('Token expired, attempting to refresh...');
      final refreshed = await refreshAuthToken();
      if (!refreshed) {
        print('Token refresh failed. Redirecting to login.');
        logout();
        return null;
      }
      print('✅ Token refreshed successfully. Proceeding with API call...');
    }

    headers ??= {};
    headers['Authorization'] = 'Bearer ${token.value}';

    try {
      final Uri uri = Uri.parse(url);
      late http.Response response;

      // ✅ Handle MultipartRequest when files are present
      if (files != null && files.isNotEmpty) {
        var request = http.MultipartRequest(
            isPost
                ? 'POST'
                : isPut
                    ? 'PUT'
                    : 'POST',
            uri);
        request.headers.addAll(headers);

        // Add form fields if present
        if (fields != null) {
          request.fields.addAll(fields);
        }

        // Add files to request
        request.files.addAll(files);

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // ✅ Handle regular JSON requests
        headers['Content-Type'] = 'application/json';

        if (isPost) {
          response =
              await http.post(uri, headers: headers, body: jsonEncode(body));
        } else if (isPut) {
          response =
              await http.put(uri, headers: headers, body: jsonEncode(body));
        } else if (isDelete) {
          response = await http.delete(uri, headers: headers);
        } else {
          response = await http.get(uri, headers: headers);
        }
      }

      print('📡 API Response: ${response.statusCode} | ${response.body}');
      return response;
    } catch (e) {
      print('API call error: $e');
      return null;
    }
  }
}
