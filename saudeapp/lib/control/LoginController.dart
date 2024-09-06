import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';


import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/user.dart';

// classe para realizar login do usuário
class LoginController {

  // chamando o banco de dados, DatabaseHelp é o nome 
  //do meu banco de dados, BancodeDados
 final DatabaseHelper _bancodedados = DatabaseHelper();

 // metodo de autenticação com e-mail e senha
 Future<User?> loginWithEmailPassword (String email, String senha) async{
    // startar a variavel de banco de dados para usar os metodos
      final db = await _bancodedados.database;

    // listar os usuários cadastrados no banco de dados
    // 'users' nome da tabela usuário do meu banco de dados
    final List<Map<String, dynamic>> lista = await db.query(
        'users', where: 'email =? AND senha=?',
        whereArgs: [email,senha],
    );//final da verificação de email e senha no banco de dados

    if(lista.isNotEmpty){
      return User.fromMap(lista.first);
      //se lista não for nula , retorne os dados do usuário
    }else{
      return null; 
      //se lista for nula, retorne null .
    }


 }// fim do metodo de autenticação com e-mail e senha

  
  
}
