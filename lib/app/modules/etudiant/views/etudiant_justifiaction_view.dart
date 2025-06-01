// import 'package:flutter/material.dart';
// import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
// import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
// import 'package:frontend_gesabsence/app/routes/app_pages.dart';
// import 'package:get/get.dart';

// import '../controllers/etudiant_controller.dart';

// class EtudiantJustificationView extends StatelessWidget {
//   const EtudiantJustificationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const JustifierAbsenceScreen();
//   }
// }

// class JustifierAbsenceScreen extends StatefulWidget {
//   const JustifierAbsenceScreen({super.key});

//   @override
//   _JustifierAbsenceScreenState createState() => _JustifierAbsenceScreenState();
// }

// class _JustifierAbsenceScreenState extends State<JustifierAbsenceScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final EtudiantController controller = Get.find<EtudiantController>();
//   Absence? absence;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final arguments = Get.arguments;
//       if (arguments != null && arguments is Absence) {
//         setState(() {
//           absence = arguments;
//         });
//       }
//     });
//   }

//   // Other methods remain the same

//   void _submitJustification() async {
//     if (_messageController.text.trim().isEmpty) {
//       Get.snackbar('Error', 'Please enter a justification message');
//       return;
//     }

//     if (absence == null) {
//       Get.snackbar('Error', 'Missing data');
//       return;
//     }

//     final justificationData = JustificationCreateRequestDto(
//       etudiantId: absence!.etudiantId,
//       date: DateTime.now(),
//       justificatif: _messageController.text.trim(),
//       validation: false,
//     );

//     try {
//       await controller.createJustificationAndUpdateAbsence(
//         justificationData,
//         absence!.id,
//       );
//       Get.snackbar('Success', 'Justification submitted successfully');
//       Get.offAllNamed(Routes.ETUDIANT); // Navigate back to the list of absences
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to submit justification: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Justifier Absence'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _messageController,
//               decoration: const InputDecoration(
//                 labelText: 'Justification Message',
//               ),
//               maxLines: 5,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitJustification,
//               child: const Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/justification_model.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../controllers/etudiant_controller.dart';

class EtudiantJustificationView extends GetView<EtudiantController> {
  const EtudiantJustificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return JustifierAbsenceScreen(controller: controller);
  }
}

class JustifierAbsenceScreen extends StatefulWidget {
  final EtudiantController controller;

  const JustifierAbsenceScreen({super.key, required this.controller});

  @override
  _JustifierAbsenceScreenState createState() => _JustifierAbsenceScreenState();
}

class _JustifierAbsenceScreenState extends State<JustifierAbsenceScreen> {
  final TextEditingController _messageController = TextEditingController();
  Absence? absence;
  bool isJustified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = Get.arguments;
      if (arguments != null && arguments is Absence) {
        setState(() {
          absence = arguments;
          isJustified = absence!.justificationId != null;
        });

        // If the absence is already justified, fetch and populate the justification text
        if (isJustified) {
          _loadExistingJustification();
        }
      }
    });
  }

  Future<void> _loadExistingJustification() async {
    if (absence?.justificationId != null) {
      try {
        // Fetch the justification details using the justificationId
        final justifications = await widget.controller.justificationApiService
            .getJustificationByEtudiantId(absence!.justificationId!);

        if (justifications != null && justifications.isNotEmpty) {
          setState(() {
            _messageController.text = justifications.first?.justificatif ?? '';
          });
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to load existing justification: $e');
      }
    }
  }

  void _submitJustification() async {
    if (_messageController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a justification message');
      return;
    }

    if (absence == null) {
      Get.snackbar('Error', 'Missing data');
      return;
    }

    // If already justified, update the existing justification
    if (isJustified && absence!.justificationId != null) {
      try {
        await widget.controller.justificationApiService
            .updateJustification(absence!.justificationId!, {
              'justificatif': _messageController.text.trim(),
              'date': DateTime.now().toIso8601String(),
            });
        Get.snackbar('Success', 'Justification updated successfully');
        Get.offAllNamed(Routes.ETUDIANT);
      } catch (e) {
        Get.snackbar('Error', 'Failed to update justification: $e');
      }
    } else {
      // Create new justification
      List<Justification?> justifications = await widget
          .controller
          .justificationApiService
          .getAllJustifications();

      List<JustificationCreateRequestDto> justificationCreateRequestDtos =
          justifications
              .where((justification) => justification != null)
              .map(
                (justification) => JustificationCreateRequestDto(
                  id: justification!.id,
                  etudiantId: justification.etudiantId,
                  date: justification.date,
                  justificatif: justification.justificatif,
                  validation: justification.validation,
                ),
              )
              .toList();

      String newId = JustificationCreateRequestDto.generateNewId(
        justificationCreateRequestDtos,
      );

      final justificationData = JustificationCreateRequestDto(
        id: newId,
        etudiantId: absence!.etudiantId,
        date: DateTime.now(),
        justificatif: _messageController.text.trim(),
        validation: false,
      );

      try {
        await widget.controller.createJustificationAndUpdateAbsence(
          justificationData,
          absence!.id,
        );
        Get.snackbar('Success', 'Justification submitted successfully');
        Get.offAllNamed(Routes.ETUDIANT);
      } catch (e) {
        Get.snackbar('Error', 'Failed to submit justification: $e');
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF351F16),
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        title: Text(
          isJustified ? 'Modifier Justification' : 'Justifier Absence',
          style: const TextStyle(
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Absence Info Card
              if (absence != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF58613).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.event_busy,
                              color: Color(0xFFF58613),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Absence #${absence!.id}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF351F16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFFF58613),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(absence!.date),
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF351F16).withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (isJustified) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF58613).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Déjà justifiée",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFF58613),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              // Justification Input Section
              const Text(
                "Message de justification",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF351F16),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText:
                          'Veuillez expliquer la raison de votre absence...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14,
                      ),
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF351F16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitJustification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF58613),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isJustified
                        ? 'Modifier la justification'
                        : 'Soumettre la justification',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final List<String> months = [
        'Jan',
        'Fév',
        'Mar',
        'Avr',
        'Mai',
        'Jun',
        'Jul',
        'Aoû',
        'Sep',
        'Oct',
        'Nov',
        'Déc',
      ];
      return "${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }
}
