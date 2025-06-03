import 'package:flutter/material.dart';
import 'package:frontend_gesabsence/app/modules/vigile/controllers/vigile_liste_controller.dart';

class StudentCard extends StatelessWidget {
  final dynamic pointage;
  final VigileListController controller;

  const StudentCard({
    super.key,
    required this.pointage,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final matricule = controller.getStudentMatricule(pointage);
    final prenom = pointage.etudiant?.prenom ?? '';
    final nom = pointage.etudiant?.nom ?? '';
    final email = pointage.etudiant?.email ?? '';
    final niveau = pointage.etudiant?.niveau ?? 'L3';
    final filiere = pointage.etudiant?.filiere ?? 'GLRS';
    final typeAbsence = pointage.typeAbsence ?? 'Présent';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStudentInfo('Nom:', nom),
                _buildStudentInfo('Prénom:', prenom),
                _buildStudentInfo('Email:', email),
                _buildStudentInfo('Matricule:', matricule),
                _buildStudentInfo('Niveau:', niveau),
                _buildStudentInfo('Filière:', filiere),
              ],
            ),
          ),
          _buildStatusBadge(typeAbsence),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFF6B00), width: 3),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFF6B00),
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildStudentInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String typeAbsence) {
    final color = controller.getTypeAbsenceColor(typeAbsence);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        typeAbsence,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
