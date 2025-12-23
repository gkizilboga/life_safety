import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult
import 'package:life_safety/models/bolum_19_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_20_screen.dart';
// import 'package:life_safety/logic/hesaplama_motoru.dart'; // Sonraki aşama

class Bolum19Screen extends StatefulWidget {
  const Bolum19Screen({super.key});

  @override
  State<Bolum19Screen> createState() => _Bolum19ScreenState();
}

class _Bolum19ScreenState extends State<Bolum19Screen> {
  Bolum19Model _model = Bolum19Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum19 != null) {
      _model = BinaStore.instance.bolum19!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum19 = _model;
    print("Bölüm 19 Kaydedildi.");
    // VERİ GİRİŞİ SONU - Hesaplama Motoruna Geçiş
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum20Screen()));
  }

  // Çoklu Seçim Mantığı (Checkbox)
  void _toggleObstacle(ChoiceResult option, bool isSelected) {
    setState(() {
      List<ChoiceResult> currentList = List.from(_model.resKacisEngeller);
      
      if (isSelected) {
        // Eğer A (Olumlu) seçilirse, diğer tüm olumsuzları temizle
        if (option.label == "A") {
          currentList.clear();
          currentList.add(option);
        } else {
          // Eğer Olumsuz (B, C, D) seçilirse, A'yı temizle
          currentList.removeWhere((item) => item.label == "A");
          currentList.add(option);
        }
      } else {
        currentList.removeWhere((item) => item.label == option.label);
      }
      
      _model = _model.copyWith(resKacisEngeller: currentList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kaçış Güvenliği",
            subtitle: "Bölüm 19: Engeller ve İşaretler",
            currentStep: 19,
            totalSteps: 19,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: KAÇIŞ YOLLARINDA ENGEL
                  const Text("ADIM-1: KAÇIŞ YOLLARINDA ENGEL VE KİLİT", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Yangın merdivenine giden koridorlarda veya merdiven kapılarında aşağıdakilerden hangisi var?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        _buildCheckboxOption(
                          ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR. Kaçış yolu temiz ve açık."),
                          "A) Kaçış yolu temiz ve açık.",
                          "Kapılar kilitsiz ve kolayca açılıyor.",
                        ),
                        _buildCheckboxOption(
                          ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Yangın merdiveni kapılarına ASLA kilit, sürgü veya zincir takılamaz!"),
                          "B) Kapılar kilitli / asma kilitli.",
                          "🚨 KRİTİK RİSK: Panik anında anahtar aranmaz.",
                        ),
                        _buildCheckboxOption(
                          ChoiceResult(label: "C", reportText: "🚨 KIRMIZI RİSK. Kaçış yolları ve merdiven sahanlıkları depo alanı değildir!"),
                          "C) Eşya, koli, çöp var.",
                          "🚨 RİSK: Dumanlı ortamda takılıp düşmeye sebep olur.",
                        ),
                        _buildCheckboxOption(
                          ChoiceResult(label: "D", reportText: "🚨 KIRMIZI RİSK. Kaçış yolu, kilitlenebilir başka bir odanın içinden geçemez."),
                          "D) Başka odanın içinden geçiyor.",
                          "🚨 RİSK: Koridordan direkt ulaşım sağlanmalıdır.",
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2: YÖNLENDİRME
                  const Divider(height: 40),
                  const Text("ADIM-2: YÖNLENDİRME VE İŞARETLEME", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Koridorlarda, karanlıkta bile parlayan veya ışıklı 'ÇIKIŞ / EXIT' levhaları var mı?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Evet, var ve çalışıyor.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resYonlendirme,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resYonlendirme: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Hayır, yok veya bozuk.",
                          subtitle: "⚠️ UYARI: Duman görüşü kapatabilir.",
                          value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Yangın anında elektrikler kesilebilir. Işıklı levhalar hayati önem taşır."),
                          groupValue: _model.resYonlendirme,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resYonlendirme: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Var ama yanlış yeri gösteriyor.",
                          subtitle: "🚨 RİSK: İnsanları tuzağa düşürür.",
                          value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Yanlış yönlendirme panik anında tehlikelidir."),
                          groupValue: _model.resYonlendirme,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resYonlendirme: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3: YANILTICI KAPILAR
                  const Divider(height: 40),
                  const Text("ADIM-3: ÇIKIŞ NİTELİĞİ TAŞIMAYAN KAPILAR", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Koridorda, yangın merdiveni kapısına benzeyen ama aslında depo/teknik oda olan kapılar var mı?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, sadece daire ve merdiven kapısı var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resYanilticiKapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resYanilticiKapi: val, resKapiEtiket: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, benzer kapılar var.",
                          value: ChoiceResult(label: "B", reportText: "Benzer kapılar mevcut."),
                          groupValue: _model.resYanilticiKapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resYanilticiKapi: val)),
                        ),
                        if (_model.resYanilticiKapi?.label == "B") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Üzerinde ne kapısı olduğu yazıyor mu?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Evet, yazıyor.", "✅ OLUMLU", "A", _model.resKapiEtiket, (v) => setState(() => _model = _model.copyWith(resKapiEtiket: v))),
                          _buildSubOption("Hayır, yazmıyor.", "⚠️ UYARI: İnsanlar çıkış sanabilir.", "B", _model.resKapiEtiket, (v) => setState(() => _model = _model.copyWith(resKapiEtiket: v))),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(ChoiceResult option, String title, String subtitle) {
    bool isSelected = _model.resKacisEngeller.any((item) => item.label == option.label);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CheckboxListTile(
        title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        value: isSelected,
        onChanged: (val) => _toggleObstacle(option, val ?? false),
        activeColor: const Color(0xFF1A237E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300),
        ),
        tileColor: isSelected ? const Color(0xFFE8EAF6) : Colors.white,
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
    if (_model.resKacisEngeller.isEmpty) return false;
    if (_model.resYonlendirme == null) return false;
    if (_model.resYanilticiKapi == null) return false;
    if (_model.resYanilticiKapi?.label == "B" && _model.resKapiEtiket == null) return false;
    return true;
  }
}