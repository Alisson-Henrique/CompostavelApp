import 'package:compostavel_app/models/composter.dart';
import 'package:compostavel_app/models/visitation.dart';
import 'package:compostavel_app/pages/visitation/register_visitation_page.dart';
import 'package:compostavel_app/pages/visitation/visitation_details_page.dart';
import 'package:compostavel_app/repositories/composter_repository.dart';
import 'package:compostavel_app/repositories/visitation_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComposterVisitationPage extends StatefulWidget {
  Composter composter;
  ComposterVisitationPage({Key? key, required this.composter})
      : super(key: key);

  @override
  _ComposterVisitationState createState() => _ComposterVisitationState();
}

class _ComposterVisitationState extends State<ComposterVisitationPage> {
  late VisitationRepository visitationRepository;
  @override
  Widget build(BuildContext context) {
    visitationRepository = context.watch<VisitationRepository>();
    visitationRepository.readVisitations(widget.composter.name);
    List<Visitation> visitations = visitationRepository.getVisitations();

    Future<void> _reloadList() async {
      setState(() {
        visitationRepository.readVisitations(widget.composter.name);
        visitations = visitationRepository.getVisitations();
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _reloadList,
        child: ListView.separated(
            itemBuilder: (BuildContext context, int visitation) {
              return ListTile(
                leading: SizedBox(
                  child: Image.asset("images/composter_icon.png"),
                  width: 40,
                ),
                title: Text(
                  visitations[visitation].name,
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
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          visitationRepository.remove(
                              widget.composter.name, visitations[visitation]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          visitationRepository.remove(
                              widget.composter.name, visitations[visitation]);
                        },
                      ),
                    ],
                  ),
                ),
                selected: false,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return VisitationDetailsPage(
                        visitation: visitations[visitation]);
                  }),
                ),
              );
            },
            padding: EdgeInsets.all(16),
            separatorBuilder: (_, __) => Divider(),
            itemCount: visitations.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.add),
      ),
    );
  }
}
