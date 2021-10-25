import 'composter_state.dart';

class Visitation {
  int id;
  String name;
  int? temperature;
  int? ph;
  int? moisture;
  String? date;
  String? note;
  String? composterState;

  Visitation(
      {required this.id,
      required this.name,
      this.date,
      this.temperature,
      this.ph,
      this.composterState,
      this.note,
      this.moisture});
}
