import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_28_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_29_screen.dart';


class Bolum28Screen extends StatefulWidget {
  const Bolum28Screen({super.key});

  @override
  State<Bolum28Screen> createState() => _Bolum28ScreenState();
}

class _Bolum28ScreenState extends State<Bolum28Screen> {
  Bolum28Model _model = Bolum28Model();
  bool _isExempt = false; // Muafiyet durumu
  bool _showCommercialWarning = false; // 4 kat altı ama ticari var uyarısı

  @override
  void initState() {
    super.initState();
    _checkExemption();
    
    if (BinaStore.instance.bolum28 != null) {
      _model = BinaStore.instance.bolum28!;
    }
  }

  void _checkExemption() {
    final int normal = BinaStore.instance.normalKatSayisi;
    final int bodrum = BinaStore.instance.bodrumKatSayisi;
    final bool hasTicari = BinaStore.instance.bolum6?.hasTicari ?? false;
    
    final int totalFloors = normal + bodrum + 1; // Zemin dahil

    // DURUM A: MUAFİYET (4 KAT ALTI VE TİCARİ YOK)
    if (totalFloors <= 4 && !hasTicari) {
      _isExempt = true;
      _model = _model.copyWith(isExempt: true);
    } 
    // DURUM B: DENETİME DEVAM
    else {
      _isExempt = false;
      _model = _model.copyWith(isExempt: false);
      
      // Özel Bilgi Mesajı Kontrolü
      if (totalFloors <= 4 && hasTicari) {
        _showCommercialWarning = true;
      }
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum28 = _model;
    print("Bölüm 28 Kaydedildi. Muafiyet: $_isExempt");
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum29Screen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bölüm 28 Tamamlandı.")));
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSprinkler = BinaStore.instance.bolum9?.hasSprinkler ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Konut Kaçış Kuralları",
            subtitle: "Bölüm 28: Daire İçi Mesafe",
            currentStep: 28,
            totalSteps: 30, // Tahmini
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DURUM A: MUAFİYET EKRANI
                  if (_isExempt) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 50),
                          const SizedBox(height: 15),
                          const Text(
                            "MUAFİYET DURUMU",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Binanız bodrum dahil 4 katı geçmemektedir ve binada konut harici Ticari bir kullanım bulunmamaktadır. (Konut otoparkları ve depoları bu duruma engel değildir). Bu nedenle 'Tek Kullanımlı Yapı' statüsünde olup, özel bir yangın merdiveni veya kaçış mesafesi şartı aranmaz. Mevcut normal merdiveniniz yeterlidir.",
                            style: TextStyle(fontSize: 15, color: Colors.green.shade900, height: 1.4),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ] 
                  // DURUM B: DENETİM EKRANI
                  else ...[
                    if (_showCommercialWarning)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.orange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Binanız alçak katlı (4 kat altı) olmasına rağmen, bünyesinde Ticari Alan barındırdığı için 'Tek Kullanımlı Konut' muafiyetinden yararlanamamaktadır. Karma kullanım riski nedeniyle daire içi kaçış mesafeleri kontrol edilecektir.",
                                style: TextStyle(fontSize: 13, color: Colors.orange.shade900),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ADIM-2: DAİRE İÇİ MESAFE
                    const Text("ADIM-2: DAİRE İÇİ KAÇIŞ MESAFESİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan yürüme mesafesi yaklaşık ne kadardır?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Kısa (20 metreden az).",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resDaireMesafe,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDaireMesafe: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Orta (20 - 30 metre arası).",
                            subtitle: hasSprinkler ? "✅ OLUMLU (Sprinkler var)" : "🚨 RİSK: Sprinkler yoksa 20m sınır.",
                            value: ChoiceResult(
                              label: "B", 
                              reportText: hasSprinkler 
                                ? "✅ OLUMLU GÖRÜNÜYOR" 
                                : "🚨 RİSK. Sprinkler olmayan dairelerde en uzak noktadan çıkışa mesafe 20 metreyi geçemez. Mevcut mesafe uzundur."
                            ),
                            groupValue: _model.resDaireMesafe,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDaireMesafe: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Uzun (30 metreden fazla).",
                            subtitle: "🚨 RİSK: Sınır aşıldı.",
                            value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Sprinkler olsa bile daire içi kaçış mesafesi 30 metreyi geçemez."),
                            groupValue: _model.resDaireMesafe,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDaireMesafe: val)),
                          ),
                        ],
                      ),
                    ),

                    // ADIM-3: DUBLEKS DAİRELER
                    const Divider(height: 40),
                    const Text("ADIM-3: DUBLEKS DAİRELER", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Daireniz Dubleks (İki katlı) mi?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Hayır, normal daire.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resDubleksTip,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDubleksTip: val, resDubleksAlan70: null, resDubleksCikis: null)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Evet, dubleks.",
                            value: ChoiceResult(label: "B", reportText: "Dubleks daire."),
                            groupValue: _model.resDubleksTip,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDubleksTip: val)),
                          ),
                          
                          // ALT SORU 1: ALAN > 70m2
                          if (_model.resDubleksTip?.label == "B") ...[
                            const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Üst katınızın alanı 70 m²'den büyük mü?", style: TextStyle(fontWeight: FontWeight.bold))),
                            _buildSubOption("Hayır.", "✅ OLUMLU", "A", _model.resDubleksAlan70, (v) => setState(() => _model = _model.copyWith(resDubleksAlan70: v, resDubleksCikis: null))),
                            _buildSubOption("Evet.", "Kontrol Gerekli", "B", _model.resDubleksAlan70, (v) => setState(() => _model = _model.copyWith(resDubleksAlan70: v))),
                          ],

                          // ALT SORU 2: ÇIKIŞ KAPISI
                          if (_model.resDubleksAlan70?.label == "B") ...[
                            const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Üst kattan apartman koridoruna açılan ikinci bir çıkış kapısı var mı?", style: TextStyle(fontWeight: FontWeight.bold))),
                            _buildSubOption("Evet, var.", "✅ OLUMLU", "A", _model.resDubleksCikis, (v) => setState(() => _model = _model.copyWith(resDubleksCikis: v))),
                            _buildSubOption("Hayır, yok.", "⚠️ UYARI: Zorunludur.", "B", _model.resDubleksCikis, (v) => setState(() => _model = _model.copyWith(resDubleksCikis: v))),
                          ],
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
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_isExempt) return true; // Muafsa validasyon yok

    if (_model.resDaireMesafe == null) return false;
    if (_model.resDubleksTip == null) return false;
    
    if (_model.resDubleksTip?.label == "B") {
      if (_model.resDubleksAlan70 == null) return false;
      if (_model.resDubleksAlan70?.label == "B" && _model.resDubleksCikis == null) return false;
    }

    return true;
  }
}