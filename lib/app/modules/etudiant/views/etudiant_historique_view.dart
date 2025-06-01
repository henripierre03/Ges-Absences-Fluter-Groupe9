import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/core/themes/colors.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class EtudiantHistoriqueView extends StatelessWidget {
  const EtudiantHistoriqueView({super.key});

  @override
  Widget build(BuildContext context) {
    // Utiliser le VigileController au lieu d'EtudiantController
    final VigileController vigileController = Get.find<VigileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Étudiants'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearHistoriqueDialog(vigileController),
            tooltip: 'Vider l\'historique',
          ),
        ],
      ),
      body: Column(
        children: [
          // Section des statistiques
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Obx(
              () => Column(
                children: [
                  Text(
                    'Statistiques du jour',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Scannés',
                        vigileController.todayScannedCount.toString(),
                        Icons.qr_code_scanner,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Recherchés',
                        vigileController.todaySearchedCount.toString(),
                        Icons.search,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Total',
                        vigileController.todayTotalCount.toString(),
                        Icons.people,
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Liste des étudiants
          Expanded(
            child: Obx(() {
              if (vigileController.etudiantsAujourdhui.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aucun étudiant consulté aujourd\'hui',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Scannez un QR code ou recherchez un étudiant',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: vigileController.etudiantsAujourdhui.length,
                itemBuilder: (context, index) {
                  final etudiant = vigileController.etudiantsAujourdhui[index];

                  // Trouver les entrées d'historique pour cet étudiant aujourd'hui
                  final todayEntries = vigileController.fullHistorique
                      .where(
                        (entry) =>
                            entry.isToday() && entry.etudiant.id == etudiant.id,
                      )
                      .toList();

                  // Compter les scans et recherches
                  final scanCount = todayEntries
                      .where((entry) => entry.searchMethod == 'scan')
                      .length;
                  final searchCount = todayEntries
                      .where((entry) => entry.searchMethod == 'search')
                      .length;

                  // Obtenir la dernière consultation
                  final lastEntry = todayEntries.isNotEmpty
                      ? todayEntries.first
                      : null;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: lastEntry?.searchMethod == 'scan'
                            ? Colors.blue.shade100
                            : Colors.green.shade100,
                        child: Icon(
                          lastEntry?.searchMethod == 'scan'
                              ? Icons.qr_code_scanner
                              : Icons.search,
                          color: lastEntry?.searchMethod == 'scan'
                              ? Colors.blue
                              : Colors.green,
                        ),
                      ),
                      title: Text(
                        '${etudiant.nom} ${etudiant.prenom}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Matricule: ${etudiant.matricule}',
                            style: const TextStyle(color: AppColors.accent),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (scanCount > 0) ...[
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$scanCount scan${scanCount > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              if (searchCount > 0) ...[
                                Icon(
                                  Icons.search,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$searchCount recherche${searchCount > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (lastEntry != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Dernière consultation: ${_formatTime(lastEntry.timestamp)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'details') {
                            _showStudentDetails(
                              context,
                              etudiant,
                              todayEntries,
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'details',
                            child: Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(width: 8),
                                Text('Voir détails'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Helper method to format time
  String _formatTime(DateTime dateTime) {
    final intl.DateFormat timeFormat = intl.DateFormat('HH:mm');
    return timeFormat.format(dateTime);
  }

  // Helper method to format time with seconds
  String _formatTimeWithSeconds(DateTime dateTime) {
    final intl.DateFormat timeFormat = intl.DateFormat('HH:mm:ss');
    return timeFormat.format(dateTime);
  }

  void _showClearHistoriqueDialog(VigileController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Vider l\'historique'),
        content: const Text(
          'Êtes-vous sûr de vouloir vider tout l\'historique ?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              controller.clearHistorique();
              Get.back();
              Get.snackbar(
                'Succès',
                'Historique vidé avec succès',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Vider', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showStudentDetails(
    BuildContext context,
    dynamic etudiant,
    List<dynamic>
    entries, // Changed from List<HistoriqueEntry> to List<dynamic>
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('${etudiant.nom} ${etudiant.prenom}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Matricule: ${etudiant.matricule}'),
              const SizedBox(height: 16),
              const Text(
                'Consultations d\'aujourd\'hui:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        entry.searchMethod == 'scan'
                            ? Icons.qr_code_scanner
                            : Icons.search,
                        size: 16,
                        color: entry.searchMethod == 'scan'
                            ? Colors.blue
                            : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatTimeWithSeconds(entry.timestamp)} - ${entry.searchMethod == 'scan' ? 'Scan QR' : 'Recherche'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }
}
