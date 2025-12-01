import 'package:get/get.dart';

class ScanController extends GetxController {
  // slider value (0.0 - 1.0)
  final RxDouble sliderValue = 0.2.obs;

  // state for showing a scanning animation / progress (mock)
  final RxBool isScanning = false.obs;

  void setSlider(double v) => sliderValue.value = v;

  Future<void> startScan() async {
    if (isScanning.value) return;
    isScanning.value = true;
    // Simule une action de scan (remplace par ta logique réelle)
    await Future.delayed(const Duration(seconds: 2));
    isScanning.value = false;
    // tu peux appeler une méthode pour analyser l'image, etc.
  }

  void onMenuPressed() {
    // ouvrir drawer ou menu
    Get.snackbar('Menu', 'Menu pressed');
  }

  void onSettingsPressed() {
    // ouvrir la page des paramètres
    Get.snackbar('Settings', 'Settings pressed');
  }
}
