import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/models/visitation.dart';
import 'package:compostavel_app/pages/register_visitation_page.dart';
import 'package:compostavel_app/pages/visitation_details_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/visitation_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitationList extends StatefulWidget {
  String composterName;
  String userEmail;
  VisitationList(
      {Key? key, required this.composterName, required this.userEmail})
      : super(key: key);

  @override
  _VisitationListState createState() => _VisitationListState();
}

class _VisitationListState extends State<VisitationList> {
  late Stream<QuerySnapshot> _visitationStream;

  @override
  Widget build(BuildContext context) {
    VisitationRepository visitationRepository =
        Provider.of<VisitationRepository>(context);

    _visitationStream = visitationRepository.getSnapshots(
        widget.composterName, widget.userEmail == "" ? "" : widget.userEmail);

    return Scaffold(
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
                  data['id'].toString(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  width: widget.userEmail == "" ? 100 : 50,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return RegisterVisitationPage(
                                composterName: widget.composterName,
                                visitation: Visitation(
                                    id: data["id"],
                                    name: data["responsável"],
                                    temperature: data["temperatura"],
                                    ph: data["ph"],
                                    moisture: data["umidade"],
                                    date: data["data"],
                                    note: data["observações"],
                                    composterState: data["estado_composteira"]),
                                userEmail: "",
                              );
                            }),
                          );
                        },
                      ),
                      Visibility(
                        visible: widget.userEmail == "" ? true : false,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            visitationRepository.remove(
                                widget.composterName,
                                Visitation(
                                  id: data["id"],
                                  name: data["responsável"],
                                  temperature: data["temperatura"],
                                  ph: data["ph"],
                                  moisture: data["umidade"],
                                  date: data["data"],
                                  note: data["observações"],
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                ),
                subtitle: Text(data["data"]),
                selected: false,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return VisitationDetailsPage(
                        visitation: Visitation(
                            id: data["id"],
                            name: data["responsável"],
                            temperature: data["temperatura"],
                            ph: data["ph"],
                            moisture: data["umidade"],
                            date: data["data"],
                            note: data["observações"],
                            composterState: data["estado_composteira"]));
                  }),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegisterVisitationPage(
            composterName: widget.composterName,
            name: visitationRepository.auth.user!.email,
            visitation: new Visitation(id: 0, name: ""),
            userEmail: widget.userEmail == "" ? "" : widget.userEmail,
          );
        })),
        child: Icon(Icons.add),
      ),
    );
  }
}
