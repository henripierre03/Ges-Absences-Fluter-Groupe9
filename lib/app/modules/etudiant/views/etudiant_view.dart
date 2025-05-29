import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/providers/etudiant_provider.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:get/get.dart';



class EtudiantView extends GetView<EtudiantController> {
  const EtudiantView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Get.find<EtudiantProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Étudiants'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (provider.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.etudiants.isEmpty) {
          return const Center(child: Text('Aucun étudiant trouvé.'));
        }

        return ListView.builder(
          itemCount: provider.etudiants.length,
          itemBuilder: (_, index) {
            final etu = provider.etudiants[index];
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
