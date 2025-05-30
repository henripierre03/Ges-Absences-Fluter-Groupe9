import 'package:frontend_gesabsence/app/modules/parametres/bindings/parametres_binding.dart';
import 'package:frontend_gesabsence/app/modules/parametres/views/parametres_view.dart';
import 'package:get/get.dart';

import '../modules/etudiant/bindings/etudiant_binding.dart';
import '../modules/etudiant/views/etudiant_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/layout/bindings/main_binding.dart';
import '../modules/layout/views/main_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

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
    GetPage(
      name: _Paths.MAIN,
      page: () =>  MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.PARAMETRES,
      page: () => const ParametresView(),
      binding: ParametresBinding(),
    ),
  ];
}
