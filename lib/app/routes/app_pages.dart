import 'package:get/get.dart';
import 'package:money_management/app/modules/home/views/edit_profile.dart';
import 'package:money_management/app/modules/personal/views/expense_data.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login.dart';
import '../modules/auth/views/otp.dart';
import '../modules/business/bindings/business_binding.dart';
import '../modules/business/views/business_view.dart';
import '../modules/fixed_deposit/bindings/fixed_deposit_binding.dart';
import '../modules/fixed_deposit/views/fixed_deposit_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/add_entry_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loans/bindings/loans_binding.dart';
import '../modules/loans/views/loans_view.dart';
import '../modules/onboard/bindings/onboard_binding.dart';
import '../modules/onboard/views/intro_screen1.dart';
import '../modules/onboard/views/intro_screen2.dart';
import '../modules/onboard/views/intro_screen3.dart';
import '../modules/onboard/views/onboard_view.dart';
import '../modules/personal/bindings/personal_binding.dart';
import '../modules/personal/views/add_category.dart';
import '../modules/personal/views/income_data.dart';
import '../modules/personal/views/personal_view.dart';
import '../modules/personal_edit/bindings/personal_edit_binding.dart';
import '../modules/personal_edit/views/personal_edit_view.dart';
import '../modules/pie_charts/bindings/pie_charts_binding.dart';
import '../modules/pie_charts/views/pie_charts_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ENTRY,
      page: () => AddEntryView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.EDITPROFILE,
      page: () => EditProfile(),
      binding: HomeBinding(),
    ),

    //  personal start

    GetPage(
      name: _Paths.PERSONAL,
      page: () => const PersonalView(),
      binding: PersonalBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => Category(),
      binding: PersonalBinding(),
    ),
    GetPage(
      name: _Paths.PERSONALDATAGETINCOME,
      page: () => Incomedata(),
      binding: PersonalBinding(),
    ),
    GetPage(
      name: _Paths.PERSONALDATAGETIEXPENSE,
      page: () => Expensedata(),
      binding: PersonalBinding(),
    ),

    // personal end

    // bussinesss start
    GetPage(
      name: _Paths.BUSINESS,
      page: () => BusinessView(),
      binding: BusinessBinding(),
    ),

// bussinesss end

// loan start

    GetPage(
      name: _Paths.LOANS,
      page: () => LoansView(),
      binding: LoansBinding(),
    ),

// loan start

    GetPage(
      name: _Paths.ONBOARD,
      page: () => OnboardView(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_1,
      page: () => IntroScreen1(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_2,
      page: () => IntroScreen2(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_3,
      page: () => IntroScreen3(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: _Paths.PIE_CHARTS,
      page: () => PieChartsView(),
      binding: PieChartsBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.OTPVERIFY,
      page: () => Otp(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FIXED_DEPOSIT,
      page: () => FixedDepositView(),
      binding: FixedDepositBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashscreenView(),
      binding: SplashScreenBinding(),
    ),

    GetPage(
      name: _Paths.PERSONAL_EDIT,
      page: () => const PersonalEditView(),
      binding: PersonalEditBinding(),
    ),
  ];
}
