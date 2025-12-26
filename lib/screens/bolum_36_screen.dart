import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_36_model.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import 'report_summary_screen.dart'; // Rapor ekranı import edildi

class Bolum36Screen extends StatefulWidget {
  const Bolum36Screen({super.key});

  @override
  State<Bolum36Screen> createState() => _Bolum36ScreenState();
}

class _Bolum36ScreenState extends State<Bolum36Screen> {
  Bolum36Model _model = Bolum36Model();
  final _genislikCtrl = TextEditingController();
  final _kapiGenislikCtrl = TextEditingController();

  int _cntDisCelik = 0;
  bool _isHighBuilding = false;
  bool _showStep0Warning = false;

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

  @override
  void dispose() {
    _genislikCtrl.dispose();
    _kapiGenislikCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'disMerd') _model = _model.copyWith(disMerd: choice);
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'kapiTipi') _model = _model.copyWith(kapiTipi: choice);
      if (type == 'gorunurluk') _model = _model.copyWith(gorunurluk: choice);
    });
  }

  void _onFinishPressed() {
    double? gen = double.tryParse(_genislikCtrl.text.replaceAll(',', '.'));
    double? kGen = double.tryParse(_kapiGenislikCtrl.text.replaceAll(',', '.'));
    _model = _model.copyWith(genislik: gen, kapiGenislik: kGen);

    if (_cntDisCelik > 0 && _model.disMerd == null) return _showError("Lütfen dış merdiven çevresi sorusunu yanıtlayınız.");
    if ((_model.totalValidCikisSayisi ?? 0) > 1 && _model.konum == null) return _showError("Lütfen merdiven konumu sorusunu yanıtlayınız.");
    if (gen == null) return _showError("Lütfen koridor/merdiven genişliğini giriniz.");
    if (_model.kapiTipi == null) return _showError("Lütfen çıkış kapısı tipini seçiniz.");
    if (kGen == null) return _showError("Lütfen kapı net geçiş genişliğini giriniz.");
    if (_model.gorunurluk == null) return _showError("Lütfen çıkışların görünürlüğünü seçiniz.");

    BinaStore.instance.bolum36 = _model;
    _showFinishDialog();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800));
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Analiz Tamamlandı", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        content: const Text("Tüm veriler başarıyla işlendi. Binanızın risk analiz raporu hazırlandı."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx); // Diyaloğu kapat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportSummaryScreen()),
              );
            },
            child: const Text("Raporu Görüntüle"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-36: Kapasite Kontrol", 
            subtitle: "Son ölçümler ve erişim denetimi.", 
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_showStep0Warning) _buildStep0Card(),
                  if (_cntDisCelik > 0) ...[
                    if (_isHighBuilding) _buildHighBuildingWarning(),
                    _buildSoru("Dışarıdaki yangın merdivenine 3 metre mesafede herhangi bir pencere, kapı veya duvar boşluğu var mı?", 'disMerd', 
                      [Bolum36Content.disMerdOptionA, Bolum36Content.disMerdOptionB, Bolum36Content.disMerdOptionC], _model.disMerd),
                  ],
                  if ((_model.totalValidCikisSayisi ?? 0) > 1)
                    _buildSoru("Binanızdaki kaçış merdivenleri birbirine göre nasıl konumlanmış?", 'konum', 
                      [Bolum36Content.konumOptionA, Bolum36Content.konumOptionB, Bolum36Content.konumOptionC], _model.konum),
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Merdiveninizin ve ona giden koridorun temiz genişliği (cm) kaçtır?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _genislikCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Örn: 120", suffixText: "cm", border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                  _buildSoru("Yangın merdivenine (veya sokağa) açılan çıkış kapınızın tipi nedir?", 'kapiTipi', 
                    [Bolum36Content.kapiTipiOptionA, Bolum36Content.kapiTipiOptionB, Bolum36Content.kapiTipiOptionC], _model.kapiTipi),
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kapı 90 derece açıldığında, geçiş yapılabilecek temiz net genişlik (cm) kaçtır?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _kapiGenislikCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Örn: 90", suffixText: "cm", border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                  _buildSoru("Kaçış yolları ve çıkış kapıları açıkça görülebiliyor mu ve önlerinde engel var mı?", 'gorunurluk', 
                    [Bolum36Content.gorunurlukOptionA, Bolum36Content.gorunurlukOptionB, Bolum36Content.gorunurlukOptionC], _model.gorunurluk),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))]),
            child: SafeArea(child: SizedBox(width: double.infinity, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: _onFinishPressed, 
              child: const Text("ANALİZİ BİTİR VE RAPORLA")
            ))),
          ),
        ],
      ),
    );
  }

  Widget _buildStep0Card() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber)),
      child: Column(
        children: [
          const Row(children: [Icon(Icons.warning, color: Colors.amber), SizedBox(width: 10), Text("DİKKAT: BAZI ÇIKIŞLAR ELENDİ", style: TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 10),
          Text("Yönetmelik gereği bina yüksekliğinizden dolayı; "
               "${_model.donerElendi! ? 'Döner merdivenleriniz, ' : ''}"
               "${_model.disCelikElendi! ? 'Dışarıdaki açık çelik merdivenleriniz, ' : ''}"
               "Yasal Kaçış Yolu olarak hesaba katılmamıştır.", style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildHighBuildingWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
      child: const Text("🚨 KRİTİK RİSK: Bina yüksekliği 21.50m üzerinde olduğu için dış açık merdivenlere izin verilmez.", 
        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )),
        ],
      ),
    );
  }
}