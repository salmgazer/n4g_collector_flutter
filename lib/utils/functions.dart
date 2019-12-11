import 'package:shared_preferences/shared_preferences.dart';

getLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final language = prefs.getString('language');
  if (language == null) {
    await prefs.setString('language', language);
  }
  return language;
}
