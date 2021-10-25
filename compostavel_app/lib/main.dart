import 'package:compostavel_app/compostavel.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
import 'package:compostavel_app/repositories/visitation_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
      ChangeNotifierProvider(
        create: (context) =>
            UserDataRepository(auth: context.read<AuthService>()),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            ComposterRepository(auth: context.read<AuthService>()),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            AddressRepository(auth: context.read<AuthService>()),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            VisitationRepository(auth: context.read<AuthService>()),
      ),
    ],
    child: Compostavel(),
  ));
}
