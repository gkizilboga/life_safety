import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import 'bolum_4_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum3Screen extends StatefulWidget {
  const Bolum3Screen({super.key});

  @override
  State<Bolum3Screen> createState() => _Bolum3ScreenState();
}

class _Bolum3ScreenState extends State<Bolum3Screen> {
  Bolum3Model _model = Bolum3Model();

  // Text Controller'lar (Yazılanları yakalamak için)
  final TextEditingController _normalKatController = TextEditingController();
  final TextEditingController _bodrumKatController = TextEditingController();
  final TextEditingController _zeminHController = TextEditingController();
  final TextEditingController _normalHController = TextEditingController();
  final TextEditingController _bodrumHController = TextEditingController();

  @override
  void dispose() {
    _normalKatController.dispose();
    _bodrumKatController.dispose();
    _zeminHController.dispose();
    _normalHController.dispose();
    _bodrumHController.dispose();
    super.dispose();
  }

  void _handleYukseklikTercihi(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(yukseklikTercihi: choice);
    });
  }

  void _onNextPressed() {
    // 1. Verileri Model'e kaydet
    // Kat Sayıları
    int? nKat = int.tryParse(_normalKatController.text);
    int? bKat = int.tryParse(_bodrumKatController.text);

    if (nKat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen normal kat sayısını giriniz.")),
      );
      return;
    }

    // Yükseklik Tercihi Seçilmediyse
    if (_model.yukseklikTercihi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen yükseklik hesaplama tercihinizi seçiniz.")),
      );
      return;
    }

    // Hassas yükseklik seçildiyse değerleri al
    double? zH, nH, bH;
    if (_model.yukseklikTercihi?.label == Bolum3Content.yukseklikBiliniyor.label) {
      zH = double.tryParse(_zeminHController.text.replaceAll(',', '.'));
      nH = double.tryParse(_normalHController.text.replaceAll(',', '.'));
      bH = double.tryParse(_bodrumHController.text.replaceAll(',', '.'));
      
      if (zH == null || nH == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen kat yüksekliklerini giriniz.")),
        );
        return;
      }
    }

    // Modeli güncelle
    _model = _model.copyWith(
      normalKatSayisi: nKat,
      bodrumKatSayisi: bKat ?? 0,
      zeminKatYuksekligi: zH,
      normalKatYuksekligi: nH,
      bodrumKatYuksekligi: bH,
    );

    // Store'a kaydet ve ilerle
    BinaStore.instance.bolum3 = _model;
    
    // DEBUG İÇİN: Konsola hesaplanan yüksekliği yazalım
    print("Hesaplanan Bina Yüksekliği: ${_model.toplamYukseklik} metre");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum4Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-3: Kat ve Yükseklik",
            subtitle: "Bina boyutlarını girelim.",
            currentStep: 3,
            totalSteps: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- KAT SAYILARI ---
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Bolum3Content.normalKatGiris.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _normalKatController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Örn: 5",
                            helperText: Bolum3Content.normalKatGiris.uiSubtitle,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(Bolum3Content.bodrumKatGiris.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _bodrumKatController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Örn: 1",
                            helperText: Bolum3Content.bodrumKatGiris.uiSubtitle,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- YÜKSEKLİK TERCİHİ ---
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kat Yükseklikleri", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        
                        SelectableCard(
                          choice: Bolum3Content.yukseklikStandart,
                          isSelected: _model.yukseklikTercihi?.label == Bolum3Content.yukseklikStandart.label,
                          onTap: () => _handleYukseklikTercihi(Bolum3Content.yukseklikStandart),
                        ),
                        
                        SelectableCard(
                          choice: Bolum3Content.yukseklikBiliniyor,
                          isSelected: _model.yukseklikTercihi?.label == Bolum3Content.yukseklikBiliniyor.label,
                          onTap: () => _handleYukseklikTercihi(Bolum3Content.yukseklikBiliniyor),
                        ),

                        // EĞER "BİLİYORUM" SEÇİLİRSE AÇILAN DETAYLAR
                        if (_model.yukseklikTercihi?.label == Bolum3Content.yukseklikBiliniyor.label) ...[
                          const Divider(height: 30),
                          _buildHeightInput("Zemin Kat Yüksekliği (m)", _zeminHController),
                          const SizedBox(height: 10),
                          _buildHeightInput("Normal Kat Yüksekliği (m)", _normalHController),
                          const SizedBox(height: 10),
                          _buildHeightInput("Bodrum Kat Yüksekliği (m)", _bodrumHController),
                        ],
                      ],
                    ),
                  ),
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
                  onPressed: _onNextPressed,
                  child: const Text("OTOMATİK HESAPLA VE DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Yükseklik girişi için yardımcı widget
  Widget _buildHeightInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: "Örn: 3.00",
        suffixText: "m",
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }
}