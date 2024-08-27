import 'package:flutter/material.dart';

class BeberAgua extends StatefulWidget {
  @override
  _BeberAguaState createState() => _BeberAguaState();
}

class _BeberAguaState extends State<BeberAgua> {
  double waterIntake = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beber Água'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Consumo diário de água: ${waterIntake.toStringAsFixed(0)} ml',
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: removeWater,
                    child: Icon(Icons.remove),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: addWater,
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
