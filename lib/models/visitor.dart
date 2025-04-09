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

  /// Cria um Visitor a partir do JSON recebido pela API (que pode conter somente id e name)
  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id']?.toString(),
      name: json['no_pessoa'] ?? '',
    );
  }

  /// Converte o Visitor em JSON para envio à API (para cadastro, por exemplo)
  Map<String, dynamic> toJson() {
    return {
      'no_pessoa': name,
      'cpf': cpf,
      'phone': phone,
    };
  }
}
