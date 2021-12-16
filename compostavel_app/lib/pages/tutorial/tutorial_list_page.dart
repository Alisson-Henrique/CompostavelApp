import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/tutorial.dart';
import 'package:compostavel_app/pages/tutorial/tutorial_details_page.dart';
import 'package:compostavel_app/repositories/tutorial_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorialListPage extends StatefulWidget {
  const TutorialListPage({Key? key}) : super(key: key);

  @override
  _TutorialListPageState createState() => _TutorialListPageState();
}

class _TutorialListPageState extends State<TutorialListPage> {
  @override
  Widget build(BuildContext context) {
    TutorialRepository tutorialRepository =
        Provider.of<TutorialRepository>(context);

    Stream<QuerySnapshot> _tutorialStream =
        tutorialRepository.getTutorialSnapShot();
    return Scaffold(
      appBar: AppBar(
        title: Text("Tutorias"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _tutorialStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data?.docs.length == 0) {
              return Center(child: Text('Nenhuma tutorial cadastrado'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  leading: SizedBox(
                    child: Image.asset("images/book_icon.png"),
                    width: 40,
                  ),
                  title: Text(
                    data['titulo'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: false,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return TutorialDetailsPage(
                          tutorial: Tutorial(
                              title: data['titulo'],
                              description: data['descricao'],
                              link: data['link']),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
