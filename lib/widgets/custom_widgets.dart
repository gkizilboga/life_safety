import 'package:flutter/material.dart';
import '../utils/app_progress.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';

class ModernHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Type screenType;
  final VoidCallback? onBack;

  const ModernHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.screenType,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    int currentStep = AppProgress.currentStep(screenType);
    int totalSteps = AppProgress.totalSteps;
    double progress = currentStep / totalSteps;
    final bool canPop = Navigator.canPop(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 15),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (canPop)
                GestureDetector(
                  onTap: onBack ?? () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                  ),
                )
              else
                const SizedBox(width: 28),
              Text(
                "ADIM $currentStep / $totalSteps",
                style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Analiz İlerlemesi", style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text("%${(progress * 100).toInt()}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Widget child;
  const QuestionCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E8ED), width: 1.5),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w900, 
          color: Color(0xFF1A237E), 
          height: 1.4,
        ),
        child: child,
      ),
    );
  }
}

class SectionImage extends StatelessWidget {
  final String assetPath;
  const SectionImage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          assetPath,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class TechnicalDrawingButton extends StatelessWidget {
  final String assetPath;
  final String title;

  const TechnicalDrawingButton({super.key, required this.assetPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _showImagePopup(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity, 
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1A237E).withValues(alpha: 0.2), width: 1.2),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.zoom_in_rounded, color: Color(0xFF1A237E), size: 22),
              SizedBox(width: 12),
              Text(
                "İLGİLİ GÖRSELİ İNCELE",
                style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
        child: Column(
          children: [
            Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A237E))),
            const SizedBox(height: 20),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: InteractiveViewer(minScale: 1.0, maxScale: 5.0, child: Image.asset(assetPath, fit: BoxFit.contain)))),
            const SizedBox(height: 15),
            const Text("Görseli iki parmağınızla büyütebilirsiniz.", style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            SafeArea(child: Padding(padding: const EdgeInsets.only(bottom: 30), child: SizedBox(width: double.infinity, height: 54, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () => Navigator.pop(context), child: const Text("ANLADIM", style: TextStyle(fontWeight: FontWeight.bold)))))),
          ],
        ),
      ),
    );
  }
}

class AnalysisPageLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Type screenType;
  final Widget child;
  final VoidCallback? onNext;
  final bool isNextEnabled;

  const AnalysisPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.screenType,
    required this.child,
    this.onNext,
    this.isNextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(title: title, subtitle: subtitle, screenType: screenType),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(18.0), child: child)),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 55), // Samsung alt bar için padding artırıldı
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))]),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: isNextEnabled ? () { BinaStore.instance.saveToDisk(); if (onNext != null) onNext!(); } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("DEVAM ET", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}