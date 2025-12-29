import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_33_model.dart';
import 'bolum_34_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum33Screen extends StatefulWidget {
  const Bolum33Screen({super.key});

  @override
  State<Bolum33Screen> createState() => _Bolum33ScreenState();
}

class _Bolum33ScreenState extends State<Bolum33Screen> {
  Bolum33Model _model = Bolum33Model();
  final _zeminCtrl = TextEditingController();
  final _normalCtrl = TextEditingController();
  final _bodrumCtrl = TextEditingController();

  bool _hasNormal = false;
  bool _hasBodrum = false;
  bool _showSummary = false;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final b3 = BinaStore.instance.bolum3;
    final b5 = BinaStore.instance.bolum5;
    setState(() {
      _hasNormal = (b3?.normalKatSayisi ?? 0) >= 1;
      _hasBodrum = (b3?.bodrumKatSayisi ?? 0) >= 1;
      _zeminCtrl.text = b5?.tabanAlani?.toString() ?? "";
      _normalCtrl.text = b5?.normalKatAlani?.toString() ?? "";
      _bodrumCtrl.text = b5?.bodrumKatAlani?.toString() ?? "";
    });
  }

  // BYKHY EK-5/B'ye göre m2/kişi katsayıları
  double _getKatsayi(ChoiceResult? choice) {
    if (choice == null) return 20.0; // Varsayılan Konut
    final label = choice.label;
    if (label == "10-Konut") return 20.0;
    if (label == "10-Az-Ticari") return 5.0;
    if (label == "10-Orta-Ticari") return 3.0;
    if (label == "10-Yuksek-Ticari") return 1.5;
    if (label == "10-Teknik") return 30.0;
    return 20.0;
  }

  int _hesaplaGerekliCikis(double kisi) {
    if (kisi <= 0) return 0;
    if (kisi <= 50) return 1;
    if (kisi <= 500) return 2;
    if (kisi <= 1000) return 3;
    return 4;
  }

  void _hesapla() {
    final b5 = BinaStore.instance.bolum5;
    final b10 = BinaStore.instance.bolum10;
    final b20 = BinaStore.instance.bolum20;

    if (b5 == null || b10 == null) {
      _showError("Hata: Bölüm 5 veya Bölüm 10 verileri eksik!");
      return;
    }

    // Her kat tipi için ayrı katsayı alıyoruz (Hibrit Hesaplama)
    double kZemin = _getKatsayi(b10.zemin);
    double kNormal = _getKatsayi(b10.normaller.isNotEmpty ? b10.normaller.first : null);
    double kBodrum = _getKatsayi(b10.bodrumlar.isNotEmpty ? b10.bodrumlar.first : null);

    // Mevcut Çıkışlar
    int mevcutUst = (b20?.normalMerdivenSayisi ?? 0) + 
                    (b20?.binaIciYanginMerdiveniSayisi ?? 0) + 
                    (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + 
                    (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0);
    
    int mevcutBodrum = (b20?.bodrumMerdivenDevami?.label == "20-Bodrum-A") ? mevcutUst : 1;

    // Yük Hesaplama (Alan / Katsayı)
    double yukZemin = (b5.tabanAlani ?? 0) / kZemin;
    double yukNormal = (b5.normalKatAlani ?? 0) / kNormal;
    double yukBodrum = (b5.bodrumKatAlani ?? 0) / kBodrum;

    // Gerekli Çıkış Sayısı
    int gZemin = _hesaplaGerekliCikis(yukZemin);
    int gNormal = _hesaplaGerekliCikis(yukNormal);
    int gBodrum = _hesaplaGerekliCikis(yukBodrum);

    setState(() {
      _model = Bolum33Model(
        alanZemin: b5.tabanAlani, alanNormal: b5.normalKatAlani, alanBodrumMax: b5.bodrumKatAlani,
        yukZemin: yukZemin, yukNormal: yukNormal, yukBodrum: yukBodrum,
        gerekliZemin: gZemin, gerekliNormal: gNormal, gerekliBodrum: gBodrum,
        mevcutUst: mevcutUst, mevcutBodrum: mevcutBodrum,
        zeminKatSonuc: (mevcutUst >= gZemin) ? Bolum33Content.zeminKatYeterli : Bolum33Content.zeminKatYetersiz,
        normalKatSonuc: (mevcutUst >= gNormal) ? Bolum33Content.normalKatYeterli : Bolum33Content.normalKatYetersiz,
        bodrumKatSonuc: _hasBodrum ? (mevcutBodrum >= gBodrum ? Bolum33Content.bodrumKatYeterli : Bolum33Content.bodrumKatYetersiz) : null,
      );
      _showSummary = true;
    });
  }

  void _onNextPressed() {
    if (!_isConfirmed) return;
    BinaStore.instance.bolum33 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum34Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(title: "Bölüm-33: Kapasite Analizi", subtitle: "Kullanıcı yükü ve çıkış sayısı doğrulaması", screenType: widget.runtimeType),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Bölüm-5'ten Alınan Kat Alanları", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 20),
                        _buildReadOnlyInput("Zemin Kat Alanı", _zeminCtrl),
                        if (_hasNormal) ...[const SizedBox(height: 15), _buildReadOnlyInput("Normal Kat Alanı", _normalCtrl)],
                        if (_hasBodrum) ...[const SizedBox(height: 15), _buildReadOnlyInput("Bodrum Kat Alanı", _bodrumCtrl)],
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _hesapla,
                            icon: const Icon(Icons.analytics_outlined),
                            label: const Text("ANALİZİ BAŞLAT"),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_showSummary) _buildSummaryCard(),
                ],
              ),
            ),
          ),
          if (_showSummary) _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildReadOnlyInput(String label, TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label, suffixText: "m²", filled: true, fillColor: Colors.grey.shade100,
        border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.lock_outline, size: 18),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text("📊 ANALİZ SONUÇLARI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A237E)))),
          const Divider(height: 30),
          _buildResultRow("ZEMİN KAT", _model.yukZemin, _model.gerekliZemin, _model.mevcutUst),
          if (_hasNormal) ...[const SizedBox(height: 20), _buildResultRow("NORMAL KATLAR", _model.yukNormal, _model.gerekliNormal, _model.mevcutUst)],
          if (_hasBodrum) ...[const SizedBox(height: 20), _buildResultRow("BODRUM KATLAR", _model.yukBodrum, _model.gerekliBodrum, _model.mevcutBodrum)],
          const Divider(height: 40),
          CheckboxListTile(
            value: _isConfirmed,
            onChanged: (v) => setState(() => _isConfirmed = v ?? false),
            title: const Text("Hesaplanan kullanıcı yükü ve çıkış kapasitesi sonuçlarını onaylıyorum.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFF1A237E),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String title, double? yuk, int? gerekli, int? mevcut) {
    bool isOk = (mevcut ?? 0) >= (gerekli ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF2C3E50))),
        const SizedBox(height: 4),
        Text("• Tahmini Kişi Yükü: ${yuk?.toStringAsFixed(1)} Kişi", style: const TextStyle(fontSize: 13)),
        Text("• Gereken Çıkış: $gerekli | Mevcut: $mevcut", style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: isOk ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
          child: Text(isOk ? "✅ KAPASİTE UYGUN" : "🚨 KAPASİTE YETERSİZ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isOk ? Colors.green.shade700 : Colors.red.shade700)),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: _isConfirmed ? _onNextPressed : null, child: const Text("ONAYLA VE DEVAM ET")),
        ),
      ),
    );
  }
}