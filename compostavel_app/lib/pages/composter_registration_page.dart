import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

class ComposterRegistration extends StatefulWidget {
  ComposterRegistration({Key? key}) : super(key: key);

  @override
  _ComposterRegistrationState createState() => _ComposterRegistrationState();
}

class _ComposterRegistrationState extends State<ComposterRegistration> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final startDate = MaskedTextController(mask: '00/00/0000');
  bool isLoading = false;
  late ComposterRepository composterRepository;
  late AddressRepository addressRepository;
  String? valueChoice;

  @override
  Widget build(BuildContext context) {
    save() {
      if (valueChoice != null) {
        Address? address = addressRepository.getAddressesByName(valueChoice);

        composterRepository.save(
            Composter(
              name: name.text,
              startDate: startDate.text,
            ),
            address);
        setState(() {
          name.text = "";
          startDate.text = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Composteira Cadastrada com Sucesso!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Escolha Um Endereço!")));
      }
    }

    composterRepository = context.watch<ComposterRepository>();
    addressRepository = context.watch<AddressRepository>();
    addressRepository.readAddress();
    List listItem = addressRepository.getAddressesNames();

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
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: Text(
                      "Endereço",
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
                  hint: Text("Selecione o Endereço"),
                  value: valueChoice,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoice = newValue as String?;
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
