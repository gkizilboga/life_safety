import 'package:flutter/material.dart';
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
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Seçili olduğunda arka plan rengi belirginleşir
          color: isSelected ? const Color(0xFFE8EAF6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            // Seçili olduğunda çerçeve kalınlaşır ve lacivert olur
            color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol taraftaki yuvarlak işaretleyici (Check)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF1A237E) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade500,
                  width: 2,
                ),
              ),
              child: isSelected 
                  ? const Icon(Icons.check, size: 16, color: Colors.white) 
                  : null,
            ),
            const SizedBox(width: 12),
            // Metin Alanı
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    choice.uiTitle, // app_content'ten gelen başlık
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
                    ),
                  ),
                  if (choice.uiSubtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      choice.uiSubtitle, // app_content'ten gelen alt başlık
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.3,
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