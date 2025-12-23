import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart'; // EKLENDİ
import 'package:life_safety/models/bolum_9_model.dart';
import 'package:life_safety/screens/bolum_10_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart'; // ModernHeader ve SelectableCard

class Bolum9Screen extends StatefulWidget {
  const Bolum9Screen({super.key});

  @override
  State<Bolum9Screen> createState() => _Bolum9ScreenState();
}

class _Bolum9ScreenState extends State<Bolum9Screen> {
  Bolum9Model _model = Bolum9Model();

  @override
  void initState() {
    super.initState();
    // Hafızadaki veriyi geri yükle
    if (BinaStore.instance.bolum9 != null) {
      _model = BinaStore.instance.bolum9!;
    }
  }

  void _handleSelection(SprinklerDurumuSecim? value) {
    setState(() {
      _model = _model.copyWith(secim: value);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ SEÇİM YAPMANIZ GEREKMEKTEDİR"),
          content: const Text(
              "Yağmurlama (Sprinkler) sisteminin varlığı, binanızdaki izin verilen kaçış mesafelerini doğrudan etkileyen bir faktördür. Lütfen binanızda otomatik yangın söndürmenin olup olmadığını işaretleyiniz. Emin değilseniz ve tavanda su püskürtme başlıkları görmüyorsanız 'Hayır, hiçbir yerde yok' seçeneğini işaretleyiniz."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tamam"),
            ),
          ],
        ),
      );
      return;
    }

    _navigateToNext();
  }

  void _navigateToNext() {
    // VERİYİ DEPOYA KAYDET
    BinaStore.instance.bolum9 = _model;
    print("Bölüm 9 Kaydedildi. Sprinkler Var mı?: ${_model.hasSprinkler}");
    
    // Bölüm 10 artık veriyi Store'dan çekecek, parametreye gerek yok.
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const Bolum10Screen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. MODERN BAŞLIK
          ModernHeader(
            title: "Sprinkler Sistemi",
            subtitle: "Bölüm 9: Yangın Söndürme",
            currentStep: 9,
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
                    "SPRINKLER SİSTEMİ VARLIĞI",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "SPRINKLER VARLIĞI",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  
                  // Soru ve Tooltip Satırı
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          "Binanızın koridorlarında, daire içlerinde, (varsa) dükkan ve (varsa) otopark alanında otomatik yağmurlama (sprinkler) sistemi var mı?",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      Tooltip(
                        message: "Tavanda bulunan, yangın anında otomatik devreye girip su püskürten metal başlıklardır.",
                        triggerMode: TooltipTriggerMode.tap,
                        child: Icon(Icons.info_outline, color: Colors.blue.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // SEÇENEKLER (Senin Metinlerinle)
                  SelectableCard<SprinklerDurumuSecim>(
                    title: "A) Evet, tüm binada sprinkler sistemi var.",
                    subtitle: "(Daireler, koridorlar, (varsa)dükkanlar ve otopark dahil)",
                    value: SprinklerDurumuSecim.tamamenVar,
                    groupValue: _model.secim,
                    onChanged: _handleSelection,
                  ),
                  
                  SelectableCard<SprinklerDurumuSecim>(
                    title: "B) Hayır, binada hiçbir yerde sprinkler yok.",
                    subtitle: null,
                    value: SprinklerDurumuSecim.hicYok,
                    groupValue: _model.secim,
                    onChanged: _handleSelection,
                  ),

                  SelectableCard<SprinklerDurumuSecim>(
                    title: "C) Kısmen var.",
                    subtitle: "(Sadece bazı katlarda veya bazı mahallerde sprinkler var)",
                    value: SprinklerDurumuSecim.kismenVar,
                    groupValue: _model.secim,
                    onChanged: _handleSelection,
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
                  onPressed: _onNextPressed,
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