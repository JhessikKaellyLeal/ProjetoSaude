import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentWaterIntake = 0;

  void _incrementWaterIntake() {
    setState(() {
      _currentWaterIntake += 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Peso e IMC'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Lógica para seleção do menu
            },
            itemBuilder: (BuildContext context) {
              return {'Perfil', 'Configurações', 'Sair'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Evolução de Peso e IMC',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(),
                series: <ChartSeries>[
                  LineSeries<WeightData, int>(
                    dataSource: <WeightData>[
                      WeightData(0, 70),
                      WeightData(1, 69.5),
                      WeightData(2, 69),
                      WeightData(3, 68.8),
                      WeightData(4, 68.5),
                      WeightData(5, 68.3),
                    ],
                    xValueMapper: (WeightData data, _) => data.week,
                    yValueMapper: (WeightData data, _) => data.weight,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Registro de Água',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Consumo diário: $_currentWaterIntake ml',
              style: TextStyle(fontSize: 20, color: Colors.green.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementWaterIntake,
        child: Icon(Icons.local_drink),
        backgroundColor: Colors.green.shade700,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Desenvolvido por Jhessik Kaelly Bezerra Leal - 2024',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class WeightData {
  final int week;
  final double weight;

  WeightData(this.week, this.weight);
}
