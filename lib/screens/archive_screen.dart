import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import 'report_summary_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    final archive = BinaStore.instance.archive;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Yangın Risk Analizi Arşivi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: archive.isEmpty ? _buildEmptyState() : _buildArchiveList(archive),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text("Henüz kayıtlı bir analiz bulunamadı.", style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildArchiveList(List<Map<String, dynamic>> archive) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archive.length,
      itemBuilder: (context, index) {
        final item = archive[index];
        final String dateStr = item['date'].toString().split('T')[0]; // Basit tarih formatı

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF1A237E).withOpacity(0.05), shape: BoxShape.circle),
              child: const Icon(Icons.business_outlined, color: Color(0xFF1A237E)),
            ),
            title: Text(
              item['name'] ?? "İsimsiz Bina",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2C3E50)),
            ),
            subtitle: Text("Analiz Tarihi: $dateStr", style: const TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () => _viewReport(item['id']),
            onLongPress: () => _showDeleteDialog(item['id'], item['name']),
          ),
        );
      },
    );
  }

  void _viewReport(String id) {
    BinaStore.instance.loadBuildingFromArchive(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportSummaryScreen()),
    );
  }

  void _showDeleteDialog(String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Analizi Sil"),
        content: Text("'$name' isimli binaya ait tüm analiz verileri kalıcı olarak silinecektir. Onaylıyor musunuz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Vazgeç")),
          TextButton(
            onPressed: () {
              setState(() {
                BinaStore.instance.deleteFromArchive(id);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}