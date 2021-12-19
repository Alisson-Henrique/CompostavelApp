import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/models/composter_state.dart';
import 'package:compostavel_app/pages/composter/composter_address_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComposterMonitoringPage extends StatefulWidget {
  String composterName;
  String userEmail;
  ComposterMonitoringPage(
      {Key? key, required this.composterName, required this.userEmail})
      : super(key: key);

  @override
  _ComposterMonitoringState createState() => _ComposterMonitoringState();
}

class _ComposterMonitoringState extends State<ComposterMonitoringPage> {
  @override
  Widget build(BuildContext context) {
    ComposterRepository composterRepository =
        Provider.of<ComposterRepository>(context);
    final Stream<DocumentSnapshot> _composterStream;
    if (widget.userEmail == "") {
      _composterStream =
          composterRepository.getComposterSnapshot(widget.composterName);
    } else {
      _composterStream = composterRepository.getCompostersByUserEmailSnapshots(
          widget.userEmail, widget.composterName);
    }

    AddressRepository addressRepository =
        Provider.of<AddressRepository>(context);

    final Stream<DocumentSnapshot> _addressStream = addressRepository
        .getAddressSnapshotByComposterName(widget.composterName);

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: _composterStream,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            Map<String, dynamic> data = snapshot.data!.data();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      //Nome Composteiras
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nome:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data["nome"],
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Temperatura:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  data["temperatura"].toString(),
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ph:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                data["ph"].toString(),
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Umidade:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      data["umidade"].toString(),
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ])),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Data de Inicio:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  data["data_inicio"],
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ultima Atualização:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                data["última_atualização"],
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estado:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  data["estado_composteira"],
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Observações:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  data["observações"],
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ComposterAddressPage(
                    composterName: widget.composterName);
              })),
          child: Icon(Icons.location_on_sharp)),
    );
  }
}
