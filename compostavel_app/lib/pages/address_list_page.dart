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
    addressRepository.readAddress();
    List<Address> addresses = addressRepository.getAddresses();

    return Scaffold(
      appBar: AppBar(
        title: Text("Endereços"),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int addressIndex) {
            return ListTile(
              leading: Icon(Icons.location_on_sharp),
              title: Text(
                addresses[addressIndex].name,
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
                      icon: Icon(Icons.edit, color: Colors.red),
                      onPressed: () {
                        addressRepository.remove(addresses[addressIndex]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        addressRepository.remove(addresses[addressIndex]);
                      },
                    ),
                  ],
                ),
              ),
              selected: false,
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, __) => Divider(),
          itemCount: addresses.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddressRegisterPage();
        })),
        child: Icon(Icons.add_location),
      ),
    );
  }
}
