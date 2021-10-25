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

  var change = true;

  ComposterRepository({required this.auth}) {
    _startRepository();
  }

  List<Composter> getComposters() {
    return _composters;
  }

  Future<Composter> getComposter(String composterName) async {
    DocumentSnapshot composterStream = await db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .doc('$composterName')
        .get();

    Map<String, dynamic> data =
        composterStream.data(); //data!.data() as Map<String, dynamic>;
    return Composter(
      name: data["nome"],
      startDate: data["data_inicio"],
      temperature: data["temperatura"],
      ph: data["ph"],
      moisture: data["umidade"],
      lastDateUpdate: data["última_atualização"],
      note: data["observações"],
      visitationIdLastUpdate: data["id_última_atualização"],
    );
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
    if (auth.user != null && _composters.isEmpty && change == true) {
      final snapshot = await db
          .collection('Composteiras/${auth.user!.email}/Composteiras')
          .get();

      _composters = snapshot.docs
          .map((doc) => Composter(
                name: doc["nome"],
                startDate: doc["data_inicio"],
                temperature: doc["temperatura"],
                ph: doc["ph"],
                moisture: doc["umidade"],
                lastDateUpdate: doc["última_atualização"],
                note: doc["observações"],
                visitationIdLastUpdate: doc["id_última_atualização"],
              ))
          .toList();
      change = false;
      notifyListeners();
    }
  }

  save(Composter composter, Address? address) async {
    await db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .doc(composter.name)
        .set({
      'nome': composter.name,
      'data_inicio': composter.startDate,
      'temperatura': 0,
      'ph': 0,
      'umidade': 0,
      'observações': "N/A",
      'estado_composteira': "PREPARAÇÃO",
      'id_última_atualização': 0,
      'última_atualização': "N/A",
    });
    await db
        .collection(
            'Composteiras/${auth.user!.email}/Composteiras/${composter.name}/Endereco')
        .doc("1")
        .set({
      'nome': address!.name,
      'bairro': address.district,
      'cep': address.cep,
      'cidade': address.city,
      'complemento': address.complement,
      'estado': address.state,
      'logradouro': address.street,
      'numero': address.number,
    });
    _composters.clear();
    change = true;
    notifyListeners();
  }

  Future<Stream<QuerySnapshot>> getAll() async {
    var collection = db.collection("composters/${auth.user!.email}/data");
    return collection.snapshots();
  }

  remove(String composterName) async {
    await db
        .collection("Composteiras/${auth.user!.email}/Composteiras")
        .doc(composterName)
        .delete();

    change = true;
    notifyListeners();
  }

  Stream<DocumentSnapshot> getComposterSnapshot(String composterName) {
    return db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .doc('$composterName')
        .snapshots();
  }

  Stream<QuerySnapshot> getCompostersSnapshots() {
    return db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .snapshots();
  }
}
