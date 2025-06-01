import 'package:get/get.dart';

import '../modules/etudiant/bindings/etudiant_binding.dart';
import '../modules/etudiant/views/etudiant_justifiaction_view.dart';
import '../modules/etudiant/views/etudiant_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/vigile/bindings/vigile_binding.dart';
import '../modules/vigile/views/vigile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN; // Change initial route to login
  static final etudiantBinding = EtudiantBinding();
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
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
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.VIGILE,
      page: () => const VigileView(),
      binding: VigileBinding(),
    ),
  ];
}
