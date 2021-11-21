import 'package:compostavel_app/pages/composters_page.dart';
import 'package:compostavel_app/pages/compound_list.dart';
import 'package:compostavel_app/pages/donation_list_made_page.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProducerPage extends StatefulWidget {
  HomeProducerPage({Key? key}) : super(key: key);

  @override
  _HomeProducerPageState createState() => _HomeProducerPageState();
}

class _HomeProducerPageState extends State {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtor"),
      ),
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
                  return CompostersPage();
                })),
                style: OutlinedButton.styleFrom(primary: Colors.green),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.house),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Composteiras",
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
                  return CompostersPage();
                })),
                style: OutlinedButton.styleFrom(primary: Colors.red),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pin_drop_sharp),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Visitações",
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
                  return DonationListMadePage(path: "Recebidas");
                })),
                style: OutlinedButton.styleFrom(primary: Colors.orange),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delivery_dining),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Insumos",
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
                  return CompoundListPage();
                })),
                style: OutlinedButton.styleFrom(primary: Colors.brown),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Compostos",
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
                onPressed: () => null,
                style: OutlinedButton.styleFrom(primary: Colors.lightBlue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.turned_in),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Conquistas",
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
