import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/pages/reporting/reporting_composter_result_page.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportingComposterPage extends StatefulWidget {
  const ReportingComposterPage({Key? key}) : super(key: key);

  @override
  _ReportingComposterPageState createState() => _ReportingComposterPageState();
}

class _ReportingComposterPageState extends State<ReportingComposterPage> {
  @override
  Widget build(BuildContext context) {
    ComposterRepository composterRepository =
        Provider.of<ComposterRepository>(context);

    final Stream<QuerySnapshot> _compostersStream =
        composterRepository.getCompostersSnapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Composteiras"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _compostersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data?.docs.length == 0) {
              return Center(child: Text('Nenhuma Composteira cadastrada'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return ListTile(
                  leading: SizedBox(
                    child: Image.asset("images/report.png"),
                    width: 40,
                  ),
                  title: Text(
                    data['nome'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(data["estado_composteira"]),
                  selected: false,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ReportingComposterResultPage(
                        composterName: data["nome"],
                      );
                    }),
                  ),
                  dense: true,
                );
              }).toList(),
            );
          }),
    );
  }
}
