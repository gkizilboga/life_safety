import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/bolum_2_model.dart';
import 'bolum_3_screen.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/selectable_card.dart';
import '../utils/app_content.dart';
import '../models/choice_result.dart';
import '../utils/app_assets.dart'; // Görsel yolu için

class Bolum2Screen extends StatefulWidget {
  const Bolum2Screen({super.key});

  @override
  State<Bolum2Screen> createState() => _Bolum2ScreenState();
}

class _Bolum2ScreenState extends State<Bolum2Screen> {
  Bolum2Model _model = Bolum2Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;
    BinaStore.instance.bolum2 = _model;
    BinaStore.instance.saveToDisk(); // EKLE
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum3Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Ofis Standartı Arka Plan
      body: Column(
        children: [
          ModernHeader(
            title: "Bina Kullanım Sınıfı ve Taşıyıcı Sistemi",
            subtitle: "",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      "Binanızın taşıyıcı sistemi (yapı türü) nedir?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ),

                  // --- BETONARME ŞIKKI ---
                  SelectableCard(
                    choice: Bolum2Content.betonarme,
                    isSelected:
                        _model.secim?.label == Bolum2Content.betonarme.label,
                    onTap: () => _handleSelection(Bolum2Content.betonarme),
                  ),

                  // --- ÇELİK ŞIKKI VE BUTONU ---
                  SelectableCard(
                    choice: Bolum2Content.celik,
                    isSelected:
                        _model.secim?.label == Bolum2Content.celik.label,
                    onTap: () => _handleSelection(Bolum2Content.celik),
                  ),
                  // Çelik seçildiğinde veya her zaman görünecek standart buton
                  TechnicalDrawingButton(
                    assetPath: AppAssets.section2Celik,
                    title: "Çelik Taşıyıcı Sistem Detayı",
                  ),
                  const SizedBox(height: 8),

                  // --- DİĞER ŞIKLAR ---
                  SelectableCard(
                    choice: Bolum2Content.ahsap,
                    isSelected:
                        _model.secim?.label == Bolum2Content.ahsap.label,
                    onTap: () => _handleSelection(Bolum2Content.ahsap),
                  ),
                  SelectableCard(
                    choice: Bolum2Content.yigma,
                    isSelected:
                        _model.secim?.label == Bolum2Content.yigma.label,
                    onTap: () => _handleSelection(Bolum2Content.yigma),
                  ),
                  SelectableCard(
                    choice: Bolum2Content.bilinmiyor,
                    isSelected:
                        _model.secim?.label == Bolum2Content.bilinmiyor.label,
                    onTap: () => _handleSelection(Bolum2Content.bilinmiyor),
                  ),
                ],
              ),
            ),
          ),
          // ALT BUTON ALANI
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: _model.secim == null ? null : _onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "DEVAM ET",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
