import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/absence_controller.dart';
import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';

class AbsenceView extends GetView<AbsenceController> {
  const AbsenceView({Key? key}) : super(key: key);

  Color getStatusColor(TypeAbsence status) {
    switch (status) {
      case TypeAbsence.absente:
        return Colors.grey;
      case TypeAbsence.enRetard:
        return Colors.orangeAccent;
      case TypeAbsence.justifiee:
        return Colors.green;
      case TypeAbsence.nonJustifiee:
        return Colors.redAccent;
      case TypeAbsence.retard:
        return Colors.orange;
      case TypeAbsence.absence:
        return Colors.red;
    }
  }

  IconData getStatusIcon(TypeAbsence status) {
    switch (status) {
      case TypeAbsence.absente:
        return Icons.help_outline;
      case TypeAbsence.enRetard:
        return Icons.access_time_outlined;
      case TypeAbsence.justifiee:
        return Icons.check_circle;
      case TypeAbsence.nonJustifiee:
        return Icons.cancel_outlined;
      case TypeAbsence.retard:
        return Icons.access_time;
      case TypeAbsence.absence:
        return Icons.close;
    }
  }

  String getStatusText(TypeAbsence status) {
    switch (status) {
      case TypeAbsence.absente:
        return 'Non défini';
      case TypeAbsence.enRetard:
        return 'En retard (enRetard)';
      case TypeAbsence.justifiee:
        return 'Présent justifié';
      case TypeAbsence.nonJustifiee:
        return 'Absence non justifiée';
      case TypeAbsence.retard:
        return 'En Retard';
      case TypeAbsence.absence:
        return 'Absent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Barre de navigation inférieure personnalisée avec 3 boutons circulaires
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.orange,
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.black),
                onPressed: () {
                  // TODO: Action de déconnexion
                },
              ),
            ),
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.orange,
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.black),
                onPressed: () {
                  // TODO: Aller à la page d'accueil
                },
              ),
            ),
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.orange,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.black),
                onPressed: () {
                  // TODO: Afficher le profil
                },
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Message d’accueil
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Hello, ',
              style: TextStyle(fontSize: 22),
            ),
            TextSpan(
              text: 'Chère Etudiant(Aly)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    ),
    const CircleAvatar(
      radius: 24,
      backgroundColor: Colors.orange,
      child: Icon(Icons.person, color: Colors.white),
    ),
  ],
),


              const SizedBox(height: 16),

              /// Titre de la section
              const Text(
                'Liste des Absences, Présences et Retards',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              /// Liste des absences
              Obx(() => Expanded(
                    child: ListView.builder(
                      itemCount: controller.absences.length,
                      itemBuilder: (context, index) {
                        final Absence absence = controller.absences[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          child: ListTile(
                            title: Text('Cours: ${absence.coursId}'),
                            subtitle: const Text('Salle: 204'),
                            leading: Text(
                              '${absence.date.day.toString().padLeft(2, '0')}/'
                              '${absence.date.month.toString().padLeft(2, '0')}/'
                              '${absence.date.year}',
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: getStatusColor(absence.absence),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    getStatusIcon(absence.absence),
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    getStatusText(absence.absence),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
