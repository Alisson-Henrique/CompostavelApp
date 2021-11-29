import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/pages/home_donor_page.dart';
import 'package:compostavel_app/pages/my_data_page.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'composter/composter_list_page.dart';
import 'home_producer_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: pageIndex);
  }

  setCurrentPage(page) {
    setState(() {
      pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          HomeDonorPage(),
          HomeProducerPage(),
          MyDataPage(),
        ],
        onPageChanged: setCurrentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Doador"),
          BottomNavigationBarItem(
              icon: Icon(Icons.agriculture), label: "Produtor"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Meus Dados"),
        ],
        onTap: (page) {
          pc.animateToPage(
            page,
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        backgroundColor: Colors.lightGreen[100],
      ),
    );
  }
}
