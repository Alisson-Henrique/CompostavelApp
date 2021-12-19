import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/pages/address/anddress_page.dart';
import 'package:compostavel_app/pages/composter/composter_monitoring_page.dart';
import 'package:compostavel_app/pages/composter/composter_producers_page.dart';
import 'package:compostavel_app/pages/composter/composter_visitation_page.dart';
import 'package:compostavel_app/pages/visitation/visitation_list_page.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/repositories/visitation_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComposterDetailsPage extends StatefulWidget {
  String composterName;
  ComposterDetailsPage({Key? key, required this.composterName})
      : super(key: key);

  @override
  _ComposterDetailsState createState() => _ComposterDetailsState();
}

class _ComposterDetailsState extends State<ComposterDetailsPage> {
  late Composter composter;
  @override
  Widget build(BuildContext context) {
    ComposterRepository composterRepository =
        Provider.of<ComposterRepository>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.composterName),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.monitor),
                ),
                Tab(
                  icon: Icon(Icons.person_add),
                ),
                Tab(
                  icon: Icon(Icons.calendar_today),
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            ComposterMonitoringPage(
              composterName: widget.composterName,
              userEmail: "",
            ),
            ComposterProducersPage(
              composterName: widget.composterName,
            ),
            VisitationList(
              composterName: widget.composterName,
              userEmail: "",
            )
          ]),
        ),
      ),
    );
  }
}
