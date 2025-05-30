import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/parametres_controller.dart';

class ParametresView extends GetView<ParametresController> {
  const ParametresView({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Paramètres View is working',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Action à effectuer lors de l'appui sur le bouton
              Get.snackbar('Info', 'Bouton Paramètres cliqué');
            },
            child: const Text('Cliquez ici pour une action'),
          ),
        ],
      ),
    );
  }
}
