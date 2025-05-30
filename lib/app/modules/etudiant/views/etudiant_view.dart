import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/modules/etudiant/controllers/etudiant_controller.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EtudiantView extends GetView<EtudiantController> {
  const EtudiantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                } else if (controller.errorMessage.value.isNotEmpty) {
                  return _buildErrorState();
                } else if (controller.absences.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildAbsencesList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF351F16),
      foregroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      title: const Text(
        "Mes Absences",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFFFFF)),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildHeader() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(4),
    decoration: const BoxDecoration(
      color: Color(0xFF351F16),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Column(
      children: [
        // Student Info Section
        Obx(() {
          final etudiant = controller.etudiant.value;
          if (etudiant == null) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(
                color: Color(0xFFF58613),
              ),
            );
          }
          
          return Column(
            children: [
              // Student Name
              Text(
                "${etudiant.prenom} ${etudiant.nom}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              
              // QR Code Container with gradient background - FULL WIDTH
              Container(
                width: double.infinity, // Ensure full width
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Add margin instead of padding
                padding: const EdgeInsets.all(20), // Reduce padding
                decoration: BoxDecoration(
                  color: Color(0xFFF58613),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // QR Code with white background
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: etudiant.matricule,
                            version: QrVersions.auto,
                            size: 120.0,
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF351F16),
                          ),
                          Text(
                            "Matricule: ${etudiant.matricule}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF351F16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        
        const SizedBox(height: 4),
        const Text(
          "Scannez ce code QR pour marquer votre présence",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFF58613),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
        
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFF351F16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Erreur de chargement",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF351F16),
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF351F16).withOpacity(0.7),
              ),
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final arguments = Get.arguments;
                if (arguments != null && arguments is Map<String, dynamic>) {
                  final etudiantId = arguments['etudiantId'];
                  controller.fetchEtudiantData(etudiantId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF58613),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF58613).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Color(0xFFF58613),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Félicitations !",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF351F16),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Vous n'avez aucune absence enregistrée",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF351F16),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Continuez votre excellent travail !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF351F16).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsencesList() {
    return RefreshIndicator(
      color: const Color(0xFFF58613),
      onRefresh: () async {
        final arguments = Get.arguments;
        if (arguments != null && arguments is Map<String, dynamic>) {
          final etudiantId = arguments['etudiantId'];
          await controller.fetchAbsencesByEtudiantId(etudiantId);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.absences.length,
        itemBuilder: (context, index) {
          final absence = controller.absences[index];
          return _buildAbsenceCard(absence, index);
        },
      ),
    );
  }

  Widget _buildAbsenceCard(Absence absence, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.toNamed(
              Routes.ETUDIANT_JUSTIFICATION,
              arguments: absence,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getStatusColor(absence),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF58613).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.event_busy,
                    color: Color(0xFFF58613),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Absence #${absence.id}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF351F16),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFFF58613),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(absence.date),
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF351F16).withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getStatusText(absence),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(absence),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF351F16).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF351F16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(Absence absence) {
    if (absence.justificationId != null) {
      return const Color(0xFFF58613); // Orange for justified
    } else {
      return const Color(0xFF351F16); // Dark brown for not justified
    }
  }

  String _getStatusText(Absence absence) {
    if (absence.justificationId != null) {
      return "Justifiée";
    } else {
      return "Non justifiée";
    }
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final List<String> months = [
        'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
        'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
      ];
      return "${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }
}