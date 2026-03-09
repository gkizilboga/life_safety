import 'package:flutter/material.dart';
import '../logic/report_engine.dart';
import '../widgets/confetti_particles.dart';
import '../utils/app_progress.dart';
import '../data/bina_store.dart';

class ModuleTransitionScreen extends StatelessWidget {
  final ReportModule module;
  final VoidCallback onContinue;

  const ModuleTransitionScreen({
    super.key,
    required this.module,
    required this.onContinue,
  });

  String? _getEncouragingMessage() {
    switch (module) {
      case ReportModule.binaBilgileri:
        return "Harikasın! Genel bilgileri başarıyla tamamladın!";
      case ReportModule.modul1:
        return "Tempoyu hiç düşürmüyorsun!";
      case ReportModule.modul2:
        return "Muazzam ilerliyorsun!";
      case ReportModule.modul3:
        return "Hedefe çok az kaldı!";
      case ReportModule.modul4:
        return "Neredeyse bitmek üzere!";
      case ReportModule.modul5:
        return "Tebrikler, tüm analizi tamamladın!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ReportEngine.calculateRiskMetrics();
    final int criticalCount = metrics['criticalCount'] ?? 0;
    final progressRes = AppProgress.getAnalysisProgress(BinaStore.instance);
    final int completion = progressRes.percentage;
    final String? encouragingMessage = _getEncouragingMessage();

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: ConfettiParticles(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield_rounded,
                color: Color(0xFFFFD700),
                size: 80,
              ),
              const SizedBox(height: 30),
              Text(
                module.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "TAMAMLANDI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (encouragingMessage != null) ...[
                const SizedBox(height: 20),
                // Progress Message
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        encouragingMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: "Şu ana kadar "),
                            TextSpan(
                              text: "$criticalCount adet Kritik Risk",
                              style: const TextStyle(
                                color: Color(0xFFFF5252),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: " tespit ettik.\n"),
                            const TextSpan(text: "Analizin "),
                            TextSpan(
                              text: "%$completion",
                              style: const TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: " kısmını başarıyla tamamladın.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (module != ReportModule.binaBilgileri) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "YENİ RÜTBE: ${module.rankName}",
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        module.rankDescription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ] else
                const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onContinue,
                  child: const Text(
                    "SONRAKİ MODÜLE GEÇ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
