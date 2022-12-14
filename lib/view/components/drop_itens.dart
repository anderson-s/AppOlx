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

  List<DropdownMenuItem<String>> listDropCategoriasItens = [  "Categoria",
    "Automóvel",
    "Imóvel",
    "Eletrônico",
    "Moda",
    "Esportes",].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: value == "Categoria"
                        ? const Color(0xff9c27b0)
                        : Colors.black,
                    fontSize: 20,
                  ),
                ),
              );
            }).toList();

  hintText(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Color(0xff9c27b0),
        fontSize: 20,
      ),
    );
  }

  retornarDropCategorias(Function(String?)? salvar, int opcao,
      [String? valor, Function(String?)? onChanged]) {
    return opcao == 0
        ? DropdownButtonFormField(
            items: listDropCategoriasItens,
            onChanged: (String? value) {
              dropdownValueCategoria = value!;
            },
            onSaved: salvar,
            validator: (value) {
              return Validador()
                  .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                  .valido(value);
            },
            hint: hintText("Categoria"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          )
        : DropdownButtonHideUnderline(
            child: Center(
              child: DropdownButton(
                iconEnabledColor: const Color(0xff9c27b0),
                items: listDropCategoriasItens,
                onChanged: onChanged,
                hint: hintText("Categorias"),
                value: valor!,
              ),
            ),
          );
  }

  retornarDropEstados(
      Function(String?)? mudar, Function(String?)? salvar, int opcao,
      [String? valor]) {
    final texto = hintText("Região");
    listDropEstadosItens.insert(
      0,
      DropdownMenuItem(
        value: "null",
        child: texto,
      ),
    );

    return opcao == 0
        ? DropdownButtonFormField(
            items: listDropEstadosItens,
            onChanged: mudar,
            validator: (value) {
              return Validador()
                  .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                  .valido(value);
            },
            hint: texto,
            onSaved: salvar,
          )
        : DropdownButtonHideUnderline(
            child: Center(
              child: DropdownButton(
                iconEnabledColor: const Color(0xff9c27b0),
                items: listDropEstadosItens,
                onChanged: mudar,
                hint: texto,
                value: valor!,
              ),
            ),
          );
  }
}
