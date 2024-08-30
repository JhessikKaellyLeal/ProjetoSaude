import 'package:flutter/material.dart';
import 'package:saudeapp/control/bancoDados.dart';

class BeberAgua extends StatefulWidget {
  @override
  _BeberAguaState createState() => _BeberAguaState();
}

class _BeberAguaState extends State<BeberAgua> {
  double waterIntake = 0;
  final DatabaseHelper dbHelper = DatabaseHelper();

  void addWater() async {
    setState(() {
      waterIntake += 200;
    });
    await dbHelper.addWater(200, DateTime.now()); // Salvar no banco de dados
  }

  void removeWater() async {
    setState(() {
      if (waterIntake >= 200) {
        waterIntake -= 200;
      }
    });
    await dbHelper.addWater(-200, DateTime.now()); // Salvar no banco de dados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Água'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Água Consumida: ${waterIntake.toStringAsFixed(0)} ml',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: addWater,
                  child: Text('Adicionar 200 ml'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: removeWater,
                  child: Text('Remover 200 ml'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
