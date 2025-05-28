enum TypeAbsence { absente, enRetard, justifiee, nonJustifiee, retard, absence }

extension TypeAbsenceExtension on TypeAbsence {
  String get name {
    switch (this) {
      case TypeAbsence.absente:
        return 'Absente';
      case TypeAbsence.enRetard:
        return 'En retard';
      case TypeAbsence.justifiee:
        return 'Justifiee';
      case TypeAbsence.nonJustifiee:
        return 'Non justifiee';
      case TypeAbsence.retard:
        return 'Retard';
      case TypeAbsence.absence:
        return 'Absence';
    }
  }

  static TypeAbsence fromString(String type) {
    switch (type) {
      case 'Absente':
        return TypeAbsence.absente;
      case 'En retard':
        return TypeAbsence.enRetard;
      case 'Justifiee':
        return TypeAbsence.justifiee;
      case 'Non justifiee':
        return TypeAbsence.nonJustifiee;
      case 'Retard':
        return TypeAbsence.retard;
      case 'Absence':
        return TypeAbsence.absence;
      default:
        throw ArgumentError('Unknown type: $type');
    }
  }
}
