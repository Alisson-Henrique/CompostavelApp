import 'package:compostavel_app/pages/badge/badge_list_page.dart';
import 'package:compostavel_app/pages/donation/donation_list_made_page.dart';
import 'package:compostavel_app/pages/tutorial/tutorial_list_page.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDonorPage extends StatefulWidget {
  HomeDonorPage({Key? key}) : super(key: key);

  @override
  _HomeDonorPageState createState() => _HomeDonorPageState();
}

class _HomeDonorPageState extends State {
  @override
  Widget build(BuildContext context) {
    UserDataRepository userDataRepository =
        Provider.of<UserDataRepository>(context);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Doador"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return DonationListMadePage(path: "Feitas");
                })),
                style: OutlinedButton.styleFrom(primary: Colors.red),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Doações",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TutorialListPage();
                })),
                style: OutlinedButton.styleFrom(primary: Colors.lightGreen),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Tutoriais",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () => {
                  userDataRepository.change = true,
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BadgeListPage(
                          userType: "Doador",
                        );
                      },
                    ),
                  ),
                },
                style: OutlinedButton.styleFrom(primary: Colors.lightBlue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.turned_in),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Conquistas",
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
