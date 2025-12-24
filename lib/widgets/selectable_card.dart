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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EAF6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF1A237E) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade500,
                      width: 2,
                    ),
                  ),
                  child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    choice.uiTitle,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? const Color(0xFF1A237E) : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            if (choice.uiSubtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Text(
                  choice.uiSubtitle,
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.w500, 
                    color: Colors.grey[800], 
                    height: 1.3
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
