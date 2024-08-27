import 'package:flutter/material.dart';
import 'package:saudeapp/view/ControledeMedidas.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'RegistroIMC.dart';
import 'ControledeMedidas.dart'; // Certifique-se de que este import está correto
import 'BeberAgua.dart'; // Certifique-se de que este import está correto
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double waterIntake = 0;

  List<_ChartData> imcData = [
    _ChartData('Sem 1', 20),
    _ChartData('Sem 2', 22),
    _ChartData('Sem 3', 19),
    _ChartData('Sem 4', 21),
    _ChartData('Sem 5', 18),
  ];

  void addWater() {
    setState(() {
      waterIntake += 200;
    });
  }

  void removeWater() {
    setState(() {
      if (waterIntake >= 200) {
        waterIntake -= 200;
      }
    });
  }

  void _updateIMC(double imc, DateTime date) {
    setState(() {
      final String formattedDate = DateFormat('dd/MM').format(date);
      imcData.add(_ChartData(formattedDate, imc));
    });
  }

  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
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
          BeberAgua(), // Substitua pelo nome correto da classe
          // Página 3: Controle de Medidas Corporais
          ControleMedidas(), // Substitua pelo nome correto da classe
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
