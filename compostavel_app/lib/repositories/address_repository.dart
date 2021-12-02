import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class AddressRepository extends ChangeNotifier {
  List<Address> _addresses = [];
  List<String> _addressesNames = [];
  late FirebaseFirestore db;
  late AuthService auth;
  var change = true;

  AddressRepository({required this.auth}) {
    _startRepository();
  }

  Future<List<Address>> getAddresses() async {
    QuerySnapshot addressesQuerySnapshot = await db
        .collection('Composteiras/${auth.user!.email}/Composteiras')
        .get();

    var addresses = addressesQuerySnapshot.docs
        .map((doc) => Address(
              name: doc['nome'],
              district: doc['bairro'],
              cep: doc['cep'],
              city: doc['cidade'],
              complement: doc['complemento'],
              state: doc['estado'],
              street: doc['logradouro'],
              number: doc['numero'],
            ))
        .toList();

    for (var address in addresses) {
      _addressesNames.add(address.name);
    }
    _addresses = addresses;
    notifyListeners();
    return addresses;
  }

  List<String> getAddressesNames() {
    return _addressesNames;
  }

  Address? getAddressesByName(String? name) {
    for (var address in _addresses) {
      if (address.name == name) {
        return address;
      }
    }
    return null;
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  readAddress() async {
    if (auth.user != null && _addresses.isEmpty && change == true) {
      final snapshot =
          await db.collection('Usuarios/${auth.user!.email}/Enderecos').get();

      _addresses = snapshot.docs
          .map((doc) => Address(
                name: doc['nome'],
                district: doc['bairro'],
                cep: doc['cep'],
                city: doc['cidade'],
                complement: doc['complemento'],
                state: doc['estado'],
                street: doc['logradouro'],
                number: doc['numero'],
              ))
          .toList();
      _addressesNames.clear();
      for (var address in _addresses) {
        _addressesNames.add(address.name);
      }
      change = false;
      notifyListeners();
    }
  }

  save(Address address) async {
    await db
        .collection('Usuarios/${auth.user!.email}/Enderecos')
        .doc(address.name)
        .set({
      'nome': address.name,
      'bairro': address.district,
      'cep': address.cep,
      'cidade': address.city,
      'complemento': address.complement,
      'estado': address.state,
      'logradouro': address.street,
      'numero': address.number,
    });
    _addresses.clear();
    change = true;
    notifyListeners();
  }

  remove(String address) async {
    await db
        .collection("Usuarios/${auth.user!.email}/Enderecos")
        .doc(address)
        .delete();

    _addresses.clear();
    change = true;
    notifyListeners();
  }

  Stream<QuerySnapshot> getAddressesSnapshot() {
    return db.collection('Usuarios/${auth.user!.email}/Enderecos').snapshots();
  }

  Stream<DocumentSnapshot> getAddressSnapshotByComposterName(
      String composterName) {
    return db
        .collection(
            'Composteiras/${auth.user!.email}/Composteiras/$composterName/Endereco')
        .doc("1")
        .snapshots();
  }

  Stream<DocumentSnapshot> getDocumentSnapshot(String name) {
    return db
        .collection("Usuarios/${auth.user!.email}/Enderecos")
        .doc(name)
        .snapshots();
  }

  Stream<DocumentSnapshot> getDocumentSnapshotByUser(
      String addressName, String recipientEmail) {
    return db
        .collection("Usuarios/$recipientEmail/Enderecos")
        .doc(addressName)
        .snapshots();
  }

  clearCash() {
    _addresses.clear();
    change = true;
    notifyListeners();
  }
}
