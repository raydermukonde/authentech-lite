import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const Icon(
                    Icons.verified_user_outlined, // Placeholder for small logo
                    size: 24,
                    color: Colors.black,
                  ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                "Create account",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Mockup uses black/dark grey
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                ),
              ),
              const SizedBox(height: 16),
              
              // Post Name Dropdown
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedPostName.value,
                    decoration: const InputDecoration(
                      labelText: 'Post Name',
                    ),
                    items: controller.postNameOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedPostName.value = newValue;
                      }
                    },
                  )),
              const SizedBox(height: 16),

              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  hintText: 'Enter your email',
                  suffixIcon: Icon(Icons.arrow_drop_down), // Mockup style hint
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

               TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password', // Added for functionality
                  hintText: 'Create a password',
                ),
              ),
               const SizedBox(height: 16),
              
              TextField(
                controller: controller.addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your address',
                ),
              ),
              const SizedBox(height: 40),

              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.signUp,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Next"), // Mockup says "Next"
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
