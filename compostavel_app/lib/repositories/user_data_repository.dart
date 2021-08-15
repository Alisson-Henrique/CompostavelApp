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
  }

  Future<Type_User> getUserDataType() async {
    Type_User type_user = Type_User.DONOR;

    final docc = await FirebaseFirestore.instance
        .collection("users/${auth.user!.uid}/dados")
        .get();

    final userData = docc.docs.forEach((doc) {
      if (doc.get("name") == "Diego") {
        if (doc.get("typeUser") == "Type_User.PRODUCER") {
          type_user = Type_User.PRODUCER;
        }
      }
    });
    return type_user;
  }

  _startFireStore() {
    db = DBFirestore.get();
  }
}
