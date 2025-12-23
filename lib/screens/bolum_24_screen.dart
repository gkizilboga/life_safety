import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_24_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_25_screen.dart';
// import 'package:life_safety/screens/sonuc_ekrani.dart'; // FİNAL AŞAMA

class Bolum24Screen extends StatefulWidget {
  const Bolum24Screen({super.key});

  @override
  State<Bolum24Screen> createState() => _Bolum24ScreenState();
}

class _Bolum24ScreenState extends State<Bolum24Screen> {
  Bolum24Model _model = Bolum24Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum24 != null) {
      _model = BinaStore.instance.bolum24!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum24 = _model;
    print("Bölüm 24 Kaydedildi.");
    
    // BURASI ŞİMDİLİK SON EKRAN.
    // Raporlama motoru ve Sonuç Ekranı yazılınca oraya yönlendireceğiz.
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum25Screen()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veri Girişi Tamamlandı! Raporlama aşamasına geçiliyor...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Dış Kaçış Geçitleri",
            subtitle: "Bölüm 24: Açık Koridorlar",
            currentStep: 24,
            totalSteps: 25, // Tahmini final adım
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: GEÇİT TİPİ (FİLTRE)
                  const Text("ADIM-1: GEÇİT TİPİ SORGUSU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text(
                    "Daire kapınızdan çıktığınızda, kapalı bir apartman boşluğuna mı giriyorsunuz, yoksa dışarıya açık bir koridora/geçide mı çıkıyorsunuz?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Kapalı apartman boşluğuna (Normal Koridor).",
                          value: ChoiceResult(label: "A", reportText: "Kapalı koridor sistemi."),
                          groupValue: _model.resKoridorTipi,
                          onChanged: (val) => setState(() {
                            // A seçilirse diğer verileri temizle (Modül biter)
                            _model = Bolum24Model(resKoridorTipi: val);
                          }),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Dışarıya açık koridora çıkıyorum.",
                          subtitle: "Üstü kapalı ama yanları açık.",
                          value: ChoiceResult(label: "B", reportText: "Dışarıya açık koridor sistemi."),
                          groupValue: _model.resKoridorTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKoridorTipi: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2 ve 3 SADECE "B" SEÇİLİRSE GÖRÜNÜR
                  if (_model.resKoridorTipi?.label == "B") ...[
                    const Divider(height: 40),
                    const Text("ADIM-2: PENCERE VE MENFEZLER", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Bu açık koridora bakan daire pencereleriniz veya havalandırma delikleriniz var mı?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Hayır, hiç pencere yok.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resGecitPencere,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resGecitPencere: val, resPencereYukseklik: null)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Evet, pencereler var.",
                            value: ChoiceResult(label: "B", reportText: "Koridora bakan pencere var."),
                            groupValue: _model.resGecitPencere,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resGecitPencere: val)),
                          ),
                          if (_model.resGecitPencere?.label == "B") ...[
                            const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Alt kenarı yerden en az 1.80m yüksekte mi?", style: TextStyle(fontWeight: FontWeight.bold))),
                            _buildSubOption("Evet.", "✅ OLUMLU GÖRÜNÜYOR", "A", _model.resPencereYukseklik, (v) => setState(() => _model = _model.copyWith(resPencereYukseklik: v))),
                            _buildSubOption("Hayır.", "🚨 RİSK: Duman kaçış yolunu kapatır.", "B", _model.resPencereYukseklik, (v) => setState(() => _model = _model.copyWith(resPencereYukseklik: v))),
                          ],
                        ],
                      ),
                    ),

                    const Divider(height: 40),
                    const Text("ADIM-3: GEÇİT KAPILARI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Bu açık koridora açılan daire kapınızın özelliği nedir?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Yangına 30 dk. dayanıklı ve otomatik kapanıyor.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resGecitKapi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resGecitKapi: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Dayanıksız veya otomatik kapanmıyor.",
                            subtitle: "⚠️ UYARI: Yangın kaçış yolunu bloke edebilir.",
                            value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Dış kaçış geçitlerine açılan kapılar en az 30 dakika yangına dayanıklı olmalı ve otomatik kapanmalıdır."),
                            groupValue: _model.resGecitKapi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resGecitKapi: val)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildSubOption(String text, String subText, String label, ChoiceResult? group, Function(ChoiceResult) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: SelectableCard(
        title: text,
        subtitle: subText,
        value: ChoiceResult(label: label, reportText: subText),
        groupValue: group,
        onChanged: (v) => onSelected(v!),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid() ? _onNextPressed : null,
            child: const Text("ANALİZİ TAMAMLA"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_model.resKoridorTipi == null) return false;
    
    // Eğer Açık Koridor (B) seçildiyse diğer sorular zorunlu
    if (_model.resKoridorTipi?.label == "B") {
      if (_model.resGecitPencere == null) return false;
      if (_model.resGecitPencere?.label == "B" && _model.resPencereYukseklik == null) return false;
      if (_model.resGecitKapi == null) return false;
    }
    return true;
  }
}