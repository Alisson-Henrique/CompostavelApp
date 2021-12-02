import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/databases/db_firestore.dart';
import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/donation.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:compostavel_app/services/util_service.dart';
import 'package:flutter/material.dart';

class DonationRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;

  DonationRepository({required this.auth}) {
    _startRepository();
  }
  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  save(Donation donation, Address? address) async {
    if (donation.recipientEmail == auth.user!.email) {
      throw Exception();
    }

    if (donation.id == "") {
      donation.id = Util.CreateId();
    }
    await db
        .collection("Usuarios/${auth.user!.email}/Doacao/Feitas/Doacoes")
        .doc(donation.id)
        .set({
      'id': donation.id,
      'destinatario': donation.recipientEmail,
      'remetente': auth.user!.email,
      'peso': donation.weight,
      'data_coleta': donation.collenctionDate,
      'horas': donation.hours,
      'observações': donation.note,
      'estado_coleta': donation.status,
      'endereco': donation.addressId,
      'deleted_at': null,
    });

    await db
        .collection(
            "Usuarios/${donation.recipientEmail}/Doacao/Recebidas/Doacoes")
        .doc(donation.id)
        .set({
      'id': donation.id,
      'destinatario': donation.recipientEmail,
      'remetente': auth.user!.email,
      'peso': donation.weight,
      'data_coleta': donation.collenctionDate,
      'horas': donation.hours,
      'observações': donation.note,
      'estado_coleta': donation.status,
      'endereco': donation.addressId,
      'deleted_at': null,
    });

    await db
        .collection(
            'Usuarios/${donation.recipientEmail}/Doacao/Recebidas/Doacoes/${donation.id}/Endereco')
        .doc(address!.name)
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
  }

  remove(String donationId) async {
    return db
        .collection("Usuarios/${auth.user!.email}/Doacao/Feitas/Doacoes")
        .doc(donationId)
        .update({'deleted_at': DateTime.now().toString()})
        .then((value) => null)
        .catchError((value) => null);
  }

  Stream<QuerySnapshot> getSnapshots(String path) {
    return db
        .collection('Usuarios/${auth.user!.email}/Doacao/$path/Doacoes')
        .where('deleted_at', isNull: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getDocumentSnapshotMade(
      String donationId, String path) {
    return db
        .collection("Usuarios/${auth.user!.email}/Doacao/$path/Doacoes")
        .doc(donationId)
        .snapshots();
  }

  cancel(String donationId, String recipientEmail) async {
    await db
        .collection("Usuarios/$recipientEmail/Doacao/Feitas/Doacoes")
        .doc(donationId)
        .update({'estado_coleta': "CANCELADA"});

    await db
        .collection("Usuarios/${auth.user!.email}/Doacao/Recebidas/Doacoes")
        .doc(donationId)
        .delete();
  }

  accept(String donationId, String senderEmail) async {
    await db
        .collection("Usuarios/$senderEmail/Doacao/Feitas/Doacoes")
        .doc(donationId)
        .update({'estado_coleta': "PENDENTE"})
        .then((value) => null)
        .catchError((value) => null);

    await db
        .collection("Usuarios/${auth.user!.email}/Doacao/Recebidas/Doacoes")
        .doc(donationId)
        .update({'estado_coleta': "PENDENTE"})
        .then((value) => null)
        .catchError((value) => null);
  }

  collected(String donationId, String senderEmail) async {
    await db
        .collection("Usuarios/$senderEmail/Doacao/Feitas/Doacoes")
        .doc(donationId)
        .update({'estado_coleta': "REALIZADA"})
        .then((value) => null)
        .catchError((value) => null);

    await db
        .collection("Usuarios/${auth.user!.email}/Doacao/Recebidas/Doacoes")
        .doc(donationId)
        .update({'estado_coleta': "REALIZADA"})
        .then((value) => null)
        .catchError((value) => null);
  }

  Stream<DocumentSnapshot> getAddressDocumentSnapshotByUser(
      String addressName, String recipientEmail, String donationId) {
    return db
        .collection(
            "Usuarios/${auth.user!.email}/Doacao/Recebidas/Doacoes/$donationId/Endereco")
        .doc(addressName)
        .snapshots();
  }
}
