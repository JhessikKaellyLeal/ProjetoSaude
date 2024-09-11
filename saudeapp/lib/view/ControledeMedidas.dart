import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saudeapp/control/medidasCorporaisController.dart';
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
  String? _selectedImageUrl; // Armazena a URL da imagem selecionada

  @override
  void initState() {
    super.initState();
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
      final imageUrl = await uploadImage(
          imageBytes); // Enviar imagem para armazenamento e obter URL

      setState(() {
        _selectedImageUrl = imageUrl;
      });
    }
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    // Implementar lógica para upload da imagem e retornar o URL
    // Placeholder para URL de imagem
    return 'https://example.com/image.jpg';
  }

  Future<void> _salvarMedida() async {
    final double cintura = double.tryParse(_cinturaController.text) ?? 0;
    final double quadril = double.tryParse(_quadrilController.text) ?? 0;

    if (cintura > 0 && quadril > 0 && _selectedImageUrl != null) {
      try {
        final id = await _medidaController.saveMedidaCorporal(
          MedidaCorporal(
            cintura: cintura,
            quadril: quadril,
            data: DateTime.now(),
            imagemUrl: _selectedImageUrl!, // Utiliza URL da imagem
            idusuario: widget.userId,
          ),
        );

        setState(() {
          _medidas.add(MedidaCorporal(
            id: id,
            cintura: cintura,
            quadril: quadril,
            data: DateTime.now(),
            imagemUrl: _selectedImageUrl!,
            idusuario: widget.userId,
          ));
          _cinturaController.clear();
          _quadrilController.clear();
          _selectedImageUrl = null;
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
            content: Text('Erro ao cadastrar medida! $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Por favor, insira valores válidos para cintura, quadril e selecione uma imagem!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _mostrarImagem(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizarImagem(imageUrl: imageUrl),
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
              _selectedImageUrl == null
                  ? Text('Nenhuma imagem selecionada.')
                  : Image.network(
                      _selectedImageUrl!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _adicionarImagem(fromCamera: true),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Câmera'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _adicionarImagem(),
                    icon: Icon(Icons.image),
                    label: Text('Galeria'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarMedida,
                child: Text('Salvar Medida'),
              ),
              SizedBox(height: 16),
              Text(
                'Medidas Registradas:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold), // Estilo genérico
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _medidas.length,
                itemBuilder: (context, index) {
                  final medida = _medidas[index];
                  return ListTile(
                    title: Text(
                        'Cintura: ${medida.cintura} cm, Quadril: ${medida.quadril} cm'),
                    subtitle: Text('Data: ${medida.data.toLocal()}'),
                    leading: medida.imagemUrl.isNotEmpty
                        ? GestureDetector(
                            onTap: () => _mostrarImagem(medida.imagemUrl),
                            child: Image.network(
                              medida.imagemUrl,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirmar Exclusão'),
                              content:
                                  Text('Deseja realmente excluir esta medida?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('Sim'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Não'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm == true) {
                          await _medidaController
                              .deleteMedidaCorporal(medida.id!);
                          setState(() {
                            _medidas.removeAt(index);
                          });
                        }
                      },
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
  final String imageUrl;

  VisualizarImagem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Imagem'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
