import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

class UserDataRepository extends ChangeNotifier {
  UserData? userDate;

  var change = true;

  late FirebaseFirestore db;
  late AuthService auth;

  UserDataRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFireStore();
  }

  _startFireStore() {
    db = DBFirestore.get();
  }

  UserData? getUserdata() {
    return userDate;
  }

  read() async {
    if (change) {
      DocumentSnapshot userProgressSnapshot = await db
          .collection('Usuarios/${auth.user!.email}/Dados')
          .doc('Conta')
          .get();

      Map<String, dynamic> data = userProgressSnapshot.data();

      userDate = UserData(
        name: data['name'],
        donateAmount: data['quantidade_doacao'],
        composterAmount: data['quantidade_composteira'],
        collaborationAmount: data['quantidade_colaboracoes'],
        compoundAmount: data['quantidade_composto'],
        visitAmount: data['quantidade_visita'],
      );
      change = false;
      notifyListeners();
    }
  }

  recoverPassword(String email) {
    auth.recoverPassword(email);
  }
}
