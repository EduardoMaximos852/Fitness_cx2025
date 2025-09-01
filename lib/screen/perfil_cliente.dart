import 'package:flutter/material.dart';
import '../models/cliente.dart';

class PerfilClientePage extends StatelessWidget {
  final Cliente cliente;
  const PerfilClientePage({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cliente.nome),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${cliente.nome}', style: const TextStyle(fontSize: 18)),
            Text('Peso: ${cliente.peso}kg', style: const TextStyle(fontSize: 18)),
            Text('Altura: ${cliente.altura}cm', style: const TextStyle(fontSize: 18)),
            Text('Idade: ${cliente.idade}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            // Aqui você pode adicionar gráfico de evolução, treinos concluídos etc.
          ],
        ),
      ),
    );
  }
}
