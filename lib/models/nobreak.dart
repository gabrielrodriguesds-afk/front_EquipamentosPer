class Nobreak {
  final String id;
  final String codigo;
  final String clienteId;
  final String? clienteNome;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final DateTime? dataBateria;
  final String? modeloBateria;
  final int quantidadeBaterias;
  final String? setor;
  final String? observacao;
  final String? fotoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Nobreak({
    required this.id,
    required this.codigo,
    required this.clienteId,
    this.clienteNome,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    this.dataBateria,
    this.modeloBateria,
    this.quantidadeBaterias = 1,
    this.setor,
    this.observacao,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Construtor para criar novo nobreak (sem ID e código)
  Nobreak.novo({
    required this.clienteId,
    this.clienteNome,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    this.dataBateria,
    this.modeloBateria,
    this.quantidadeBaterias = 1,
    this.setor,
    this.observacao,
    this.fotoUrl,
  }) : id = '',
       codigo = '',
       createdAt = null,
       updatedAt = null;

  // Converter de JSON para Nobreak
  factory Nobreak.fromJson(Map<String, dynamic> json) {
    return Nobreak(
      id: json['id'] ?? '',
      codigo: json['codigo'] ?? '',
      clienteId: json['cliente_id'] ?? '',
      clienteNome: json['cliente_nome'],
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      numeroSerie: json['numero_serie'] ?? '',
      dataBateria: json['data_bateria'] != null 
          ? DateTime.parse(json['data_bateria']) 
          : null,
      modeloBateria: json['modelo_bateria'],
      quantidadeBaterias: json['quantidade_baterias'] ?? 1,
      setor: json['setor'],
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

  // Converter Nobreak para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'cliente_id': clienteId,
      'cliente_nome': clienteNome,
      'marca': marca,
      'modelo': modelo,
      'numero_serie': numeroSerie,
      'data_bateria': dataBateria?.toIso8601String().split('T')[0], // Apenas data
      'modelo_bateria': modeloBateria,
      'quantidade_baterias': quantidadeBaterias,
      'setor': setor,
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
      'data_bateria': dataBateria?.toIso8601String().split('T')[0], // Apenas data
      'modelo_bateria': modeloBateria,
      'quantidade_baterias': quantidadeBaterias,
      'setor': setor,
      'observacao': observacao,
      'foto_url': fotoUrl,
    };
  }

  // Criar cópia com modificações
  Nobreak copyWith({
    String? id,
    String? codigo,
    String? clienteId,
    String? clienteNome,
    String? marca,
    String? modelo,
    String? numeroSerie,
    DateTime? dataBateria,
    String? modeloBateria,
    int? quantidadeBaterias,
    String? setor,
    String? observacao,
    String? fotoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Nobreak(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      clienteId: clienteId ?? this.clienteId,
      clienteNome: clienteNome ?? this.clienteNome,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      dataBateria: dataBateria ?? this.dataBateria,
      modeloBateria: modeloBateria ?? this.modeloBateria,
      quantidadeBaterias: quantidadeBaterias ?? this.quantidadeBaterias,
      setor: setor ?? this.setor,
      observacao: observacao ?? this.observacao,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Nobreak{id: $id, codigo: $codigo, marca: $marca, modelo: $modelo}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Nobreak &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
