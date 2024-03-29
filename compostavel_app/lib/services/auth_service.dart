import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/Badge.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late FirebaseFirestore db;

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
            .collection("Usuarios/${email}/Dados")
            .doc("Conta")
            .set(
          {
            'email': email,
            'name': userData.name,
            'quantidade_doacao': 0,
            'quantidade_composteira': 0,
            'quantidade_composto': 0,
            'quantidade_visita': 0,
            'quantidade_colaboracoes': 0,
          },
        );
        _getUser();
      } else {
        throw AuthException("Senhas diferentes.");
      }
    } on FirebaseAuthException catch (exception) {
      print(exception.code);
      if (exception.code == 'weak-password') {
        throw AuthException("Senha Fraca.");
      } else if (exception.code == 'email-already-in-use') {
        throw AuthException("Email já cadastrado.");
      } else if (exception.code == 'invalid-email') {
        throw AuthException("Email Inválido.");
      }
    }
  }

  login(String email, String password) async {
    try {
      if (email == "" || password == "") {
        throw AuthException("Campos Obrigatórios.");
      }
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

  recoverPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
