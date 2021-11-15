import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/compound.dart';
import 'package:compostavel_app/pages/compound_form_page.dart';
import 'package:compostavel_app/repositories/compound_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompoundListPage extends StatefulWidget {
  CompoundListPage({Key? key}) : super(key: key);

  @override
  _CompoundListPageState createState() => _CompoundListPageState();
}

class _CompoundListPageState extends State<CompoundListPage> {
  @override
  Widget build(BuildContext context) {
    CompoundRepositoy compoundRepositoy =
        Provider.of<CompoundRepositoy>(context);

    final Stream<QuerySnapshot> _compoundStream =
        compoundRepositoy.getSnapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("Compostos"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _compoundStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.length == 0) {
            return Center(child: Text('Nenhuma Composto cadastrado'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                leading: SizedBox(
                  child: Image.asset("images/composto.png"),
                  width: 40,
                ),
                title: Text(
                  data['nome'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return CompoundFormPage(
                            compound: Compound(
                                name: data['nome'],
                                weight: data['peso'],
                                collenctionDate: data['data_coleta']),
                          );
                        })),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          compoundRepositoy.remove(data['nome']);
                        },
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  data["data_coleta"].toString() +
                      "      " +
                      data["peso"].toString() +
                      "kg",
                  style: TextStyle(fontSize: 15),
                ),
                selected: false,
                onTap: () => [],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return CompoundFormPage(
            compound: Compound(name: "", weight: 0, collenctionDate: ""),
          );
        })),
        child: Icon(Icons.add),
      ),
    );
  }
}
