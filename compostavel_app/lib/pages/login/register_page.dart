import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/pages/login/login_page.dart';
import 'package:compostavel_app/repositories/user_data_repository.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key, Type_User? typeUsert}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  late UserDataRepository userDataRepository;
  bool isLoading = false;
  late UserData userData;
  @override
  void initState() {
    super.initState();
  }

  register() async {
    setState(() => isLoading = true);

    try {
      await context
          .read<AuthService>()
          .register(email.text, password.text, confirmPassword.text, userData);
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userDataRepository = context.watch<UserDataRepository>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Cadastre-se",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nome",
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        String patttern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (value!.isEmpty) {
                          return "Nome vazio";
                        } else if (!regExp.hasMatch(value)) {
                          return "O nome deve conter caracteres de a-z ou A-Z";
                        }
                        return null;
                      })),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email Invalido!";
                      }
                      return null;
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Senha",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: TextFormField(
                  controller: confirmPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirmar Senha",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      userData = new UserData(name: name.text);

                      register();

                      Navigator.pop(context);
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
                                "Cadastrar",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
