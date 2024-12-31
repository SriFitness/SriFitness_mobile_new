import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferenceHelper {
  // Existing user keys
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPasswordKey = "USERPASSWORDKEY";
  static String userWalletKey = "USERWALLETKEY";
  static String userProfileKey = "USERPROFILEKEY";

  // Form related keys
  static String personalDetailsKey = "PERSONAL_DETAILS_KEY";
  static String medicalInquiry1Key = "MEDICAL_INQUIRY_1_KEY";
  static String medicalInquiry2Key = "MEDICAL_INQUIRY_2_KEY";
  static String medicalInquiry3Key = "MEDICAL_INQUIRY_3_KEY";
  static String formProgressKey = "FORM_PROGRESS_KEY";

  // Existing user methods
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserPassword(String getUserPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPasswordKey, getUserPassword);
  }

  Future<bool> saveUserWallet(String getUserWallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userWalletKey, getUserWallet);
  }

  Future<bool> saveUserProfile(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPasswordKey);
  }

  Future<String?> getUserWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userWalletKey);
  }

  Future<String?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }

  // New form data methods
  Future<bool> saveFormData(String key, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getFormData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(key);
    return jsonData != null ? jsonDecode(jsonData) : null;
  }

  // Form progress methods
  Future<bool> saveFormProgress(int progress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(formProgressKey, progress);
  }

  Future<int> getFormProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(formProgressKey) ?? 0;
  }

  // Clear methods
  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(userNameKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userPasswordKey);
    await prefs.remove(userWalletKey);
    await prefs.remove(userProfileKey);
  }

  Future<void> clearFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(personalDetailsKey);
    await prefs.remove(medicalInquiry1Key);
    await prefs.remove(medicalInquiry2Key);
    await prefs.remove(medicalInquiry3Key);
    await prefs.remove(formProgressKey);
  }

  Future<void> clearAllData() async {
    await clearUserData();
    await clearFormData();
  }
}