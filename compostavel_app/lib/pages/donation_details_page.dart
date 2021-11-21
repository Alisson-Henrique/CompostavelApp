import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/pages/address_details_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/donation_repository.dart';
import 'package:compostavel_app/services/util_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationDetailsPage extends StatefulWidget {
  String donationId;
  String status;
  String path;
  DonationDetailsPage(
      {Key? key,
      required this.donationId,
      required this.status,
      required this.path})
      : super(key: key);

  @override
  _DonationDetailsPageState createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    DonationRepository donationRepository =
        Provider.of<DonationRepository>(context);
    final Stream<DocumentSnapshot> _donationStream =
        donationRepository.getDocumentSnapshotMade(widget.donationId);

    AddressRepository addressRepository =
        Provider.of<AddressRepository>(context);

    late Stream<DocumentSnapshot> _addressStream;
    late String senderEmail;

    bool colected = widget.status == "REALIZADA" ? false : true;
    ;
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes da Doação"),
          actions: [
            IconButton(
              icon: Icon(Icons.location_on_sharp),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return AddressDetailsPage(
                  addressStream: _addressStream,
                );
              })),
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: _donationStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Ocorreu um erro!'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              Map<String, dynamic> data = snapshot.data!.data();

              _addressStream =
                  addressRepository.getDocumentSnapshot(data["endereco"]);
              senderEmail = data["remetente"];

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
                                  "De:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data["remetente"],
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
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "para:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    data["destinatario"].toString(),
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "data de coleta:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        data["data_coleta"].toString(),
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "horas:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        data["horas"].toString(),
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
                                    "Status:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    data["estado_coleta"],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Util.GetColorStatus(
                                            data["estado_coleta"])),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "peso:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    data["peso"].toString(),
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
                                    "Endereço:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    data["endereco"],
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
                                    "Descrição:",
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
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Visibility(
                            visible: widget.path == "Recebidas" ||
                                    data["estado_coleta"] == "REALIZADA"
                                ? false
                                : true,
                            child: Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          donationRepository.cancel(
                                              widget.donationId,
                                              data["destinatario"]);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: (isLoading)
                                            ? [
                                                Padding(
                                                  padding: EdgeInsets.all(16),
                                                  child: SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ]
                                            : [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.red,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Text(
                                                    "Cancelar",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: Visibility(
          visible: colected,
          child: FloatingActionButton(
              onPressed: () => {
                    colected = false,
                    donationRepository.collected(widget.donationId, senderEmail)
                  },
              child: Icon(Icons.done)),
        ));
  }
}
