import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../views/login_view.dart';
import '../../home/views/scanner_view.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✔ Correction : constructeur valide pour google_sign_in 7.2.0
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

  final firebaseUser = Rx<User?>(null);

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final postNameController = TextEditingController();

  // Dropdown
  final List<String> postNameOptions = [
    "Director",
    "Manager",
    "Employee",
    "Intern"
  ];
  final selectedPostName = "Employee".obs;

  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    addressController.dispose();
    postNameController.dispose();
    super.onClose();
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginView());
    } else {
      Get.offAll(() => const ScannerView());
    }
  }

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Login failed");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- GOOGLE LOGIN ----------------

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // cancel
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      _showError("Google Sign-In failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- REGISTER ----------------

  Future<void> signUp() async {
    try {
      isLoading.value = true;

      final cred = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await cred.user?.updateDisplayName(nameController.text.trim());
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.15),
      colorText: Colors.red,
    );
  }
}
