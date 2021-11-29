import 'package:compostavel_app/pages/reporting/reporting_composter_page.dart';
import 'package:flutter/material.dart';

class ReportingListPage extends StatefulWidget {
  const ReportingListPage({Key? key}) : super(key: key);

  @override
  _ReportingListPageState createState() => _ReportingListPageState();
}

class _ReportingListPageState extends State<ReportingListPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Relatórios"),
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
                  return ReportingComposterPage();
                })),
                style: OutlinedButton.styleFrom(primary: Colors.green),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.house),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Composteiras",
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
