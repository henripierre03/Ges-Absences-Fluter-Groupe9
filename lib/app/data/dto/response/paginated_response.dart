class PaginatedResponse<T> {
  final int status;
  final List<T> result;
  final String type;
  final int pages;
  final int curentPage;
  final int totalPage;
  final int totalItems;
  final bool first;
  final bool last;

  PaginatedResponse({
    required this.status,
    required this.result,
    required this.type,
    required this.pages,
    required this.curentPage,
    required this.totalPage,
    required this.totalItems,
    required this.first,
    required this.last,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonModel,
  ) {
    return PaginatedResponse<T>(
      status: json['status'],
      result: (json['result'] as List).map(fromJsonModel).toList(),
      type: json['type'],
      pages: json['pages'],
      curentPage: json['curentPage'],
      totalPage: json['totalPage'],
      totalItems: json['totalItems'],
      first: json['first'],
      last: json['last'],
    );
  }
}
