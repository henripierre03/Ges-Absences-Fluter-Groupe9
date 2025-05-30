import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vigile_controller.dart';

class VigileView extends GetView<VigileController> {
  const VigileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VigileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VigileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
