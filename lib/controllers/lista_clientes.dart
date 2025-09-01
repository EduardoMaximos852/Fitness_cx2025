import 'package:flutter/material.dart';
import 'package:myapp/controllers/cadastro_cliente.dart';
import 'package:myapp/screen/perfil_cliente.dart';
import 'package:myapp/services/database_helpers.dart';
import '../models/cliente.dart';

class ListaClientesPage extends StatefulWidget {
  const ListaClientesPage({super.key});

  @override
  State<ListaClientesPage> createState() => _ListaClientesPageState();
}

class _ListaClientesPageState extends State<ListaClientesPage> {
  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final List<Map<String, dynamic>> listaMap = await DatabaseHelper.instance
        .getClientes();
    setState(() {
      clientes = listaMap
          .map(
            (e) => Cliente(
              id: e['id'],
              nome: e['nome'],
              peso: e['peso'],
              altura: e['altura'],
              idade: e['idade'],
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Usuários"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroClientePage(),
                ),
              );
              if (result == true) {
                _carregarClientes(); // Atualiza lista após cadastro
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: clientes.isEmpty
            ? const Center(child: Text("Nenhum usuário cadastrado."))
            : ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          cliente.nome[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        cliente.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Peso: ${cliente.peso}kg | Altura: ${cliente.altura}cm | Idade: ${cliente.idade}",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PerfilClientePage(cliente: cliente),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
