import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_2_model.dart';
import 'package:life_safety/screens/bolum_3_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart'; // ModernHeader ve SelectableCard

class Bolum2Screen extends StatefulWidget {
  const Bolum2Screen({super.key});

  @override
  State<Bolum2Screen> createState() => _Bolum2ScreenState();
}

class _Bolum2ScreenState extends State<Bolum2Screen> {
  Bolum2Model _model = Bolum2Model();

  @override
  void initState() {
    super.initState();
    // Hafızadaki veriyi geri yükle
    if (BinaStore.instance.bolum2 != null) {
      _model = BinaStore.instance.bolum2!;
    }
  }

  void _onNextPressed() {
    if (_model.secim == null) return;

    if (_model.secim == TasiyiciSistemSecim.bilmiyorum) {
      _showBilmiyorumDialog();
    } else {
      _navigateToNext();
    }
  }

  void _navigateToNext() {
    // VERİYİ DEPOYA KAYDET
    BinaStore.instance.bolum2 = _model;
    print("Bölüm 2 Kaydedildi: ${_model.tasiyiciSistemDeger}");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum3Screen()),
    );
  }

  Future<void> _showBilmiyorumDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(child: Text("⚠️ BİLGİLENDİRME", style: TextStyle(fontSize: 18))),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Otomatik Atama: Arka planda tasiyici_sistem = 'BETONARME' olarak kaydet.\n\nUyarı: Taşıyıcı sistemin bilinmemesi durumunda, analiz 'Betonarme' varsayımı ile devam edecektir. Bu durum sonuçların hassasiyetini etkileyebilir.\n\nKesin bilgi için apartman yöneticinize sorarak veya statik ya da mimari projenize bakarak bu seçimi güncellemeniz önemle tavsiye edilir.",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToNext();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
              ),
              child: const Text("Anladım, Devam Et"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. MODERN BAŞLIK
          ModernHeader(
            title: "Taşıyıcı Sistem",
            subtitle: "Bölüm 2: Yapısal Sistem Türü",
            currentStep: 2,
            totalSteps: 21,
            onBack: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TAŞIYICI SİSTEM SEÇİMİ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Binanızın ana taşıyıcı sistemi nedir?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // SEÇENEKLER (Senin Metinlerinle)
                  SelectableCard<TasiyiciSistemSecim>(
                    title: "A) Betonarme",
                    subtitle: "Türkiye'deki binaların neredeyse tamamıdır. Binada kolon, kiriş ve/veya perde beton bulunur. Diğer duvarlar sadece odaları bölmek için kullanılır.",
                    // imagePath: "assets/images/betonarme.jpg", // Resim ekleyince burayı açarsın
                    value: TasiyiciSistemSecim.betonarme,
                    groupValue: _model.secim,
                    onChanged: (val) => setState(() => _model = _model.copyWith(secim: val)),
                  ),
                  
                  SelectableCard<TasiyiciSistemSecim>(
                    title: "B) Çelik",
                    subtitle: "Türkiye'de çelik konstrüksiyon konutta nadiren görülür. Binanın iskeleti kalın demir/çelik profillerden oluşur. Genelde fabrika veya depo binalarında kullanılır.",
                    value: TasiyiciSistemSecim.celik,
                    groupValue: _model.secim,
                    onChanged: (val) => setState(() => _model = _model.copyWith(secim: val)),
                  ),

                  SelectableCard<TasiyiciSistemSecim>(
                    title: "C) Ahşap",
                    subtitle: "Binanın ana taşıyıcıları kalın ahşap kolon ve kirişlerden oluşur.",
                    value: TasiyiciSistemSecim.ahsap,
                    groupValue: _model.secim,
                    onChanged: (val) => setState(() => _model = _model.copyWith(secim: val)),
                  ),

                  SelectableCard<TasiyiciSistemSecim>(
                    title: "D) Yığma / Kagir (Taş Duvarlı)",
                    subtitle: "Binada kolon, kiriş veya perde beton olmaz. Tüm yükü taşıyan, çok kalın dış taş duvarlar olur. Duvara vurduğunuzda tok bir ses gelir.",
                    value: TasiyiciSistemSecim.yigma,
                    groupValue: _model.secim,
                    onChanged: (val) => setState(() => _model = _model.copyWith(secim: val)),
                  ),

                  SelectableCard<TasiyiciSistemSecim>(
                    title: "E) Bilmiyorum / Emin Değilim",
                    subtitle: null, // Açıklama yoksa null bırakıyoruz
                    value: TasiyiciSistemSecim.bilmiyorum,
                    groupValue: _model.secim,
                    onChanged: (val) => setState(() => _model = _model.copyWith(secim: val)),
                  ),
                ],
              ),
            ),
          ),

          // SABİT BUTON ALANI
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
                  onPressed: _model.secim == null ? null : _onNextPressed,
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}