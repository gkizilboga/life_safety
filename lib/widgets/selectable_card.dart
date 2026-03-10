import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/data/bina_store.dart';
import '../models/choice_result.dart';
import '../utils/text_formatter.dart';
import 'custom_widgets.dart' show ImageModalHelper;

class SelectableCard extends StatelessWidget {
  final ChoiceResult choice;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;
  final String? imageAssetPath;
  final String? imageTitle;

  const SelectableCard({
    super.key,
    required this.choice,
    required this.isSelected,
    this.onTap,
    this.isDisabled = false,
    this.imageAssetPath,
    this.imageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled || onTap == null
          ? null
          : () {
              if (BinaStore.instance.hapticEnabled) {
                HapticFeedback.lightImpact();
              }
              onTap!();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade200
              : (isSelected
                    ? const Color(0xFF1A237E).withOpacity(0.06)
                    : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.shade400
                : (isSelected
                      ? const Color(0xFF1A237E)
                      : const Color(0xFFCFD8DC)),
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : (isDisabled
                        ? Icons.lock_outline
                        : Icons.radio_button_unchecked_rounded),
              color: isDisabled
                  ? Colors.grey.shade500
                  : (isSelected
                        ? const Color(0xFF1A237E)
                        : Colors.grey.shade400),
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormattedText(
                    choice.uiTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDisabled
                          ? Colors.grey.shade600
                          : (isSelected
                                ? const Color(0xFF1A237E)
                                : const Color(0xFF263238)),
                      height: 1.3,
                    ),
                  ),
                  if (choice.uiSubtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    FormattedText(
                      choice.uiSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDisabled
                            ? Colors.grey.shade500
                            : (isSelected
                                  ? const Color(0xFF1A237E).withOpacity(0.8)
                                  : Colors.grey.shade700),
                        height: 1.4,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Option-level camera icon
            if (imageAssetPath != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => ImageModalHelper.show(
                  context,
                  assetPath: imageAssetPath!,
                  title: imageTitle ?? 'Görseli İncele',
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
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
