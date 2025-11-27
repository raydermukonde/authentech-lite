import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/scan_controller.dart';
import '../../../core/themes/app_theme.dart';

class ScannerView extends GetView<ScanController> {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is put
    final controller = Get.put(ScanController());

    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(
        title: const Text("Stamp Scanner"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.cameraController,
            onDetect: (capture) {
              // The barcode detection is not used for this specific AI image analysis flow
              // but the camera view is needed.
            },
          ),
          
          // Overlay
          Container(
            decoration: ShapeDecoration(
              shape: OverlayShape(
                borderColor: AppTheme.darkTeal,
                borderRadius: 20,
                borderLength: 40,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Align the stamp within the frame",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () async {
                    // Trigger image capture logic here
                    // e.g., controller.captureAndAnalyze();
                    Get.snackbar("Info", "Capture functionality to be implemented");
                  },
                  backgroundColor: AppTheme.darkTeal,
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
          
          // Loading Indicator
          Obx(() => controller.isScanning.value 
            ? Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: AppTheme.successGreen),
                ),
              ) 
            : const SizedBox.shrink()
          ),
        ],
      ),
    );
  }
}

// Custom Overlay Shape
class OverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;

  const OverlayShape({
    required this.borderColor,
    required this.borderWidth,
    required this.borderLength,
    required this.borderRadius,
    required this.cutOutSize,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero)
      ..addRect(
        Rect.fromCenter(
          center: rect.center,
          width: cutOutSize,
          height: cutOutSize,
        ),
      );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Unused variables commented out or removed to fix lint warnings
    // final width = rect.width; 
    // final height = rect.height;

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final backgroundPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Draw background with hole
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: rect.center,
                width: cutOutSize,
                height: cutOutSize,
              ),
              Radius.circular(borderRadius),
            ),
          ),
      ),
      backgroundPaint,
    );
    
    // Draw corners
    final r = cutOutSize / 2;
    final path = Path();
    
    // Top left
    path.moveTo(rect.center.dx - r, rect.center.dy - r + borderLength);
    path.lineTo(rect.center.dx - r, rect.center.dy - r);
    path.lineTo(rect.center.dx - r + borderLength, rect.center.dy - r);
    
    // Top right
    path.moveTo(rect.center.dx + r - borderLength, rect.center.dy - r);
    path.lineTo(rect.center.dx + r, rect.center.dy - r);
    path.lineTo(rect.center.dx + r, rect.center.dy - r + borderLength);
    
    // Bottom right
    path.moveTo(rect.center.dx + r, rect.center.dy + r - borderLength);
    path.lineTo(rect.center.dx + r, rect.center.dy + r);
    path.lineTo(rect.center.dx + r - borderLength, rect.center.dy + r);
    
    // Bottom left
    path.moveTo(rect.center.dx - r + borderLength, rect.center.dy + r);
    path.lineTo(rect.center.dx - r, rect.center.dy + r);
    path.lineTo(rect.center.dx - r, rect.center.dy + r - borderLength);

    canvas.drawPath(path, paint);
  }
  
  @override
  ShapeBorder scale(double t) => this;
}
