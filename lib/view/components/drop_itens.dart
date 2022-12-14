import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:validadores/Validador.dart';

class ConfiguracoesItensDrop {
  String dropdownValueCategoria = "";

  List<String> categorias = [
    "Categoria",
    "Automóvel",
    "Imóvel",
    "Eletrônico",
    "Moda",
    "Esportes",
  ];

  List<DropdownMenuItem<String>> listDropEstadosItens =
      Estados.listaEstadosSigla.map<DropdownMenuItem<String>>(
    (String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(
            color: value == "Estados" ? const Color(0xff9c27b0) : Colors.black,
            fontSize: 20,
          ),
        ),
      );
    },
  ).toList();

  retornarDropCategorias(Function(String?)? salvar) {
    return DropdownButtonFormField(
      items: categorias.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color:
                  value == "Categoria" ? const Color(0xff9c27b0) : Colors.black,
              fontSize: 20,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        dropdownValueCategoria = value!;
      },
      onSaved: salvar,
      validator: (value) {
        return Validador()
            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
            .valido(value);
      },
      hint: const Text(
        "Categoria",
        style: TextStyle(
          color: Color(0xff9c27b0),
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    );
  }

  retornarDropEstados(
    Function(String?)? mudar,
    Function(String?)? salvar,
  ) {
    listDropEstadosItens.insert(
      0,
      const DropdownMenuItem(
        value: null,
        child: Text(
          "Região",
          style: TextStyle(
            color: Color(0xff9c27b0),
            fontSize: 20,
          ),
        ),
      ),
    );
    return DropdownButtonFormField(
      items: listDropEstadosItens,
      onChanged: mudar,
      validator: (value) {
        return Validador()
            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
            .valido(value);
      },
      hint: const Text(
        "Região",
        style: TextStyle(
          color: Color(0xff9c27b0),
          fontSize: 20,
        ),
      ),
      onSaved: salvar,
    );
  }
}
