import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_progress.dart';
import '../utils/app_theme.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';
import '../utils/text_formatter.dart';

class ModernHeader extends StatelessWidget {
  final String title;
  final Type screenType;
  final VoidCallback? onBack;
  final VoidCallback? onSave;

  const ModernHeader({
    super.key,
    required this.title,
    required this.screenType,
    this.onBack,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAnalysisScreen = screenType.toString().contains('Bolum');
    
    final progressResult = AppProgress.getAnalysisProgress(
      BinaStore.instance,
      screenType,
    );
    double progress = progressResult.percentage / 100.0;
    String stepLabel = progressResult.stepString;
    final bool canPop = Navigator.canPop(context);

    final double topPadding = MediaQuery.of(context).padding.top;
    
    // Sabit yükseklik - Tüm sayfalarda aynı durması için. Tasarruflu ama dengeli.
    return Container(
      width: double.infinity,
      height: topPadding + 105.0, // Her ekranda birebir aynı yükseklik
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 20), // Dashboard ile senkronize edildi
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (canPop)
                GestureDetector(
                  onTap: onBack ?? () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(right: 12, bottom: 2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst Satır: Bölüm Etiketi (Sol) ve KAYDET (Sağ)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center, // Align label and button center-vertically
                      children: [
                        if (isAnalysisScreen)
                          Padding(
                            padding: const EdgeInsets.only(top: 2), // Move label slightly down
                            child: Text(
                              stepLabel,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (isAnalysisScreen)
                          GestureDetector(
                            onTap: () {
                              if (onSave != null) {
                                onSave!();
                              } else {
                                BinaStore.instance.saveToDisk(immediate: true);
                              }
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Analiz kaydedildi ve ana menüye dönüldü."),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: AppColors.successGreen,
                                ),
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white24, width: 1),
                              ),
                              child: const Text(
                                "KAYDET & ÇIK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Alt Satır: Başlık (Sol) ve İlerleme Yüzdesi (Sağ)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FormattedText(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                        if (isAnalysisScreen) ...[
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "İlerleme: ",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AnimatedPercentageText(
                                percentage: (progress * 100).toInt(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isAnalysisScreen) ...[
            const SizedBox(height: 8),
            AnimatedHeaderProgressBar(value: progress),
          ] else ...[
             // Diğer ekranlarda (Dashboard, Arşiv vb.) başlık altı boşluğu dengele
             const SizedBox(height: 16.5),
          ]
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
      ),
      child: child,
    );
  }
}

class QuestionTitle extends StatelessWidget {
  final String title;
  const QuestionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 14, top: 4),
      child: FormattedText(title, style: AppStyles.questionTitle),
    );
  }
}

class SubQuestionTitle extends StatelessWidget {
  final String title;
  const SubQuestionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 2),
      child: FormattedText(title, style: AppStyles.subQuestionTitle),
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
  final Type screenType;
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onSave;
  final bool isNextEnabled;

  const AnalysisPageLayout({
    super.key,
    required this.title,
    required this.screenType,
    required this.child,
    this.onNext,
    this.onSave,
    this.isNextEnabled = true,
  });

  @override
  State<AnalysisPageLayout> createState() => _AnalysisPageLayoutState();
}

class AnimatedPercentageText extends StatefulWidget {
  final int percentage;
  final TextStyle? style;
  const AnimatedPercentageText({
    super.key,
    required this.percentage,
    this.style,
  });

  @override
  State<AnimatedPercentageText> createState() => _AnimatedPercentageTextState();
}

class _AnimatedPercentageTextState extends State<AnimatedPercentageText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedPercentageText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _controller.forward(from: 0.0);
      if (!WidgetsBinding.instance.toString().contains('Test')) {
         HapticFeedback.selectionClick();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        "%${widget.percentage}",
        style:
            widget.style ??
            const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class AnimatedHeaderProgressBar extends StatefulWidget {
  final double value;
  const AnimatedHeaderProgressBar({super.key, required this.value});

  @override
  State<AnimatedHeaderProgressBar> createState() =>
      _AnimatedHeaderProgressBarState();
}

class _AnimatedHeaderProgressBarState extends State<AnimatedHeaderProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    if (!WidgetsBinding.instance.toString().contains('Test')) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double glowAlpha = 0.1 + (_pulseAnimation.value * 0.2);
        final double dynamicHeight = 9.0 + (_pulseAnimation.value * 1.5);

        return Container(
          height: 12,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.successGreen.withOpacity(glowAlpha),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: dynamicHeight,
              color: Colors.white.withValues(alpha: 0.15),
              child: Stack(
                children: [
                  // Smooth Value Transition
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(begin: 0, end: widget.value),
                    builder: (context, value, _) {
                      return FractionallySizedBox(
                        widthFactor: value.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF66BB6A),
                                AppColors.successGreen,
                                Color(0xFF2E7D32),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                  // Shimmer Effect
                  Positioned.fill(
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: AnimatedBuilder(
                        animation: _shimmerAnimation,
                        builder: (context, _) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [
                                  _shimmerAnimation.value - 0.2,
                                  _shimmerAnimation.value,
                                  _shimmerAnimation.value + 0.2,
                                ],
                                colors: [
                                  Colors.white.withValues(alpha: 0.0),
                                  Colors.white.withValues(alpha: 0.4),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnalysisPageLayoutState extends State<AnalysisPageLayout> {
  @override
  void initState() {
    super.initState();
    // Auto-track current section
    // Moved to initState to prevent overwriting when background screens rebuild
    final progressRes = AppProgress.getAnalysisProgress(
      BinaStore.instance,
      widget.screenType,
    );
    final step = AppProgress.currentStep(widget.screenType);
    if (progressRes.percentage > 0) {
      // Use addPostFrameCallback to ensure build is safely started/done
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          BinaStore.instance.lastActiveSection = step;
          BinaStore.instance.saveToDisk(); // Auto-save on entry
        }
      });
    }
  }

  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          ModernHeader(
            title: widget.title,
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                onPressed: widget.isNextEnabled && !_isNavigating
                    ? () async {
                        setState(() => _isNavigating = true);
                        try {
                          await BinaStore.instance.saveToDisk();
                          if (widget.onNext != null) widget.onNext!();
                        } finally {
                          // Navigasyon gerçekleşirse zaten bu ekran dispose edilecek.
                          // Ama hata olursa veya navigasyon iptal edilirse butonu geri açıyoruz.
                          Future.delayed(const Duration(seconds: 1), () {
                            if (mounted) setState(() => _isNavigating = false);
                          });
                        }
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.centerRight,
        child: Container(
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
                  fontSize: 14,
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

// ─────────────────────────────────────────────────────────────────────────────
// ImageModalHelper — shared modal logic for both question-level & option-level
// ─────────────────────────────────────────────────────────────────────────────
class ImageModalHelper {
  static void show(
    BuildContext context, {
    required String assetPath,
    required String title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ImageModal(assetPath: assetPath, title: title),
    );
  }
}

class _ImageModal extends StatelessWidget {
  final String assetPath;
  final String title;
  const _ImageModal({required this.assetPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
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
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  cacheWidth: 1000, // Optimize memory: Limit decode resolution to 1000px width
                  errorBuilder: (c, o, s) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text("Görsel yüklenemedi: $assetPath"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Görseli iki parmağınızla büyütebilirsiniz",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QuestionHeaderWithImage — soru başlığı + sağda 📷 kamera ikonu
// Kullanım: tüm şıkları kapsayan görseller için
// ─────────────────────────────────────────────────────────────────────────────
class QuestionHeaderWithImage extends StatelessWidget {
  final String questionText;
  final String imageAssetPath;
  final String imageTitle;

  const QuestionHeaderWithImage({
    super.key,
    required this.questionText,
    required this.imageAssetPath,
    required this.imageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: Text(questionText, style: AppStyles.questionTitle)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => ImageModalHelper.show(
              context,
              assetPath: imageAssetPath,
              title: imageTitle,
            ),
            child: Tooltip(
              message: 'Görseli İncele',
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
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
      margin: const EdgeInsets.only(top: 8),
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
                      fontSize: 14, // Increased for readability
                      fontWeight: FontWeight.w700,
                      color: value
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF388E3C),
                      height: 1.3,
                    ),
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

enum InfoNoteType { info, warning }

/// Standart bilgi ve uyarı notu widget'ı - Bölüm 8'deki tasarımı temel alır
class CustomInfoNote extends StatelessWidget {
  final String? text;
  final InlineSpan? richText;
  final IconData? icon;
  final InfoNoteType type;
  final EdgeInsetsGeometry? margin;

  const CustomInfoNote({
    super.key,
    this.text,
    this.richText,
    this.icon,
    this.type = InfoNoteType.warning,
    this.margin,
  }) : assert(
         text != null || richText != null,
         'text veya richText alanlarından en az biri dolu olmalıdır.',
       );

  @override
  Widget build(BuildContext context) {
    // Standardize colors based on type
    final Color bg;
    final Color bc;
    final Color ic;
    final Color tc;
    final IconData displayIcon;

    if (type == InfoNoteType.info) {
      // Info: Blue spectrum
      bg = const Color(0xFFE3F2FD); // Light Blue 50
      bc = const Color(0xFF90CAF9); // Light Blue 200
      ic = const Color(0xFF1976D2); // Blue 700
      tc = const Color(0xFF0D47A1); // Blue 900
      displayIcon = icon ?? Icons.info_outline;
    } else {
      // Warning: Orange/Amber spectrum
      bg = const Color(0xFFFFF3E0); // Orange 50
      bc = const Color(0xFFFFB74D); // Orange 300
      ic = const Color(0xFFF57C00); // Orange 700
      tc = const Color(0xFFE65100); // Orange 900
      displayIcon = icon ?? Icons.warning_amber_rounded;
    }

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bc, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(displayIcon, color: ic, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: richText != null
                ? RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: tc,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        height: 1.4,
                      ),
                      children: [richText!],
                    ),
                  )
                : Text(
                    text!,
                    style: TextStyle(
                      color: tc,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      height: 1.4,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Standart Uygulama Pop-up Penceresi - Tüm uygulamada tutarlı görünüm sağlar
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required String title,
  String? content,
  Widget? contentWidget,
  String confirmText = "TAMAM",
  String? cancelText,
  IconData? icon = Icons.info_outline,
  Color? iconColor,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CustomAlertDialog(
      title: title,
      content: content,
      contentWidget: contentWidget,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      iconColor: iconColor ?? AppColors.primaryBlue,
    ),
  );
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final String confirmText;
  final String? cancelText;
  final IconData? icon;
  final Color iconColor;

  const CustomAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    required this.confirmText,
    this.cancelText,
    this.icon,
    this.iconColor = AppColors.primaryBlue,
  }) : assert(content != null || contentWidget != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Area
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor, size: 28),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: iconColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (contentWidget != null)
                  contentWidget!
                else
                  Text(
                    content!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textBody,
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (cancelText != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.cardBorder),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            cancelText!,
                            style: const TextStyle(
                              color: AppColors.textLabel,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: iconColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectHint extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;

  const MultiSelectHint({
    super.key,
    this.text = "Birden fazla seçenek işaretleyebilirsiniz.",
    this.padding = const EdgeInsets.only(left: 4, bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blueGrey.shade600,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
