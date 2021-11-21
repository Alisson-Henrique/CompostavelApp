class Donation {
  String id;
  String recipientEmail;
  String senderEmail;
  int weight;
  String collenctionDate;
  String hours;
  String note;
  String status;
  String addressId;

  Donation({
    required this.id,
    required this.recipientEmail,
    required this.senderEmail,
    required this.weight,
    required this.collenctionDate,
    required this.hours,
    required this.note,
    required this.status,
    required this.addressId,
  });
}
