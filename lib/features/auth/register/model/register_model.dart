class RegisterModel {
  final String id;
  final String name;
  final String email;
  final String balance;
  final String role;

  RegisterModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.role,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      balance: (json["balance"]).toString(),
      role: json["role"],
    );
  }
}