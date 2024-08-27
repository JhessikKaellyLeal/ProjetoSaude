import 'package:flutter/material.dart';
import 'package:saudeapp/view/BeberAgua.dart';
import 'package:saudeapp/view/ControledeMedidas.dart';
import 'package:saudeapp/view/Home.dart';
import 'package:saudeapp/view/RegistroIMC.dart';
import 'view/Login.dart';
import 'view/Register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde +',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define as rotas aqui
      initialRoute: '/',
      routes: {
        '/': (context) => Login(), //tela login
        '/cadastro': (context) => Cadastro(), //tela cadastro
        '/home' : (context) => Home(), //tela home
        '/registroIMC' : (context) => RegistroIMC(onIMCUpdated: (double , DateTime ) {  },),
        '/controlemedidas' : (context) => ControleMedidas(),
        '/beberagua' : (context) => BeberAgua(),
      },
    );
  }
}
