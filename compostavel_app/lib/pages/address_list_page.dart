import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/pages/address_registration_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressesPage extends StatefulWidget {
  AddressesPage({Key? key}) : super(key: key);

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  Widget build(BuildContext context) {
    AddressRepository addressRepository =
        Provider.of<AddressRepository>(context);

    Stream<QuerySnapshot> _addressesStream =
        addressRepository.getAddressesSnapshot();

    return Scaffold(
      appBar: AppBar(
        title: Text("Endereços"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _addressesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data?.docs.length == 0) {
              return Center(child: Text('Nenhum Endereço cadastrado'));
            }
            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                leading: Icon(Icons.location_on_sharp),
                title: Text(
                  data["nome"],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AddressRegisterPage(
                              address: Address(
                                  name: data["nome"],
                                  street: data["logradouro"],
                                  city: data["cidade"],
                                  cep: data["cep"],
                                  state: data["estado"],
                                  district: data["bairro"],
                                  number: data["numero"],
                                  complement: data["complemento"]),
                            );
                          }));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          addressRepository.remove(data["nome"]);
                        },
                      ),
                    ],
                  ),
                ),
                selected: false,
              );
            }).toList());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddressRegisterPage(
            address: Address(
                name: "",
                street: "",
                city: "",
                cep: "",
                state: "",
                district: "",
                number: "",
                complement: ""),
          );
        })),
        child: Icon(Icons.add_location),
      ),
    );
  }
}
