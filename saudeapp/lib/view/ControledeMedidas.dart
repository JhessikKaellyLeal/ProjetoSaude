import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saudeapp/control/MedidasCorporaisController.dart';
import 'dart:typed_data';
import 'package:saudeapp/model/medidasCorporais.dart';

class ControleMedidas extends StatefulWidget {
  final int userId; // Recebe o ID do usuário

  ControleMedidas({required this.userId});

  @override
  _ControleMedidasState createState() => _ControleMedidasState();
}

class _ControleMedidasState extends State<ControleMedidas> {
  final TextEditingController _cinturaController = TextEditingController();
  final TextEditingController _quadrilController = TextEditingController();
  final MedidaCorporalController _medidaController = MedidaCorporalController();
  final List<MedidaCorporal> _medidas = [];

  @override
  void initState() {
    super.initState();
    _carregarMedidas();
  }

  Future<void> _carregarMedidas() async {
    final medidas = await _medidaController.getMedidasByUserId(widget.userId);
    setState(() {
      _medidas.addAll(medidas);
    });
  }

  void _adicionarMedida({bool fromCamera = false}) async {
    final double cintura = double.tryParse(_cinturaController.text) ?? 0;
    final double quadril = double.tryParse(_quadrilController.text) ?? 0;

    if (cintura > 0 && quadril > 0) {
      final XFile? image = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (image != null) {
        final imageBytes = await image.readAsBytes();
        final userId = widget.userId;

        final id = await _medidaController.saveMedidaCorporal(
          MedidaCorporal(
            cintura: cintura,
            quadril: quadril,
            data: DateTime.now(),
            imagePath: imageBytes,
            idusuario: userId,
          ),
        );

        setState(() {
          _medidas.add(MedidaCorporal(
            id: id,
            cintura: cintura,
            quadril: quadril,
            data: DateTime.now(),
            imagePath: imageBytes,
            idusuario: userId,
          ));
        });

        _cinturaController.clear();
        _quadrilController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira valores válidos para cintura e quadril!'),
        ),
      );
    }
  }

  void _mostrarImagem(Uint8List imageBytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizarImagem(imageBytes: imageBytes),
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
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () => _adicionarMedida(fromCamera: false),
                    icon: Icon(Icons.photo_library),
                    label: Text('Selecionar da Galeria'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

class VisualizarImagem extends StatelessWidget {
  final Uint8List imageBytes;

  VisualizarImagem({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagem'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Image.memory(
          imageBytes,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
