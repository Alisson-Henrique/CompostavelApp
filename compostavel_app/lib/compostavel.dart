import 'package:compostavel_app/widgets/auth_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Compostavel extends StatelessWidget {
  const Compostavel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Compostavel App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: AuthCheck(),
    );
  }
}
