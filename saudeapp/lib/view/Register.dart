import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saudeapp/control/UserController.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:saudeapp/model/user.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _dataNascimentoController =
    TextEditingController();
  String _sexo = 'Masculino';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _cadastroGoogle = false;
  File? _profileImage;
  Uint8List? _imageBytes;

  @override
  void dispose() {
    _pageController.dispose();
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _imageBytes = _profileImage!.readAsBytesSync();
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }










 /* void _salvarCadastro() async {

    try {
      UserController userController = UserController();

      User newUser = User(
        nome: _nomeController.text,
        cpf: _cpfController.text,
        dataNascimento: _dataNascimentoController.text,
        sexo: _sexo,
        email: _emailController.text,
        senha: _senhaController.text,
      );

      // Salvar o usuário
      int userId = await userController.addUser(newUser);

      // Salvar a imagem de perfil, se disponível
      if (_imageBytes != null) {
        await userController.saveProfileImage(userId, _imageBytes!);
      }

      // Limpar os campos
      _nomeController.clear();
      _cpfController.clear();
      _emailController.clear();
      _senhaController.clear();
      _dataNascimentoController.clear();

      setState(() {
        _sexo = 'Masculino';
        _cadastroGoogle = false;
        _currentIndex = 0;
        _profileImage = null;
        _imageBytes = null;
      });

      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dados salvos com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Retornar à tela de login (assumindo que é a primeira tela no stack)
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {
      // Mostrar mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar dados. Tente novamente.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }*/

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


//criar metodo para salvar cadastro
void salvarcadastro()async{
  // try catch serve para tratar erros
  try{ 
    // Objeto da classe user controller
    // variavel me permite chamar o metodo de salvar usuário
    UserController useController = UserController();
    
    // salvar os dados que o usuário digitou na classe model
    // User é minha classe model do usuário
    User usuario =User(
        nome: _nomeController.text,
        cpf: _cpfController.text,
        dataNascimento: _dataNascimentoController.text,
        sexo: _sexo,
        email: _emailController.text,
        senha: _senhaController.text,
    ); // final da inserção dos dados na classe model

    // salvar usuário 
    int userId = await useController.addUser(usuario);
    /* criando uma variavel do tipo int para guardar o id do novo
     usuario criado, e manda ao banco de dados através do
     metodo de adicionar um novo usuário*/

     //mensagem de sucesso para o cadastro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cadastro realizado com sucesso!"), 
          backgroundColor: Colors.green, //mensagem em caixa verde
          duration: Duration(seconds: 5),// mensagem dura 5 segundos
        ), 
      );

  }catch(e){ // mensagem de erro ao tentar cadastrar usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cadastro não realizado!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
  }// fim do try catch

}//final do metodo salvar cadastro


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Cadastro',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChanged,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showImageSourceOptions,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _cpfController,
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _dataNascimentoController,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _dataNascimentoController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _sexo,
                  onChanged: (String? newValue) {
                    setState(() {
                      _sexo = newValue!;
                    });
                  },
                  items: ['Masculino', 'Feminino', 'Outro']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _onItemTapped(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('Próximo'),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_cadastroGoogle) ...[
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                ],
                ElevatedButton(
                  onPressed: salvarcadastro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('Salvar Cadastro'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Informações Pessoais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Email e Senha',
          ),
        ],
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
