import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/view/components/botao_customizado.dart';
import 'package:olx/view/components/input_form.dart';
import 'package:validadores/validadores.dart';

class TelaNovoAnuncio extends StatefulWidget {
  const TelaNovoAnuncio({super.key});

  @override
  State<TelaNovoAnuncio> createState() => _TelaNovoAnuncioState();
}

class _TelaNovoAnuncioState extends State<TelaNovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  List<File> imagens = [];
  String dropdownValueEstados = "";
  String dropdownValueCategoria = "";
  List<String> categorias = [
    "Automóvel",
    "Imóvel",
    "Eletrônico",
    "Moda",
    "Esportes",
  ];
  _validarcampos() {
    if (_formKey.currentState!.validate()) {}
  }

  _pegarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageSelecionada =
        await picker.pickImage(source: ImageSource.gallery);

    if (imageSelecionada != null) {
      setState(() {
        imagens.add(File(imageSelecionada.path));
      });
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
                              if (imagens.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.file(imagens[index]),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      imagens.removeAt(index);
                                                    });
                                                    Navigator.of(context);
                                                  },
                                                  child: const Text(
                                                    "Remover",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          FileImage(imagens[index]),
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        if (state.hasError)
                          Text(
                            "[${state.errorText}]",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          )
                      ],
                    );
                  },
                  validator: (imgs) {
                    if (imgs!.isEmpty) {
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          items: Estados.listaEstadosSigla
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValueEstados = value!;
                            });
                          },
                          validator: (value) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(value);
                          },
                          hint: const Text("Estados"),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          items: categorias
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValueCategoria = value!;
                            });
                          },
                          validator: (value) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(value);
                          },
                          hint: const Text("Categorias"),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InputForm(
                    validar: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                    tipo: TextInputType.text,
                    formato: [],
                    nomeCampo: "Titulo",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputForm(
                    validar: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                    tipo: TextInputType.number,
                    formato: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(),
                    ],
                    nomeCampo: "Preço",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputForm(
                    validar: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                    tipo: TextInputType.phone,
                    formato: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    nomeCampo: "Telefone",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputForm(
                    tipo: TextInputType.text,
                    validar: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                    formato: [],
                    nomeCampo: "Descrição",
                  ),
                ),
                BotaoCustomizado(
                  funcao: _validarcampos,
                  texto: "Cadastrar",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
