import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComposterRegistration extends StatefulWidget {
  ComposterRegistration({Key? key}) : super(key: key);

  @override
  _ComposterRegistrationState createState() => _ComposterRegistrationState();
}

class _ComposterRegistrationState extends State<ComposterRegistration> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final startDate = TextEditingController();
  bool isLoading = false;
  late ComposterRepository composterRepository;

  @override
  Widget build(BuildContext context) {
    save() {
      composterRepository.save(Composter(
        name: name.text,
        startDate: startDate.text,
      ));

      setState(() {
        name.text = "";
        startDate.text = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Composteira Cadastrada com Sucesso!")));
    }

    composterRepository = context.watch<ComposterRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Composteira"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nome",
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nome vazio";
                        }
                        return null;
                      })),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: TextFormField(
                    controller: startDate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Data de início",
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
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      save();
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
                                "Cadastrar",
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
