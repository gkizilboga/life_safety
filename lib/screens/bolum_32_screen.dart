import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_32_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_33_screen.dart';

class Bolum32Screen extends StatefulWidget {
  const Bolum32Screen({super.key});

  @override
  State<Bolum32Screen> createState() => _Bolum32ScreenState();
}

class _Bolum32ScreenState extends State<Bolum32Screen> {
  Bolum32Model _model = Bolum32Model();
  bool _isSkipped = false;

  @override
  void initState() {
    super.initState();
    // KONTROL: Jeneratör odası yoksa atla
    final bool hasJenerator = BinaStore.instance.bolum7?.hasJeneratorOdasi ?? false;
    if (!hasJenerator) {
      _isSkipped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed(); 
      });
    }

    if (BinaStore.instance.bolum32 != null) {
      _model = BinaStore.instance.bolum32!;
    }
  }

  void _onNextPressed() {
    if (!_isSkipped) {
      BinaStore.instance.bolum32 = _model;
      print("Bölüm 32 Kaydedildi.");
    } else {
      print("Bölüm 32 Atlandı (Jeneratör Yok).");
    }
    
    // VERİ GİRİŞİ BİTTİ - RAPOR EKRANINA GİDİŞ
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum33Screen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tebrikler! Tüm veri girişi tamamlandı.")));
  }

  @override
  Widget build(BuildContext context) {
    if (_isSkipped) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Jeneratör Odası",
            subtitle: "Bölüm 32: Güç Kaynağı Güvenliği",
            currentStep: 32,
            totalSteps: 32,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: YAPI VE KONUM
                  const Text("ADIM-1: YAPI VE KONUM", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text(
                          "Jeneratör odasının duvarları yangına dayanıklı mı ve kapısı nereye açılıyor?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Duvarlar beton/tuğla, kapı dışarıya açılıyor.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resJeneratorYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorYapi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Kapısı direkt apartman koridoruna açılıyor.",
                          subtitle: "🚨 KRİTİK RİSK: Egzoz gazı riski.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Jeneratör odasından çıkacak zehirli egzoz gazı ve duman, kaçış yollarını kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır."),
                          groupValue: _model.resJeneratorYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorYapi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Duvarlar alçıpan, kapı normal.",
                          subtitle: "🚨 RİSK: Yangına dayanmaz.",
                          value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Jeneratör odası yangın bölmesi olarak tasarlanmalıdır. Duvarlar ve kapı en az 120 dakika yangına dayanmazsa, yakıt yangını binaya sıçrar."),
                          groupValue: _model.resJeneratorYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorYapi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Jeneratör odasının yapısal özellikleri bilinmiyor. Yalıtımın zayıf olması tüm binayı riske atar."),
                          groupValue: _model.resJeneratorYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorYapi: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2: YAKIT DEPOLAMA
                  const Divider(height: 40),
                  const Text("ADIM-2: YAKIT DEPOLAMA GÜVENLİĞİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Jeneratörün yakıtı nerede ve nasıl depolanıyor?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Kendi tankında veya gömülü tankta.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resJeneratorYakit,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorYakit: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Oda içinde bidonlarda/varillerde.",
                          subtitle: "🚨 KRİTİK RİSK: Patlama tehlikesi.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Jeneratör odasında bidonla veya açık kapta yakıt saklamak kesinlikle yasaktır!"),
                          groupValue: _model.resJeneratorYakit,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorYakit: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Yakıtın nasıl depolandığı bilinmiyor. Kontrolsüz yakıt depolama büyük risk taşır."),
                          groupValue: _model.resJeneratorYakit,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorYakit: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3: ÇEVRESEL RİSKLER
                  const Divider(height: 40),
                  const Text("ADIM-3: ÇEVRESEL RİSKLER", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Jeneratör odasının içinden su borusu geçiyor mu VEYA üst katında ıslak zemin var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, çevresi ve üstü kuru.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resJeneratorCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorCevre: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, içinden su/doğalgaz boruları geçiyor.",
                          subtitle: "🚨 KRİTİK RİSK: Tesisat riski.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Jeneratör odasından su veya gaz tesisatı geçirilemez."),
                          groupValue: _model.resJeneratorCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorCevre: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Evet, üstünde banyo/tuvalet var.",
                          subtitle: "🚨 RİSK: Su sızıntısı tehlikesi.",
                          value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Jeneratör odalarının üstü ıslak hacim olamaz. Su sızıntısı kısa devreye yol açar."),
                          groupValue: _model.resJeneratorCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorCevre: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Odanın çevresel riskleri bilinmiyor. Tesisat geçişleri kontrol edilmelidir."),
                          groupValue: _model.resJeneratorCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorCevre: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-4: HAVALANDIRMA VE EGZOZ
                  const Divider(height: 40),
                  const Text("ADIM-4: HAVALANDIRMA VE EGZOZ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Jeneratörün egzoz borusu nereye veriliyor ve oda havalandırılıyor mu?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Egzoz dışarıda, havalandırma var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resJeneratorHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorHavalandirma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Egzoz içeride veya havalandırma yok.",
                          subtitle: "🚨 KRİTİK RİSK: Zehirlenme tehlikesi.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Ölümcül Hata! Jeneratör egzozu karbonmonoksit içerir. Boru mutlaka bina dışına uzatılmalıdır."),
                          groupValue: _model.resJeneratorHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorHavalandirma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Egzoz ve havalandırma durumu bilinmiyor. Karbonmonoksit sızıntısı sessiz ve ölümcüldür."),
                          groupValue: _model.resJeneratorHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resJeneratorHavalandirma: val)),
                        ),
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
    if (_isSkipped) return true;
    if (_model.resJeneratorYapi == null) return false;
    if (_model.resJeneratorYakit == null) return false;
    if (_model.resJeneratorCevre == null) return false;
    if (_model.resJeneratorHavalandirma == null) return false;
    return true;
  }
}