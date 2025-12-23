import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_14_screen.dart';

class Bolum13Screen extends StatefulWidget {
  const Bolum13Screen({super.key});

  @override
  State<Bolum13Screen> createState() => _Bolum13ScreenState();
}

class _Bolum13ScreenState extends State<Bolum13Screen> {
  Bolum13Model _model = Bolum13Model();

  @override
  void initState() {
    super.initState();
    // HAFIZA DÜZELTMESİ
    if (BinaStore.instance.bolum13 != null) {
      _model = BinaStore.instance.bolum13!;
    }
  }

  void _onNextPressed() {
    if (!_isFormValid()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ EKSİK SEÇİM"),
          content: const Text("Lütfen ekranda görünen tüm riskli alanlar için bir seçim yapınız."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))],
        ),
      );
      return;
    }

    BinaStore.instance.bolum13 = _model;
    print("Bölüm 13 Kaydedildi.");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum14Screen()));
  }

  @override
  Widget build(BuildContext context) {
    final b7 = BinaStore.instance.bolum7;
    final b6 = BinaStore.instance.bolum6;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Yangın Kompartımanı",
            subtitle: "Özel Riskli Hacimlerin Ayrımı",
            currentStep: 13,
            totalSteps: 15,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "RİSKLİ HACİM DENETİMİ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Binanızda var olduğunu belirttiğiniz teknik alanların güvenlik durumunu inceleyelim.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 25),

                  if (b7?.hasKapaliOtopark == true)
                    _buildSection(
                      title: "1) KAPALI OTOPARK",
                      question: "Otoparktan bina içine açılan kapınızın özelliği nedir?",
                      currentValue: _model.resOtoparkKapi,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resOtoparkKapi: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "Çelik/Metal, duman sızdırmaz, yangına dayanıklı kapı. (✅ OLUMLU GÖRÜNÜYOR)"),
                        ChoiceResult(label: "B", reportText: "Normal demir, plastik veya ahşap kapı. (🚨 RİSK: Kapı en az 90 dk dayanıklı olmalı.)"),
                        ChoiceResult(label: "C", reportText: "Kapı yok, direkt açık geçiş var. (🚨 KRİTİK RİSK: Duman direkt binaya dolar.)"),
                        ChoiceResult(label: "D", reportText: "Otopark kapısının özelliklerini bilmiyorum. (❓ BİLİNMİYOR)"),
                      ],
                    ),

                  if (b7?.hasKazanDairesi == true)
                    _buildSection(
                      title: "2) KAZAN DAİRESİ",
                      question: "Kazan dairesinin duvarları ve kapısı nasıldır?",
                      currentValue: _model.resKazanKapi,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKapi: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "Duvarlar beton, kapı dışarıya açılan yangın kapısı. (✅ OLUMLU GÖRÜNÜYOR)"),
                        ChoiceResult(label: "B", reportText: "Kapı plastik/ahşap veya içeriye açılıyor. (🚨 RİSK)"),
                        ChoiceResult(label: "C", reportText: "Kazan dairesi binadan ayrı bir yerde. (✅ OLUMLU GÖRÜNÜYOR)"),
                        ChoiceResult(label: "D", reportText: "Bilmiyorum. (❓ BİLİNMİYOR)"),
                      ],
                    ),

                  if (b7?.hasAsansorNormal == true)
                    _buildSection(
                      title: "3) NORMAL ASANSÖR",
                      question: "Binanızdaki normal asansörün kapısı nasıldır?",
                      currentValue: _model.resAsansorKapi,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorKapi: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "Asansör kat / kabin kapıları yangına dayanıklı. (✅ OLUMLU GÖRÜNÜYOR)"),
                        ChoiceResult(label: "B", reportText: "Asansör kat / kabin kapıları yangına dayanıklı değil. (⚠️ UYARI)"),
                        ChoiceResult(label: "C", reportText: "Bilmiyorum. (❓ BİLİNMİYOR)"),
                      ],
                    ),
                  
                  if (b7?.hasAsansorDairesi == true)
                    _buildSection(
                      title: "4) ASANSÖR MAKİNE DAİRESİ",
                      question: "Çatıdaki asansör makine dairesinin kapısı nasıldır?",
                      currentValue: _model.resAsansorMakineKapi,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorMakineKapi: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "Çelik/Metal yangına dayanıklı kapı. (✅ OLUMLU GÖRÜNÜYOR)"),
                        ChoiceResult(label: "B", reportText: "Normal demir, plastik veya ahşap kapı. (⚠️ UYARI)"),
                        ChoiceResult(label: "C", reportText: "Bilmiyorum. (❓ BİLİNMİYOR)"),
                      ],
                    ),

                  if (b7?.hasJeneratorOdasi == true)
                    _buildSection(
                      title: "5) JENERATÖR ODASI",
                      question: "Jenerator odasının duvar ve kapısı nasıldır?",
                      currentValue: _model.resJeneratorKapi,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorKapi: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "Yangına dayanıklı duvar ve kapı ile ayrılmış. (✅ OLUMLU GÖRÜNÜYOR)"),
                        ChoiceResult(label: "B", reportText: "Açıkta veya basit bir bölme ile ayrılmış. (🚨 RİSK)"),
                        ChoiceResult(label: "C", reportText: "Bilmiyorum. (❓ BİLİNMİYOR)"),
                      ],
                    ),

                  // EKSİK OLAN ELEKTRİK ODASI EKLENDİ
                  if (b7?.hasElektrikOdasi == true)
                    _buildSection(
                      title: "6) ELEKTRİK PANO ODASI",
                      question: "Binadaki elektrik odalarının duvarları ve kapıları nasıldır?",
                      currentValue: _model.resElektrikKapi,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resElektrikKapi: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "Kilitli, yangına dayanıklı ve duman sızdırmaz kapı. (✅ OLUMLU GÖRÜNÜYOR)"),
                        ChoiceResult(label: "B", reportText: "Normal dayanıksız (demir, plastik, ahşap) kapı. (⚠️ UYARI)"),
                        ChoiceResult(label: "C", reportText: "Bilmiyorum. (❓ BİLİNMİYOR)"),
                      ],
                    ),

                  if (b6?.hasTicari == true)
                    _buildTicariSection(),

                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  // GÖRÜNÜM DÜZELTMESİ: Başlık artık metin, alt başlık seçenek harfi
  Widget _buildSection({
    required String title,
    required String question,
    required ChoiceResult? currentValue,
    required ValueChanged<ChoiceResult?> onChanged,
    required List<ChoiceResult> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        QuestionCard(
          child: Column(
            children: options.map((opt) => SelectableCard<ChoiceResult>(
              title: opt.reportText, // DÜZELTME: Metin başlık oldu
              subtitle: "Seçenek ${opt.label}", // DÜZELTME: Harf alt başlık oldu
              value: opt,
              groupValue: currentValue,
              onChanged: onChanged,
            )).toList(),
          ),
        ),
        const Divider(height: 40),
      ],
    );
  }

  Widget _buildTicariSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("11) TİCARİ ALAN", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        const Text("Konutların altındaki dükkan veya ofisten konut merdivenine geçiş nasıl?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard<ChoiceResult>(
                title: "Tamamen ayrı girişleri var, bina içinden bağlantı yok. (✅ OLUMLU GÖRÜNÜYOR)",
                subtitle: "Seçenek A",
                value: ChoiceResult(label: "A", reportText: "Tamamen ayrı girişleri var. (✅ OLUMLU GÖRÜNÜYOR)"),
                groupValue: _model.resTicariAlan,
                onChanged: (val) => setState(() => _model = _model.copyWith(resTicariAlan: val, hasTicariYanginKapisi: null)),
              ),
              SelectableCard<ChoiceResult>(
                title: "Aynı merdiven boşluğunu kullanıyorlar.",
                subtitle: "Seçenek B",
                value: ChoiceResult(label: "B", reportText: "Aynı merdiven boşluğu kullanılıyor."),
                groupValue: _model.resTicariAlan,
                onChanged: (val) => setState(() => _model = _model.copyWith(resTicariAlan: val)),
              ),
              if (_model.resTicariAlan?.label == "B") ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text("Alt Soru: Arada yangın kapısı var mı?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                // DÜZELTME: Alt soru stili Bölüm 15 gibi yapıldı
                _buildSubOption("Evet Var", "✅ OLUMLU", true, _model.hasTicariYanginKapisi, (v) => setState(() => _model = _model.copyWith(hasTicariYanginKapisi: v))),
                _buildSubOption("Hayır Yok", "🚨 RİSK: Ayrılmalıdır.", false, _model.hasTicariYanginKapisi, (v) => setState(() => _model = _model.copyWith(hasTicariYanginKapisi: v))),
              ],
              SelectableCard<ChoiceResult>(
                title: "Bilmiyorum. (❓ BİLİNMİYOR)",
                subtitle: "Seçenek C",
                value: ChoiceResult(label: "C", reportText: "Bilmiyorum. (❓ BİLİNMİYOR)"),
                groupValue: _model.resTicariAlan,
                onChanged: (val) => setState(() => _model = _model.copyWith(resTicariAlan: val, hasTicariYanginKapisi: null)),
              ),
            ],
          ),
        ),
        const Divider(height: 40),
      ],
    );
  }

  // YENİ: Alt soru için özel widget (Bölüm 15 stili)
  Widget _buildSubOption(String text, String subText, bool value, bool? groupValue, Function(bool) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: SelectableCard<bool>(
        title: text,
        subtitle: subText,
        value: value,
        groupValue: groupValue,
        onChanged: (v) => onSelected(v!),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
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
    final b7 = BinaStore.instance.bolum7;
    final b6 = BinaStore.instance.bolum6;
    
    if (b7?.hasKapaliOtopark == true && _model.resOtoparkKapi == null) return false;
    if (b7?.hasKazanDairesi == true && _model.resKazanKapi == null) return false;
    if (b7?.hasAsansorNormal == true && _model.resAsansorKapi == null) return false;
    if (b7?.hasAsansorDairesi == true && _model.resAsansorMakineKapi == null) return false;
    if (b7?.hasJeneratorOdasi == true && _model.resJeneratorKapi == null) return false;
    if (b7?.hasElektrikOdasi == true && _model.resElektrikKapi == null) return false; // EKLENDİ
    
    if (b6?.hasTicari == true) {
       if (_model.resTicariAlan == null) return false;
       if (_model.resTicariAlan?.label == "B" && _model.hasTicariYanginKapisi == null) return false;
    }
    return true;
  }
}