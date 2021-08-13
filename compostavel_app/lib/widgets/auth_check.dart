import 'package:compostavel_app/pages/home_donor_page.dart';
import 'package:compostavel_app/pages/login_page.dart';
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
      return LoginPage();
    else
      return HomePage();
  }
}

loading() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
