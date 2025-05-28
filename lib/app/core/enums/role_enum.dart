enum UserRole { admin, vigile, etudiant }

extension RoleEnumExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.vigile:
        return 'vigile';
      case UserRole.etudiant:
        return 'etudiant';
    }
  }

  static UserRole fromString(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'vigile':
        return UserRole.vigile;
      case 'etudiant':
        return UserRole.etudiant;
      default:
        throw ArgumentError('Unknown role: $role');
    }
  }
}
