import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/models/visitation.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisitationRepository extends ChangeNotifier {
  List<Visitation> _visitations = [];
  var change = true;
  late FirebaseFirestore db;
  late AuthService auth;

  VisitationRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  List<Visitation> getVisitations() {
    return _visitations;
  }

  readVisitations(String composterName) async {
    if (auth.user != null && _visitations.isEmpty && change == true) {
      final snapshot = await db
          .collection(
              'Composteiras/${auth.user!.email}/Composteiras/${composterName}/Visitas')
          .get();

      _visitations = snapshot.docs
          .map((doc) => Visitation(
                id: doc["id"],
                name: doc["responsável"],
                temperature: doc["temperatura"],
                ph: doc["ph"],
                moisture: doc["umidade"],
                date: doc["data"],
                note: doc["observações"],
              ))
          .toList();
      change = false;
      notifyListeners();
    }
  }

  save(String composterName, Visitation? visitation) async {
    DocumentSnapshot composterStream = await db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .doc('$composterName')
        .get();

    Map<String, dynamic> data = composterStream.data();

    var composter = Composter(
        name: data["nome"],
        startDate: data["data_inicio"],
        temperature: data["temperatura"],
        ph: data["ph"],
        moisture: data["umidade"],
        lastDateUpdate: data["última_atualização"],
        note: data["observações"],
        visitationIdLastUpdate: data["id_última_atualização"],
        composterState: data["estado_composteira"]);

    var id = visitation!.id;
    if (id == 0) {
      var id = composter.visitationIdLastUpdate;
      id = id! + 1;
    }

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(now);

    await db
        .collection(
            'Composteiras/${auth.user!.email}/Composteiras/${composter.name}/Visitas')
        .doc(id.toString())
        .set({
      'responsável': auth.user!.email,
      'temperatura': visitation!.temperature,
      'ph': visitation.ph,
      'umidade': visitation.moisture,
      'data': formatted,
      'observações': visitation.note,
      'estado_composteira': visitation.composterState,
      'id': id,
    });
    await db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .doc(composter.name)
        .set({
      'data_inicio': composter.startDate,
      'nome': composter.name,
      'temperatura': visitation.temperature,
      'ph': visitation.ph,
      'umidade': visitation.moisture,
      'última_atualização': formatted,
      'observações': visitation.note,
      'estado_composteira': visitation.composterState,
      'id_última_atualização': id,
    });
    _visitations.clear();
    change = true;
    notifyListeners();
  }

  remove(String composter, Visitation visitation) async {
    await db
        .collection(
            "Composteiras/${auth.user!.email}/Composteiras/${composter}/Visitas")
        .doc(visitation.name)
        .delete();
    _visitations.remove(visitation);
    change = true;
    notifyListeners();
  }

  Stream<QuerySnapshot> getSnapshots(String composterName) {
    return db
        .collection(
            'Composteiras/${auth.user!.email}/Composteiras/$composterName/Visitas')
        .orderBy("id", descending: true)
        .snapshots();
  }
}
