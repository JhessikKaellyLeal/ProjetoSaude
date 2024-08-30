import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/imcModel.dart';
import 'package:sqflite/sqflite.dart';

class IMCController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> registrarIMC(double imc, DateTime data) async {
    final db = await _databaseHelper.database;
    final imcModel = IMCModel(imc: imc, data: data);
    await db.insert('imc', imcModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<IMCModel>> getIMCRecords() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('imc');

    return List.generate(maps.length, (i) {
      return IMCModel(
        id: maps[i]['id'],
        imc: maps[i]['valor'], // Use 'valor' em vez de 'imc'
        data: DateTime.parse(maps[i]['data']),
      );
    });
  }
}
