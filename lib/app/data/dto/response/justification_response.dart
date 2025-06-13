class JustificationSimpleResponse {
  final String id;
  final String message;
  final bool validation;
  final List<String> justificatifs;

  JustificationSimpleResponse({
    required this.id,
    required this.message,
    required this.validation,
    required this.justificatifs,
  });
  factory JustificationSimpleResponse.fromJson(Map<String, dynamic> json) {
    return JustificationSimpleResponse(
      id: json['id'] as String,
      message: json['message'] as String,
      validation: json['validation'] as bool,
      justificatifs: List<String>.from(json['justificatif'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'validation': validation,
      'justificatif': justificatifs,
    };
  }
}
