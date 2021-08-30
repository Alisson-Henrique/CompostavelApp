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

  AddressRepository({required this.auth}) {
    _startRepository();
  }

  List<Address> getAddresses() {
    return _addresses;
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
    if (auth.user != null && _addresses.isEmpty) {
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
    notifyListeners();
  }

  remove(Address address) async {
    await db
        .collection("Usuarios/${auth.user!.email}/Enderecos")
        .doc(address.name)
        .delete();
    _addresses.remove(address);
    notifyListeners();
  }
}
