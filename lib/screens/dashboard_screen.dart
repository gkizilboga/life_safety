import 'package:flutter/material.dart';
import 'report_summary_screen.dart';
import '../../data/bina_store.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasOngoing = BinaStore.instance.bolum1 != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (hasOngoing) _buildOngoingCard(context),
                const SizedBox(height: 20),
                _buildMainActions(context),
                const SizedBox(height: 25),
                _buildSecondaryMenu(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bina Karnesi", 
            style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          const Text("Hoş Geldiniz,", 
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const Text("Kişi", 
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w300)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Text("Sistem Aktif: Binaların Yangından Korunması Hakkında Yönetmeliği (BYKHY) ile Entegre", 
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF283593), const Color(0xFF1A237E)]
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("AKTİF ANALİZ", 
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Icon(Icons.analytics_outlined, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 15),
          const Text("Mevcut Analize Devam Et", 
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Yarım kalan yangın risk analizine kaldığınız yerden devam edebilirsiniz.", 
            style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: const Color(0xFF1A237E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              onPressed: () {
                // Navigasyon mantığı
              },
              child: const Text("ANALİZE DÖN", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            "Yeni Analiz",
            "Yeni Risk Analizi Başlat",
            Icons.add_moderator_outlined,
            Colors.green.shade700,
            () => _startNewAnalysis(context),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionCard(
            context,
            "Arşiv",
            "Tamamlanan Analizler",
            Icons.inventory_2_outlined,
            const Color(0xFF1A237E),
            () { /* Arşiv */ },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: Colors.grey.shade200)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2C3E50))),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, height: 1.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5, bottom: 15),
          child: Text("KÜTÜPHANE VE AYARLAR", 
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
        ),
        _buildMenuTile(Icons.menu_book_outlined, "Yangın Yönetmeliği", "BYKHY Teknik Maddeler"),
        _buildMenuTile(Icons.calculate_outlined, "Hesaplama Araçları", "Kapasite ve Mesafe Cetvelleri"),
        _buildMenuTile(Icons.settings_outlined, "Uygulama Ayarları", "Profil ve Tercihler"),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF1A237E).withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFF1A237E), size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C3E50))),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  void _startNewAnalysis(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Yeni Yangın Risk Analizi"),
        content: const Text("Mevcut veriler temizlenecek ve yeni bir analiz süreci başlayacaktır. Devam etmek istiyor musunuz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Vazgeç", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
            onPressed: () {
              BinaStore.instance.reset();
              BinaStore.instance.saveToDisk();
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportSummaryScreen()));
            },
            child: const Text("Başlat"),
          ),
        ],
      ),
    );
  }
}