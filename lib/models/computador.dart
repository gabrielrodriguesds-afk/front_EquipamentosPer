class Computador {
  final String id;
  final String codigo;
  final String clienteId;
  final String? clienteNome;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final String? setor;
  final String? operador;
  final String? observacao;
  final String? fotoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Computador({
    required this.id,
    required this.codigo,
    required this.clienteId,
    this.clienteNome,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    this.setor,
    this.operador,
    this.observacao,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Construtor para criar novo computador (sem ID e código)
  Computador.novo({
    required this.clienteId,
    this.clienteNome,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    this.setor,
    this.operador,
    this.observacao,
    this.fotoUrl,
  }) : id = '',
       codigo = '',
       createdAt = null,
       updatedAt = null;

  // Converter de JSON para Computador
  factory Computador.fromJson(Map<String, dynamic> json) {
    return Computador(
      id: json['id'] ?? '',
      codigo: json['codigo'] ?? '',
      clienteId: json['cliente_id'] ?? '',
      clienteNome: json['cliente_nome'],
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      numeroSerie: json['numero_serie'] ?? '',
      setor: json['setor'],
      operador: json['operador'],
      observacao: json['observacao'],
      fotoUrl: json['foto_url'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // Converter Computador para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'cliente_id': clienteId,
      'cliente_nome': clienteNome,
      'marca': marca,
      'modelo': modelo,
      'numero_serie': numeroSerie,
      'setor': setor,
      'operador': operador,
      'observacao': observacao,
      'foto_url': fotoUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Converter para JSON para criação (sem ID, código e timestamps)
  Map<String, dynamic> toJsonForCreation() {
    return {
      'cliente_id': clienteId,
      'marca': marca,
      'modelo': modelo,
      'numero_serie': numeroSerie,
      'setor': setor,
      'operador': operador,
      'observacao': observacao,
      'foto_url': fotoUrl,
    };
  }

  // Criar cópia com modificações
  Computador copyWith({
    String? id,
    String? codigo,
    String? clienteId,
    String? clienteNome,
    String? marca,
    String? modelo,
    String? numeroSerie,
    String? setor,
    String? operador,
    String? observacao,
    String? fotoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Computador(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      clienteId: clienteId ?? this.clienteId,
      clienteNome: clienteNome ?? this.clienteNome,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      setor: setor ?? this.setor,
      operador: operador ?? this.operador,
      observacao: observacao ?? this.observacao,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Computador{id: $id, codigo: $codigo, marca: $marca, modelo: $modelo}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Computador &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

