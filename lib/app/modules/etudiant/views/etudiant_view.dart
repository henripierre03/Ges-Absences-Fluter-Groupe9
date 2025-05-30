import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';

class EtudiantView extends GetView<EtudiantController> {
  const EtudiantView({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the student ID from the arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final etudiantId = arguments['etudiantId'];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchAbsencesByEtudiantId(etudiantId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Absences de l'Étudiant"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else if (controller.absences.isEmpty) {
            return const Center(child: Text("Aucune absence trouvée"));
          }

          return ListView.builder(
            itemCount: controller.absences.length,
            padding: const EdgeInsets.only(top: 8.0),
            itemBuilder: (context, index) {
              final absence = controller.absences[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: ListTile(
                  title: Text("Absence ${absence.id}"),
                  subtitle: Text("Date : ${absence.date}"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Get.toNamed(
                      Routes.ETUDIANT_JUSTIFICATION,
                      arguments: absence,
                    );
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
