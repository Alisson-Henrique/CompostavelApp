import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/models/visitation.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisitReposiitory extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;

  VisitReposiitory({required this.auth}) {
    _startRepository();
  }
  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  Stream<QuerySnapshot> getVisitSnapshot(String userEmail) {
    return db.collection("Composteiras/$userEmail/Composteiras").snapshots();
  }

  Stream<QuerySnapshot> seekVisitGetSnapshot() {
    return db
        .collection("Composteiras/${auth.user!.email}/Colaboracoes")
        .snapshots();
  }

  requestParticipation(String composterName, String userEmail) async {
    await db
        .collection(
            "Composteiras/$userEmail/Composteiras/$composterName/Solicitacoes")
        .doc(auth.user!.email)
        .set({
      'email': auth.user!.email,
    });
  }

  Stream<QuerySnapshot> requestListSnapshot(String composterName) {
    return db
        .collection(
            "Composteiras/${auth.user!.email}/Composteiras/$composterName/Solicitacoes")
        .snapshots();
  }

  acceptRequest(String userEmail, String composterName) async {
    await db
        .collection(
            "Composteiras/${auth.user!.email}/Composteiras/$composterName/Solicitacoes")
        .doc(userEmail)
        .delete();

    await db
        .collection(
            "Composteiras/${auth.user!.email}/Composteiras/$composterName/Colaboradores")
        .doc(userEmail)
        .set({
      'email': userEmail,
    });

    await db
        .collection("Composteiras/$userEmail/Colaboracoes")
        .doc(auth.user!.email)
        .set({
      'dono': auth.user!.email,
      'nome_composteira': composterName,
    });
  }

  remove(String userEmail, String composterName) async {
    await db
        .collection(
            "Composteiras/${auth.user!.email}/Composteiras/$composterName/Solicitacoes")
        .doc(userEmail)
        .delete();
  }

  removeContributor(String userEmail, String composterName) async {
    await db
        .collection(
            "Composteiras/${auth.user!.email}/Composteiras/$composterName/Colaboradores")
        .doc(userEmail)
        .delete();
  }

  Stream<QuerySnapshot> getContributorsSnapshot(String composterName) {
    return db
        .collection(
            "Composteiras/${auth.user!.email}/Composteiras/$composterName/Colaboradores")
        .snapshots();
  }

  save(String composterName, Visitation? visitation, String userEmail) async {
    DocumentSnapshot composterStream = await db
        .collection('Composteiras/$userEmail/Composteiras')
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
      id = composter.visitationIdLastUpdate!;
      id = id + 1;
    }

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(now);

    await db
        .collection(
            'Composteiras/${userEmail}/Composteiras/${composter.name}/Visitas')
        .doc(id.toString())
        .set({
      'responsável': auth.user!.email,
      'temperatura': visitation.temperature,
      'ph': visitation.ph,
      'umidade': visitation.moisture,
      'data': formatted,
      'observações': visitation.note,
      'estado_composteira': visitation.composterState,
      'id': id,
    });
    await db
        .collection('Composteiras/${userEmail}/Composteiras')
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
  }
}
