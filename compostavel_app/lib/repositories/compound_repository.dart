import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/compound.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class CompoundRepositoy extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;

  CompoundRepositoy({required this.auth}) {
    _startRepository();
  }
  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  save(Compound compound) async {
    await db
        .collection("Compostos/${auth.user!.email}/Compostos")
        .doc(compound.name)
        .set({
      'nome': compound.name,
      'data_coleta': compound.collenctionDate,
      'peso': compound.weight,
    });

    DocumentSnapshot snapshot = await db
        .collection("Usuarios/${auth.user!.email}/Dados")
        .doc("Conta")
        .get();

    Map<String, dynamic> data = snapshot.data();

    await db
        .collection("Usuarios/${auth.user!.email}/Dados")
        .doc("Conta")
        .update({'quantidade_composto': data['quantidade_composto'] + 1});
  }

  remove(String compoundName) async {
    await db
        .collection("Compostos/${auth.user!.email}/Compostos")
        .doc(compoundName)
        .delete();
  }

  Stream<QuerySnapshot> getSnapshots() {
    return db
        .collection('Compostos/${auth.user!.email}/Compostos')
        .orderBy("nome", descending: true)
        .snapshots();
  }
}
