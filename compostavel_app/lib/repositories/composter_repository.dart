import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

class ComposterRepository extends ChangeNotifier {
  List<Composter> _composters = [
    /*
    Composter(
        name: "Composteira IFPB - 01",
        startDate: "20/09/2020",
        andress: new Andress(),
        composterState: Composter_State.ATIVA),
    Composter(
        name: "Composteira IFPB - 02",
        startDate: "05/02/2021",
        andress: new Andress(),
        composterState: Composter_State.DESATIVADA),
    Composter(
        name: "Composteira IFPB - 03",
        startDate: "07/05/2021",
        andress: new Andress(),
        composterState: Composter_State.DESATIVADA)
        */
  ];

  late FirebaseFirestore db;
  late AuthService auth;

  ComposterRepository({required this.auth}) {
    _startRepository();
  }

  List<Composter> getComposters() {
    return _composters;
  }

  Future<void> getCompostersfromFireBase() async {
    CollectionReference composters =
        db.collection("composters/${auth.user!.uid}/data");
    DocumentSnapshot snapshot = await composters.doc().get();
    Map<String, dynamic> data = snapshot.data();

    Composter composter = Composter.fromJson(data);
    _composters.add(composter);
    notifyListeners();
  }

  _startRepository() async {
    await _startFirestore();
    readComposters();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  readComposters() async {
    if (auth.user != null && _composters.isEmpty) {
      final snapshot = await db
          .collection('Composteiras/${auth.user!.email}/Composteiras')
          .get();

      _composters = snapshot.docs
          .map((doc) => Composter(
                name: doc["nome"],
                startDate: doc["data_inicio"],
              ))
          .toList();

      notifyListeners();
    }
  }

  save(Composter composter) async {
    await db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .doc(composter.name)
        .set({
      'nome': composter.name,
      'data_inicio': composter.startDate,
    });
    _composters.clear();
    notifyListeners();
  }

  Future<Stream<QuerySnapshot>> getAll() async {
    var collection = db.collection("composters/${auth.user!.email}/data");
    return collection.snapshots();
  }

  remove(Composter composter) async {
    await db
        .collection("Composteiras/${auth.user!.email}/Composteiras")
        .doc(composter.name)
        .delete();
    _composters.remove(composter);
    notifyListeners();
  }
}
