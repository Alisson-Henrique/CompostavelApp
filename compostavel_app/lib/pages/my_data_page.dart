import 'package:compostavel_app/pages/address/address_list_page.dart';
import 'package:compostavel_app/pages/address/address_registration_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDataPage extends StatefulWidget {
  MyDataPage({Key? key}) : super(key: key);

  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State {
  late AddressRepository addressRepository;
  @override
  Widget build(BuildContext context) {
    addressRepository = context.watch<AddressRepository>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Dados"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddressesPage();
                })),
                style: OutlinedButton.styleFrom(primary: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_outlined),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Endereço(s)",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () => {
                  addressRepository.clearCash(),
                  context.read<AuthService>().logout()
                },
                style: OutlinedButton.styleFrom(primary: Colors.red),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Sair",
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
    );
  }
}
