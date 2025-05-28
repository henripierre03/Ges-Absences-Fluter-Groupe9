import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/etudiant_controller.dart';

class EtudiantView extends GetView<EtudiantController> {
  const EtudiantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EtudiantView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EtudiantView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
