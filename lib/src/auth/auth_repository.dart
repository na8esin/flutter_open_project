import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
