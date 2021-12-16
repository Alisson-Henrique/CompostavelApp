import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class TutorialRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;

  TutorialRepository({required this.auth}) {
    _startRepository();
  }
  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  getTutorialSnapShot() {
    return db.collection("Tutorial").snapshots();
  }
}
