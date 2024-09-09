import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saudeapp/control/medidasCorporaisController.dart';
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
  Uint8List? _selectedImage; // Para armazenar a imagem selecionada

  @override
  void initState() {
    super.initState();
    _carregarMedidas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Garantir que os dados sejam recarregados sempre que a tela for exibida
    _carregarMedidas();
  }

  Future<void> _carregarMedidas() async {
    final medidas = await _medidaController.getMedidasByUserId(widget.userId);
    setState(() {
      _medidas.clear();
      _medidas.addAll(medidas);
    });
  }

  Future<void> _adicionarImagem({bool fromCamera = false}) async {
    final XFile? image = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      final imageBytes = await image.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
      });
    }
  }

  Future<void> _salvarMedida() async {
    final double cintura = double.tryParse(_cinturaController.text) ?? 0;
    final double quadril = double.tryParse(_quadrilController.text) ?? 0;

    if (cintura > 0 && quadril > 0 && _selectedImage != null) {
      try {
        final id = await _medidaController.saveMedidaCorporal(
          MedidaCorporal(
            cintura: cintura,
            quadril: quadril,
            data: DateTime.now(),
            imagePath: _selectedImage!,
            idusuario: widget.userId,
          ),
        );

        setState(() {
          _medidas.add(MedidaCorporal(
            id: id,
            cintura: cintura,
            quadril: quadril,
            data: DateTime.now(),
            imagePath: _selectedImage!,
            idusuario: widget.userId,
          ));
          _cinturaController.clear();
          _quadrilController.clear();
          _selectedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Medida cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar medida!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira valores válidos para cintura, quadril e selecione uma imagem!'),
          backgroundColor: Colors.orange,
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
              SizedBox(height: 16),
              _selectedImage == null
                  ? Text('Nenhuma imagem selecionada.')
                  : Image.memory(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _adicionarImagem(fromCamera: true),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Capturar Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () => _adicionarImagem(fromCamera: false),
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
              ElevatedButton(
                onPressed: _salvarMedida,
                child: Text('Salvar Medida'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Cor do botão
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 32),
              _medidas.isEmpty
                  ? Text('Nenhuma medida registrada.')
                  : ListView.builder(
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
