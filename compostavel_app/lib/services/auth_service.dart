import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  bool isLoading = true;

  AuthService() {
    _authCheck();
  }
  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      user = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'weak-password') {
        throw AuthException("Senha Fraca.");
      } else if (exception.code == 'email-already-in-use') {
        throw AuthException("Email já cadastrado.");
      }
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'user-not-found') {
        throw AuthException("Usuário não cadastrado.");
      } else if (exception.code == 'wrong-password') {
        throw AuthException("Senha incorreta. Tente novamente.");
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}