enum Niveau { licence1, licence2, licence3, master1, master2 }

extension NiveauExtension on Niveau {
  String get name {
    switch (this) {
      case Niveau.licence1:
        return 'Licence 1';
      case Niveau.licence2:
        return 'Licence 2';
      case Niveau.licence3:
        return 'Licence 3';
      case Niveau.master1:
        return 'Master 1';
      case Niveau.master2:
        return 'Master 2';
    }
  }

  static Niveau fromString(String niveau) {
    switch (niveau) {
      case 'Licence 1':
        return Niveau.licence1;
      case 'Licence 2':
        return Niveau.licence2;
      case 'Licence 3':
        return Niveau.licence3;
      case 'Master 1':
        return Niveau.master1;
      case 'Master 2':
        return Niveau.master2;
      default:
        throw ArgumentError('Unknown niveau: $niveau');
    }
  }
}
