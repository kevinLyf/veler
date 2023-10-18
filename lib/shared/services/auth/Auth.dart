import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<void> setId(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("id", id);
  }

  static Future<void> setName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("name", name);
  }

  static Future<void> setEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("email", email);
  }

  static Future<void> setPassword(String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("password", password);
  }

  static Future<void> setAdmin(bool admin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("admin", admin);
  }

  static Future<String> getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("id") ?? "";
  }

  static Future<String> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("name") ?? "";
  }

  static Future<String> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("email") ?? "";
  }

  static Future<String> getPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("password") ?? "";
  }

  static Future<bool> getAdmin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("admin") ?? false;
  }
}