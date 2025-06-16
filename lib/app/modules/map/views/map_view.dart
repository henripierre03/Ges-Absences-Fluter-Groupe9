import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart' as custom_map;
import 'package:frontend_gesabsence/app/modules/layout/views/custom_bottom_navigation_bar.dart';
import 'package:frontend_gesabsence/app/modules/login/controllers/login_controller.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Créer/récupérer le contrôleur
    final controller = Get.put(custom_map.MapController());
    final LoginController loginController = Get.find<LoginController>();
    final RxInt selectedIndex = 3.obs; // Index 3 pour la map

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              // Carte
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter:
                                controller.userPosition.value ??
                                controller.schoolLocation,
                            initialZoom: 14.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            // Ligne entre l'utilisateur et l'école
                            if (controller.userPosition.value != null)
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: [
                                      controller.userPosition.value!,
                                      controller.schoolLocation,
                                    ],
                                    color: const Color(0xFF2196F3),
                                    strokeWidth: 3.0,
                                  ),
                                ],
                              ),
                            MarkerLayer(
                              markers: [
                                // Marqueur de l'école
                                Marker(
                                  point: controller.schoolLocation,
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B00),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.school,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                // Marqueur de l'utilisateur
                                if (controller.userPosition.value != null)
                                  Marker(
                                    point: controller.userPosition.value!,
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2196F3),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.navigation,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        // Bouton de rafraîchissement
                        Positioned(
                          top: 16,
                          right: 16,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.white,
                            onPressed: controller.refreshLocation,
                            child: controller.isLoadingLocation.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.my_location,
                                    color: Color(0xFF2196F3),
                                  ),
                          ),
                        ),
                        // Légende
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2196F3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Ma Position',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF6B00),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'ISM Campus',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Section des prochains cours
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mes Prochains Cours',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: controller.nextCourses.isEmpty
                            ? const Center(
                                child: Text(
                                  'Aucun cours à venir',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: controller.nextCourses.length,
                                itemBuilder: (context, index) {
                                  final course = controller.nextCourses[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFFF6B00),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Cours: ${course.name}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFF2C3E50),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Salle: ${course.room}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF7F8C8D),
                                                ),
                                              ),
                                              Text(
                                                'Lieu: ${course.location}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF7F8C8D),
                                                ),
                                              ),
                                              Text(
                                                'De ${course.startTime} à ${course.endTime}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF7F8C8D),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          course.date,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF95A5A6),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
