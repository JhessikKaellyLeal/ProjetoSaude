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

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      return googleUser;
    } catch (e) {
      // Handle the error here
      print('Error signing in with Google: $e');
      return null;
    }
  }
  // Implementação futura: Método para login com Google (pode usar GoogleSignIn package)
}
