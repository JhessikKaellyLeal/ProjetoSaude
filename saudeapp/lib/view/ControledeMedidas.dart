import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saudeapp/control/bancoDados.dart';
import 'dart:io';

class ControleMedidas extends StatefulWidget {
  @override
  _ControleMedidasState createState() => _ControleMedidasState();
}

class _ControleMedidasState extends State<ControleMedidas> {
  final TextEditingController _cinturaController = TextEditingController();
  final TextEditingController _quadrilController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();
  final List<MedidaCorporal> _medidas = [];

  void _adicionarMedida({bool fromCamera = false}) async {
    final double cintura = double.tryParse(_cinturaController.text) ?? 0;
    final double quadril = double.tryParse(_quadrilController.text) ?? 0;

    if (cintura > 0 && quadril > 0) {
      final XFile? image = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (image != null) {
        await dbHelper.addMeasurement(
          cintura,
          quadril,
          DateTime.now(),
          image.path,
        ); // Salvar no banco de dados

        setState(() {
          _medidas.add(MedidaCorporal(
            cintura: cintura,
            quadril: quadril,
            data: DateTime.now(),
            imagePath: image.path,
          ));
        });

        _cinturaController.clear();
        _quadrilController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor, insira valores válidos para cintura e quadril!')),
      );
    }
  }

  void _mostrarImagem(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizarImagem(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Medidas Corporais'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _cinturaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cintura (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _quadrilController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quadril (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _adicionarMedida(fromCamera: true),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Capturar Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () => _adicionarMedida(fromCamera: false),
                    icon: Icon(Icons.photo_library),
                    label: Text('Selecionar da Galeria'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _medidas.length,
                itemBuilder: (context, index) {
                  final medida = _medidas[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        'Cintura: ${medida.cintura} cm, Quadril: ${medida.quadril} cm',
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Data: ${medida.data.day}/${medida.data.month}/${medida.data.year}',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Icon(Icons.image),
                      onTap: () => _mostrarImagem(medida.imagePath),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedidaCorporal {
  final double cintura;
  final double quadril;
  final DateTime data;
  final String imagePath;

  MedidaCorporal({
    required this.cintura,
    required this.quadril,
    required this.data,
    required this.imagePath,
  });
}

class VisualizarImagem extends StatelessWidget {
  final String imagePath;

  VisualizarImagem({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagem'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
