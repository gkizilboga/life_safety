import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import 'report_summary_screen.dart';
import '../services/pdf_service.dart';
import 'paywall_screen.dart';

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Analiz Arşivi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: archive.isEmpty ? _buildEmptyState() : _buildArchiveList(archive),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            "Henüz kayıtlı bir analiz bulunamadı.",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Yeni bir analiz başlatarak arşivi doldurabilirsiniz.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildArchiveList(List<Map<String, dynamic>> archive) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archive.length,
      itemBuilder: (context, index) {
        final item = archive.reversed.toList()[index];
        final String dateStr = item['date'].toString().split('T')[0];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.business_rounded,
                color: Color(0xFF1A237E),
              ),
            ),
            title: Text(
              item['name'] ?? "İsimsiz Bina",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF2C3E50),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  "${item['city']} / ${item['district']}",
                  style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),
                const SizedBox(height: 2),
                Text(
                  "Tarih: $dateStr",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    if (BinaStore.instance.isPremium) {
                      BinaStore.instance.loadBuildingFromArchive(item['id']);
                      await PdfService.generateAndShowPdf();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaywallScreen(),
                        ),
                      );
                    }
                  },
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Analizi Sil"),
        content: Text(
          "'$name' binasına ait tüm veriler kalıcı olarak silinecektir. Bu işlem geri alınamaz.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Vazgeç"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                BinaStore.instance.deleteFromArchive(id);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Sil"),
          ),
        ],
      ),
    );
  }
}
