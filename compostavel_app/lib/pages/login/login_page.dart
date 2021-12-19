import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/pages/login/register_page.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  late String title;
  late String subTitle;
  late String actionButton;
  late String toggleButton;

  @override
  void initState() {
    super.initState();
    setFormAction();
  }

  setFormAction() {
    setState(() {
      title = "CompoIFPB";
      actionButton = "Login";
      toggleButton = "Novo Cadastro";
      subTitle = "Bem Vindo!";
    });
  }

  login() async {
    setState(() => isLoading = true);
    try {
      await context.read<AuthService>().login(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                    color: Colors.green),
              ),
              Text(
                subTitle,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black54,
                      ),
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
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Senha",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.black54,
                      ),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      login();
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
                                actionButton,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return RegisterPage(
                        typeUsert: Type_User.PRODUCER,
                      );
                    }),
                  );
                },
                child: Text(
                  toggleButton,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Recuperar senha?",
                          ),
                          actions: [
                            MaterialButton(
                              child: Text("Sim",
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () => {
                                if (formKey.currentState!.validate())
                                  {
                                    context
                                        .read<AuthService>()
                                        .recoverPassword(email.text),
                                    Navigator.pop(context),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Um email de recuperação de senha foi enviado para seu email")))
                                  }
                              },
                            ),
                            MaterialButton(
                              child: Text("Não",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () => {Navigator.pop(context)},
                            )
                          ],
                        );
                      });
                },
                child: Text(
                  "Recuperar Senha",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
