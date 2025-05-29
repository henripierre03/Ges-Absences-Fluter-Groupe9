import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/core/themes/app_theme.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      theme: AppTheme.light,
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
    );
  }
}

void main() {
  runApp(const App());
}
