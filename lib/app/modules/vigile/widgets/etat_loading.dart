import 'package:flutter/material.dart';

class EtatLoading extends StatelessWidget {
  const EtatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFF6B00)),
          SizedBox(height: 16),
          Text(
            'Chargement des étudiants...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
