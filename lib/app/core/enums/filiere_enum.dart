enum FiliereEnum { GLRS, CPD }


extension FiliereExtension on FiliereEnum {
  String get name => toString().split('.').last;

  static FiliereEnum fromString(String value) {
    return FiliereEnum.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid FiliereEnum value: $value'),
    );
  }
}
