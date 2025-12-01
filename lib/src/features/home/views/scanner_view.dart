import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Assure-toi que le binding est utilisé depuis la route ou un parent
    final ScanController c = controller;

    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFD9CBB2), // papier/beige du mock
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            // Contenu principal (colonne centrée)
            Column(
              children: [
                // Top bar spacing + icons
                SizedBox(height: topPadding + 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu icon (left)
                      GestureDetector(
                        onTap: c.onMenuPressed,
                        child: Image.asset(
                          'assets/images/Menu Icone.png',
                          height: 26,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // small logo top-right (optionnel: tu peux remplacer par asset logo)
                      Image.asset(
                        'assets/images/Setting-button.png',
                        height: 26,
                        fit: BoxFit.contain,
                        // we use the setting asset just as small icon placeholder
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Central label image (le timbre)
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // légère ombre pour surélever l'étiquette
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/Scan icone.png',
                        width: size.width * 0.72,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Slider + handle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Obx(() {
                    return Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF00897B),
                            inactiveTrackColor: Colors.white.withOpacity(0.4),
                            thumbColor: const Color(0xFF00897B),
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          ),
                          child: Slider(
                            value: c.sliderValue.value,
                            min: 0.0,
                            max: 1.0,
                            onChanged: (v) => c.setSlider(v),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 6),

                // Scan button (icône) - centré bas
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: Center(
                    child: Obx(() {
                      return GestureDetector(
                        onTap: c.isScanning.value ? null : c.startScan,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // circular ring when scanning
                              if (c.isScanning.value)
                                SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    valueColor: AlwaysStoppedAnimation(const Color(0xFF00897B)),
                                  ),
                                ),

                              // main scan icon
                              Image.asset(
                                'assets/images/Scan icone.png',
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),

            // Top-right settings floating (real settings icon with action)
            Positioned(
              top: topPadding + 14,
              right: 18,
              child: GestureDetector(
                onTap: c.onSettingsPressed,
                child: Image.asset(
                  'assets/images/Setting-button.png',
                  height: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
