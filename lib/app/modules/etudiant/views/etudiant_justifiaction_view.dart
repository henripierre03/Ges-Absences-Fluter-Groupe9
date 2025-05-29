import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
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

  Map<String, dynamic>? currentUser;
  Map<String, dynamic>? currentEtudiant;
  Map<String, dynamic>? currentAbsence;
  Map<String, dynamic>? currentCours;
  Map<String, dynamic>? currentSalle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    setState(() {
      currentUser = {
        "id": "10",
        "nom": "Sow",
        "prenom": "Alioune",
        "email": "alioune.sow@example.com",
        "role": "etudiant",
      };

      currentEtudiant = {
        "id": "1",
        "userId": "10",
        "matricule": "ETU003",
        "niveau": "Licence 3",
        "classeId": "1",
      };

      currentAbsence = {
        "id": "1",
        "etudiantId": "1",
        "date": "2025-05-20T08:00:00.000Z",
        "absence": "nonJustifiee",
        "justificationId": null,
        "coursId": "1",
      };

      currentCours = {"id": "1", "module": "Informatique", "salleId": "1"};
      currentSalle = {"id": "1", "nom": "Salle A", "capacite": 30};
    });
  }

  static const Color primaryOrange = Color(0xFFF58613);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Justifier Absence',
          style: TextStyle(
            color: black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoCard(),
            const SizedBox(height: 25),
            _buildCourseInfoCard(),
            const SizedBox(height: 25),
            _buildMessageSection(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: primaryOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: white, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser != null
                      ? '${currentUser!['prenom']}'
                      : 'User null',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cours:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    currentCours != null ? currentCours!['module'] : 'Cours',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: currentAbsence?['absence'] == 'nonJustifiee'
                      ? Colors.red
                      : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentAbsence?['absence'] == 'nonJustifiee'
                      ? 'Non Justifiée'
                      : 'Justifiée',
                  style: const TextStyle(
                    color: white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Salle:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    currentSalle != null ? currentSalle!['nom'] : 'Salle',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                ],
              ),
              Text(
                currentAbsence != null
                    ? _formatDate(currentAbsence!['date'])
                    : 'Date',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Message de justification',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _messageController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Expliquez la raison de votre absence...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitJustification,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
        ),
        child: const Text(
          'Envoyer la justification',
          style: TextStyle(
            color: white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      DateTime date = DateTime.parse(isoDate);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return 'Date';
    }
  }

  void _submitJustification() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un message de justification'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (currentEtudiant == null || currentAbsence == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur: Données manquantes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final justificationData = JustificationCreateRequestDto(
      etudiantId: currentEtudiant!['id'],
      date: DateTime.now(),
      justificatif: _messageController.text.trim(),
      validation: false,
    );

    try {
      await controller.createJustificationAndUpdateAbsence(
        justificationData,
        currentAbsence!['id'],
      );
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text('Justification envoyée'),
            content: const Text(
              'Votre justification d\'absence a été envoyée avec succès et est en attente de validation.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: primaryOrange),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
