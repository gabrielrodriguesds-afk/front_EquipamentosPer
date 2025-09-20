class Cliente {
  final String id;
  final String nome;
  final String? email;
  final String? telefone;
  final String? endereco;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cliente({
    required this.id,
    required this.nome,
    this.email,
    this.telefone,
    this.endereco,
    this.createdAt,
    this.updatedAt,
  });

  // Construtor para criar novo cliente (sem ID)
  Cliente.novo({
    required this.nome,
    this.email,
    this.telefone,
    this.endereco,
  }) : id = '',
       createdAt = null,
       updatedAt = null;

  // Converter de JSON para Cliente
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'],
      telefone: json['telefone'],
      endereco: json['endereco'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // Converter Cliente para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Converter para JSON para criação (sem ID e timestamps)
  Map<String, dynamic> toJsonForCreation() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
    };
  }

  // Criar cópia com modificações
  Cliente copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? endereco,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      endereco: endereco ?? this.endereco,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Cliente{id: $id, nome: $nome, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cliente &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

