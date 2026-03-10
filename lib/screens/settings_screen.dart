import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final store = BinaStore.instance;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          const ModernHeader(
            title: "Profil ve Ayarlar",
            screenType: SettingsScreen,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildProfileCard(store),
                const SizedBox(height: 25),
                _buildSectionLabel("UYGULAMA TERCİHLERİ"),
                _buildSettingTile(
                  icon: Icons.vibration,
                  title: "Dokunsal Geri Bildirim",
                  trailing: Switch(
                    value: store.hapticEnabled,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (val) {
                      setState(() => store.hapticEnabled = val);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                _buildSectionLabel("VERİ VE GÜVENLİK"),
                _buildSettingTile(
                  icon: Icons.delete_forever_outlined,
                  title: "Tüm Arşivi Temizle",
                  onTap: () => _showDeleteArchiveDialog(),
                ),
                _buildSettingTile(
                  icon: Icons.person_remove_outlined,
                  title: "Kaydı Sıfırla",
                  onTap: () => _showResetAccountDialog(),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "Versiyon 1.0.0",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BinaStore store) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryBlue,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  store.userProfession,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryBlue),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 13))
            : null,
        trailing:
            trailing ??
            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteArchiveDialog() async {
    final confirmed = await showCustomDialog<bool>(
      context: context,
      title: "Arşivi Temizle",
      content:
          "Tüm geçmiş analizleriniz kalıcı olarak silinecektir. Bu işlem geri alınamaz.",
      confirmText: "SİL",
      cancelText: "VAZGEÇ",
      icon: Icons.delete_sweep_rounded,
      iconColor: Colors.red,
    );

    if (confirmed == true) {
      BinaStore.instance.archive = [];
      BinaStore.instance.saveToDisk();
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Arşiv temizlendi.")));
    }
  }

  void _showResetAccountDialog() async {
    final confirmed = await showCustomDialog<bool>(
      context: context,
      title: "Kaydı Sıfırla",
      content:
          "Profil bilgileriniz silinecek ve kayıt ekranına yönlendirileceksiniz. Emin misiniz?",
      confirmText: "SIFIRLA",
      cancelText: "VAZGEÇ",
      icon: Icons.person_remove_rounded,
      iconColor: Colors.red,
    );

    if (confirmed == true) {
      BinaStore.instance.isRegistered = false;
      BinaStore.instance.hasSeenOnboarding = false;
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (r) => false,
      );
    }
  }
}
