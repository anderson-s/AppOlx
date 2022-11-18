import 'dart:ffi';
import 'dart:io';

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
  List<File> imagens = [];
  String dropdownValue = Estados.listaEstadosSigla[0];

  _validarcampos() {
    if (_formKey.currentState!.validate()) {}
  }

  _pegarImagem() {}

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: imagens,
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imagens.length + 1,
                            itemBuilder: (context, index) {
                              if (index == imagens.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _pegarImagem(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                // return Text("data");
                              }
                              return Container();
                            },
                          ),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          )
                      ],
                    );
                  },
                  validator: (imgs) {
                    if (imgs!.length == 0) {
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                ),
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
