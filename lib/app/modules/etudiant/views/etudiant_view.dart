import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/providers/etudiant_provider.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/etudiant_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/implJson/justification_api_service.dart';
import 'package:get/get.dart';

class EtudiantView extends StatelessWidget {
  const EtudiantView({super.key});

  @override
  Widget build(BuildContext context) {
    final EtudiantProvider etudiantProvider = Get.put(
      EtudiantProvider(
        EtudiantApiServiceImplJson(),
        JustificationApiServiceImplJson(),
      ),
    );

    final userId = '1'; // Example user ID, replace with actual user ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absences de l\'Étudiant'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Absence>>(
          future: etudiantProvider.getAbsencesByEtudiantId(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur de chargement: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucune absence trouvée"));
            }

            final absences = snapshot.data!;
            return ListView.builder(
              itemCount: absences.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final absence = absences[index];
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
                      Navigator.pushNamed(
                        context,
                        '/justifier-absence',
                        arguments: {
                          "absence": absence,
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
