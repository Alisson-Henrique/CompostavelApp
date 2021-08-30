import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/pages/composter_details.dart';
import 'package:compostavel_app/pages/composter_registration_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompostersPage extends StatefulWidget {
  CompostersPage({Key? key}) : super(key: key);

  @override
  _CompostersState createState() => _CompostersState();
}

class _CompostersState extends State<CompostersPage> {
  composterDetails(Composter composter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComposterDetailsPage(composter: composter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ComposterRepository composterRepository =
        Provider.of<ComposterRepository>(context);
    AddressRepository addressRepository =
        Provider.of<AddressRepository>(context);
    composterRepository.readComposters();
    addressRepository.readAddress();
    List<Composter> composters = composterRepository.getComposters();
    List<String> addressesNames = addressRepository.getAddressesNames();
    List<Address> addresses = addressRepository.getAddresses();
    return Scaffold(
      appBar: AppBar(
        title: Text("Composteiras"),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int composter) {
            return ListTile(
              leading: SizedBox(
                child: Image.asset("images/composter_icon.png"),
                width: 40,
              ),
              title: Text(
                composters[composter].name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  composterRepository.remove(composters[composter]);
                },
              ),
              selected: false,
              onTap: () => composterDetails(composters[composter]),
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, __) => Divider(),
          itemCount: composters.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ComposterRegistration(
            addresses: addresses,
            addressesNames: addressesNames,
          );
        })),
        child: Icon(Icons.add),
      ),
    );

    /*
    return Scaffold(
      appBar: AppBar(
        title: Text('Composteiras'),
      ),
      body: Container(
          color: Colors.indigo.withOpacity(0.05),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(12.0),
          child: Consumer<ComposterRepository>(
              builder: (context, composters, child) {
            return composters.table.isEmpty
                ? ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Ainda não há Composteiras'),
                  )
                : ListView.separated(
                    itemBuilder: (BuildContext context, int composter) {
                      return ListTile(
                        leading: SizedBox(
                          child: Image.asset("images/composter_icon.png"),
                          width: 40,
                        ),
                        title: Text(
                          composters.table[composter].name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Text(composters.table[composter].startDate),
                        selected: false,
                      );
                    },
                    padding: EdgeInsets.all(16),
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: composters.table.length);
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ComposterRegistration();
        })),
        child: Icon(Icons.add),
      ),
    );
    */
    /*
    return Scaffold(
      appBar: AppBar(
        title: Text('Composteiras'),
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("composters/${authService.user!.uid}")
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.length == 0) {
            return Center(child: Text('Nenhuma Composteira cadastrada'));
          }

          return ListView.separated(
              itemBuilder: (BuildContext context, int composter) {
                return ListTile(
                  leading: SizedBox(
                    child: Image.asset("images/composter_icon.png"),
                    width: 40,
                  ),
                  title: Text(
                    snapshot.data?.docs[composter]["name"],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(snapshot.data?.docs[composter]["start_date"]),
                  selected: false,
                );
              },
              padding: EdgeInsets.all(16),
              separatorBuilder: (_, __) => Divider(),
              itemCount: snapshot.data!.docs.length);
        },
      ),
    );
    */
  }
}
