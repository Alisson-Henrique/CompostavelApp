import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/models/visitation.dart';
import 'package:compostavel_app/repositories/visit_repository.dart';
import 'package:compostavel_app/repositories/visitation_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterVisitationPage extends StatefulWidget {
  String composterName;
  String? name;
  Visitation visitation;
  String userEmail;
  RegisterVisitationPage({
    Key? key,
    required this.composterName,
    this.name,
    required this.visitation,
    required this.userEmail,
  }) : super(key: key);

  @override
  _RegisterVisitationPageState createState() => _RegisterVisitationPageState();
}

class _RegisterVisitationPageState extends State<RegisterVisitationPage> {
  final formKey = GlobalKey<FormState>();
  final temperature = TextEditingController();
  final ph = TextEditingController();
  final date = TextEditingController();
  final note = TextEditingController();
  final moisture = TextEditingController();

  bool isLoading = false;
  late VisitationRepository visitationRepository;
  late VisitReposiitory _visitReposiitory;
  late Visitation visitation;

  var listItem = ["ATIVA", "FINALIZADA"];

  @override
  Widget build(BuildContext context) {
    visitationRepository = context.watch<VisitationRepository>();
    _visitReposiitory = context.watch<VisitReposiitory>();

    String valueChoice = listItem[0];
    bool isEdit = false;

    if (widget.visitation.id != 0) {
      isEdit = true;
      temperature.text = widget.visitation.temperature.toString();
      ph.text = widget.visitation.ph.toString();
      date.text = widget.visitation.date.toString();
      note.text = widget.visitation.note.toString();
      moisture.text = widget.visitation.moisture.toString();
    }

    saveVisitation() async {
      setState(() => isLoading = true);
      try {
        if (widget.userEmail == "") {
          visitationRepository.save(
            widget.composterName,
            visitation,
          );
        } else {
          _visitReposiitory.save(
              widget.composterName, visitation, widget.userEmail.toString());
        }
      } on AuthException catch (e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Visita"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                  child: TextFormField(
                      controller: temperature,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Temperatura(°c)",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String patttern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (regExp.hasMatch(value!)) {
                          return "A temperatura só deve conter dígitos";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      controller: ph,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "ph",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String patttern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (regExp.hasMatch(value!)) {
                          return "A ph só deve conter dígitos";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      controller: moisture,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Umidade",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String patttern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (regExp.hasMatch(value!)) {
                          return "A umidade só deve conter dígitos";
                        }
                        return null;
                      }),
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      child: Text(
                        "Estado",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: DropdownButton(
                    hint: Text("Selecione o Estado atual"),
                    value: valueChoice,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        valueChoice = newValue as String;
                      });
                    },
                    items: listItem.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      controller: note,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Observações",
                      ),
                      keyboardType: TextInputType.text),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isEdit) {
                          visitation = new Visitation(
                              id: widget.visitation.id,
                              name: widget.name!,
                              date: date.text,
                              moisture: int.parse(moisture.text),
                              ph: int.parse(ph.text),
                              temperature: int.parse(temperature.text),
                              note: note.text,
                              composterState: valueChoice);
                          saveVisitation();
                        } else {
                          visitation = new Visitation(
                              id: 0,
                              name: widget.name!,
                              date: date.text,
                              moisture: int.parse(moisture.text),
                              ph: int.parse(ph.text),
                              temperature: int.parse(temperature.text),
                              note: note.text,
                              composterState: valueChoice);
                          saveVisitation();
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (isLoading)
                          ? [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              Icon(Icons.check),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Registrar",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
