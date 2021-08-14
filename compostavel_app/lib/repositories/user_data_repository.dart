import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserDataRepository extends ChangeNotifier {
  UserData? userDate;

  late FirebaseFirestore db;
  late AuthService auth;

  UserDataRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFireStore();
    await _readUserData();
  }

  _readUserData() async {
    if (auth.user != null && userDate == null) {
      final snapshot = await db.collection("user/${auth.user!.uid}/").get();
    }
  }

  _save(UserData userData) async {
    await db
        .collection("user/${auth.user!.uid}/")
        .doc()
        .set({'nome': userDate!.name});
    notifyListeners();
  }

  _startFireStore() {
    db = DBFirestore.get();
  }
}
