import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/repositories/visitation_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportingComposterResultPage extends StatefulWidget {
  String composterName;
  ReportingComposterResultPage({Key? key, required this.composterName})
      : super(key: key);

  @override
  _ReportingComposterResultPageState createState() =>
      _ReportingComposterResultPageState();
}

class _ReportingComposterResultPageState
    extends State<ReportingComposterResultPage> {
  late Stream<QuerySnapshot> _visitationStream;
  @override
  Widget build(BuildContext context) {
    VisitationRepository visitationRepository =
        Provider.of<VisitationRepository>(context);

    _visitationStream =
        visitationRepository.getSnapshots(widget.composterName, "");

    return Scaffold(
      appBar: AppBar(
        title: Text("Composteira"),
        bottom: PreferredSize(
          child: DecoratedBox(
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Text(
                  "   Temperatura",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Text(
                  "     Umidade",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Text(
                  "     ph",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
              ],
            ),
          ),
          preferredSize: Size(40, 40),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _visitationStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.length == 0) {
            return Center(child: Text('Nenhuma Visita registrada'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                leading: SizedBox(
                  child: Image.asset("images/calendar_icon.png"),
                  width: 40,
                ),
                title: Text(
                  data['data'].toString() + "  Visita " + data['id'].toString(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              data["temperatura"].toString() + " °c       ",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              data["umidade"].toString(),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              data["ph"].toString(),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                selected: false,
                onTap: () => [],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
