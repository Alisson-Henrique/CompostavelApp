enum Type_User { PRODUCER, DONOR }

class UserData {
  String name;
  String? email;
  int? donateAmount;
  int? composterAmount;
  int? visitAmount;
  int? compoundAmount;
  int? collaborationAmount;

  UserData({
    required this.name,
    this.email,
    this.donateAmount,
    this.composterAmount,
    this.visitAmount,
    this.compoundAmount,
    this.collaborationAmount,
  });
}
