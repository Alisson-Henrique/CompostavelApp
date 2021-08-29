import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/pages/anddress_page.dart';
import 'package:compostavel_app/pages/composter_monitoring_page.dart';
import 'package:compostavel_app/pages/composter_producers_page.dart';
import 'package:compostavel_app/pages/composter_visitation_page.dart';
import 'package:flutter/material.dart';

class ComposterDetailsPage extends StatefulWidget {
  Composter composter;
  ComposterDetailsPage({Key? key, required this.composter}) : super(key: key);

  @override
  _ComposterDetailsState createState() => _ComposterDetailsState();
}

class _ComposterDetailsState extends State<ComposterDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.composter.name),
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
              composter: widget.composter,
            ),
            ComposterProducersPage(
              composter: widget.composter,
            ),
            ComposterVisitationPage(
              composter: widget.composter,
            ),
          ]),
          floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AnddressPage();
                  })),
              child: Icon(Icons.location_on_sharp)),
        ),
      ),
    );
  }
}
