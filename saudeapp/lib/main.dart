import 'package:flutter/material.dart';
import 'package:saudeapp/view/Home.dart';
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
      title: 'Projeto App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define as rotas aqui
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/cadastro': (context) => Cadastro(),
        
      },
    );
  }
}
