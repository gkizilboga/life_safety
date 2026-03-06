import 'package:flutter/material.dart';
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
    int currentStep = AppProgress.currentStep(screenType);
    int totalSteps = AppProgress.totalSteps;
    double progress = currentStep / totalSteps;
    final bool canPop = Navigator.canPop(context);

    final double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 8, 20, 10),
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
          // Top row: Back | [spacer] | KAYDET
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (canPop)
                GestureDetector(
                  onTap: onBack ?? () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 28),
              const Spacer(),
              // Only show KAYDET button on Bolum screens (test sections 1-36)
              if (screenType.toString().contains('Bolum'))
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
                        content: Text(
                          "Analiz kaydedildi ve ana menüye dönüldü.",
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.save_as_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "KAYDET",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Integrated Title, Section and Progress Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Main Title (Ufaltılmış font)
              Expanded(
                child: FormattedText(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
              ),
              if (currentStep > 0) ...[
                const SizedBox(width: 12),
                // Bölüm X/Y (Ortada gibi konumlanmış)
                Text(
                  "Bölüm $currentStep",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                // İlerleme (Sağda)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "İlerleme: ",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AnimatedPercentageText(
                      percentage: (progress * 100).toInt(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (currentStep > 0) ...[
            const SizedBox(height: 10),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.successGreen,
                ),
              ),
            ),
          ] else
            const SizedBox(height: 5),
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
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: FormattedText(title, style: AppStyles.questionTitle),
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
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedPercentageText oldWidget) {
    super.didUpdateWidget(oldWidget);
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
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align to the right
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => _buildModal(ctx),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF43A047), // Green color
              borderRadius: BorderRadius.circular(
                20,
              ), // More rounded/pill shape
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.image_search, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "Görseli İncele",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      margin: const EdgeInsets.only(top: 4),
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
                      fontSize: 12, // Reduced from 14
                      fontWeight: FontWeight.w600,
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

/// Standart bilgi ve uyarı notu widget'ı - Bölüm 8'deki tasarımı temel alır
class CustomInfoNote extends StatelessWidget {
  final String? text;
  final InlineSpan? richText;
  final IconData icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsetsGeometry? margin;

  const CustomInfoNote({
    super.key,
    this.text,
    this.richText,
    this.icon = Icons.info_outline,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
    this.margin,
  }) : assert(
         text != null || richText != null,
         'text veya richText alanlarından en az biri dolu olmalıdır.',
       );

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? const Color(0xFFFFF3E0);
    final bc = borderColor ?? const Color(0xFFFF9800);
    final ic = iconColor ?? const Color(0xFFE65100);
    final tc = textColor ?? Colors.orange.shade900;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bc),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ic, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: richText != null
                ? RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: tc,
                        fontSize: 12,
                        fontFamily: 'Roboto',
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
                      fontWeight: FontWeight.w500,
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
                      fontSize: 15,
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
