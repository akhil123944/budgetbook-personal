import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management/app/core/themes/app_colors.dart';
import 'package:money_management/app/core/themes/app_textstyles.dart';
import 'package:money_management/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.getINCOME();
    controller.customerDETAILS();
    controller.fetchPersonalFinance();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.tealColor,
        toolbarHeight: 10,
      ),
      drawer: Obx(() {
        return Drawer(
          backgroundColor: AppColors.backgroundColor,
          child: controller.customerDetails.isEmpty
              ? const Center(
                  child:
                      CircularProgressIndicator()) // ✅ Show loader while fetching
              : Column(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: controller.customerDetails.map((customer) {
                            String baseUrl =
                                "https://s2swebsolutions.in/budgetbook/";
                            String imageUrl = customer['profileImg'] != null &&
                                    customer['profileImg'].isNotEmpty
                                ? baseUrl + customer['profileImg']
                                : '';

                            return UserAccountsDrawerHeader(
                              decoration: BoxDecoration(
                                color: AppColors.tealColor,
                              ),
                              accountName: Text(
                                customer['name'] ?? 'Guest',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              accountEmail: Text(
                                customer['email'] ?? 'No Email',
                                style: const TextStyle(fontSize: 14),
                              ),
                              currentAccountPicture: GestureDetector(
                                onTap: () {
                                  print(
                                      "Profile Image URL: ${customer['profileImg']}");
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: customer['profileImg'] !=
                                              null &&
                                          customer['profileImg'].isNotEmpty
                                      ? NetworkImage(imageUrl) as ImageProvider
                                      : const AssetImage('assets/man.png'),
                                  onBackgroundImageError: (_, __) {
                                    print(
                                        "Error loading profile image, showing default");
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Positioned(
                          left: 50,
                          bottom: 68,
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo,
                                color: AppColors.backgroundColor),
                            onPressed: () {
                              controller.pickImage();
                            },
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.customerDetails.length,
                        itemBuilder: (context, index) {
                          var customer = controller.customerDetails[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.person,
                                    color: Colors.blue),
                                title: Text(customer['name'] ?? 'Unknown'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone,
                                    color: Colors.green),
                                title: Text(customer['phone'] ?? 'No Phone'),
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.email, color: Colors.red),
                                title: Text(customer['email'] ?? 'No Email'),
                              ),
                              const Divider(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Get.toNamed(Routes.EDITPROFILE);
                                    },
                                    label: const Text(
                                      'Update Profile',
                                      style: TextStyle(
                                          color: AppColors.incomeColor),
                                    ),
                                    icon: const Icon(
                                      Icons.edit_attributes,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.black),
                      title: const Text("Logout"),
                      onTap: () {
                        controller.logoutcustomer();
                      },
                    ),
                  ],
                ),
        );
      }),
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double heightFactor = constraints.maxHeight / 812;
          double widthFactor = constraints.maxWidth / 375;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  child: Container(
                    height: 220 * heightFactor,
                    width: double.infinity,
                    color: AppColors.tealColor,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0 * heightFactor),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0 * heightFactor,
                                    horizontal: 18.0 * widthFactor,
                                  ),
                                  child: InkWell(onTap: () {
                                    scaffoldKey.currentState?.openDrawer();
                                  }, child: Obx(
                                    () {
                                      return CircleAvatar(
                                        radius: 25.0 * widthFactor,
                                        backgroundImage: controller
                                                    .customerDetails
                                                    .isNotEmpty &&
                                                controller.customerDetails[0]
                                                        ['profileImg'] !=
                                                    null &&
                                                controller.customerDetails[0]
                                                        ['profileImg']
                                                    .toString()
                                                    .isNotEmpty
                                            ? NetworkImage(
                                                    "https://s2swebsolutions.in/budgetbook/${controller.customerDetails[0]['profileImg']}")
                                                as ImageProvider
                                            : const AssetImage(
                                                'assets/man.png'), // Default image if `profileImg` is null or empty
                                        onBackgroundImageError: (_, __) {
                                          print(
                                              "Error loading profile image, showing default");
                                        },
                                      );
                                    },
                                  )),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Available Balance',
                                        style: AppTextStyles.availableBalance),
                                    Obx(
                                      () => Text(
                                        '${controller.totalIncome.value}',
                                        style: TextStyle(
                                            color: AppColors.backgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16 * widthFactor),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 14 * heightFactor),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0 * widthFactor),
                              child: Obx(
                                () => Row(
                                  // ✅ Row directly inside Obx
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 100 * heightFactor,
                                      width: 150 * widthFactor,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12 * widthFactor),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 40 * heightFactor,
                                            width: 40 * widthFactor,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                'assets/chart-up.png',
                                                height: 35 * heightFactor,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4 * heightFactor),
                                          Text(
                                            '₹${controller.totalIncome.value.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18 * widthFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 100 * heightFactor,
                                      width: 150 * widthFactor,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12 * widthFactor),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 40 * heightFactor,
                                            width: 40 * widthFactor,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                'assets/chart-down.png',
                                                height: 35 * heightFactor,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4 * heightFactor),
                                          Text(
                                            '₹${controller.totalExpense.value}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 18 * widthFactor,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20 * heightFactor),
                _buildTabs(context, heightFactor, widthFactor),
                SizedBox(height: 20 * heightFactor),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22 * widthFactor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Recent Records",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20 * heightFactor,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealColor,
                        ),
                      ),
                      Image.asset(
                        'assets/history.png',
                        height: 23 * heightFactor,
                        width: 23 * widthFactor,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8 * heightFactor),
                Expanded(
                  child: Obx(() {
                    return SizedBox(
                      height: constraints.maxHeight * 0.7,
                      child: controller.isLoading
                              .value // ✅ Show shimmer while fetching data
                          ? ListView.builder(
                              itemCount: 6, // Number of shimmer items
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    height: 80, // Shimmer item height
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                );
                              },
                            )
                          : controller.getallDATAINCOME
                                  .isEmpty // ✅ Show animation if no data
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/No-Data-Animation.json',
                                        height: 120 * heightFactor,
                                        width: 120 * widthFactor,
                                      ),
                                      const Text(
                                        'No Data Available',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 30.0 * heightFactor),
                                    ],
                                  ),
                                )
                              : _buildRecentlyAddedList(
                                  heightFactor, widthFactor), // ✅ Show data
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(
      BuildContext context, double heightFactor, double widthFactor) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: 14 * widthFactor),
        padding: EdgeInsets.all(4 * heightFactor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTabButton('Personal', 0, heightFactor, widthFactor),
            // _buildTabButton('Business', 1, heightFactor, widthFactor),
            // _buildTabButton('Loans', 2, heightFactor, widthFactor),
            // _buildTabButton('Fixed Deposit', 3, heightFactor, widthFactor),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(
      String label, int index, double heightFactor, double widthFactor) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          switch (index) {
            case 0:
              Get.toNamed(Routes.PERSONAL);
              break;
            case 1:
              Get.toNamed(Routes.BUSINESS);
              break;
            case 2:
              Get.toNamed(Routes.LOANS);
              break;
            case 3:
              Get.toNamed(Routes.FIXED_DEPOSIT);
              break;
            default:
              Get.toNamed(Routes.HOME);
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2 * widthFactor),
          padding: EdgeInsets.symmetric(vertical: 12 * heightFactor),
          decoration: BoxDecoration(
            gradient: controller.getallDATAINCOME.length > index
                ? LinearGradient(
                    colors: [
                      AppColors.tealColor,
                      AppColors.tealColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: controller.getallDATAINCOME.length > index
                ? null
                : Colors.grey.shade200,
            border: Border.all(
              color: controller.getallDATAINCOME.length > index
                  ? Colors.transparent
                  : AppColors.tealColor.withOpacity(0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: controller.getallDATAINCOME.length > index
                ? [
                    BoxShadow(
                      color: AppColors.tealColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * heightFactor,
                fontWeight: FontWeight.w500,
                color: controller.getallDATAINCOME.length > index
                    ? Colors.white
                    : AppColors.primaryTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentlyAddedList(double heightFactor, double widthFactor) {
    return Obx(() {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: controller.getallDATAINCOME.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: 10 * widthFactor, vertical: 8 * heightFactor),
          itemBuilder: (context, index) {
            final item = controller.getallDATAINCOME[index];

            Color categoryColor;
            switch (item['categoryType']) {
              case 'Income':
                categoryColor = Colors.green;
                break;
              case 'Expense':
                categoryColor = Colors.red;
                break;
              case 'Savings':
                categoryColor = Colors.blue;
                break;
              case 'Loans':
                categoryColor = Colors.purple;
                break;
              default:
                categoryColor = Colors.grey;
            }
            // Construct the full image URL
            String baseUrl =
                "https://s2swebsolutions.in/budgetbook/"; // Replace with actual base URL
            String imageUrl =
                item['categoryImg'] != null && item['categoryImg'].isNotEmpty
                    ? baseUrl + item['categoryImg'].toString()
                    : '';
            return GestureDetector(
              onTap: () {
                // Action on tap
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10 * heightFactor),
                padding: EdgeInsets.all(12 * widthFactor),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20 * widthFactor,
                      backgroundColor: categoryColor.withOpacity(0.2),
                      child: imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(20 * widthFactor),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 40 * widthFactor,
                                height: 40 * widthFactor,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const CircularProgressIndicator(
                                      strokeWidth: 2);
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/loan.png',
                                    width: 100 * widthFactor,
                                    height: 100 * heightFactor,
                                  );
                                },
                              ),
                            )
                          : const Icon(Icons.image,
                              color: Colors.grey, size: 24), // Placeholder icon
                    ),
                    SizedBox(width: 12 * widthFactor),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\₹ ${item['amount'].toString()}',
                            style: TextStyle(
                              fontSize: 16 * heightFactor,
                              fontWeight: FontWeight.w700,
                              color: categoryColor,
                            ),
                          ),
                          Text(
                            item['description'],
                            style: TextStyle(
                              fontSize: 13 * heightFactor,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4 * heightFactor),
                          Text(
                            item['incomeDate'] ?? "No date available",
                            style: TextStyle(
                              fontSize: 12 * heightFactor,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10 * widthFactor),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.PERSONAL_EDIT,
                          arguments: {'id': item['id'].toString()},
                        );
                        print('Edit selected ID: ${item['id']}');
                      },
                      icon: Icon(Icons.edit,
                          color: AppColors.tealColor, size: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Confirm Deletion",
                          titleStyle:
                              const TextStyle(color: AppColors.expenseColor),
                          middleText:
                              "Are you sure you want to delete this income?",
                          textConfirm: "Yes",
                          cancelTextColor: AppColors.tealColor,
                          textCancel: "No",
                          confirmTextColor: AppColors.expenseColor,
                          buttonColor: AppColors.backgroundColor,
                          onConfirm: () {
                            controller.deleteIncome(item['id'].toString());
                            Get.back();
                          },
                        );
                      },
                      icon: Icon(Icons.delete_forever,
                          color: AppColors.expenseColor,
                          size: 20 * heightFactor),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
