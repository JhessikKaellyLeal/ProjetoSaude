import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'RegistroIMC.dart';
import 'BeberAgua.dart';
import 'ControledeMedidas.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:saudeapp/control/imcController.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String profileImagePath; // Caminho da foto de perfil
  List<_ChartData> imcData = [];
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final IMCController imcController = IMCController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final records = await imcController.getIMCRecords();
      setState(() {
        profileImagePath = 'assets/images/profile.jpg';
        imcData = records.map((record) {
          final formattedDate = DateFormat('dd/MM').format(record.data);
          return _ChartData(formattedDate, record.imc);
        }).toList();
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
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
                    backgroundImage: FileImage(File(profileImagePath)),
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
          // Página 2: Tela para Beber Água
          BeberAgua(),
          // Página 3: Controle de Medidas Corporais
          ControleMedidas(),
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
            icon: Icon(Icons.local_drink),
            label: 'Água',
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
              builder: (context) => RegistroIMC(onIMCUpdated: _updateIMC),
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
