import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../controllers/etudiant_controller.dart';

class EtudiantJustificationView extends StatelessWidget {
  const EtudiantJustificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const JustifierAbsenceScreen();
  }
}

class JustifierAbsenceScreen extends StatefulWidget {
  const JustifierAbsenceScreen({super.key});

  @override
  _JustifierAbsenceScreenState createState() => _JustifierAbsenceScreenState();
}

class _JustifierAbsenceScreenState extends State<JustifierAbsenceScreen> {
  final TextEditingController _messageController = TextEditingController();
  final EtudiantController controller = Get.find<EtudiantController>();
  Absence? absence;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = Get.arguments;
      if (arguments != null && arguments is Absence) {
        setState(() {
          absence = arguments;
        });
      }
    });
  }

  // Other methods remain the same

  void _submitJustification() async {
    if (_messageController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a justification message');
      return;
    }

    if (absence == null) {
      Get.snackbar('Error', 'Missing data');
      return;
    }

    final justificationData = JustificationCreateRequestDto(
      etudiantId: absence!.etudiantId,
      date: DateTime.now(),
      justificatif: _messageController.text.trim(),
      validation: false,
    );

    try {
      await controller.createJustificationAndUpdateAbsence(
        justificationData,
        absence!.id,
      );
      Get.snackbar('Success', 'Justification submitted successfully');
      Get.offAllNamed(Routes.ETUDIANT); // Navigate back to the list of absences
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit justification: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Justifier Absence'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Justification Message',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitJustification,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
