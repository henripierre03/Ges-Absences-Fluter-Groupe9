class RestResponse<T> {
  final int status;
  final T result;
  final String type;

  RestResponse({
    required this.status,
    required this.result,
    required this.type,
  });

  factory RestResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonModel,
  ) {
    return RestResponse<T>(
      status: json['status'],
      result: fromJsonModel(json['result']),
      type: json['type'],
    );
  }
}
