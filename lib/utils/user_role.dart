import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}
