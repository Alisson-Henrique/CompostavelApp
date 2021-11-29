import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/pages/composter/composter_contributors_list_page.dart';
import 'package:compostavel_app/pages/composter/composter_request_list_page.dart';
import 'package:flutter/material.dart';

class ComposterProducersPage extends StatefulWidget {
  String composterName;
  ComposterProducersPage({Key? key, required this.composterName})
      : super(key: key);

  @override
  _ComposterProducersState createState() => _ComposterProducersState();
}

class _ComposterProducersState extends State<ComposterProducersPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ComposterContributorsListPage(
                    composterName: widget.composterName,
                  );
                })),
                style: OutlinedButton.styleFrom(primary: Colors.green),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Colaboradores",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ComposterRequestListPage(
                    composterName: widget.composterName,
                  );
                })),
                style: OutlinedButton.styleFrom(primary: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Solicitações",
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
