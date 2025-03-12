import 'package:get/get.dart';

class BusinessController extends GetxController {
  // Observable list for recently added items
  var recentlyAdded = <Map<String, dynamic>>[].obs;

  // Method to add a new item
  void addNewItem(Map<String, dynamic> item) {
    recentlyAdded.insert(0, item); // Add the new item at the top
  }

  // Summary data
  var totalIncome = 0.0.obs;
  var totalExpenses = 0.0.obs;
  var totalSavings = 0.0.obs;
  var totalLoans = 0.0.obs;
  var availableBalance = 1000.0.obs;

  // Tabs
  var selectedTab = 0.obs; // 0 = Personal, 1 = Business

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    // Mock data loading
    totalIncome.value = 1500.0;
    totalExpenses.value = 500.0;
    totalSavings.value = totalIncome.value - totalExpenses.value;
  }

  // Define the method to view transaction details
  void viewTransactionDetails(int index) {
    var transaction = recentlyAdded[index];
    // You can handle navigation or showing the details here
    // Example: You can show a dialog, navigate to another screen, etc.
    print("Viewing transaction: ${transaction['title']} with amount: ${transaction['amount']}");
  }
}
