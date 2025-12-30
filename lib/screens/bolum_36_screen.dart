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
  final ScrollController _scrollController = ScrollController();

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

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _genislikCtrl.dispose();
    _kapiGenislikCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'disMerd') {
        _model = _model.copyWith(disMerd: choice);
        _scrollToBottom();
      }
      if (type == 'konum') {
        _model = _model.copyWith(konum: choice);
        _scrollToBottom();
      }
      if (type == 'kapiTipi') {
        _model = _model.copyWith(kapiTipi: choice);
        _scrollToBottom();
      }
      if (type == 'gorunurluk') _model = _model.copyWith(gorunurluk: choice);
    });
  }

  void _onFinishPressed() {
    double? gen = _genislikBilinmiyor ? null : double.tryParse(_genislikCtrl.text.replaceAll(',', '.'));
    double? kGen = _kapiGenislikBilinmiyor ? null : double.tryParse(_kapiGenislikCtrl.text.replaceAll(',', '.'));
    
    _model = _model.copyWith(genislik: gen, kapiGenislik: kGen);

    if (_cntDisCelik > 0 && _model.disMerd == null) return _showError("Lütfen dış merdiven sorusunu yanıtlayınız.");
    if ((_model.totalValidCikisSayisi ?? 0) > 1 && _model.konum == null) return _showError("Lütfen merdiven konumu sorusunu yanıtlayınız.");
    if (!_genislikBilinmiyor && gen == null) return _showError("Lütfen genişlik giriniz veya 'Bilmiyorum' seçiniz.");
    if (_model.kapiTipi == null) return _showError("Lütfen kapı tipini seçiniz.");
    if (!_kapiGenislikBilinmiyor && kGen == null) return _showError("Lütfen kapı genişliği giriniz veya 'Bilmiyorum' seçiniz.");
    if (_model.gorunurluk == null) return _showError("Lütfen görünürlük sorusunu yanıtlayınız.");

    BinaStore.instance.bolum36 = _model;
    BinaStore.instance.saveToDisk();
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
        content: const Text("Tüm veriler başarıyla işlendi. Binanızın yangın risk analiz raporu hazırlandı."),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ReportSummaryScreen()),
                (route) => false, // Geri dönmeyi kapatır, çünkü analiz bitti.
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
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_showStep0Warning) _buildStep0Card(),
                  
                  if (_cntDisCelik > 0) ...[
                    if (_isHighBuilding) _buildHighBuildingWarning(),
                    _buildSoru("Dışarıdaki yangın merdivenine 3 metre mesafede açıklık var mı?", 'disMerd', 
                      [Bolum36Content.disMerdOptionA, Bolum36Content.disMerdOptionB, Bolum36Content.disMerdOptionC], _model.disMerd),
                  ],

                  if ((_model.totalValidCikisSayisi ?? 0) > 1) ...[
                    _buildInfoNote("Binada birden fazla çıkış tespit edildiği için konum analizi gereklidir."),
                    _buildSoru("Kaçış merdivenleri birbirine göre nasıl konumlanmış?", 'konum', 
                      [Bolum36Content.konumOptionA, Bolum36Content.konumOptionB, Bolum36Content.konumOptionC], _model.konum),
                  ],

                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Merdiven/Koridor temiz genişliği (cm) kaçtır?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _genislikCtrl,
                          enabled: !_genislikBilinmiyor,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: "Örn: 120", suffixText: "cm", border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard(
                          choice: Bolum36Content.genislikBilinmiyor,
                          isSelected: _genislikBilinmiyor,
                          onTap: () => setState(() {
                            _genislikBilinmiyor = !_genislikBilinmiyor;
                            if (_genislikBilinmiyor) _genislikCtrl.clear();
                            _scrollToBottom();
                          }),
                        ),
                      ],
                    ),
                  ),

                  _buildSoru("Çıkış kapınızın tipi nedir?", 'kapiTipi', 
                    [Bolum36Content.kapiTipiOptionA, Bolum36Content.kapiTipiOptionB, Bolum36Content.kapiTipiOptionC], _model.kapiTipi),

                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kapı net geçiş genişliği (cm) kaçtır?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _kapiGenislikCtrl,
                          enabled: !_kapiGenislikBilinmiyor,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: "Örn: 90", suffixText: "cm", border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard(
                          choice: Bolum36Content.kapiGenislikBilinmiyor,
                          isSelected: _kapiGenislikBilinmiyor,
                          onTap: () => setState(() {
                            _kapiGenislikBilinmiyor = !_kapiGenislikBilinmiyor;
                            if (_kapiGenislikBilinmiyor) _kapiGenislikCtrl.clear();
                            _scrollToBottom();
                          }),
                        ),
                      ],
                    ),
                  ),

                  _buildSoru("Kaçış yolları açıkça görülebiliyor mu?", 'gorunurluk', 
                    [Bolum36Content.gorunurlukOptionA, Bolum36Content.gorunurlukOptionB, Bolum36Content.gorunurlukOptionC], _model.gorunurluk),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.3))),
      child: Row(children: [const Icon(Icons.arrow_downward, color: Colors.orange, size: 20), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 13)))]),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(child: SizedBox(width: double.infinity, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
        onPressed: _onFinishPressed, 
        child: const Text("ANALİZİ BİTİR VE RAPORLA", style: TextStyle(fontWeight: FontWeight.bold))
      ))),
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
      child: const Text("🚨 KRİTİK: 21.50m üzeri binalarda dış açık merdivenler yönetmeliğe aykırıdır.", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
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