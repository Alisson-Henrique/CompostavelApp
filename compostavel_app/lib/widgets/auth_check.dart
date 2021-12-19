import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/pages/home/home_page.dart';
import 'package:compostavel_app/pages/login/login_page.dart';
import 'package:compostavel_app/pages/login/login_register_page.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);

    if (authService.isLoading)
      return loading();
    else if (authService.user == null)
      return LoginRegisterPage();
    else {
      return HomePage();
    }
  }
}

loading() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
