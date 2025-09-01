import 'package:flutter/material.dart';
import 'package:myapp/services/database_helpers.dart';

class CadastroRotinaPage extends StatefulWidget {
  const CadastroRotinaPage({super.key});

  @override
  State<CadastroRotinaPage> createState() => _CadastroRotinaPageState();
}

class _CadastroRotinaPageState extends State<CadastroRotinaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _frequenciaController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();

  String _objetivo = 'Hipertrofia';

  // Lista dinâmica de exercícios
  List<Map<String, String>> _exercicios = [];

  // Controllers temporários para adicionar exercício
  final TextEditingController _exNomeController = TextEditingController();
  final TextEditingController _exSeriesController = TextEditingController();
  final TextEditingController _exObsController = TextEditingController();

  void _adicionarExercicio() {
    if (_exNomeController.text.isEmpty || _exSeriesController.text.isEmpty)
      return;

    setState(() {
      _exercicios.add({
        'nome': _exNomeController.text,
        'series': _exSeriesController.text,
        'observacao': _exObsController.text,
      });

      _exNomeController.clear();
      _exSeriesController.clear();
      _exObsController.clear();
    });
  }

  Future<void> _salvarRotina() async {
    if (_formKey.currentState!.validate()) {
      // Salvar rotina
      int rotinaId = await DatabaseHelper.instance.inserirRotina({
        'nome': _nomeController.text,
        'objetivo': _objetivo,
        'frequencia': _frequenciaController.text,
        'duracao': int.tryParse(_duracaoController.text) ?? 0,
      });

      // Salvar exercícios vinculados
      for (var ex in _exercicios) {
        await DatabaseHelper.instance.inserirExercicio({
          'rotina_id': rotinaId,
          'nome': ex['nome'],
          'series': ex['series'],
          'observacao': ex['observacao'],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rotina cadastrada com sucesso! 🎉'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Cadastro de Rotina"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildRoundedInput(
                _nomeController,
                "Nome da Rotina",
                Icons.fitness_center,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _objetivo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.flag),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Hipertrofia',
                    child: Text('Hipertrofia'),
                  ),
                  DropdownMenuItem(
                    value: 'Resistência',
                    child: Text('Resistência'),
                  ),
                  DropdownMenuItem(
                    value: 'Full Body',
                    child: Text('Full Body'),
                  ),
                  DropdownMenuItem(value: 'HIIT', child: Text('HIIT')),
                  DropdownMenuItem(value: 'Core', child: Text('Core')),
                  DropdownMenuItem(
                    value: 'Flexibilidade',
                    child: Text('Flexibilidade'),
                  ),
                ],
                onChanged: (val) => setState(() => _objetivo = val!),
              ),
              const SizedBox(height: 16),
              _buildRoundedInput(
                _frequenciaController,
                "Frequência (ex.: 3x/semana)",
                Icons.calendar_month,
              ),
              const SizedBox(height: 16),
              _buildRoundedInput(
                _duracaoController,
                "Duração (minutos)",
                Icons.timer,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 24),
              const Text(
                "Exercícios",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._exercicios.map(
                (ex) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(ex['nome'] ?? ""),
                    subtitle: Text(
                      "Séries/Reps: ${ex['series']}\nObservação: ${ex['observacao']}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _exercicios.remove(ex);
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildExercicioForm(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarRotina,
                  icon: const Icon(Icons.save),
                  label: const Text("Salvar Rotina"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Input arredondado
  Widget _buildRoundedInput(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? "Campo obrigatório" : null,
    );
  }

  /// Formulário para adicionar exercício
  Widget _buildExercicioForm() {
    return Column(
      children: [
        _buildRoundedInput(
          _exNomeController,
          "Nome do Exercício",
          Icons.fitness_center,
        ),
        const SizedBox(height: 8),
        _buildRoundedInput(
          _exSeriesController,
          "Séries/Repetições",
          Icons.repeat,
        ),
        const SizedBox(height: 8),
        _buildRoundedInput(
          _exObsController,
          "Observação (opcional)",
          Icons.notes,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _adicionarExercicio,
            icon: const Icon(Icons.add),
            label: const Text("Adicionar Exercício"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
