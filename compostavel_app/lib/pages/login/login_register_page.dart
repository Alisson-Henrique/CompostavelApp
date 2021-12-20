import 'package:compostavel_app/models/user_data.dart';
import 'package:compostavel_app/pages/login/register_page.dart';
import 'package:compostavel_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  late String title;
  late String subTitle;
  late String actionButton;
  late String toggleButton;

  late UserData userData;

  @override
  void initState() {
    super.initState();
    setFormAction(isLogin);
  }

  setFormAction(bool login) {
    setState(() {
      isLogin = login;
      if (isLogin) {
        title = "CompoIFPB";
        actionButton = "Login";
        toggleButton = "Ainda não tem Conta? Cadastre-se";
        subTitle = "Bem Vindo!";
      } else {
        title = "Cadastre-se";
        actionButton = "Cadastrar";
        toggleButton = "Voltar ao Login";
        subTitle = "Bem Vindo!";
      }
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
              Visibility(
                visible: !isLogin,
                child: Padding(
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
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Senha Invalida!";
                      }
                      return null;
                    }),
              ),
              Visibility(
                visible: !isLogin,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: TextFormField(
                      controller: confirmPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirmar Senha",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black54,
                        ),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Senha Invalida!";
                        }
                        return null;
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (isLogin) {
                        login();
                      } else {
                        userData = new UserData(name: name.text);
                        register();
                      }
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
                onPressed: () => setFormAction(!isLogin),
                child: Text(
                  toggleButton,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Visibility(
                visible: isLogin,
                child: TextButton(
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
                      },
                    );
                  },
                  child: Text(
                    "Recuperar Senha",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
