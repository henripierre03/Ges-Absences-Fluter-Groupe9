import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_simple_response.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/views/etudiant_justification_view.dart';
import 'package:frontend_gesabsence/app/modules/layout/views/custom_bottom_navigation_bar.dart';
import 'package:frontend_gesabsence/app/modules/map/views/map_view.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/app_bar.dart';
import 'package:get/get.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';
import 'package:intl/intl.dart';

class EtudiantView extends GetView<EtudiantController> {
  EtudiantView({super.key});

  final RxInt _selectedIndex = 1.obs;
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: const GreetingAppBar(title: 'Étudiant'),
        body: SafeArea(child: _buildPage(_selectedIndex.value)),
        bottomNavigationBar: SafeArea(
          child: CustomBottomNavigationBar(
            currentIndex: _selectedIndex.value,
            onTap: (index) async {
              if (index == 0) {
                // Gérer la déconnexion
                final shouldLogout = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text(
                      'Voulez-vous vraiment vous déconnecter ?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text('Déconnecter'),
                      ),
                    ],
                  ),
                  barrierDismissible: false,
                );

                if (shouldLogout == true) {
                  await loginController.logout();
                }
              } else {
                _selectedIndex.value = index;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 1:
        return _buildAbsencePage();
      case 2:
        return _buildHomePage();
      case 3:
        return MapView();
      default:
        return _buildHomePage();
    }
  }

  // Exemple d'utilisation des infos étudiant dans votre vue
  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Après le Container d'informations de l'étudiant
          const SizedBox(height: 20),
          Obx(() {
            if (controller.isLoadingQrCode.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.qrCodeImage.value != null) {
              return Center(
                child: Column(
                  children: [
                    const Text(
                      'Votre QR Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.memory(
                        controller.qrCodeImage.value!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            } else if (controller.qrCodeErrorMessage.value.isNotEmpty) {
              return Center(child: Text(controller.qrCodeErrorMessage.value));
            } else {
              return const SizedBox(); // Pas d'image ni d'erreur
            }
          }),
        ],
      ),
    );
  }

  Widget _buildAbsencePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this
        children: [
          const Text(
            'Liste des Absences, Présences et Retards',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            // Changed from Expanded to Flexible
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (controller.absences.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucune absence enregistrée.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.absences.length,
                  itemBuilder: (context, index) {
                    final absence = controller.absences[index];
                    return _buildAbsenceCard(absence);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenceCard(AbsenceSimpleResponseDto absence) {
    Color statusColor;
    String statusText;

    switch (absence.typeAbsence.toUpperCase()) {
      case 'ABSENCE':
        statusColor = Colors.red;
        statusText = 'Absent';
        break;
      case 'PRESENCE':
        statusColor = Colors.green;
        statusText = 'Présent';
        break;
      case 'RETARD':
        statusColor = Colors.orange;
        statusText = 'En Retard';
        break;
      default:
        statusColor = Colors.grey;
        statusText = absence.typeAbsence;
    }

    // Logique améliorée pour déterminer si on peut justifier
    bool canJustify =
        absence.typeAbsence.toUpperCase() == 'ABSENCE' &&
        !absence.hasJustification;

    print('Absence ID: ${absence.id}');
    print('Type: ${absence.typeAbsence}');
    print('Has Justification: ${absence.hasJustification}');
    print('Can Justify: $canJustify');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Cours: Flutter',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Affichage conditionnel des boutons
                        if (canJustify) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showJustificationPopup(absence),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ] else if (absence.hasJustification &&
                            absence.typeAbsence.toUpperCase() == 'ABSENCE') ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Salle: 204',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy à HH:mm').format(absence.date),
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (absence.hasJustification &&
                        absence.typeAbsence.toUpperCase() == 'ABSENCE') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Justifiée',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showJustificationPopup(AbsenceSimpleResponseDto absence) {
    if (absence.hasJustification) {
      Get.snackbar(
        'Information',
        'Cette absence a déjà une justification',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      EtudiantJustificationViewPopup(absence: absence),
      barrierDismissible: false,
    );
  }
}
