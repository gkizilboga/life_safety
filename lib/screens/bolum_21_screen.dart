import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_22_screen.dart';
// import 'package:life_safety/screens/bolum_22_screen.dart'; // Sonraki aşama

class Bolum21Screen extends StatefulWidget {
  const Bolum21Screen({super.key});

  @override
  State<Bolum21Screen> createState() => _Bolum21ScreenState();
}

class _Bolum21ScreenState extends State<Bolum21Screen> {
  Bolum21Model _model = Bolum21Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum21 != null) {
      _model = BinaStore.instance.bolum21!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum21 = _model;
    print("Bölüm 21 Kaydedildi.");
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum22Screen()));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLimit5150 = BinaStore.instance.bolum4?.isLimitYapi5150 ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Yangın Güvenlik Holü",
            subtitle: "Bölüm 21: YGH Denetimi",
            currentStep: 21,
            totalSteps: 25, // Tahmini toplam adım
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ADIM-1: YGH ZORUNLULUĞU",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 15),
                  
                  if (isLimit5150)
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text(
                            "Binanız 51.50 metreden yüksek olduğu için; daire kapısından çıkıp yangın merdivenine giderken, arada ikinci bir kapıdan geçtiğiniz küçük bir oda (YGH) var mı?",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, var.",
                            subtitle: "Merdiven önünde çift kapılı bir hol var. (✅ OLUMLU GÖRÜNÜYOR)",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resYghVarligi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghVarligi: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, yok.",
                            subtitle: "Direkt merdivene çıkıyoruz.",
                            value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. 51.50m üzeri binalarda merdiven önünde YGH ZORUNLUDUR. Dumanın merdivene dolmasını bu hol engeller."),
                            groupValue: _model.resYghVarligi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghVarligi: val)),
                          ),
                        ],
                      ),
                    )
                  else
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text(
                            "Bodrum katlarda (Otopark, Kazan Dairesi vb.) merdivene girerken arada YGH var mı?",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, var.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resYghVarligi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghVarligi: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, direkt giriyoruz.",
                            subtitle: "⚠️ UYARI",
                            value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Bodrum katlardaki riskli alanlardan merdivene geçişte YGH olması mecburidir."),
                            groupValue: _model.resYghVarligi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghVarligi: val)),
                          ),
                        ],
                      ),
                    ),

                  if (_model.resYghVarligi?.label == "A") ...[
                    const Divider(height: 40),
                    const Text(
                      "ADIM-2: YGH FİZİKSEL ÖZELLİKLERİ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                    ),
                    const SizedBox(height: 15),

                    // A) MALZEME
                    QuestionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("YGH duvarlarında, zemininde, tavanında kullanılan malzeme nedir?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Sıva, boya, beton, mermer.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resYghMalzeme,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghMalzeme: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Ahşap, duvar kağıdı, plastik.",
                            subtitle: "🚨 KIRMIZI RİSK: Yanıcı malzeme yasaktır.",
                            value: ChoiceResult(label: "B", reportText: "🚨 KIRMIZI RİSK. Yangın güvenlik holleri 'Kaçış Yolu'dur. Yanıcı malzeme kullanılamaz."),
                            groupValue: _model.resYghMalzeme,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghMalzeme: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Holdeki malzemelerin yanıcılık sınıfı bilinmiyor."),
                            groupValue: _model.resYghMalzeme,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghMalzeme: val)),
                          ),
                        ],
                      ),
                    ),

                    // B) KAPILAR
                    QuestionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bu hole giriş ve çıkış sağlayan kapıların özelliği nedir?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Yangına dayanıklı, contalı, çelik kapı.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resYghKapi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghKapi: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Normal oda kapısı, plastik veya cam.",
                            subtitle: "🚨 KIRMIZI RİSK: Dumanı tutamaz.",
                            value: ChoiceResult(label: "B", reportText: "🚨 KIRMIZI RİSK. Güvenlik holü kapıları en az 90 dakika yangına dayanıklı ve 'Duman Sızdırmaz' olmalıdır."),
                            groupValue: _model.resYghKapi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghKapi: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Kapıların yangın dayanımı bilinmiyor."),
                            groupValue: _model.resYghKapi,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghKapi: val)),
                          ),
                        ],
                      ),
                    ),

                    // C) EŞYA
                    QuestionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Şu an YGH ‘nin içinde herhangi bir eşya bekletiliyor mu?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Hayır, tamamen boş.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resYghEsya,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghEsya: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Evet; dolap, bisiklet vb. var.",
                            subtitle: "🚨 KIRMIZI RİSK: Kaçışı engeller.",
                            value: ChoiceResult(label: "B", reportText: "🚨 KIRMIZI RİSK. Yangın güvenlik holleri ASLA depolama alanı olarak kullanılamaz."),
                            groupValue: _model.resYghEsya,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghEsya: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum / Dikkat etmedim.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Holün kullanım durumu bilinmiyor."),
                            groupValue: _model.resYghEsya,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghEsya: val)),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  onPressed: _isFormValid() ? _onNextPressed : null,
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isFormValid() {
    if (_model.resYghVarligi == null) return false;
    if (_model.resYghVarligi?.label == "A") {
      if (_model.resYghMalzeme == null) return false;
      if (_model.resYghKapi == null) return false;
      if (_model.resYghEsya == null) return false;
    }
    return true;
  }
}