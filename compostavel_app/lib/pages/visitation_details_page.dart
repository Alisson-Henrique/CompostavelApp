import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/models/composter_state.dart';
import 'package:compostavel_app/models/visitation.dart';
import 'package:flutter/material.dart';

class VisitationDetailsPage extends StatefulWidget {
  Visitation visitation;
  VisitationDetailsPage({Key? key, required this.visitation}) : super(key: key);

  @override
  _VisitationDetailsState createState() => _VisitationDetailsState();
}

class _VisitationDetailsState extends State<VisitationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    String name = widget.visitation.name;
    String? date = widget.visitation.date;
    String? moisture = widget.visitation.moisture.toString();
    String? temperature = widget.visitation.temperature.toString();
    String? ph = widget.visitation.ph.toString();
    String state = widget.visitation.composterState.toString();
    String? notes = widget.visitation.note;

    if (date == null) {
      date = "N/A";
    }
    if (widget.visitation.moisture == null) {
      moisture = "N/A";
    }
    if (widget.visitation.temperature == null) {
      temperature = "N/A";
    }
    if (widget.visitation.ph == null) {
      ph = "N/A";
    }
    if (notes == null) {
      notes = "N/A";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Visita " + widget.visitation.id.toString()),
      ),
      body: SafeArea(
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
                          "Responsável:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          name,
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
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            temperature.toString(),
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
                          ph.toString(),
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
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            moisture.toString(),
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          date,
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
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            state,
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
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            notes,
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
      ),
    );
  }
}
