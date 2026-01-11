import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/data/bina_store.dart';
import '../models/choice_result.dart';

class SelectableCard extends StatelessWidget {
  final ChoiceResult choice;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.choice,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (BinaStore.instance.hapticEnabled) {
          HapticFeedback.lightImpact();
        }
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A237E).withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A237E) : const Color(0xFFCFD8DC),
            width: isSelected ? 2.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade400,
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
                      fontWeight: FontWeight.w800, // Yanıtlar da artık çok kalın ve net
                      color: isSelected ? const Color(0xFF1A237E) : const Color(0xFF263238), // Koyu Kömür Siyahı
                      height: 1.3,
                    ),
                  ),
                  if (choice.uiSubtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      choice.uiSubtitle,
                      style: TextStyle(
                        fontSize: 12, 
                        color: isSelected ? const Color(0xFF1A237E).withValues(alpha: 0.7) : Colors.grey.shade700, 
                        height: 1.4,
                        fontWeight: FontWeight.w600, // Alt metinler bile artık daha kalın
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