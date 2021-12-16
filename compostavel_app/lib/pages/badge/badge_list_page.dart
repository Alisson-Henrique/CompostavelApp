import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/repositories/badge_repository.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BadgeListPage extends StatefulWidget {
  String userType;
  BadgeListPage({Key? key, required this.userType}) : super(key: key);

  @override
  _BadgeListPageState createState() => _BadgeListPageState();
}

class _BadgeListPageState extends State<BadgeListPage> {
  late UserData userData;

  @override
  Widget build(BuildContext context) {
    BadgeRepository badgeRepository = Provider.of<BadgeRepository>(context);

    UserDataRepository userDataRepository =
        Provider.of<UserDataRepository>(context);

    Future.delayed(Duration.zero, () async {
      userDataRepository.read();
      userData = userDataRepository.getUserdata()!;
    });

    Stream<QuerySnapshot> _badgesStream =
        badgeRepository.getBadgesSnapShot(widget.userType);

    int badgeAmountType(String data) {
      int result = 0;
      switch (data) {
        case "doacao":
          result = userData.donateAmount!;
          break;

        case "composteira":
          result = userData.composterAmount!;
          break;

        case "composto":
          result = userData.compoundAmount!;
          break;

        case "colaboracao":
          result = userData.collaborationAmount!;
          break;

        case "visita":
          result = userData.visitAmount!;
          break;
      }

      return result;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Conquistas"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _badgesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data?.docs.length == 0) {
              return Center(child: Text('Nenhuma conquista cadastrado'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  leading: SizedBox(
                    child: Image.asset("images/medal_icon.png"),
                    width: 40,
                  ),
                  title: Text(
                    data['descricao'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Center(
                    child: SizedBox(
                      width: 300,
                      height: 20,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          LinearProgressIndicator(
                            value: badgeAmountType(data["contador"]) /
                                data['meta'],
                          ),
                          Center(
                            child: Text(
                                badgeAmountType(data["contador"]).toString() +
                                    "/" +
                                    data['meta'].toString()),
                          )
                        ],
                      ),
                    ),
                  ),
                  selected: false,
                  onTap: () => [],
                );
              }).toList(),
            );
          }),
    );
  }
}
