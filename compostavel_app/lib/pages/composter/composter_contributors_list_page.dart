import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/repositories/visit_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComposterContributorsListPage extends StatefulWidget {
  String composterName;
  ComposterContributorsListPage({Key? key, required this.composterName})
      : super(key: key);

  @override
  _ComposterContributorsListPageState createState() =>
      _ComposterContributorsListPageState();
}

class _ComposterContributorsListPageState
    extends State<ComposterContributorsListPage> {
  @override
  Widget build(BuildContext context) {
    VisitReposiitory visitRepositoy = Provider.of<VisitReposiitory>(context);

    Stream<QuerySnapshot> _visitStream =
        visitRepositoy.getContributorsSnapshot(widget.composterName);
    return Scaffold(
      appBar: AppBar(
        title: Text("Colaboradores"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _visitStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.length == 0) {
            return Center(child: Text("Nenhuma colaborador na composteira"));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return ListTile(
                leading: Icon(
                  Icons.account_circle,
                  size: 40,
                ),
                title: Text(
                  data["email"],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  width: 50,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => {
                          visitRepositoy.removeContributor(
                              data["email"], widget.composterName, data['id'])
                        },
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
