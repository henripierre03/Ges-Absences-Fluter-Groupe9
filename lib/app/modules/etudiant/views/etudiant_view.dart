import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EtudiantView extends GetView<EtudiantController> {
  const EtudiantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Étudiants')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.etudiants.isEmpty) {
          return const Center(child: Text('Aucun étudiant trouvé.'));
        }
        return ListView.builder(
          itemCount: controller.etudiants.length,
          itemBuilder: (_, index) {
            final etu = controller.etudiants[index];
            return ListTile(
              title: Text('${etu.nom} ${etu.prenom}'),
              subtitle: Text('Matricule: ${etu.matricule}'),
            );
          },
        );
      }),
    );
  }
}
