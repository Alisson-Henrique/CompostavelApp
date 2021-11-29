import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/pages/composter_details_page.dart';
import 'package:compostavel_app/pages/composter_registration_page.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComposterListPage extends StatefulWidget {
  ComposterListPage({Key? key}) : super(key: key);

  @override
  _ComposterListPageState createState() => _ComposterListPageState();
}

class _ComposterListPageState extends State<ComposterListPage> {
  composterDetails(String composterName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComposterDetailsPage(composterName: composterName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ComposterRepository composterRepository =
        Provider.of<ComposterRepository>(context);
    AddressRepository addressRepository =
        Provider.of<AddressRepository>(context);

    final Stream<QuerySnapshot> _compostersStream =
        composterRepository.getCompostersSnapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Composteiras"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _compostersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data?.docs.length == 0) {
              return Center(child: Text('Nenhuma Composteira cadastrada'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  leading: SizedBox(
                    child: Image.asset("images/composteira.png"),
                    width: 40,
                  ),
                  title: Text(
                    data['nome'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      composterRepository.remove(data['nome']);
                    },
                  ),
                  subtitle: Text(data["estado_composteira"]),
                  selected: false,
                  onTap: () => composterDetails(data['nome']),
                );
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ComposterRegistration();
        })),
        child: Icon(Icons.add),
      ),
    );
  }
}
