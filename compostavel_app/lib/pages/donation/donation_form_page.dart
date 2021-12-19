import 'package:compostavel_app/models/address.dart';
import 'package:compostavel_app/models/donation.dart';
import 'package:compostavel_app/repositories/address_repository.dart';
import 'package:compostavel_app/repositories/donation_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

class DonationFormPage extends StatefulWidget {
  Donation? donation;
  DonationFormPage({Key? key, this.donation}) : super(key: key);

  @override
  _DonationFormPageState createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  final formKey = GlobalKey<FormState>();
  final recipientEmail = TextEditingController();
  final weight = TextEditingController();
  final collenctionDate = MaskedTextController(mask: '00/00/0000');
  final hours = MaskedTextController(mask: '00:00');
  final note = TextEditingController();

  bool isLoading = false;
  bool edit = false;
  late DonationRepository donationRepository;
  late Donation donation;

  late AddressRepository addressRepository;
  String? valueChoice;

  @override
  Widget build(BuildContext context) {
    donationRepository = context.watch<DonationRepository>();
    save() async {
      try {
        if (valueChoice != null) {
          Address? address = addressRepository.getAddressesByName(valueChoice);
          await donationRepository.save(donation, address);
          setState(() {
            recipientEmail.text = "";
            weight.text = "";
            collenctionDate.text = "";
            hours.text = "";
            note.text = "";
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Doação agendada com Sucesso!")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Selecione um Endereço")));
        }
      } on DonationException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }

    if (widget.donation != null) {
      recipientEmail.text = widget.donation!.recipientEmail;
      weight.text = widget.donation!.weight.toString();
      collenctionDate.text = widget.donation!.collenctionDate;
      hours.text = widget.donation!.hours;
      note.text = widget.donation!.note;
      edit = true;
    }

    addressRepository = context.watch<AddressRepository>();
    addressRepository.readAddress();
    List listItem = addressRepository.getAddressesNames();

    return Scaffold(
      appBar: AppBar(
        title: Text("Fazer Doação"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                  child: TextFormField(
                      controller: recipientEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email Destinatário",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "O Email Destinatário vazío";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      controller: weight,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Peso",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String patttern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (regExp.hasMatch(value!)) {
                          return "O peso só deve conter dígitos";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      controller: collenctionDate,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Data de Coleta",
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "A data de Coleta está vazia";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      controller: hours,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Horas",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String patttern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (regExp.hasMatch(value!)) {
                          return "As horas só deve conter dígitos";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: DropdownButton(
                    hint: Text("Selecione o Endereço"),
                    value: valueChoice,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        valueChoice = newValue as String?;
                      });
                    },
                    items: listItem.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                      controller: note,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Descrição",
                      ),
                      keyboardType: TextInputType.text),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (!edit) {
                          donation = Donation(
                            id: "",
                            recipientEmail: recipientEmail.text,
                            senderEmail: "",
                            weight: int.parse(weight.text),
                            collenctionDate: collenctionDate.text,
                            hours: hours.text,
                            note: note.text,
                            status: "AGENDADA",
                            addressId: valueChoice.toString(),
                          );
                        } else {
                          donation = Donation(
                            id: widget.donation!.id,
                            recipientEmail: recipientEmail.text,
                            senderEmail: widget.donation!.senderEmail,
                            weight: int.parse(weight.text),
                            collenctionDate: collenctionDate.text,
                            hours: hours.text,
                            note: note.text,
                            status: widget.donation!.status,
                            addressId: valueChoice.toString(),
                          );
                        }
                        save();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (isLoading)
                          ? [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              Icon(Icons.check),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Fazer",
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
        ),
      ),
    );
  }
}
