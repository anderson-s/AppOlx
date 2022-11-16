import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/view/components/botao_customizado.dart';
import 'package:olx/view/components/input_form.dart';

class TelaNovoAnuncio extends StatefulWidget {
  const TelaNovoAnuncio({super.key});

  @override
  State<TelaNovoAnuncio> createState() => _TelaNovoAnuncioState();
}

class _TelaNovoAnuncioState extends State<TelaNovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = Estados.listaEstadosSigla[0];

  _validarcampos() {
    if(_formKey.currentState!.validate()){

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward_outlined),
                      elevation: 16,
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: Estados.listaEstadosSigla
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const InputForm(
                  tipo: TextInputType.text,
                  formato: [],
                  nomeCampo: "Titulo",
                ),
                InputForm(
                  tipo: TextInputType.number,
                  formato: [
                    FilteringTextInputFormatter.digitsOnly,
                    RealInputFormatter(),
                  ],
                  nomeCampo: "Preço",
                ),
                InputForm(
                  tipo: TextInputType.number,
                  formato: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  nomeCampo: "Telefone",
                ),
                const InputForm(
                  tipo: TextInputType.text,
                  formato: [],
                  nomeCampo: "Descrição",
                ),
                BotaoCustomizado(funcao: _validarcampos, texto: "Cadastrar")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
