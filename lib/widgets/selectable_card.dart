import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/data/bina_store.dart';
import '../models/choice_result.dart';

class SelectableCard extends StatelessWidget {
  final ChoiceResult choice;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const SelectableCard({
    super.key,
    required this.choice,
    required this.isSelected,
    this.onTap,
    this.isDisabled = false,
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
        margin: const EdgeInsets.only(bottom: 4),
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
            width: isSelected ? 2.5 : 1.2,
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
                  Text(
                    choice.uiTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
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
                    Text(
                      choice.uiSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDisabled
                            ? Colors.grey.shade500
                            : (isSelected
                                  ? const Color(0xFF1A237E).withOpacity(
                                      0.8,
                                    ) // Increased opacity for better visibility
                                  : Colors.grey.shade700),
                        height: 1.4,
                        fontWeight:
                            FontWeight.w500, // Standardized to w500 (Medium)
                        fontStyle: FontStyle.normal, // Ensure normal style
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
