import 'package:flutter/material.dart';
import 'package:saudeapp/control/imcController.dart';

class RegistroIMC extends StatefulWidget {
  final Function(double, DateTime) onIMCUpdated;

  RegistroIMC({required this.onIMCUpdated});

  @override
  _RegistroIMCState createState() => _RegistroIMCState();
}

class _RegistroIMCState extends State<RegistroIMC> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final IMCController imcController = IMCController();

  double _imc = 0;

  void _calcularIMC() {
    final double peso = double.tryParse(_pesoController.text) ?? 0;
    final double altura = double.tryParse(_alturaController.text) ?? 0;

    if (peso > 0 && altura > 0) {
      setState(() {
        _imc = peso / (altura * altura);
      });
    }
  }

  void _registrarIMC() async {
    if (_imc > 0) {
      final DateTime now = DateTime.now();
      try {
        await imcController.registrarIMC(_imc, now);
        widget.onIMCUpdated(_imc, now);
        _pesoController.clear();
        _alturaController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('IMC registrado com sucesso!')),
        );
      } catch (e) {
        print('Erro ao registrar IMC: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar IMC.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira peso e altura válidos!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar IMC'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _calcularIMC(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _alturaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Altura (m)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _calcularIMC(),
            ),
            SizedBox(height: 32),
            Text(
              'IMC: ${_imc.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _registrarIMC,
              child: Text('Registrar IMC'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
