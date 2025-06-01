class JustificationCreateRequestDto {
  final String? id;
  final String etudiantId;
  final DateTime date;
  final String justificatif;
  final bool validation;

  JustificationCreateRequestDto({
    this.id,
    required this.etudiantId,
    required this.date,
    required this.justificatif,
    required this.validation,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'etudiantId': etudiantId,
    'date': date.toIso8601String(),
    'justificatif': justificatif,
    'validation': validation,
  };

  factory JustificationCreateRequestDto.fromJson(Map<String, dynamic> json) {
    return JustificationCreateRequestDto(
      id: json['id'],
      etudiantId: json['etudiantId'],
      date: DateTime.parse(json['date']),
      justificatif: json['justificatif'],
      validation: json['validation'],
    );
  }

  // Static method to create a new ID
  static String generateNewId(List<JustificationCreateRequestDto> justifications) {
    if (justifications.isEmpty) {
      return '1'; // Start with ID '1' if there are no justifications
    }

    // Find the maximum ID currently in use
    int maxId = justifications
        .map((j) => int.tryParse(j.id ?? '0') ?? 0)
        .reduce((currentMax, id) => id > currentMax ? id : currentMax);

    // Increment the maximum ID by 1
    return (maxId + 1).toString();
  }
}
