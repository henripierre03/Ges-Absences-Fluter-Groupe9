class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String role;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'password': password,
    'role': role,
  };
}
