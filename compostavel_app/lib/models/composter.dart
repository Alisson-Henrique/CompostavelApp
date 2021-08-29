import 'package:compostavel_app/models/address.dart';

class Composter {
  String name;
  int? temperature;
  int? ph;
  String? lastDateUpdate;
  String startDate;
  Andress? andress;
  Composter_State? composterState;
  String? note;

  Composter(
      {required this.name,
      required this.startDate,
      this.temperature,
      this.ph,
      this.lastDateUpdate,
      this.composterState,
      this.note});

  factory Composter.fromJson(Map<String, dynamic> json) {
    return Composter(
      name: json['name'],
      startDate: json['start_data'],
    );
  }
}

enum Composter_State {
  ATIVA,
  FINALIZADA,
}
