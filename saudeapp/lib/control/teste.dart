import 'package:saudeapp/control/UserController.dart';
import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/user.dart';

void main() async {
  final dbHelper = DatabaseHelper();
  final userController = UserController();

  // Teste: Adicionar um usuário
  User newUser = User(nome: "Alice",cpf: "000.090.090-00", dataNascimento: "12/10/2001",sexo: "feminino", email: "alice@example.com",senha:"12345678",profileImage: null);
  await userController.saveUser(newUser);

  // Teste: Listar todos os usuários
  List<User> users = await userController.getAllUsers();
  for (User user in users) {
    print('Usuário ID: ${user.id}, Nome: ${user.nome}, Email: ${user.email}');
  }
}
