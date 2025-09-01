import 'package:flutter/material.dart';
import 'package:myapp/screen/cliente_profile_screen.dart';
import 'package:myapp/services/class_cliente.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  Database? database;
  List<Client> clients = [];
  String searchQuery = '';
  String levelFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      p.join(await getDatabasesPath(), 'academy.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE clients(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, level TEXT, progress INTEGER)',
        );
      },
      version: 1,
    );
    _loadClients();
  }

  Future<void> _loadClients() async {
    if (database == null) return;
    final List<Map<String, dynamic>> maps = await database!.query('clients');
    setState(() {
      clients = List.generate(
        maps.length,
        (i) => Client(
          id: maps[i]['id'],
          name: maps[i]['name'],
          level: maps[i]['level'],
          progress: maps[i]['progress'],
        ),
      );
    });
  }

  Future<void> _addClient(Client client) async {
    if (database == null) return;
    await database!.insert(
      'clients',
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadClients();
  }

  @override
  Widget build(BuildContext context) {
    List<Client> filteredClients = clients.where((c) {
      bool matchesSearch = c.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
      bool matchesLevel = levelFilter == 'Todos' || c.level == levelFilter;
      return matchesSearch && matchesLevel;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Campo de busca
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
            const SizedBox(height: 10),
            // Filtro por nível
            DropdownButton<String>(
              value: levelFilter,
              items: ['Todos', 'Iniciante', 'Intermediário', 'Avançado']
                  .map(
                    (level) =>
                        DropdownMenuItem(value: level, child: Text(level)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => levelFilter = val!),
            ),
            const SizedBox(height: 10),
            // Lista de clientes
            Expanded(
              child: ListView.builder(
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  final client = filteredClients[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(client.name[0])),
                      title: Text(client.name),
                      subtitle: Text(
                        '${client.level} • Progresso: ${client.progress}%',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientProfileScreen(client: client),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () => _showAddClientDialog(),
      ),
    );
  }

  void _showAddClientDialog() {
    final nameController = TextEditingController();
    String level = 'Iniciante'; // Default level

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Adicionar Novo Cliente'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: level,
                    isExpanded: true,
                    items: ['Iniciante', 'Intermediário', 'Avançado']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          level = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      _addClient(
                        Client(
                          name: nameController.text,
                          level: level,
                          progress: 0,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}