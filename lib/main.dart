import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/absence/views/absence_view.dart';
import 'app/modules/absence/controllers/absence_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/absence/bindings/absence_binding.dart';
import 'app/modules/absence/views/absence_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gestion des Absences',
      debugShowCheckedModeBanner: false,
      initialBinding: AbsenceBinding(), 
      home: const AbsenceView(),        
    );
  }
}
