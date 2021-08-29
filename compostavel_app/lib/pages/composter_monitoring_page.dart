import 'package:compostavel_app/models/composter.dart';
import 'package:flutter/material.dart';

class ComposterMonitoringPage extends StatefulWidget {
  Composter composter;
  ComposterMonitoringPage({Key? key, required this.composter})
      : super(key: key);

  @override
  _ComposterMonitoringState createState() => _ComposterMonitoringState();
}

class _ComposterMonitoringState extends State<ComposterMonitoringPage> {
  @override
  Widget build(BuildContext context) {
    String name = widget.composter.name;
    String? lastDateUpdate = widget.composter.lastDateUpdate;
    String startDate = widget.composter.startDate;
    String? temperature;
    String? ph;
    String state;
    String? notes = widget.composter.note;
    if (lastDateUpdate == null) {
      lastDateUpdate = "N/A";
    }
    if (widget.composter.temperature == null) {
      temperature = "N/A";
    }
    if (widget.composter.ph == null) {
      ph = "N/A";
    }
    if (notes == null) {
      notes = "N/A";
    }
    switch (widget.composter.composterState) {
      case Composter_State.ATIVA:
        state = "ATIVA";
        break;
      case Composter_State.FINALIZADA:
        state = "DESATIVADA";
        break;
      case null:
        state = "PREPARAÇÃO";
        break;
    }
    return Scaffold(
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
                        "Nome:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        name,
                        style: TextStyle(fontSize: 16),
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          temperature.toString(),
                          style: TextStyle(fontSize: 16),
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
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        ph.toString(),
                        style: TextStyle(fontSize: 16),
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
                          "Data de Inicio:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          startDate,
                          style: TextStyle(fontSize: 16),
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
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        lastDateUpdate,
                        style: TextStyle(fontSize: 16),
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          state,
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
    ));
  }
}
