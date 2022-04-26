import 'package:college_minor_project_frontend/constants/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {

  void saveEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(Constants.email, email);
  }

  Future<String> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = preferences.getString(Constants.email);
    return email == null ? Constants.emptyString : email;
  }

  void clearAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

}
