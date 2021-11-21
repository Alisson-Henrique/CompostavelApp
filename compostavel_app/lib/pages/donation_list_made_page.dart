import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/donation.dart';
import 'package:compostavel_app/pages/donation_details_page.dart';
import 'package:compostavel_app/pages/donation_form_page.dart';
import 'package:compostavel_app/repositories/donation_repository.dart';
import 'package:compostavel_app/services/util_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationListMadePage extends StatefulWidget {
  String path;
  DonationListMadePage({Key? key, required this.path}) : super(key: key);

  @override
  _DonationListMadePageState createState() => _DonationListMadePageState();
}

class _DonationListMadePageState extends State<DonationListMadePage> {
  late DonationRepository donationRepository;
  @override
  Widget build(BuildContext context) {
    donationRepository = Provider.of<DonationRepository>(context);
    Stream<QuerySnapshot> _donationStream =
        donationRepository.getSnapshots(widget.path);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.path == "Recebidas" ? "Insumos" : "Doações"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _donationStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data?.docs.length == 0) {
              return Center(
                  child: Text(widget.path == "Recebidas"
                      ? "Nenhum insumo doado"
                      : "Nenhuma doação feita"));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                if (widget.path == "Recebidas") {
                  return ListTile(
                    leading: SizedBox(
                      child: Image.asset("images/insumo.png"),
                      width: 40,
                    ),
                    title: Text(
                      "De: " + data['remetente'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Visibility(
                      visible:
                          data['estado_coleta'] == "AGENDADA" ? true : false,
                      child: Container(
                        width: 100,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () => {
                                donationRepository.accept(
                                    data['id'], data['remetente'])
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                donationRepository.cancel(
                                    data['id'], data['remetente']);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    subtitle: Text(
                      data["estado_coleta"],
                      style: TextStyle(
                          fontSize: 15,
                          color: Util.GetColorStatus(data["estado_coleta"])),
                    ),
                    selected: false,
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DonationDetailsPage(
                        donationId: data["id"],
                        status: data["estado_coleta"],
                        path: widget.path,
                      );
                    })),
                  );
                } else {
                  return ListTile(
                    leading: SizedBox(
                      child: Image.asset("images/insumo.png"),
                      width: 40,
                    ),
                    title: Text(
                      "Para: " + data['destinatario'],
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
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return DonationFormPage(
                                    donation: Donation(
                                  id: data['id'],
                                  recipientEmail: data['destinatario'],
                                  senderEmail: data['remetente'],
                                  weight: int.parse(data['peso'].toString()),
                                  collenctionDate: data['data_coleta'],
                                  hours: data['horas'],
                                  note: data['observações'],
                                  status: data['estado_coleta'],
                                  addressId: data['endereco'],
                                ));
                              }),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              donationRepository.remove(data['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      data["estado_coleta"],
                      style: TextStyle(
                          fontSize: 15,
                          color: Util.GetColorStatus(data["estado_coleta"])),
                    ),
                    selected: false,
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DonationDetailsPage(
                          donationId: data["id"],
                          status: data["estado_coleta"],
                          path: widget.path);
                    })),
                  );
                }
              }).toList(),
            );
          },
        ),
        floatingActionButton: Visibility(
          visible: widget.path == "Recebidas" ? false : true,
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return DonationFormPage();
            })),
            child: Icon(Icons.add),
          ),
        ));
  }
}
