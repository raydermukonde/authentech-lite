import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ScanController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController();
  final isScanning = false.obs;
  final scanResult = Rx<String?>(null);
  
  // Placeholder for AI Analysis
  Future<void> analyzeImage(Uint8List imageBytes) async {
    isScanning.value = true;
    try {
      // Initialize the model
      // ignore: deprecated_member_use
      final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
      
      // Create the prompt
      final prompt = "Analyse cette image. Est-ce un timbre valide contenant le texte 'Mutondo's Legacy' ? Réponds par un JSON : {compliant: bool, reason: string}";
      
      // Generate content
      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          // Using InlineDataPart for binary data in older/compatible SDKs
          InlineDataPart('image/jpeg', imageBytes),
        ])
      ]);
      
      // Here you would parse the JSON response
      // For now, we just show the raw text
      Get.snackbar(
        "Scan Complete", 
        response.text ?? "No response",
        backgroundColor: Colors.green.withAlpha(25),
        colorText: Colors.green,
      );
      
    } catch (e) {
      Get.snackbar("Error", "Analysis failed: $e");
    } finally {
      isScanning.value = false;
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
