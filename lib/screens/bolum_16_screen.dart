import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_8_model.dart'; // Nizam Durumu Enum
import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult
import 'package:life_safety/models/bolum_16_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_17_screen.dart';
// import 'package:life_safety/logic/hesaplama_motoru.dart'; // Sonraki aşama

class Bolum16Screen extends StatefulWidget {
  const Bolum16Screen({super.key});

  @override
  State<Bolum16Screen> createState() => _Bolum16ScreenState();
}

class _Bolum16ScreenState extends State<Bolum16Screen> {
  Bolum16Model _model = Bolum16Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum16 != null) {
      _model = BinaStore.instance.bolum16!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum16 = _model;
    print("Bölüm 16 Kaydedildi.");
    // BURASI VERİ GİRİŞİNİN SONUDUR.
    // Buradan sonra Hesaplama Motoru ve Sonuç Ekranına gidilecek.
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum17Screen()));  }

  @override
  Widget build(BuildContext context) {
    // Global Değişkenleri Çek
    final bool isLimit2850 = BinaStore.instance.bolum4?.isLimitBina2850 ?? false;
    final bool isBitisik = BinaStore.instance.bolum8?.secim == NizamDurumu.bitisik;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Dış Cepheler",
            subtitle: "Bölüm 16: Cephe ve Yalıtım",
            currentStep: 16,
            totalSteps: 16,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: CEPHE TİPİ
                  const Text("ADIM-1: CEPHE TİPİ VE YÜKSEKLİK", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Binanızın dış cephesinde kullanılan kaplama veya ısı yalıtım sistemi (Mantolama) nedir?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Klasik Mantolama (EPS/XPS köpük).",
                          subtitle: isLimit2850 
                            ? "🚨 KIRMIZI RİSK: 28.50m üzeri binalarda yasaktır!" 
                            : "⚠️ UYARI: Yangın bariyerleri zorunludur.",
                          value: ChoiceResult(
                            label: "A", 
                            reportText: isLimit2850 
                              ? "🚨 KIRMIZI RİSK. 28.50 metreden yüksek binalarda EPS/XPS vb. gibi yanıcı malzemeler kullanılamaz! Cephe malzemesi ‘Hiç Yanmaz’ (A1 sınıf) veya 'Zor Yanıcı' (A2 sınıf) olmak zorundadır." 
                              : "⚠️ UYARI (BARİYER KONTROLÜ). 28.50m altındaki binalarda EPS/XPS kullanılabilir ANCAK pencerelerin etrafında ve zemin seviyesinde taşyünü bariyer ZORUNLUDUR."
                          ),
                          groupValue: _model.resCepheTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCepheTipi: val, resGiydirmeBosluk: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Taşyünü mantolama.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR (Yanmaz malzeme).",
                          value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resCepheTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCepheTipi: val, resGiydirmeBosluk: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Giydirme cephe (Cam/Kompozit).",
                          value: ChoiceResult(label: "C", reportText: "Giydirme cephe mevcut."),
                          groupValue: _model.resCepheTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCepheTipi: val)),
                        ),
                        if (_model.resCepheTipi?.label == "C") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Cephe ile döşeme arasında boşluk var mı?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Hayır, tam kapatılmış.", "✅ OLUMLU", "A", _model.resGiydirmeBosluk, (v) => setState(() => _model = _model.copyWith(resGiydirmeBosluk: v))),
                          _buildSubOption("Evet, boşluk var.", "🚨 KIRMIZI RİSK: Dumanı üst kata taşır.", "B", _model.resGiydirmeBosluk, (v) => setState(() => _model = _model.copyWith(resGiydirmeBosluk: v))),
                          _buildSubOption("Bilmiyorum.", "❓ BİLİNMİYOR: Uzman Görüşü tavsiye edilir.", "C", _model.resGiydirmeBosluk, (v) => setState(() => _model = _model.copyWith(resGiydirmeBosluk: v))),
                        ],
                        SelectableCard<ChoiceResult>(
                          title: "D) Sadece sıva/boya (Yalıtım yok).",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "D", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resCepheTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCepheTipi: val, resGiydirmeBosluk: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "E) Bilmiyorum.",
                          subtitle: "❓ BİLİNMİYOR: Uzman Görüşü tavsiye edilir.",
                          value: ChoiceResult(label: "E", reportText: "❓ BİLİNMİYOR. Dış cephe malzemesi bilinmiyor. Yüksek binalarda yanıcı malzeme kullanımı ölümcül risk taşır."),
                          groupValue: _model.resCepheTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCepheTipi: val, resGiydirmeBosluk: null)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2: SAĞIR YÜZEY
                  const Divider(height: 40),
                  const Text("ADIM-2: KATLAR ARASI GEÇİŞ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Alt katın penceresi ile üst katın penceresi arasındaki dolu duvar mesafesi ne kadar?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) En az 100 cm dolu yüzey var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resSagirYuzey,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resSagirYuzey: val, resCepheSprinkler: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) 100 cm'den az.",
                          value: ChoiceResult(label: "B", reportText: "Mesafe yetersiz."),
                          groupValue: _model.resSagirYuzey,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resSagirYuzey: val)),
                        ),
                        if (_model.resSagirYuzey?.label == "B") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Cephe içinde sprinkler var mı?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Evet.", "✅ OLUMLU (Şartlı)", "A", _model.resCepheSprinkler, (v) => setState(() => _model = _model.copyWith(resCepheSprinkler: v))),
                          _buildSubOption("Hayır.", "🚨 KIRMIZI RİSK: Alev üst kata sıçrar.", "B", _model.resCepheSprinkler, (v) => setState(() => _model = _model.copyWith(resCepheSprinkler: v))),
                        ],
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          subtitle: "❓ BİLİNMİYOR: Uzman Görüşü tavsiye edilir.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Katlar arasındaki yangına dayanıklı yüzey 100 cm'den az ise risklidir."),
                          groupValue: _model.resSagirYuzey,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resSagirYuzey: val, resCepheSprinkler: null)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3: BİTİŞİK NİZAM (Sadece Bitişikse Görünür)
                  if (isBitisik) ...[
                    const Divider(height: 40),
                    const Text("ADIM-3: BİTİŞİK NİZAMDA ÇATI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Binanız bitişik nizamda ve yan binadan daha yüksek mi?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Hayır, aynı veya alçağız.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR. Ekstra cephe koruması gerekmez."),
                            groupValue: _model.resBitisikCati,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resBitisikCati: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Evet, bizim bina daha yüksek.",
                            subtitle: "⚠️ UYARI: Yan bina çatısı risk oluşturur.",
                            value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Yan binanın çatısının bittiği hizaya denk gelen dış cephe kaplamanız 'Hiç Yanmaz' (A1 sınıfı) malzeme olmalıdır."),
                            groupValue: _model.resBitisikCati,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resBitisikCati: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            subtitle: "❓ BİLİNMİYOR",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Bitişik bina ile yükseklik durumu bilinmiyor."),
                            groupValue: _model.resBitisikCati,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resBitisikCati: val)),
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
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_model.resCepheTipi == null) return false;
    if (_model.resCepheTipi?.label == "C" && _model.resGiydirmeBosluk == null) return false;
    
    if (_model.resSagirYuzey == null) return false;
    if (_model.resSagirYuzey?.label == "B" && _model.resCepheSprinkler == null) return false;

    final bool isBitisik = BinaStore.instance.bolum8?.secim == NizamDurumu.bitisik;
    if (isBitisik && _model.resBitisikCati == null) return false;

    return true;
  }
}