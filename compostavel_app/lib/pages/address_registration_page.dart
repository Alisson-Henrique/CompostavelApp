import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/pages/login_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddressRegisterPage extends StatefulWidget {
  Address address;
  AddressRegisterPage({Key? key, required this.address}) : super(key: key);

  @override
  _AddressRegisterPageState createState() => _AddressRegisterPageState();
}

class _AddressRegisterPageState extends State<AddressRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final street = TextEditingController();
  final city = TextEditingController();
  final cep = TextEditingController();
  final state = TextEditingController();
  final district = TextEditingController();
  final number = TextEditingController();
  final complement = TextEditingController();

  late AddressRepository addressRepository;

  bool isPop = true;
  bool isLoading = false;
  late UserData userData;

  String labelButton = "Cadastrar";
  @override
  void initState() {
    super.initState();
    edit();
  }

  edit() {
    if (widget.address.name != "") {
      name.text = widget.address.name;
      street.text = widget.address.street;
      city.text = widget.address.city;
      cep.text = widget.address.cep;
      state.text = widget.address.state;
      district.text = widget.address.district;
      number.text = widget.address.number;
      complement.text = widget.address.complement;
      labelButton = "Editar";
    }
  }

  register() async {
    setState(() => isLoading = true);
    setState(() => isPop = true);

    try {
      addressRepository.save(Address(
        name: name.text,
        street: street.text,
        city: city.text,
        cep: cep.text,
        state: state.text,
        district: district.text,
        number: number.text,
        complement: complement.text,
      ));
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      setState(() => isPop = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    addressRepository = context.watch<AddressRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Endereço"),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                    controller: street,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Logradouro",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                    controller: district,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Bairro",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                    controller: number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Número",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                    controller: city,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Cidade",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                    controller: state,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Estado",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                    controller: cep,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "CEP",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                    controller: complement,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Complemento",
                    ),
                    keyboardType: TextInputType.text),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      userData = new UserData(name: name.text);

                      register();

                      if (isPop) {
                        Navigator.pop(context);
                      }
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
