enum TypeAbsence { PRESENCE, ABSENCE, RETARD }

String typeAbsenceToString(TypeAbsence type) => type.name;
TypeAbsence typeAbsenceFromString(String value) =>
    TypeAbsence.values.firstWhere((e) => e.name == value);
