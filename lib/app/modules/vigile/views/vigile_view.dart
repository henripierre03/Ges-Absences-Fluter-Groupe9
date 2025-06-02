import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/vigile/views/qr_scanner_page.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/vigile_controller.dart';

class VigileView extends GetView<VigileController> {
  const VigileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                'Scan QR Code de l\'étudiant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => _openQRScanner(context),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ),

                          Positioned(
                            left: 30,
                            right: 30,
                            top: 120,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.lightBlueAccent.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Coins du cadre
                          const Positioned(
                            top: 40,
                            left: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Positioned(
                            top: 40,
                            right: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Positioned(
                            bottom: 40,
                            left: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Positioned(
                            bottom: 40,
                            right: 40,
                            child: Icon(
                              Icons.crop_free,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'The QR Code will be automatically detected\nwhen you position it between the guide lines',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Section Recherche
              const Text(
                'Rechercher',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Container orange pour la recherche
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Champ de recherche
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Veuillez entrer le matricule de l\'étudiant',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        onSubmitted: (value) => _validateSearch(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Bouton Valider avec état de chargement
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: controller.isSearching.value
                              ? null
                              : () => _validateSearch(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isSearching.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Valider',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Section d'affichage des résultats
              Obx(() {
                if (controller.foundStudent.value != null) {
                  return _buildStudentCard(controller.foundStudent.value!);
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return _buildErrorCard();
                } else {
                  return const SizedBox.shrink();
                }
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour afficher les informations de l'étudiant trouvé - CORRIGÉ
  Widget _buildStudentCard(dynamic student) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.green.shade600, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Étudiant trouvé',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Correction principale : Accès aux propriétés directement
          _buildInfoRow(
            'Nom:',
            '${student.prenom ?? 'N/A'} ${student.nom ?? 'N/A'}',
          ),
          _buildInfoRow('Matricule:', student.matricule ?? 'N/A'),
          _buildInfoRow('Email:', student.email ?? 'N/A'),

          // Gestion des valeurs null pour filiere et niveau
          _buildInfoRow(
            'Filière:',
            student.filiere?.toString() ?? 'Non définie',
          ),
          _buildInfoRow('Niveau:', student.niveau?.toString() ?? 'Non défini'),

          const SizedBox(height: 15),

          // Bouton pour pointer l'étudiant
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _markPresence(student.matricule ?? ''),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text('Marquer présent'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Bouton pour effacer la recherche
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.clearSearch(),
              icon: const Icon(Icons.clear),
              label: const Text('Nouvelle recherche'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade400),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher les erreurs
  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 48),
          const SizedBox(height: 10),
          const Text(
            'Étudiant non trouvé',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Vérifiez le matricule et réessayez',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => controller.clearSearch(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Réessayer'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper pour afficher une ligne d'information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour ouvrir le scanner QR
  void _openQRScanner(BuildContext context) async {
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QRScannerPage()),
      );

      if (result != null) {
        controller.handleQRScan(result);
      }
    } else {
      Get.snackbar(
        'Permission requise',
        'L\'accès à la caméra est nécessaire pour scanner les QR codes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Méthode pour valider la recherche
  void _validateSearch() {
    final searchText = controller.searchController.text;
    if (searchText.isNotEmpty) {
      controller.searchStudentByMatricule(searchText);
    } else {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer un matricule',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Méthode pour marquer la présence
  void _markPresence(String matricule) {
    if (matricule.isNotEmpty) {
      // Vous pouvez implémenter la logique de pointage ici
      // Par exemple, appeler controller.markStudentPresence(matricule, vigileId)
      Get.snackbar(
        'Succès',
        'Présence marquée pour l\'étudiant $matricule',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
}
