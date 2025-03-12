class AppUrls {
  static const baseurl = "https://s2swebsolutions.in/budgetbook/api/";
  static const phone = "$baseurl/customers";
  static const verifyotp = "$baseurl/verify";
  static const refresfToken = "$baseurl/refresh"; // not usedtoken
  static const customerprofile = "$baseurl/profileInfo";
  static const resendotp = "$baseurl/resend";
  static const incomepost = "$baseurl/income";
  static const expensivepost = "$baseurl/expense";
  static const allINCOME = "$baseurl/income";
  static const indivisualINCOME = "$baseurl/income";
  // Example to generate a specific property details URL dynamically
  static String getindivisualincome(int id) {
    return "$indivisualINCOME/$id";
  }

  static const updateINCOME = "$baseurl/income";
  static String updateINCOMEID(int id) {
    return "$updateINCOME/$id";
  }

  static const deleteINCOME = "$baseurl/income";
  static String deleteINCOMEID(int id) {
    return "$deleteINCOME/$id";
  }

  static const allexpense = "$baseurl/expense";
  static const indivisualexpense = "$baseurl/expense";
  static const updateEXPANSE = "$baseurl/expense";
  static String updateEXPENSEID(int id) {
    return "$updateEXPANSE/$id";
  }

  static const deleteEXPANSE = "$baseurl/expense";
  static String deleteEXPENSEID(int id) {
    return "$deleteEXPANSE/$id";
  }

  // static String postIncome;
  // Example to generate a specific property details URL dynamically
  static String getindivisualexpense(int id) {
    return "$indivisualexpense/$id";
  }

  static const personalincomeandexpense = "$baseurl/personal";
  static const customerdetails = "$baseurl/customers";
  static const profileImgupdate = "$baseurl/profileImg";
  static const logout = "$baseurl/logout";
  static const categoriesGET = "$baseurl/categories";
  static const categoriesPOST = "$baseurl/categories";
  static const recentadded = '$baseurl/recent';
  static String getImageUrl(String path) {
    return 'https://s2swebsolutions.in/budgetbook/api/$path';
  }
}
