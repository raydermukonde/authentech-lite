import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/core/themes/app_theme.dart';
import 'src/features/auth/controllers/auth_controller.dart';
import 'src/features/auth/views/login_view.dart';
// import 'src/features/home/views/scanner_view.dart'; // Will be used by controller

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const StampCheckApp());
}

class StampCheckApp extends StatelessWidget {
  const StampCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StampCheck',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      home: const LoginView(), 
      // AuthController will handle redirection in onReady based on user state
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
