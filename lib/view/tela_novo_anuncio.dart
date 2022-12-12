import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/controller/controller.dart';
import 'package:olx/model/anuncio.dart';
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
  late Anuncio anuncio;
  late BuildContext _dialogContext;

  String dropdownValueEstados = "";
  String dropdownValueCategoria = "";
  List<String> categorias = [
    "Automóvel",
    "Imóvel",
    "Eletrônico",
    "Moda",
    "Esportes",
  ];
  _abrirModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Salvando anúncio...")
            ],
          ),
        );
      },
    );
  }

  _salvarAnuncio() async {
    _abrirModal(_dialogContext);
    try {
      List<String> urls = await Controller().uploadImagem(imagens, anuncio.id);
      anuncio.sFotos = urls;
      await Controller().salvarDadosAnuncios(anuncio.toMap()).then((value) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
    } catch (error) {
      Navigator.pop(_dialogContext);
    }
  }

  _validarcampos() {
    if (_formKey.currentState!.validate()) {
      //Usando o context
      setState(() {
        _dialogContext = context;
      });
      //Salvando campos
      _formKey.currentState!.save();
      //Salvando anuncio
      _salvarAnuncio();
    }
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
  void initState() {
    super.initState();
    anuncio = Anuncio.gerarId();
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
                        SizedBox(
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
                          onSaved: (estado) {
                            anuncio.sEstado = estado!;
                          },
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
                          onSaved: (categoria) {
                            anuncio.scategoria = categoria!;
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
                  padding: const EdgeInsets.all(8.0),
                  child: InputForm(
                    validar: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                    salvar: (titulo) {
                      anuncio.stitulo = titulo!;
                    },
                    tipo: TextInputType.text,
                    formato: const [],
                    nomeCampo: "Titulo",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputForm(
                    salvar: (preco) {
                      anuncio.sPreco = preco!;
                    },
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
                    salvar: (telefone) {
                      anuncio.sTelefone = telefone!;
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
                    salvar: (descricao) {
                      anuncio.sDescricao = descricao!;
                    },
                    tipo: TextInputType.text,
                    validar: (value) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(value);
                    },
                    formato: const [],
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
