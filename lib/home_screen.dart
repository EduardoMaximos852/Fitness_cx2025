import 'package:flutter/material.dart';
import 'package:myapp/controllers/cadastro_rotina.dart';

import 'package:myapp/controllers/lista_clientes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Treinador'),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'Perfil Treinador',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Usuários'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Rotinas'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificações'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('Gamificação'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Funcionalidades',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _shortcutButton(Icons.people, "Usuário", Colors.blue, context),
                _shortcutButton(
                  Icons.add_task,
                  "Nova Rotina",
                  Colors.green,
                  context,
                ),
                _shortcutButton(
                  Icons.check_circle,
                  "Concluídas",
                  Colors.orange,
                  context,
                ),
                _shortcutButton(
                  Icons.filter_list,
                  "Filtros",
                  Colors.purple,
                  context,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Indicadores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _indicatorCard(
              'Evolução dos Clientes',
              'Gráfico aqui',
              Icons.show_chart,
            ),
            const SizedBox(height: 8),
            _indicatorCard(
              'Conquistas / Badges',
              'Indicadores aqui',
              Icons.emoji_events,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuários'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Rotinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificações',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Card de atalho
  Widget _shortcutCard(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 25),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 8),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card de indicadores
  Widget _indicatorCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _shortcutButton(
  IconData icon,
  String label,
  Color color,
  BuildContext context,
) {
  return Expanded(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (label == "Usuário") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ListaClientesPage(),
              ),
            );
          } else if (label == "Nova Rotina") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CadastroRotinaPage(),
              ),
            );
          }
          // Outros botões podem ter lógica própria
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 26,
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
