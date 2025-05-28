enum Module { informatique }

extension ModuleExtension on Module {
  String get name {
    switch (this) {
      case Module.informatique:
        return 'Informatique';
    }
  }

  static Module fromString(String module) {
    switch (module) {
      case 'Informatique':
        return Module.informatique;
      default:
        throw ArgumentError('Unknown module: $module');
    }
  }
}
