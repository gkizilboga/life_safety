import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'register_screen.dart';

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
            subtitle: "Kullanıcı tercihleri ve veri yönetimi",
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
                  subtitle: "Buton tıklamalarında hafif titreşim",
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
                  subtitle: "Kayıtlı tüm bina analizlerini siler",
                  onTap: () => _showDeleteArchiveDialog(),
                ),
                _buildSettingTile(
                  icon: Icons.person_remove_outlined,
                  title: "Kaydı Sıfırla",
                  subtitle: "Profil bilgilerini siler ve baştan başlatır",
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
          fontSize: 11,
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
    required String subtitle,
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
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing:
            trailing ??
            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteArchiveDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Arşivi Temizle"),
        content: const Text(
          "Tüm geçmiş analizleriniz kalıcı olarak silinecektir. Bu işlem geri alınamaz.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("VAZGEÇ"),
          ),
          TextButton(
            onPressed: () {
              BinaStore.instance.archive = [];
              BinaStore.instance.saveToDisk();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Arşiv temizlendi.")),
              );
            },
            child: const Text("SİL", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showResetAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Kaydı Sıfırla"),
        content: const Text(
          "Profil bilgileriniz silinecek ve kayıt ekranına yönlendirileceksiniz. Emin misiniz?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("VAZGEÇ"),
          ),
          TextButton(
            onPressed: () {
              BinaStore.instance.isRegistered = false;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                (r) => false,
              );
            },
            child: const Text("SIFIRLA", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
