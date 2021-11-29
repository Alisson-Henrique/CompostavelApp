import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/pages/visitation/seek_visitation_page.dart';
import 'package:compostavel_app/pages/visitation/visitation_manager_page.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/repositories/visit_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitListpage extends StatefulWidget {
  const VisitListpage({Key? key}) : super(key: key);

  @override
  _VisitListpageState createState() => _VisitListpageState();
}

class _VisitListpageState extends State<VisitListpage> {
  @override
  Widget build(BuildContext context) {
    VisitReposiitory _visitRepository = Provider.of<VisitReposiitory>(context);

    final Stream<QuerySnapshot> _compostersStream =
        _visitRepository.seekVisitGetSnapshot();

    return Scaffold(
      appBar: AppBar(
        title: Text("Visitações"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _compostersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.length == 0) {
            return Center(child: Text('Nenhuma visitação possível'));
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
                  data['nome_composteira'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  data["dono"],
                  style: TextStyle(fontSize: 15),
                ),
                selected: false,
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return VisitationManagerPage(
                    composterName: data['nome_composteira'],
                    userEmail: data['dono'],
                  );
                })),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SeekVisitationPage();
        })),
        child: Icon(Icons.add),
      ),
    );
  }
}
