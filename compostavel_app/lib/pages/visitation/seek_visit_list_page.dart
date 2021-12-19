import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/repositories/visit_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeekVisitLiistPage extends StatefulWidget {
  String userEmail;
  SeekVisitLiistPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _SeekVisitLiistPageState createState() => _SeekVisitLiistPageState();
}

class _SeekVisitLiistPageState extends State<SeekVisitLiistPage> {
  bool check = false;
  IconData icon = Icons.person_add_alt_1_outlined;
  @override
  Widget build(BuildContext context) {
    VisitReposiitory visitRepositoy = Provider.of<VisitReposiitory>(context);

    final Stream<QuerySnapshot> _visitStream =
        visitRepositoy.getVisitSnapshot(widget.userEmail);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userEmail),
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
            return Center(child: Text('Esse produtor não possui composteiras'));
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
                    data['nome'].toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Container(
                    width: 50,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.person_add_alt_1_outlined),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Solicitação enviada!")));

                            visitRepositoy.requestParticipation(
                                data['nome'].toString(), widget.userEmail);
                          },
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(data["estado_composteira"]),
                  selected: false,
                  onTap: () => []);
            }).toList(),
          );
        },
      ),
    );
  }
}
