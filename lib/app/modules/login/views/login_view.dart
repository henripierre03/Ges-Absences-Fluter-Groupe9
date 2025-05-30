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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // Header
                const Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF351F16),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Connection type text
                const Text(
                  'Je me connecte en tant que',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF351F16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // User type selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildUserTypeButton(
                      icon: Icons.school,
                      label: 'Vigile',
                      isSelected: controller.selectedUserType.value == 'vigile',
                      onTap: () => controller.setUserType('vigile'),
                    ),
                    _buildUserTypeButton(
                      icon: Icons.person,
                      label: 'Étudiant',
                      isSelected: controller.selectedUserType.value == 'etudiant',
                      onTap: () => controller.setUserType('etudiant'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Login form container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF351F16),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email field
                      _buildTextField(
                        controller: controller.emailController,
                        label: 'E-mail',
                        icon: Icons.email_outlined,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password field
                      _buildTextField(
                        controller: controller.passwordController,
                        label: 'Mot de Passe',
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Remember me and forgot password row
                      Row(
                        children: [
                          Obx(() => Row(
                            children: [
                              Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) => controller.setRememberMe(value ?? false),
                                activeColor: const Color(0xFFF58613),
                                checkColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                              const Text(
                                'Se Souvenir',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: const Text(
                              'Mot de Passe Oublié?',
                              style: TextStyle(
                                color: Color(0xFFF58613),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value ? null : controller.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF58613),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            disabledBackgroundColor: const Color(0xFFF58613).withOpacity(0.6),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Se Connecter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        )),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Students list section (if needed for debugging)
                if (controller.etudiants.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Liste des Étudiants',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF351F16),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: controller.etudiants.length,
                            itemBuilder: (context, index) {
                              final etudiant = controller.etudiants[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFF58613).withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: const Color(0xFFF58613).withOpacity(0.2),
                                      child: Text(
                                        etudiant.nom.isNotEmpty ? etudiant.nom[0].toUpperCase() : 'E',
                                        style: const TextStyle(
                                          color: Color(0xFF351F16),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            etudiant.nom,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF351F16),
                                            ),
                                          ),
                                          Text(
                                            'ID: ${etudiant.id}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color(0xFF351F16).withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF58613) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFF58613) : const Color(0xFF351F16).withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFF58613).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFFF58613) : const Color(0xFF351F16),
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF351F16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.white24,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFF58613),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}