import 'package:flutter/material.dart';
import 'package:myapp/services/database_helpers.dart';


class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Cadastro de Usuário"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildRoundedInput(
                controller: _nomeController,
                label: "Nome completo",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildRoundedInput(
                controller: _pesoController,
                label: "Peso (kg)",
                icon: Icons.fitness_center,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildRoundedInput(
                controller: _alturaController,
                label: "Altura (cm)",
                icon: Icons.height,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildRoundedInput(
                controller: _idadeController,
                label: "Idade",
                icon: Icons.calendar_month,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseHelper.instance.addCliente({
                        'nome': _nomeController.text,
                        'peso': double.tryParse(_pesoController.text) ?? 0,
                        'altura': double.tryParse(_alturaController.text) ?? 0,
                        'idade': int.tryParse(_idadeController.text) ?? 0,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Usuário cadastrado com sucesso! 🎉"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Salvar Usuário",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔧 Campo de input arredondado
  Widget _buildRoundedInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Por favor, insira $label";
        }
        return null;
      },
    );
  }
}
