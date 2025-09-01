import 'package:flutter/material.dart';
import 'package:myapp/services/class_cliente.dart';

class ClientProfileScreen extends StatelessWidget {
  final Client client;
  const ClientProfileScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${client.name}', style: const TextStyle(fontSize: 18)),
            Text('Nível: ${client.level}', style: const TextStyle(fontSize: 18)),
            Text('Progresso: ${client.progress}%', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            // Aqui podemos adicionar gráficos de evolução, treinos concluídos etc.
          ],
        ),
      ),
    );
  }
}