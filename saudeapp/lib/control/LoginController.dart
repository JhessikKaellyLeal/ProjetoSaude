import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/user.dart';
import 'package:sqflite/sqflite.dart';

class LoginController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Método para autenticar o usuário com email e senha
  Future<User?> loginWithEmailAndPassword(String email, String senha) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null; // Retorna null se as credenciais forem inválidas
    }
  }

  // Método para login com Google
}
