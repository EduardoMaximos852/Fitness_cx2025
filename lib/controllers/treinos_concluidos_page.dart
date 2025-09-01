import 'package:flutter/material.dart';
import 'package:myapp/services/database_helpers.dart';


class TreinosConcluidosPage extends StatefulWidget {
  const TreinosConcluidosPage({super.key});

  @override
  State<TreinosConcluidosPage> createState() => _TreinosConcluidosPageState();
}

class _TreinosConcluidosPageState extends State<TreinosConcluidosPage> {
  List<Map<String, dynamic>> treinos = [];

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  Future<void> _carregarTreinos() async {
    final lista = await DatabaseHelper.instance.getTreinosConcluidos();
    setState(() {
      treinos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treinos Concluídos"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: treinos.isEmpty
            ? const Center(child: Text("Nenhum treino concluído ainda."))
            : ListView.builder(
                itemCount: treinos.length,
                itemBuilder: (context, index) {
                  final treino = treinos[index];
                  double percentual = treino['percentual'] ?? 0.0;
                  double calorias = treino['calorias'] ?? 0.0;

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        "Rotina: ${treino['rotina_id']}", // Pode buscar o nome da rotina
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Data: ${treino['data']}"),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: percentual / 100,
                            minHeight: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation(
                              percentual == 100 ? Colors.green : Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Conclusão: ${percentual.toStringAsFixed(0)}% | Calorias: ${calorias.toStringAsFixed(0)} kcal",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: percentual == 100
                          ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                          : const Icon(Icons.timelapse, color: Colors.orange, size: 28),
                      onTap: () {
                        // Aqui pode abrir detalhes do treino concluído
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
