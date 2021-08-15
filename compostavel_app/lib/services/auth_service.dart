import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/user_data.dart';
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

  register(String email, String password, String confirmPassword,
      UserData userData) async {
    try {
      if (password == confirmPassword) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        _getUser();
        await FirebaseFirestore.instance
            .collection("users/${user!.uid}/dados")
            .doc(user!.email)
            .set(
          {
            'name': userData.name,
          },
        );
        _getUser();
      } else {
        throw AuthException("Senhas diferentes.");
      }
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
      } else if (exception.code == 'invalid-email') {
        throw AuthException("Email Invalido.");
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
