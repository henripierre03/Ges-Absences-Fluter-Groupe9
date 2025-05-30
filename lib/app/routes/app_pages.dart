import 'package:get/get.dart';

import '../modules/etudiant/bindings/etudiant_binding.dart';
import '../modules/etudiant/views/etudiant_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ETUDIANT,
      page: () => const EtudiantView(),
      binding: EtudiantBinding(),
    ),
    // Suppression du doublon - vous aviez la même route définie deux fois
  ];
}