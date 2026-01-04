import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_7_model.dart';
import 'bolum_8_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../utils/app_assets.dart';

class Bolum7Screen extends StatefulWidget {
  const Bolum7Screen({super.key});

  @override
  State<Bolum7Screen> createState() => _Bolum7ScreenState();
}

class _Bolum7ScreenState extends State<Bolum7Screen> {
  Bolum7Model _model = Bolum7Model();

  @override
  void initState() {
    super.initState();
    _syncWithPreviousSteps();
  }

  void _syncWithPreviousSteps() {
    final b6 = BinaStore.instance.bolum6;
    setState(() {
      _model = _model.copyWith(
        hasOtopark: b6?.hasOtopark ?? false,
        hasDepo: b6?.hasDepo ?? false,
        isHicbiri: false,
      );
    });
  }

  void _toggleOption(String key) {
    setState(() {
      switch (key) {
        case 'kazan': _model = _model.copyWith(hasKazan: !_model.hasKazan); break;
        case 'asansor': _model = _model.copyWith(hasAsansor: !_model.hasAsansor); break;
        case 'cati': _model = _model.copyWith(hasCati: !_model.hasCati); break;
        case 'jenerator': _model = _model.copyWith(hasJenerator: !_model.hasJenerator); break;
        case 'elektrik': _model = _model.copyWith(hasElektrik: !_model.hasElektrik); break;
        case 'trafo': _model = _model.copyWith(hasTrafo: !_model.hasTrafo); break;
        case 'cop': _model = _model.copyWith(hasCop: !_model.hasCop); break;
        case 'siginak': _model = _model.copyWith(hasSiginak: !_model.hasSiginak); break;
        case 'duvar': _model = _model.copyWith(hasDuvar: !_model.hasDuvar); break;
        case 'hicbiri':
          final b6 = BinaStore.instance.bolum6;
          _model = Bolum7Model(
            isHicbiri: !_model.isHicbiri,
            hasOtopark: b6?.hasOtopark ?? false,
            hasDepo: b6?.hasDepo ?? false,
          );
          return;
      }
      _model = _model.copyWith(isHicbiri: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final b6 = BinaStore.instance.bolum6;
    final bool isOtoparkLocked = b6?.hasOtopark ?? false;
    final bool isDepoLocked = b6?.hasDepo ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(
            title: "Teknik Hacimler",
            subtitle: "Binadaki özel riskli alanların tespiti",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      "Binanızda aşağıdaki alanlardan hangileri mevcut?",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF263238)),
                    ),
                  ),

                  // --- OTOPARK (Kilitli Görünüm) ---
                  _buildSyncCard(
                    isLocked: isOtoparkLocked,
                    choice: Bolum7Content.otopark,
                    message: "Otopark varlığı Bölüm-6'dan aktarılmıştır.",
                  ),

                  _buildOption(Bolum7Content.kazan, _model.hasKazan, () => _toggleOption('kazan')),
                  TechnicalDrawingButton(assetPath: AppAssets.section7Kazan, title: "Kazan Dairesi Teknik Detayı"),
                  const SizedBox(height: 8),

                  _buildOption(Bolum7Content.asansor, _model.hasAsansor, () => _toggleOption('asansor')),
                  TechnicalDrawingButton(assetPath: AppAssets.section7Asansor, title: "Asansör Kuyusu ve Makine Dairesi"),
                  const SizedBox(height: 8),

                  _buildOption(Bolum7Content.cati, _model.hasCati, () => _toggleOption('cati')),

                  _buildOption(Bolum7Content.jenerator, _model.hasJenerator, () => _toggleOption('jenerator')),
                  TechnicalDrawingButton(assetPath: AppAssets.section7Jenerator, title: "Jeneratör Odası Yerleşimi"),
                  const SizedBox(height: 8),

                  _buildOption(Bolum7Content.elektrik, _model.hasElektrik, () => _toggleOption('elektrik')),

                  _buildOption(Bolum7Content.trafo, _model.hasTrafo, () => _toggleOption('trafo')),
                  TechnicalDrawingButton(assetPath: AppAssets.section7Trafo, title: "Trafo Odası ve Yağ Çukuru"),
                  const SizedBox(height: 8),

                  // --- DEPO (Kilitli Görünüm) ---
                  _buildSyncCard(
                    isLocked: isDepoLocked,
                    choice: Bolum7Content.depo,
                    message: "Depo alanı varlığı Bölüm-6'dan aktarılmıştır.",
                  ),

                  _buildOption(Bolum7Content.cop, _model.hasCop, () => _toggleOption('cop')),
                  _buildOption(Bolum7Content.siginak, _model.hasSiginak, () => _toggleOption('siginak')),

                  _buildOption(Bolum7Content.duvar, _model.hasDuvar, () => _toggleOption('duvar')),
                  TechnicalDrawingButton(assetPath: AppAssets.section7OrtakDuvar, title: "Bitişik Nizam Ortak Duvar Detayı"),
                  const SizedBox(height: 8),

                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Color(0xFFECEFF1))),
                  
                  _buildOption(Bolum7Content.hicbiri, _model.isHicbiri, () => _toggleOption('hicbiri')),
                ],
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildOption(dynamic choice, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SelectableCard(
        choice: choice, 
        isSelected: isSelected, 
        onTap: onTap,
      ),
    );
  }

  // YENİ: Kilitli ve Senkronize Kart Tasarımı
  Widget _buildSyncCard({required bool isLocked, required dynamic choice, required String message}) {
    if (!isLocked) return _buildOption(choice, false, () => _toggleOption('otopark'));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Kilitli olduğunu belirten gri arka plan
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.lock_rounded, color: Colors.grey.shade500, size: 24),
            title: Text(
              choice.uiTitle, 
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 15)
            ),
            subtitle: Text(
              message, 
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11)
            ),
            trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ),
          // Sağ üstte küçük bir senkronizasyon ikonu
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.sync, size: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {
            BinaStore.instance.bolum7 = _model;
            BinaStore.instance.saveToDisk();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum8Screen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("DEVAM ET", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
      ),
    );
  }
}