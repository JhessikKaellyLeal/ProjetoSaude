import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/medidasCorporais.dart';

class MedidaCorporalController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> saveMedidaCorporal(MedidaCorporal medida) async {
    final db = await _databaseHelper.database;
    return await db.insert('medidas', medida.toMap());
  }

  Future<List<MedidaCorporal>> getMedidasByUserId(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medidas',
      where: 'idusuario = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return MedidaCorporal.fromMap(maps[i]);
    });
  }

  Future<MedidaCorporal?> getMedidaById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medidas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MedidaCorporal.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateMedidaCorporal(MedidaCorporal medida) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'medidas',
      medida.toMap(),
      where: 'id = ?',
      whereArgs: [medida.id],
    );
  }

  Future<int> deleteMedidaCorporal(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'medidas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
