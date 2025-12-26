import 'package:flutter/material.dart';
import 'package:life_safety/models/choice_result.dart';

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
        margin: const EdgeInsets.only(bottom: 8), // 12'den 8'e düşürdük
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 18'den 12'ye düşürdük
        decoration: BoxDecoration(
          // ... (Renk ve border kodları aynı)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 22, // 26'dan 22'ye düşürdük
                  height: 22,
                  // ... (Check ikonu kodları aynı)
                ),
                const SizedBox(width: 12), // 16'dan 12'ye düşürdük
                Expanded(
                  child: Text(
                    choice.uiTitle,
                    style: TextStyle(
                      fontSize: 15, // 17'den 15'e düşürdük (Daha kurumsal)
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            if (choice.uiSubtitle.isNotEmpty) ...[
              const SizedBox(height: 4), // 8'den 4'e düşürdük
              Padding(
                padding: const EdgeInsets.only(left: 34), // İkon küçüldüğü için hizaladık
                child: Text(
                  choice.uiSubtitle,
                  style: TextStyle(
                    fontSize: 13, // 14'ten 13'e düşürdük
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    height: 1.2,
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