import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/layout/views/custom_bottom_navigation_bar.dart';
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
          const Text(
            'Tableau de bord',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
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
                  shrinkWrap: true, // Add this
                  physics: const AlwaysScrollableScrollPhysics(), // Add this
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

  Widget _buildAbsenceCard(dynamic absence) {
    Color statusColor;
    String statusText;

    // Déterminer la couleur et le texte selon le type d'absence
    switch (absence.typeAbsence.toLowerCase()) {
      case 'absent':
        statusColor = Colors.red;
        statusText = 'Absent';
        break;
      case 'present':
        statusColor = Colors.green;
        statusText = 'Présent';
        break;
      case 'retard':
        statusColor = Colors.orange;
        statusText = 'En Retard';
        break;
      default:
        statusColor = Colors.grey;
        statusText = absence.typeAbsence;
    }

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
        crossAxisAlignment: CrossAxisAlignment.start, // Add this
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
              mainAxisSize: MainAxisSize.min, // Add this
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start, // Add this
                  children: [
                    Flexible(
                      // Wrap with Flexible
                      child: Text(
                        'Cours: Flutter', // You can replace with absence.cours if available
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis, // Add this
                      ),
                    ),
                    const SizedBox(width: 8), // Add spacing
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
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Salle: 204',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy à HH:mm').format(absence.date),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
