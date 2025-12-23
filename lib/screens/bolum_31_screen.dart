import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_31_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_32_screen.dart';

class Bolum31Screen extends StatefulWidget {
  const Bolum31Screen({super.key});

  @override
  State<Bolum31Screen> createState() => _Bolum31ScreenState();
}

class _Bolum31ScreenState extends State<Bolum31Screen> {
  Bolum31Model _model = Bolum31Model();
  bool _isSkipped = false;

  @override
  void initState() {
    super.initState();
    // KONTROL: Trafo odası yoksa atla
    final bool hasTrafo = BinaStore.instance.bolum7?.hasTrafoOdasi ?? false;
    if (!hasTrafo) {
      _isSkipped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed(); 
      });
    }

    if (BinaStore.instance.bolum31 != null) {
      _model = BinaStore.instance.bolum31!;
    }
  }

  void _onNextPressed() {
    if (!_isSkipped) {
      BinaStore.instance.bolum31 = _model;
      print("Bölüm 31 Kaydedildi.");
    } else {
      print("Bölüm 31 Atlandı (Trafo Yok).");
    }
    
    // VERİ GİRİŞİ BİTTİ - RAPOR EKRANINA GİDİŞ
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum32Screen()));
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
            title: "Trafo Merkezi",
            subtitle: "Bölüm 31: Elektrik Güvenliği",
            currentStep: 31,
            totalSteps: 31,
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
                          "Bina içerisindeki trafo odasının duvarları ve kapısı yangına dayanıklı mı? Kapısı nereye açılıyor?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Duvarlar beton/tuğla, kapı dışarıya açılıyor.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resTrafoYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoYapi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Kapısı direkt apartman koridoruna açılıyor.",
                          subtitle: "🚨 KRİTİK RİSK: Kaçış yoluna duman dolar.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Trafo odasından çıkacak yoğun duman ve ısı, kaçış yollarını kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır."),
                          groupValue: _model.resTrafoYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoYapi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Duvarlar alçıpanel, kapı normal.",
                          subtitle: "🚨 RİSK: Yangına dayanmaz.",
                          value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Trafo odası yangın bölmesi olarak tasarlanmalıdır. Duvarlar ve kapı en az 120 dakika yangına dayanmazsa, patlama anında yangın binaya sıçrar."),
                          groupValue: _model.resTrafoYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoYapi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Trafo odasının yapısal özellikleri bilinmiyor. Yüksek enerji barındıran bu odanın yalıtımı zayıfsa büyük risk taşır."),
                          groupValue: _model.resTrafoYapi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoYapi: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2: TRAFO TİPİ
                  const Divider(height: 40),
                  const Text("ADIM-2: TRAFO TİPİ VE YAĞ ÇUKURU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Binanızdaki trafo 'Yağlı Tip' mi yoksa 'Kuru Tip' mi?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Kuru Tip.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR (Yağ riski yok)",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR (Yağ riski yok)"),
                          groupValue: _model.resTrafoTip,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoTip: val, resTrafoCukur: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Yağlı Tip.",
                          value: ChoiceResult(label: "B", reportText: "Yağlı Tip Trafo."),
                          groupValue: _model.resTrafoTip,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoTip: val)),
                        ),
                        if (_model.resTrafoTip?.label == "B") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Yağ Toplama Çukuru ve ızgara var mı?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Evet, var.", "✅ OLUMLU", "A", _model.resTrafoCukur, (v) => setState(() => _model = _model.copyWith(resTrafoCukur: v))),
                          _buildSubOption("Hayır, düz zemin.", "🚨 KRİTİK RİSK: Yağ yayılır.", "B", _model.resTrafoCukur, (v) => setState(() => _model = _model.copyWith(resTrafoCukur: v))),
                          _buildSubOption("Bilmiyorum.", "❓ BİLİNMİYOR", "C", _model.resTrafoCukur, (v) => setState(() => _model = _model.copyWith(resTrafoCukur: v))),
                        ],
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Trafo tipi bilinmiyor. Eğer yağlı tip ise ve önlem alınmadıysa patlama riski yüksektir."),
                          groupValue: _model.resTrafoTip,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoTip: val, resTrafoCukur: null)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3: YANGIN ALGILAMA
                  const Divider(height: 40),
                  const Text("ADIM-3: YANGIN ALGILAMA VE SÖNDÜRME", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Trafo odasında otomatik yangın algılama veya otomatik söndürme sistemi var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Evet, dedektörler ve söndürme var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resTrafoSondurme,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoSondurme: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Hayır, hiçbir sistem yok.",
                          subtitle: "🚨 RİSK: Müdahale gecikir.",
                          value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Trafo odaları kapalı alanlardır. Otomatik algılama ve söndürme sistemi hayati önem taşır."),
                          groupValue: _model.resTrafoSondurme,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoSondurme: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Yangın koruma sistemlerinin varlığı bilinmiyor."),
                          groupValue: _model.resTrafoSondurme,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoSondurme: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-4: ÇEVRESEL RİSKLER
                  const Divider(height: 40),
                  const Text("ADIM-4: ÇEVRESEL RİSKLER", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Trafo odasının içinden su borusu geçiyor mu VEYA üst katında ıslak zemin var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, çevresi ve üstü kuru.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resTrafoCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoCevre: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, içinden su boruları geçiyor.",
                          subtitle: "🚨 KRİTİK RİSK: Patlama tehlikesi.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Yüksek gerilim hattının olduğu yerden su borusu geçirilemez!"),
                          groupValue: _model.resTrafoCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoCevre: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Evet, üstünde banyo/tuvalet var.",
                          subtitle: "🚨 RİSK: Su sızıntısı tehlikesi.",
                          value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Trafo odalarının üstü ıslak hacim olamaz. Su sızıntısı trafoya damlarsa ölümcül kazalara yol açar."),
                          groupValue: _model.resTrafoCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoCevre: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Trafo odasının çevresel riskleri bilinmiyor. Su ve elektriğin bir araya gelmesi en büyük tehlikedir."),
                          groupValue: _model.resTrafoCevre,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTrafoCevre: val)),
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
    if (_isSkipped) return true;
    if (_model.resTrafoYapi == null) return false;
    if (_model.resTrafoTip == null) return false;
    if (_model.resTrafoTip?.label == "B" && _model.resTrafoCukur == null) return false;
    if (_model.resTrafoSondurme == null) return false;
    if (_model.resTrafoCevre == null) return false;
    return true;
  }
}