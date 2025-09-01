class Cliente {
  final int? id;
  final String nome;
  final double peso;
  final double altura;
  final int idade;

  Cliente({
    this.id,
    required this.nome,
    required this.peso,
    required this.altura,
    required this.idade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'peso': peso,
      'altura': altura,
      'idade': idade,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      peso: map['peso'],
      altura: map['altura'],
      idade: map['idade'],
    );
  }
}
