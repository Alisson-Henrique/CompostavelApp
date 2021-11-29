import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/pages/visitation/seek_visit_list_page.dart';
import 'package:compostavel_app/repositories/visit_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeekVisitationPage extends StatefulWidget {
  const SeekVisitationPage({Key? key}) : super(key: key);

  @override
  _SeekVisitationPageState createState() => _SeekVisitationPageState();
}

class _SeekVisitationPageState extends State<SeekVisitationPage> {
  final formKey = GlobalKey<FormState>();
  final userEmail = TextEditingController();

  bool isLoading = false;
  String labelButton = "Buscar";

  @override
  Widget build(BuildContext context) {
    VisitReposiitory visitReposiitory = Provider.of<VisitReposiitory>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Composteira"),
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
                    controller: userEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email do Produtor",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "email vazio";
                      }
                      return null;
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SeekVisitLiistPage(
                          userEmail: userEmail.text,
                        );
                      }));
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
