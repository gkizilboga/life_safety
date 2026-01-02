import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_36_model.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import 'report_summary_screen.dart';

class Bolum36Screen extends StatefulWidget {
  const Bolum36Screen({super.key});

  @override
  State<Bolum36Screen> createState() => _Bolum36ScreenState();
}

class _Bolum36ScreenState extends State<Bolum36Screen> {
  Bolum36Model _model = Bolum36Model();
  final _genislikCtrl = TextEditingController();
  final _kapiGenislikCtrl = TextEditingController();

  // Nokta atışı kaydırma için anahtarlar
  final GlobalKey _qKonumKey = GlobalKey();
  final GlobalKey _qGenislikKey = GlobalKey();
  final GlobalKey _qKapiTipiKey = GlobalKey();
  final GlobalKey _qKapiGenislikKey = GlobalKey();
  final GlobalKey _qGorunurlukKey = GlobalKey();

  int _cntDisCelik = 0;
  bool _isHighBuilding = false;
  bool _showStep0Warning = false;
  bool _genislikBilinmiyor = false;
  bool _kapiGenislikBilinmiyor = false;

  @override
  void initState() {
    super.initState();
    _performPreCalculations();
  }

  void _performPreCalculations() {
    final b4 = BinaStore.instance.bolum4;
    final b20 = BinaStore.instance.bolum20;
    
    double hBina = b4?.hesaplananBinaYuksekligi ?? 0.0;
    _isHighBuilding = hBina >= 21.50;

    int rawDoner = b20?.donerMerdivenSayisi ?? 0;
    int validDoner = (hBina <= 9.50) ? rawDoner : 0;
    bool donerElendi = (rawDoner > 0 && validDoner == 0);

    _cntDisCelik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    int validDisCelik = (hBina <= 21.50) ? _cntDisCelik : 0;
    bool disCelikElendi = (_cntDisCelik > 0 && validDisCelik == 0);

    int totalValid = (b20?.normalMerdivenSayisi ?? 0) + 
                     (b20?.binaIciYanginMerdiveniSayisi ?? 0) + 
                     (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + 
                     validDoner + validDisCelik;

    setState(() {
      _model = _model.copyWith(
        totalValidCikisSayisi: totalValid,
        donerElendi: donerElendi,
        disCelikElendi: disCelikElendi,
      );
      _showStep0Warning = donerElendi || disCelikElendi;
    });
  }

  // Belirli bir widget'a yumuşak kaydırma fonksiyonu
  void _scrollToKey(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

  @override
  void dispose() {
    _genislikCtrl.dispose();
    _kapiGenislikCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'disMerd') {
        _model = _model.copyWith(disMerd: choice);
        // Dış merdiven seçilince varsa Konum'a, yoksa Genişlik'e kaydır
        if ((_model.totalValidCikisSayisi ?? 0) > 1) {
          _scrollToKey(_qKonumKey);
        } else {
          _scrollToKey(_qGenislikKey);
        }
      } else if (type == 'konum') {
        _model = _model.copyWith(konum: choice);
        _scrollToKey(_qGenislikKey);
      } else if (type == 'kapiTipi') {
        _model = _model.copyWith(kapiTipi: choice);
        _scrollToKey(_qKapiGenislikKey);
      } else if (type == 'gorunurluk') {
        _model = _model.copyWith(gorunurluk: choice);
      }
    });
  }

  bool _isReady() {
    double? gen = _genislikBilinmiyor ? null : double.tryParse(_genislikCtrl.text.replaceAll(',', '.'));
    double? kGen = _kapiGenislikBilinmiyor ? null : double.tryParse(_kapiGenislikCtrl.text.replaceAll(',', '.'));

    if (_cntDisCelik > 0 && _model.disMerd == null) return false;
    if ((_model.totalValidCikisSayisi ?? 0) > 1 && _model.konum == null) return false;
    if (!_genislikBilinmiyor && gen == null) return false;
    if (_model.kapiTipi == null) return false;
    if (!_kapiGenislikBilinmiyor && kGen == null) return false;
    if (_model.gorunurluk == null) return false;
    return true;
  }

  void _onFinishPressed() {
    double? gen = _genislikBilinmiyor ? null : double.tryParse(_genislikCtrl.text.replaceAll(',', '.'));
    double? kGen = _kapiGenislikBilinmiyor ? null : double.tryParse(_kapiGenislikCtrl.text.replaceAll(',', '.'));
    
    _model = _model.copyWith(genislik: gen, kapiGenislik: kGen);

    BinaStore.instance.bolum36 = _model;
    BinaStore.instance.saveToDisk();
    _showFinishDialog();
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Analiz Tamamlandı", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        content: const Text("Tüm veriler başarıyla işlendi. Binanızın Yangın Risk Analiz Ön Raporu hazırlandı."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ReportSummaryScreen()),
                (route) => false,
              );
            },
            child: const Text("Ön Raporu Görüntüle"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kaçış Yollarının Değerlendirmesi",
      subtitle: "Final ölçümleri ve erişim denetimi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: _onFinishPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showStep0Warning) _buildStep0Card(),
          
          // --- SORU 1: DIŞ MERDİVEN ---
          if (_cntDisCelik > 0) ...[
            if (_isHighBuilding) _buildHighBuildingWarning(),
            _buildSoruHeader("1. Dışarıdaki yangın merdivenine 3 metre mesafede açıklık var mı?"),
            _buildSoruCard('disMerd', [Bolum36Content.disMerdOptionA, Bolum36Content.disMerdOptionB, Bolum36Content.disMerdOptionC], _model.disMerd),
          ],

          // --- SORU 2: KONUM ---
          if ((_model.totalValidCikisSayisi ?? 0) > 1) ...[
            SizedBox(key: _qKonumKey, height: 1),
            _buildInfoNote("Binada birden fazla çıkış tespit edildiği için konum değerlendirmesi gereklidir."),
            _buildSoruHeader("2. Kaçış merdivenleri birbirine göre nasıl konumlanmış?"),
            _buildSoruCard('konum', [Bolum36Content.konumOptionA, Bolum36Content.konumOptionB, Bolum36Content.konumOptionC], _model.konum),
          ],

          // --- SORU 3: GENİŞLİK ---
          SizedBox(key: _qGenislikKey, height: 1),
          _buildSoruHeader("3. Merdiven/Koridor temiz genişliği (cm) kaçtır?"),
          QuestionCard(
            child: Column(
              children: [
                TextFormField(
                  controller: _genislikCtrl,
                  enabled: !_genislikBilinmiyor,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(hintText: "Örn: 120", suffixText: "cm", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                SelectableCard(
                  choice: Bolum36Content.genislikBilinmiyor,
                  isSelected: _genislikBilinmiyor,
                  onTap: () => setState(() {
                    _genislikBilinmiyor = !_genislikBilinmiyor;
                    if (_genislikBilinmiyor) _genislikCtrl.clear();
                    _scrollToKey(_qKapiTipiKey);
                  }),
                ),
              ],
            ),
          ),

          // --- SORU 4: KAPI TİPİ ---
          SizedBox(key: _qKapiTipiKey, height: 1),
          _buildSoruHeader("4. Merdivenlere açılan çıkış kapılarınızın tipi nedir?"),
          _buildSoruCard('kapiTipi', [Bolum36Content.kapiTipiOptionA, Bolum36Content.kapiTipiOptionB, Bolum36Content.kapiTipiOptionC], _model.kapiTipi),

          // --- SORU 5: KAPI GENİŞLİK ---
          SizedBox(key: _qKapiGenislikKey, height: 1),
          _buildSoruHeader("5. Kapı net geçiş genişliği (cm) kaçtır?"),
          QuestionCard(
            child: Column(
              children: [
                TextFormField(
                  controller: _kapiGenislikCtrl,
                  enabled: !_kapiGenislikBilinmiyor,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(hintText: "Örn: 90", suffixText: "cm", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                SelectableCard(
                  choice: Bolum36Content.kapiGenislikBilinmiyor,
                  isSelected: _kapiGenislikBilinmiyor,
                  onTap: () => setState(() {
                    _kapiGenislikBilinmiyor = !_kapiGenislikBilinmiyor;
                    if (_kapiGenislikBilinmiyor) _kapiGenislikCtrl.clear();
                    _scrollToKey(_qGorunurlukKey);
                  }),
                ),
              ],
            ),
          ),

          // --- SORU 6: GÖRÜNÜRLÜK ---
          SizedBox(key: _qGorunurlukKey, height: 1),
          _buildSoruHeader("6. Kaçış yolları açıkça görülebiliyor mu?"),
          _buildSoruCard('gorunurluk', [Bolum36Content.gorunurlukOptionA, Bolum36Content.gorunurlukOptionB, Bolum36Content.gorunurlukOptionC], _model.gorunurluk),
        ],
      ),
    );
  }

  Widget _buildSoruHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
    );
  }

  Widget _buildSoruCard(String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        children: options.map((opt) => SelectableCard(
          choice: opt,
          isSelected: selected?.label == opt.label,
          onTap: () => _handleSelection(key, opt),
        )).toList(),
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFE0B2))),
      child: Row(children: [const Icon(Icons.arrow_downward, color: Color(0xFFE65100), size: 20), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 13)))]),
    );
  }

  Widget _buildStep0Card() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber.shade200)),
      child: Column(children: [
        const Row(children: [Icon(Icons.warning_amber_rounded, color: Colors.orange), SizedBox(width: 10), Text("BAZI ÇIKIŞLAR GEÇERSİZ", style: TextStyle(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 10),
        Text("Bina yüksekliğinden dolayı; ${_model.donerElendi! ? 'Döner merdivenler, ' : ''}${_model.disCelikElendi! ? 'Dış açık merdivenler, ' : ''}yasal kaçış yolu sayılmamıştır.", style: const TextStyle(fontSize: 12)),
      ]),
    );
  }

  Widget _buildHighBuildingWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.shade200)),
      child: const Text("🚨 KRİTİK: 21.50m üzeri binalarda dış açık merdivenler Yangın Yönetmeliği'ne göre kullanılamaz..", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}