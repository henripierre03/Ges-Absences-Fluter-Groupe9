import 'package:frontend_gesabsence/app/modules/etudiant/views/etudiant_justifiaction_view.dart';
import 'package:get/get.dart';

import '../modules/etudiant/bindings/etudiant_binding.dart';
import '../modules/etudiant/views/etudiant_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static final etudiantBinding = EtudiantBinding();
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: _Paths.ETUDIANT,
    //   page: () => const EtudiantView(),
    //   binding: EtudiantBinding(),
    // ),
    GetPage(
      name: Routes.ETUDIANT,
      page: () => const EtudiantView(),
      binding: etudiantBinding,
    ),
    GetPage(
      name: Routes.ETUDIANT_JUSTIFICATION,
      page: () => const EtudiantJustificationView(),
      binding: etudiantBinding,
    ),
  ];
}