import 'dart:convert';
import 'dart:typed_data';

import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/user.dart';
import 'package:sqflite/sqflite.dart';

class UserController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Método para salvar um novo usuário
  Future<int> addUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.insert('users', user.toMap());
  }

  // Método para buscar todos os usuários
  Future<List<User>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Método para buscar um usuário por ID
  Future<User?> getUserById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Método para atualizar um usuário existente
  Future<int> updateUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Método para deletar um usuário
  Future<int> deleteUser(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> saveProfileImage(int userId, Uint8List imageBytes) async {
    Database db = await _databaseHelper.database;

    await db.update(
      'users',
      {'profileImage': imageBytes},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Método para salvar a imagem de perfil
}
