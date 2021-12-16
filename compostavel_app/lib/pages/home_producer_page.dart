import 'package:compostavel_app/pages/badge/badge_list_page.dart';
import 'package:compostavel_app/pages/composter/composter_list_page.dart';
import 'package:compostavel_app/pages/compound/compound_list.dart';
import 'package:compostavel_app/pages/donation/donation_list_made_page.dart';
import 'package:compostavel_app/pages/reporting/reporting_composter_page.dart';
import 'package:compostavel_app/pages/reporting/reporting_list_page.dart';
import 'package:compostavel_app/pages/visitation/seek_visitation_page.dart';
import 'package:compostavel_app/pages/visitation/visit_list_page.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
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
    UserDataRepository userDataRepository =
        Provider.of<UserDataRepository>(context);

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
                  return ComposterListPage();
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
                  return VisitListpage();
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
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ReportingListPage();
                })),
                style: OutlinedButton.styleFrom(primary: Colors.purple),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_library_books_rounded),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Relatórios",
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
                onPressed: () => {
                  userDataRepository.change = true,
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BadgeListPage(
                          userType: "Produtor",
                        );
                      },
                    ),
                  ),
                },
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
