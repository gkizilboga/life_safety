import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_widgets.dart';

class LegalTextScreen extends StatelessWidget {
  const LegalTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ModernHeader(
            title: "Yasal Bilgiler",
            subtitle: "KVKK ve Kullanım Şartları",
            screenType: LegalTextScreen,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(AppStrings.kvkkTitle, AppStrings.kvkkContent),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 30),
                  _buildSection(AppStrings.legalDisclaimerTitle, AppStrings.legalDisclaimerContent),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Son Güncelleme: 04.01.2026",
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        const SizedBox(height: 15),
        Text(
          content,
          style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.6),
        ),
      ],
    );
  }
}