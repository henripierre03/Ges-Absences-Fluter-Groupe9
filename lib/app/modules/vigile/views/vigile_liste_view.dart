import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_liste_controller.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/etat_empty.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/etat_error.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/etat_loading.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/header.dart';
import 'package:frontend_gesabsence/app/modules/vigile/widgets/student_card.dart';
import 'package:get/get.dart';

class VigileListView extends GetView<VigileListController> {
  const VigileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          const VigileHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const EtatLoading();
              if (controller.hasError.value) return EtatError(controller);
              if (controller.pointagesList.isEmpty) return const EtatEmpty();
              return RefreshIndicator(
                onRefresh: () => controller.refreshPointages(),
                color: const Color(0xFFFF6B00),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.pointagesList.length,
                  itemBuilder: (context, index) {
                    final pointage = controller.pointagesList[index];
                    return StudentCard(
                      pointage: pointage,
                      controller: controller,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
