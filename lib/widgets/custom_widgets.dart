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
  final VoidCallback? onSave;

  const ModernHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.screenType,
    this.onBack,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    int currentStep = AppProgress.currentStep(screenType);
    int totalSteps = AppProgress.totalSteps;
    double progress = currentStep / totalSteps;
    final bool canPop = Navigator.canPop(context);

    final double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 15),
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
              const SizedBox(width: 10),
              // Only show KAYDET button on Bolum screens (test sections 1-36)
              if (screenType.toString().contains('Bolum'))
                GestureDetector(
                  onTap: () {
                    if (onSave != null) {
                      onSave!();
                    } else {
                      BinaStore.instance.saveToDisk();
                    }
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Analiz kaydedildi ve ana menüye dönüldü.",
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669), // Emerald Green (Premium)
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.save_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
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

class AnalysisPageLayout extends StatefulWidget {
  final String title;
  final String subtitle;
  final Type screenType;
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onSave;
  final bool isNextEnabled;

  const AnalysisPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.screenType,
    required this.child,
    this.onNext,
    this.onSave,
    this.isNextEnabled = true,
  });

  @override
  State<AnalysisPageLayout> createState() => _AnalysisPageLayoutState();
}

class _AnalysisPageLayoutState extends State<AnalysisPageLayout> {
  @override
  void initState() {
    super.initState();
    // Auto-track current section
    // Moved to initState to prevent overwriting when background screens rebuild
    final step = AppProgress.currentStep(widget.screenType);
    if (step > 0) {
      // Use addPostFrameCallback to ensure build is safely started/done
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          BinaStore.instance.lastActiveSection = step;
          BinaStore.instance.saveToDisk(); // Auto-save on entry
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          ModernHeader(
            title: widget.title,
            subtitle: widget.subtitle,
            screenType: widget.screenType,
            onSave: widget.onSave,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: widget.child,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
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
                onPressed: widget.isNextEnabled
                    ? () {
                        BinaStore.instance.saveToDisk();
                        if (widget.onNext != null) widget.onNext!();
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
          margin: const EdgeInsets.only(
            bottom: 16,
          ), // Extra bottom margin for nav bar
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
                  child: const Text(
                    "KAPAT",
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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => _buildModal(ctx),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF43A047), // Green color
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_search, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              "- İlgili görseli incele -", // Fixed text as requested
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModal(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60, // Reduced from 0.85
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          // Image
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (c, o, s) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text("Görsel yüklenemedi: \$assetPath"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Text(
                    "Yakınlaştırmak için görseli iki parmağınızla büyütebilirsiniz.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "ANLADIM",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Standart onay kutusu widget'ı - tüm ekranlarda tutarlı görünüm sağlar
/// Açık yeşil arka plan ile dikkat çekici tasarım
class ConfirmationCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  const ConfirmationCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        // Açık yeşil arka plan - dikkat çekici
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE8F5E9), // Light green start
            const Color(0xFFC8E6C9), // Light green end
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? const Color(0xFF43A047) : const Color(0xFF81C784),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43A047).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                // Özel checkbox tasarımı
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: value ? const Color(0xFF43A047) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: value
                          ? const Color(0xFF43A047)
                          : const Color(0xFF81C784),
                      width: 2,
                    ),
                    boxShadow: value
                        ? [
                            BoxShadow(
                              color: const Color(0xFF43A047).withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: value
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                // Metin
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: value
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF388E3C),
                      height: 1.4,
                    ),
                  ),
                ),
                // Sağ tarafta dikkat çekici ikon
                if (!value)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.touch_app_rounded,
                      color: const Color(0xFFE65100),
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
