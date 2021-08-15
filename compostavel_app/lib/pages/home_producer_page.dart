import 'package:flutter/material.dart';

class HomeProducerPage extends StatefulWidget {
  HomeProducerPage({Key? key}) : super(key: key);

  @override
  _HomeProducerPageState createState() => _HomeProducerPageState();
}

class _HomeProducerPageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá Produtor"),
      ),
      body: Container(),
    );
  }
}
