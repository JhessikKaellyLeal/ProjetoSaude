import 'package:sqflite/sqflite.dart';
import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/IMCModel.dart';

class IMCController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Método para salvar um novo registro de IMC
  Future<int> registrarIMC(int userId, double imcValue, DateTime date) async {
    final db = await _databaseHelper.database;
    final imc = IMCModel(
      id: null, // id será gerado automaticamente
      idusuario: userId,
      imc: imcValue,
      data: date,
    );
    return await db.insert('imc', imc.toMap());
  }

  // Método para buscar todos os registros de IMC de um usuário específico
  Future<List<IMCModel>> getIMCRecordsByUserId(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'imc',
      where: 'idusuario = ?',
      whereArgs: [userId],
      orderBy: 'data ASC',
    );

    return List.generate(maps.length, (i) {
      return IMCModel(
        id: maps[i]['id'],
        idusuario: maps[i]['idusuario'],
        imc: maps[i]['valor'], // Corrigido aqui: mapeia corretamente o valor do IMC
        data: DateTime.parse(maps[i]['data']),
      );
    });
  }

  // Método para buscar um registro de IMC por ID
  Future<IMCModel?> getIMCById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'imc',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return IMCModel(
        id: maps.first['id'],
        idusuario: maps.first['idusuario'],
        imc: maps.first['valor'], // Corrigido aqui
        data: DateTime.parse(maps.first['data']),
      );
    } else {
      return null;
    }
  }

  // Método para atualizar um registro de IMC existente
  Future<int> updateIMC(IMCModel imc) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'imc',
      imc.toMap(),
      where: 'id = ?',
      whereArgs: [imc.id],
    );
  }

  // Método para deletar um registro de IMC
  Future<int> deleteIMC(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'imc',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para buscar todos os registros de IMC
  Future<List<IMCModel>> getAllIMCRecords() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('imc');

    return List.generate(maps.length, (i) {
      return IMCModel(
        id: maps[i]['id'],
        idusuario: maps[i]['idusuario'],
        imc: maps[i]['valor'], // Corrigido aqui
        data: DateTime.parse(maps[i]['data']),
      );
    });
  }
}
