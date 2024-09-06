import 'dart:convert';
import 'dart:typed_data';

class User {
  int? id;
  String nome;
  String cpf;
  String dataNascimento;
  String sexo;
  String email;
  String senha;
  Uint8List? profileImage;

//construtor
  User({
    this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.sexo,
    required this.email,
    required this.senha,
    this.profileImage,
  });

  // Método para converter os dados do usuário para um mapa (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'sexo': sexo,
      'email': email,
      'senha': senha,
      'profileImage': profileImage != null ? base64Encode(profileImage!) : null,
    };
  }

  // Método para criar um objeto User a partir de um mapa (do SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      dataNascimento: map['dataNascimento'],
      sexo: map['sexo'],
      email: map['email'],
      senha: map['senha'],
      profileImage: map['profileImage'] != null
          ? (map['profileImage'] as Uint8List)
          : null,
    );
  }
}
