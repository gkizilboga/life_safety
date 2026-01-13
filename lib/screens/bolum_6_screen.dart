import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_6_model.dart';
import 'bolum_7_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';

class Bolum6Screen extends StatefulWidget {
  const Bolum6Screen({super.key});

  @override
  State<Bolum6Screen> createState() => _Bolum6ScreenState();
}

class _Bolum6ScreenState extends State<Bolum6Screen> {
  Bolum6Model _model = Bolum6Model();

  void _toggleUsage(String type) {
    setState(() {
      bool newOtopark = _model.hasOtopark;
      bool newTicari = _model.hasTicari;
      bool newDepo = _model.hasDepo;
      bool newKonut = _model.isSadeceKonut;

      if (type == 'konut') {
        newKonut = !newKonut;
        if (newKonut) {
          newOtopark = false;
          newTicari = false;
          newDepo = false;
        }
      } else {
        if (type == 'otopark') newOtopark = !newOtopark;
        if (type == 'ticari') newTicari = !newTicari;
        if (type == 'depo') newDepo = !newDepo;

        // Eğer herhangi bir riskli alan seçildiyse, "Sadece Konut" otomatik kapanır
        if (newOtopark || newTicari || newDepo) {
          newKonut = false;
        }
      }

      _model = _model.copyWith(
        hasOtopark: newOtopark,
        hasTicari: newTicari,
        hasDepo: newDepo,
        isSadeceKonut: newKonut,
        // Otopark seçimi kaldırıldıysa tipini de sıfırla
        otoparkTipi: newOtopark ? _model.otoparkTipi : null,
      );
    });
  }

  void _handleOtoparkTipi(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(otoparkTipi: choice);
    });
  }

  // Formun geçerliliğini kontrol eden fonksiyon
  bool _isFormValid() {
    // 1. Kural: Eğer otopark var dendiyse, tipi de seçilmiş olmalı
    if (_model.hasOtopark && _model.otoparkTipi == null) return false;

    // 2. Kural: En az bir ana seçenek işaretlenmiş olmalı
    if (!_model.hasOtopark &&
        !_model.hasTicari &&
        !_model.hasDepo &&
        !_model.isSadeceKonut) {
      return false;
    }

    return true;
  }

  void _onNextPressed() {
    // KRİTİK: Veriyi Store'a yaz ve diske kaydet
    BinaStore.instance.bolum6 = _model;
    BinaStore.instance.saveToDisk();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum7Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = _isFormValid();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Ofis Standartı Arka Plan
      body: Column(
        children: [
          ModernHeader(
            title: "Kullanım Amaçları",
            subtitle: "Konut harici fonksiyonlar",
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
                      "Binanızda konut haricinde aşağıdakilerden hangileri mevcut?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ),

                  // 1. OTOPARK
                  SelectableCard(
                    choice: Bolum6Content.otoparkVar,
                    isSelected: _model.hasOtopark,
                    onTap: () => _toggleUsage('otopark'),
                  ),

                  // 2. TİCARİ ALAN VE GÖRSEL BUTONU
                  SelectableCard(
                    choice: Bolum6Content.ticariVar,
                    isSelected: _model.hasTicari,
                    onTap: () => _toggleUsage('ticari'),
                  ),
                  TechnicalDrawingButton(
                    assetPath: AppAssets.section6Ticari,
                    title: "Ticari Alan ve Dükkan Tanımları",
                  ),
                  const SizedBox(height: 8),

                  // 3. DEPO
                  SelectableCard(
                    choice: Bolum6Content.depoVar,
                    isSelected: _model.hasDepo,
                    onTap: () => _toggleUsage('depo'),
                  ),

                  // 4. SADECE KONUT
                  SelectableCard(
                    choice: Bolum6Content.sadeceKonut,
                    isSelected: _model.isSadeceKonut,
                    onTap: () => _toggleUsage('konut'),
                  ),

                  // OTOPARK DETAYI (Sadece Otopark Varsa)
                  if (_model.hasOtopark) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(thickness: 1, color: Color(0xFFECEFF1)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        "Otoparkınızın tipi nedir?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    SelectableCard(
                      choice: Bolum6Content.otoparkKapali,
                      isSelected:
                          _model.otoparkTipi?.label ==
                          Bolum6Content.otoparkKapali.label,
                      onTap: () =>
                          _handleOtoparkTipi(Bolum6Content.otoparkKapali),
                    ),
                    SelectableCard(
                      choice: Bolum6Content.otoparkAcik,
                      isSelected:
                          _model.otoparkTipi?.label ==
                          Bolum6Content.otoparkAcik.label,
                      onTap: () =>
                          _handleOtoparkTipi(Bolum6Content.otoparkAcik),
                    ),
                    SelectableCard(
                      choice: Bolum6Content.otoparkYariAcik,
                      isSelected:
                          _model.otoparkTipi?.label ==
                          Bolum6Content.otoparkYariAcik.label,
                      onTap: () =>
                          _handleOtoparkTipi(Bolum6Content.otoparkYariAcik),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ALT BUTON ALANI (REVİZE EDİLDİ)
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
                onPressed: isButtonEnabled
                    ? _onNextPressed
                    : null, // Geçerli değilse null (pasif)
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  disabledBackgroundColor: Colors.grey.shade300, // Pasif renk
                  foregroundColor: Colors.white,
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
