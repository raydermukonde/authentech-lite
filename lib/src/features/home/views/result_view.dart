import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/themes/app_theme.dart';
import '../controllers/scan_controller.dart';

class ResultView extends GetView<ScanController> {
  final bool isSuccess;
  final String message;

  const ResultView({
    super.key, 
    this.isSuccess = true, 
    this.message = "Congrat your Stamp is compliant"
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments if passed via navigation
    final bool success = Get.arguments?['isSuccess'] ?? isSuccess;
    final String msg = Get.arguments?['message'] ?? message;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          success ? "Scan Success" : "Scan Failed",
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            // Circle Indicator
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: success ? AppTheme.successGreen : AppTheme.errorRed,
                boxShadow: [
                  BoxShadow(
                    color: (success ? AppTheme.successGreen : AppTheme.errorRed).withAlpha(100),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Icon(
                success ? Icons.check : Icons.close,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            
            Text(
              msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const Spacer(),
            
            if (success) ...[
              OutlinedButton(
                onPressed: () {
                   Get.snackbar("Saved", "Stamp saved to history");
                   Get.back(); // Or navigate to history
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.darkTeal),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save it", style: TextStyle(color: AppTheme.darkTeal)),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                   side: const BorderSide(color: AppTheme.darkTeal),
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Deep Scan", style: TextStyle(color: AppTheme.darkTeal)),
              ),
            ] else ...[
              OutlinedButton(
                onPressed: () => Get.back(), // Try again
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.darkTeal),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Try again", style: TextStyle(color: AppTheme.darkTeal)),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
