class Usuario {
  final String id;
  final String nome;
  final String? email;
  final String? telefone;
  final String? cargo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Usuario({
    required this.id,
    required this.nome,
    this.email,
    this.telefone,
    this.cargo,
    this.createdAt,
    this.updatedAt,
  });

  // Construtor para criar novo usuário (sem ID)
  Usuario.novo({
    required this.nome,
    this.email,
    this.telefone,
    this.cargo,
  }) : id = '',
       createdAt = null,
       updatedAt = null;

  // Converter de JSON para Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'],
      telefone: json['telefone'],
      cargo: json['cargo'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // Converter Usuario para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cargo': cargo,
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
      'cargo': cargo,
    };
  }

  // Criar cópia com modificações
  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? cargo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cargo: cargo ?? this.cargo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, email: $email, cargo: $cargo}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

