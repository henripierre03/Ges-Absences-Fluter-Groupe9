import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the list of students when the view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllEtudiant();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: controller.passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: controller.login,
                    child: const Text('Login'),
                  )),
            const SizedBox(height: 20),
            const Text(
              'List of Students',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.etudiants.isEmpty) {
                  return const Center(child: Text("No students found"));
                }

                return ListView.builder(
                  itemCount: controller.etudiants.length,
                  itemBuilder: (context, index) {
                    final etudiant = controller.etudiants[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: ListTile(
                        title: Text("Student ${etudiant.id}"),
                        subtitle: Text("Name: ${etudiant.nom}"),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
