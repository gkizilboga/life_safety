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
    setState(() {
      _hasNormal = (b3?.normalKatSayisi ?? 0) >= 1;
      _hasBodrum = (b3?.bodrumKatSayisi ?? 0) >= 1;
    });
  }

  @override
  void dispose() {
    _zeminCtrl.dispose();
    _normalCtrl.dispose();
    _bodrumCtrl.dispose();
    super.dispose();
  }

  // Word Metnindeki Katsayı Sözlüğü
  double _getKatsayi(String? label) {
    switch (label) {
      case "10-A": return 10.0;
      case "10-B": return 10.0;
      case "10-C": return 5.0;
      case "10-D": return 1.5;
      case "10-E": return 30.0;
      default: return 10.0; // Varsayılan Konut
    }
  }

  // Word Metnindeki Çıkış Sayısı Fonksiyonu
  int _hesaplaGerekliCikis(double kisi) {
    if (kisi <= 50) return 1;
    if (kisi <= 500) return 2;
    if (kisi <= 1000) return 3;
    return 4;
  }

  void _hesapla() {
    double? aZemin = double.tryParse(_zeminCtrl.text.replaceAll(',', '.'));
    double? aNormal = double.tryParse(_normalCtrl.text.replaceAll(',', '.'));
    double? aBodrum = double.tryParse(_bodrumCtrl.text.replaceAll(',', '.'));

    if (aZemin == null) return _showError("Lütfen zemin kat alanını giriniz.");
    if (_hasNormal && aNormal == null) return _showError("Lütfen normal kat alanını giriniz.");
    if (_hasBodrum && aBodrum == null) return _showError("Lütfen bodrum kat alanını giriniz.");

    // 1. Katsayıyı Al (Bölüm 10'dan)
    final b10Label = BinaStore.instance.bolum10?.secim?.label;
    double katsayi = _getKatsayi(b10Label);

    // 2. Mevcut Çıkışları Al (Bölüm 20'den)
    final b20 = BinaStore.instance.bolum20;
    int mevcutUst = (b20?.normalMerdivenSayisi ?? 0) + 
                    (b20?.binaIciYanginMerdiveniSayisi ?? 0) + 
                    (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + 
                    (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0);
    
    // Bodrum çıkışı: Eğer devam ediyorsa mevcutUst, etmiyorsa 1 (veya b20'deki özel mantık)
    int mevcutBodrum = (b20?.bodrumMerdivenDevami?.label == "20-Bodrum-A") ? mevcutUst : 1;

    // 3. Kişi Yüklerini Hesapla
    double yukZemin = aZemin / katsayi;
    double yukNormal = (aNormal ?? 0) / katsayi;
    double yukBodrum = (aBodrum ?? 0) / katsayi;

    // 4. Gereken Çıkışları Hesapla
    int gZemin = _hesaplaGerekliCikis(yukZemin);
    int gNormal = _hesaplaGerekliCikis(yukNormal);
    int gBodrum = _hesaplaGerekliCikis(yukBodrum);

    // 5. Karşılaştırma ve Sonuç Atama
    ChoiceResult resNormal = (mevcutUst >= gNormal) ? Bolum33Content.normalKatYeterli : Bolum33Content.normalKatYetersiz;
    ChoiceResult resZemin = (mevcutUst >= gZemin) ? Bolum33Content.zeminKatYeterli : Bolum33Content.zeminKatYetersiz;
    ChoiceResult? resBodrum = _hasBodrum ? (mevcutBodrum >= gBodrum ? Bolum33Content.bodrumKatYeterli : Bolum33Content.bodrumKatYetersiz) : null;

    setState(() {
      _model = Bolum33Model(
        alanZemin: aZemin, alanNormal: aNormal, alanBodrumMax: aBodrum,
        yukZemin: yukZemin, yukNormal: yukNormal, yukBodrum: yukBodrum,
        gerekliZemin: gZemin, gerekliNormal: gNormal, gerekliBodrum: gBodrum,
        mevcutUst: mevcutUst, mevcutBodrum: mevcutBodrum,
        normalKatSonuc: resNormal, zeminKatSonuc: resZemin, bodrumKatSonuc: resBodrum,
      );
      _showSummary = true;
    });
  }

  void _onNextPressed() {
    if (!_isConfirmed) return _showError("Lütfen analiz sonuçlarını onaylayınız.");
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
          ModernHeader(
          title: "Bölüm-33: Kullanıcı Yükü ve Çıkış Sayısı Hesabı", 
          subtitle: "...", 
          screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kat Kullanım Alanları (m²)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 15),
                        _buildInput("Zemin kat toplam kullanım alanı", _zeminCtrl, "Brüt alan: ${BinaStore.instance.bolum5?.katAlani ?? '-'} m²"),
                        if (_hasNormal) ...[
                          const SizedBox(height: 15),
                          _buildInput("En büyük normal kat alanı", _normalCtrl, null),
                        ],
                        if (_hasBodrum) ...[
                          const SizedBox(height: 15),
                          _buildInput("En büyük bodrum kat alanı", _bodrumCtrl, "Birden fazla ise en büyüğünü giriniz."),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _hesapla,
                            icon: const Icon(Icons.analytics),
                            label: const Text("HESAPLA VE ANALİZ ET"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
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
          if (_showSummary)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))]),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isConfirmed ? _onNextPressed : null,
                    child: const Text("ONAYLA VE DEVAM ET"),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text("📊 KAÇIŞ KAPASİTESİ ANALİZİ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A237E)))),
          const Divider(height: 25),
          if (_hasNormal) _buildResultRow("NORMAL KATLAR", _model.yukNormal, _model.gerekliNormal, _model.mevcutUst),
          const SizedBox(height: 15),
          if (_hasBodrum) _buildResultRow("BODRUM KATLAR", _model.yukBodrum, _model.gerekliBodrum, _model.mevcutBodrum),
          const Divider(height: 30),
          CheckboxListTile(
            value: _isConfirmed,
            onChanged: (v) => setState(() => _isConfirmed = v ?? false),
            title: const Text("Yukarıdaki kapasite analiz sonuçlarını kontrol ettim ve onaylıyorum.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
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
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        Text("• Tahmini Kişi: ${yuk?.toStringAsFixed(1)}", style: const TextStyle(fontSize: 13)),
        Text("• Gereken Çıkış: $gerekli | Mevcut: $mevcut", style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 5),
        Text(isOk ? "✅ UYGUN" : "🚨 YETERSİZ", style: TextStyle(fontWeight: FontWeight.bold, color: isOk ? Colors.green : Colors.red)),
      ],
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, String? hint) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, helperText: hint, suffixText: "m²", border: const OutlineInputBorder()),
      onChanged: (_) => setState(() => _showSummary = false),
    );
  }
}