class Visitor {
  final String? id;
  final String name;
  final String cpf;
  final String phone;

  Visitor({
    this.id,
    required this.name,
    this.cpf = '',
    this.phone = '',
  });

  /// Cria um Visitor a partir do JSON recebido pela API
  /// Aqui, assumimos que para listar visitantes a API retorna apenas os campos:
  /// - id (ou cd_pessoa)
  /// - no_pessoa (nome do visitante)
  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['cd_pessoa']?.toString(), // Ajuste se necessário
      name: json['no_pessoa'] ?? '',
    );
  }

  /// Converte o Visitor em JSON para envio à API (cadastro)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cpf': cpf,
      'phone': phone,
    };
  }
}
