import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_36_model.dart';
// import 'report_screen.dart'; // SONRAKİ AŞAMA: RAPOR EKRANI
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum36Screen extends StatefulWidget {
  const Bolum36Screen({super.key});

  @override
  State<Bolum36Screen> createState() => _Bolum36ScreenState();
}

class _Bolum36ScreenState extends State<Bolum36Screen> {
  Bolum36Model _model = Bolum36Model();
  
  final _genislikCtrl = TextEditingController();
  final _kapiGenislikCtrl = TextEditingController();

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
    // Sayısal Girişleri Al
    double? gen = double.tryParse(_genislikCtrl.text.replaceAll(',', '.'));
    double? kGen = double.tryParse(_kapiGenislikCtrl.text.replaceAll(',', '.'));

    _model = _model.copyWith(genislik: gen, kapiGenislik: kGen);

    // Validasyon
    if (_model.disMerd == null) return _showError("Lütfen dış merdiven çevresi sorusunu yanıtlayınız.");
    if (_model.konum == null) return _showError("Lütfen merdiven konumu sorusunu yanıtlayınız.");
    // Sayısal alanlar opsiyonel olabilir veya zorunlu yapılabilir
    if (_model.kapiTipi == null) return _showError("Lütfen kapı tipini seçiniz.");
    if (_model.gorunurluk == null) return _showError("Lütfen çıkışların görünürlüğünü seçiniz.");

    BinaStore.instance.bolum36 = _model;
    
    // ANALİZ BİTTİ! RAPOR EKRANINA GİT.
    // Şimdilik Alert gösterip başa dönelim veya geçici bir sayfaya gidelim.
    _showFinishDialog();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Analiz Tamamlandı!"),
        content: const Text("Tüm veriler başarıyla kaydedildi. Rapor oluşturma ekranı hazırlanıyor..."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Dialogu kapat
              // Rapor ekranı olmadığı için şimdilik ana sayfaya veya 1. bölüme dön
              // Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("Tamam"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-36: Detay Kontrol",
            subtitle: "Son kontroller ve ölçümler.",
            currentStep: 26, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Dışarıdaki yangın merdivenine 3 metre mesafede herhangi bir pencere veya kapı var mı?", 'disMerd', 
                    [
                      Bolum36Content.disMerdOptionA, 
                      Bolum36Content.disMerdOptionB,
                      Bolum36Content.disMerdOptionC
                    ], _model.disMerd),

                  _buildSoru("Binanızdaki kaçış merdivenleri birbirine göre nasıl konumlanmış?", 'konum', 
                    [
                      Bolum36Content.konumOptionA, 
                      Bolum36Content.konumOptionB,
                      Bolum36Content.konumOptionC
                    ], _model.konum),

                  // Sayısal: Merdiven Genişliği
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
                    [
                      Bolum36Content.kapiTipiOptionA, 
                      Bolum36Content.kapiTipiOptionB
                    ], _model.kapiTipi),

                  // Sayısal: Kapı Genişliği
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
                    [
                      Bolum36Content.gorunurlukOptionA, 
                      Bolum36Content.gorunurlukOptionB,
                      Bolum36Content.gorunurlukOptionC
                    ], _model.gorunurluk),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Bitiş butonu yeşil olsun
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _onFinishPressed,
                  child: const Text("ANALİZİ BİTİR VE RAPORLA"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )).toList(),
        ],
      ),
    );
  }
}