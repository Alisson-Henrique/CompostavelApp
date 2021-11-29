import 'package:compostavel_app/models/compound.dart';
import 'package:compostavel_app/repositories/compound_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

class CompoundFormPage extends StatefulWidget {
  Compound compound;
  CompoundFormPage({Key? key, required this.compound}) : super(key: key);

  @override
  _CompoundFormPageState createState() => _CompoundFormPageState();
}

class _CompoundFormPageState extends State<CompoundFormPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final weight = TextEditingController();
  final collenctionDate = MaskedTextController(mask: '00/00/0000');

  bool isLoading = false;
  String labelButton = "Cadastrar";

  late CompoundRepositoy compoundRepositoy;
  @override
  void initState() {
    edit();
    super.initState();
  }

  edit() {
    if (widget.compound.name.isNotEmpty) {
      labelButton = "Editar";
      name.text = widget.compound.name;
      weight.text = widget.compound.weight.toString();
      collenctionDate.text = widget.compound.collenctionDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    compoundRepositoy = context.watch<CompoundRepositoy>();
    save() {
      setState(() => isLoading = true);
      try {
        compoundRepositoy.save(Compound(
            name: name.text,
            weight: int.parse(weight.text),
            collenctionDate: collenctionDate.text));
      } catch (e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Ocorreu um erro!"),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Composto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                  child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Identificação",
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nome vazio";
                        }
                        return null;
                      })),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                    controller: collenctionDate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Data de Coleta",
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Data vazia!";
                      }
                      return null;
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                    controller: weight,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Peso",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      save();
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
                                labelButton,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
