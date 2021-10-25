import 'package:compostavel_app/models/address.dart';

import 'composter_state.dart';

class Composter {
  String name;
  int? temperature;
  int? ph;
  int? moisture;
  String? lastDateUpdate;
  String startDate;
  Address? andress;
  String? composterState;
  String? note;
  int? visitationIdLastUpdate;

  Composter({
    required this.name,
    required this.startDate,
    this.temperature,
    this.ph,
    this.lastDateUpdate,
    this.composterState,
    this.note,
    this.visitationIdLastUpdate,
    this.moisture,
  });

  factory Composter.fromJson(Map<String, dynamic> json) {
    return Composter(
      name: json['name'],
      startDate: json['start_data'],
    );
  }
}
