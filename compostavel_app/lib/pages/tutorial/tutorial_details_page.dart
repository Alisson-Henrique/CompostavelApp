import 'package:compostavel_app/models/tutorial.dart';
import 'package:flutter/material.dart';

class TutorialDetailsPage extends StatefulWidget {
  Tutorial tutorial;
  TutorialDetailsPage({Key? key, required this.tutorial}) : super(key: key);

  @override
  _TutorialDetailsPageState createState() => _TutorialDetailsPageState();
}

class _TutorialDetailsPageState extends State<TutorialDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tutorial"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    widget.tutorial.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    widget.tutorial.description,
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    "Link",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
