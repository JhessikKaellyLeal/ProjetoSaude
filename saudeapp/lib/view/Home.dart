import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'RegistroIMC.dart';
import 'ControledeMedidas.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:saudeapp/control/imcController.dart';
import 'package:saudeapp/control/userController.dart'; // Import para o UserController
import 'package:saudeapp/model/user.dart'; // Import para o modelo User

class Home extends StatefulWidget {
  final int userId; // Recebe o ID do usuário

  Home({required this.userId});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Uint8List profileImageBytes; // Imagem de perfil em bytes
  late bool hasProfileImage; // Verifica se a imagem de perfil existe
  List<_ChartData> imcData = [];
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final IMCController imcController = IMCController();
  final UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final records = await imcController.getIMCRecordsByUserId(widget.userId);
      setState(() {
        imcData = records.map((record) {
          final formattedDate = DateFormat('dd/MM').format(record.data);
          return _ChartData(formattedDate, record.imc);
        }).toList();
        _loadProfileImage(); // Carrega a imagem de perfil após carregar os dados do IMC
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  Future<void> _loadProfileImage() async {
    try {
      User? user = await userController.getUserById(widget.userId);
      if (user != null && user.profileImage != null) {
        setState(() {
          profileImageBytes = user.profileImage!;
          hasProfileImage = true;
        });
      } else {
        setState(() {
          hasProfileImage = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar a imagem de perfil: $e');
      setState(() {
        hasProfileImage = false;
      });
    }
  }

  void _updateIMC(double imc, DateTime date) {
    setState(() {
      final String formattedDate = DateFormat('dd/MM').format(date);
      imcData.add(_ChartData(formattedDate, imc));
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.green,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          // Página 1: Perfil do Usuário e Gráfico
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Foto de perfil centralizada
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: hasProfileImage
                        ? MemoryImage(profileImageBytes)
                        : AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                    child:
                        !hasProfileImage ? Icon(Icons.person, size: 50) : null,
                  ),
                  SizedBox(height: 20),

                  // Gráfico de evolução do IMC
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <LineSeries<_ChartData, String>>[
                        LineSeries<_ChartData, String>(
                          dataSource: imcData,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Página 2: Tela para Beber Água (Não foi fornecida anteriormente, assumo que seja uma tela similar a ControleMedidas)
          // Substitua pelo widget real ou adicione a tela apropriada aqui
          // Por exemplo, BeberAgua(userId: widget.userId),

          // Página 3: Controle de Medidas Corporais
          ControleMedidas(userId: widget.userId),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Gráfico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scale),
            label: 'Medidas',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistroIMC(
                onIMCUpdated: _updateIMC,
                userId: widget.userId, // Passando o userId corretamente aqui
              ),
            ),
          );
        },
        child: Icon(Icons.add_chart),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
