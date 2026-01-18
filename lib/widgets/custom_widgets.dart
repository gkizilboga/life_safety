import 'package:flutter/material.dart';
import '../utils/app_progress.dart';
import '../utils/app_theme.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
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
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                )
              else
                const SizedBox(width: 28),
              Text(
                "ADIM $currentStep / $totalSteps",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppStyles.headerTitle),
          const SizedBox(height: 12),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "İlerleme",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "%${(progress * 100).toInt()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.successGreen,
                  ),
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
      margin: const EdgeInsets.only(bottom: 12), // Reduced from 16
      padding: const EdgeInsets.all(16), // Reduced from 20
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryBlue,
          height: 1.3,
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          assetPath,
          width: double.infinity,
          height: 180, // Slightly reduced height
          fit: BoxFit.cover,
          cacheWidth:
              800, // Optimize memory: Resize to 800px width during decode
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class TechnicalDrawingButton extends StatelessWidget {
  final String assetPath;
  final String title;

  const TechnicalDrawingButton({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: () => _showImagePopup(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade50, Colors.cyan.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.teal.shade400,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_search_rounded,
                color: Colors.teal.shade700,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                "İLGİLİ GÖRSELİ İNCELE",
                style: TextStyle(
                  color: Colors.teal.shade800,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Görseli iki parmağınızla büyütebilirsiniz.",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50, // Standard button height
                  child: ElevatedButton(
                    style: AppStyles.mainButton, // Use standard button style
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ANLADIM"),
                  ),
                ),
              ),
            ),
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
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          ModernHeader(
            title: title,
            subtitle: subtitle,
            screenType: screenType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              40,
            ), // Reduced bottom padding (was 55)
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: isNextEnabled
                    ? () {
                        BinaStore.instance.saveToDisk();
                        if (onNext != null) onNext!();
                      }
                    : null,
                style: AppStyles.mainButton, // Use standard button style
                child: const Text("DEVAM ET"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DefinitionButton extends StatelessWidget {
  final String term;
  final String definition;

  const DefinitionButton({
    super.key,
    required this.term,
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDefinition(context),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange.shade400, width: 1.5),
        ),
        child: Icon(
          Icons.help_outline_rounded,
          size: 18,
          color: Colors.orange.shade800,
        ),
      ),
    );
  }

  void _showDefinition(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          margin: const EdgeInsets.only(bottom: 16), // Extra bottom margin for nav bar
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade800),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      term,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                definition,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("KAPAT", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
