import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/modules/auth/controllers/auth_controller.dart';
import 'package:money_management/app/modules/personal/controllers/personal_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Get.put(AuthController());
  Get.put(PersonalController());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: AppColors.tealColor)),
    ),
  );
}
