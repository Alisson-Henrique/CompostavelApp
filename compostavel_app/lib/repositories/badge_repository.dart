import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class BadgeRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;

  BadgeRepository({required this.auth}) {
    _startRepository();
  }
  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  getBadgesSnapShot(String userType) {
    return db.collection("Badge/$userType/Badges").snapshots();
  }
}
