import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/core/services/firestore_service.dart';
import '../models/user_model.dart';
import '../views/login_view.dart';
import '../../home/views/scanner_view.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // google_sign_in: ^6.1.5 -> constructeur simple
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final FirestoreService _firestoreService = FirestoreService();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);

  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final postNameController = TextEditingController();

  final List<String> postNameOptions = ['Director', 'Manager', 'Employee', 'Intern'];
  final selectedPostName = 'Employee'.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
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

  void _handleAuthChanged(User? user) {
    if (user == null) {
      userModel.value = null;
      Get.offAll(() => const LoginView());
    } else {
      // charger le profil depuis Firestore et naviguer
      _firestoreService.getUser(user.uid).then((u) {
        if (u == null) {
          // Créer un profil minimal si absent
          final newUser = UserModel(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoUrl: user.photoURL,
            postName: selectedPostName.value,
            address: addressController.text.trim(),
          );
          _firestoreService.createUser(newUser);
          userModel.value = newUser;
        } else {
          userModel.value = u;
        }
        Get.offAll(() => const ScanView());
      });
    }
  }

  // EMAIL SIGN IN
  Future<void> signIn() async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // user handled by authStateChanges -> _handleAuthChanged
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCred = await _auth.signInWithCredential(credential);

      // Save user in Firestore
      final u = userCred.user;
      if (u != null) {
        final model = UserModel(
          uid: u.uid,
          email: u.email,
          displayName: u.displayName,
          photoUrl: u.photoURL,
        );
        await _firestoreService.createUser(model);
        userModel.value = model;
      }
    } catch (e) {
      _showError('Google Sign-In failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // REGISTER (EMAIL)
  Future<void> signUp() async {
    try {
      isLoading.value = true;
      final cred = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await cred.user?.updateDisplayName(nameController.text.trim());

      // build user model and save to Firestore
      final model = UserModel(
        uid: cred.user!.uid,
        email: cred.user!.email,
        displayName: nameController.text.trim(),
        address: addressController.text.trim(),
        postName: selectedPostName.value,
      );
      await _firestoreService.createUser(model);
      userModel.value = model;

      // optionally navigate to next step (e.g., scanner or profile)
      Get.offAll(() => const ScanView());
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    // userModel cleared by authStateChanges
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.15),
      colorText: Colors.red,
    );
  }
}
