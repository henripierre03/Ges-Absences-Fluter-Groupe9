import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AuthMiddleware extends GetMiddleware {
  final List<String>? allowedRoles;

  AuthMiddleware({this.allowedRoles});

  @override
  @override
  RouteSettings? redirect(String? route) {
    if (!Hive.isBoxOpen('authBox')) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    final authBox = Hive.box('authBox');
    final token = authBox.get('token');
    final role = authBox.get('role');

    if (token == null || token.isEmpty) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    if (allowedRoles != null && !allowedRoles!.contains(role)) {
      switch (role) {
        case 'ETUDIANT':
          return const RouteSettings(name: Routes.ETUDIANT);
        case 'VIGILE':
          return const RouteSettings(name: Routes.VIGILE);
        default:
          return const RouteSettings(name: Routes.LOGIN);
      }
    }
    return null;
  }
}
