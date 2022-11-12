import 'package:flutter/material.dart';
import 'package:olx/controller/controller.dart';
import 'package:olx/view/components/input_textformfield.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  String msg = "";
  String botao = "Entrar";
  bool _valor = false;

  _validar() async {
    if (_email.text.isNotEmpty && _email.text.contains("@")) {
      if (_senha.text.isNotEmpty && _senha.text.length > 6) {
        if (_valor) {
          try {
            await Controller().cadastrar(_email.text, _senha.text).then(
                  (value) =>
                      Navigator.restorablePushReplacementNamed(context, "/"),
                );
          } catch (error) {
            return error;
          }
        } else {
          Controller().logar(_email.text, _senha.text);
        }
      } else {
        setState(() {
          msg = "A senha deve possuir no mínimo 6 caracteres!";
        });
      }
    } else {
      setState(() {
        msg = "Email inválido!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        // backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "logo.png",
                  height: 100,
                  width: 125,
                ),
                InpuTextFormField(
                  controller: _email,
                  tipo: TextInputType.emailAddress,
                  autofocus: false,
                  nome: "Email",
                  oculto: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InpuTextFormField(
                    autofocus: true,
                    controller: _senha,
                    tipo: TextInputType.visiblePassword,
                    nome: "Senha",
                    oculto: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Logar"),
                      Switch(
                          value: _valor,
                          onChanged: (bool valor) {
                            setState(() {
                              _valor = valor;
                              botao = "Entrar";
                              if (valor) {
                                botao = "Cadastrar";
                              }
                            });
                          }),
                      const Text("Cadastrar"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _validar();
                  },
                  style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all(
                    //   Colors.purple,
                    // ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(32, 20, 32, 20),
                    ),
                  ),
                  child: Text(
                    botao,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    msg,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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
