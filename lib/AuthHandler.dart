import 'package:college_minor_project_frontend/screens/HomeScreen.dart';
import 'package:college_minor_project_frontend/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler {

  handleAuth() {
    if (FirebaseAuth.instance.currentUser == null) {
      // Navigate to login screen
      return LoginScreen();
    } else {
      // Navigate to home screen
      return HomeScreen();
    }
  }

}
