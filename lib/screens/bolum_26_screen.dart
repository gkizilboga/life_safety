import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_26_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_27_screen.dart';
class Bolum26Screen extends StatefulWidget {
  const Bolum26Screen({super.key});

  @override
  State<Bolum26Screen> createState() => _Bolum26ScreenState();
}

class _Bolum26ScreenState extends State<Bolum26Screen> {
  Bolum26Model _model = Bolum26Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum26 != null) {
      _model = BinaStore.instance.bolum26!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum26 = _model;
    print("Bölüm 26 Kaydedildi.");
    
    // BURASI VERİ GİRİŞİNİN SONU OLABİLİR VEYA DEVAM EDEBİLİR.
    // Şimdilik placeholder:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bölüm 26 Tamamlandı.")),
    );
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum27Screen()));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kaçış Rampaları",
            subtitle: "Bölüm 26: Rampa Güvenliği",
            currentStep: 26,
            totalSteps: 26, // Tahmini
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: RAMPA VARLIĞI
                  const Text("ADIM-1: RAMPA VARLIĞI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text(
                    "Binanızda kaçış yolu olarak kullanılan (veya otoparktan çıkışı sağlayan) eğimli bir rampa var mı?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, sadece merdiven var.",
                          value: ChoiceResult(label: "A", reportText: "Rampa yok."),
                          groupValue: _model.resRampaVar,
                          onChanged: (val) => setState(() {
                            // A seçilirse diğer verileri temizle (Modül biter)
                            _model = Bolum26Model(resRampaVar: val);
                          }),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, rampa var.",
                          value: ChoiceResult(label: "B", reportText: "Rampa mevcut."),
                          groupValue: _model.resRampaVar,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resRampaVar: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2, 3, 4 SADECE "B" SEÇİLİRSE GÖRÜNÜR
                  if (_model.resRampaVar?.label == "B") ...[
                    const Divider(height: 40),
                    const Text("ADIM-2: EĞİM VE KAYMAZLIK", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Bu rampanın eğimi (dikliği) ve zemin kaplaması nasıldır?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Eğim az ve zemin kaymaz.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resRampaEgim,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resRampaEgim: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Eğim fazla dik veya zemin kaygan.",
                            subtitle: "🚨 RİSK: Düşme tehlikesi.",
                            value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Kaçış rampalarının eğimi %10'dan fazla olamaz. Zemin mutlaka kaymaz malzeme ile kaplanmalıdır."),
                            groupValue: _model.resRampaEgim,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resRampaEgim: val)),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 40),
                    const Text("ADIM-3: SAHANLIK VE DOĞRULTU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Rampanın başlangıcında, bitişinde ve kapı önlerinde sahanlık var mı?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, kapı önleri ve dönüşler düz.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resRampaSahanlik,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resRampaSahanlik: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, hemen eğim başlıyor.",
                            subtitle: "⚠️ UYARI: Sahanlık gerekli.",
                            value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Rampa giriş ve çıkışlarında, kapı önlerinde mutlaka düz sahanlık bulunmalıdır."),
                            groupValue: _model.resRampaSahanlik,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resRampaSahanlik: val)),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 40),
                    const Text("ADIM-4: OTOPARK RAMPASI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Otoparkınızdan dışarı çıkan araç rampasını, acil durumda yürüyerek kaçış yolu olarak kullanabilir misiniz?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, eğimi uygun (%10 altı).",
                            subtitle: "✅ OLUMLU: 2. kaçış yolu olabilir.",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR. (Tek bodrum katlı otoparklarda bu rampa 2. kaçış yolu olarak kabul edilebilir.)"),
                            groupValue: _model.resOtoparkRampa,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resOtoparkRampa: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, çok dik veya kaygan.",
                            subtitle: "⚠️ BİLGİ: Kaçış yolu sayılamaz.",
                            value: ChoiceResult(label: "B", reportText: "⚠️ BİLGİ. (Bu rampa kaçış yolu sayılamaz, otoparkın başka bir yaya çıkışı olmalıdır.)"),
                            groupValue: _model.resOtoparkRampa,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resOtoparkRampa: val)),
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
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_model.resRampaVar == null) return false;
    
    // Eğer Rampa Var (B) seçildiyse diğer sorular zorunlu
    if (_model.resRampaVar?.label == "B") {
      if (_model.resRampaEgim == null) return false;
      if (_model.resRampaSahanlik == null) return false;
      if (_model.resOtoparkRampa == null) return false;
    }
    return true;
  }
}