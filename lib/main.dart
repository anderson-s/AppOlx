import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/firebase_options.dart';
import 'package:olx/model/utils/rotas.dart';
import 'package:olx/view/tela_inicio.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final tema = ThemeData();
  runApp(
    MaterialApp(
      title: "OLX",
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      home: const TelaInicio(),
      onGenerateRoute: Rotas.gerar,
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: const Color(0xff9c27b0),
          secondary: const Color(0xff7b1fa2),
        ),
      ),
    ),
  );
}
