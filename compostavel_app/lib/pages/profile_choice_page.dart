import 'package:compostavel_app/pages/home_donor_page.dart';
import 'package:compostavel_app/pages/home_producer_page.dart';
import 'package:flutter/material.dart';

class ProfileChoicePage extends StatefulWidget {
  ProfileChoicePage({Key? key}) : super(key: key);

  @override
  _ProfileChoicePageState createState() => _ProfileChoicePageState();
}

class _ProfileChoicePageState extends State<ProfileChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Modo de uso",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Produtor",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: ElevatedButton(
                onPressed: () {
                  HomePage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Doador",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
