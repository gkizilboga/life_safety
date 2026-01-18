import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_6_model.dart';
import 'bolum_7_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';

class Bolum6Screen extends StatefulWidget {
  const Bolum6Screen({super.key});

  @override
  State<Bolum6Screen> createState() => _Bolum6ScreenState();
}

class _Bolum6ScreenState extends State<Bolum6Screen> {
  Bolum6Model _model = Bolum6Model();
  final TextEditingController _kapaliOtoparkController = TextEditingController();

  @override
  void dispose() {
    _kapaliOtoparkController.dispose();
    super.dispose();
  }

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
        // Otopark seçimi kaldırıldıysa tipini ve alanı da sıfırla
        otoparkTipi: newOtopark ? _model.otoparkTipi : null,
        clearKapaliOtoparkAlani: !newOtopark,
      );
      if (!newOtopark) _kapaliOtoparkController.clear();
    });
  }

  void _handleOtoparkTipi(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(otoparkTipi: choice, clearKapaliOtoparkAlani: true);
      _kapaliOtoparkController.clear();
    });
  }

  void _updateKapaliOtoparkAlani(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    setState(() {
      _model = _model.copyWith(kapaliOtoparkAlani: parsed);
    });
  }

  // Formun geçerliliğini kontrol eden fonksiyon
  bool _isFormValid() {
    // 1. Kural: Eğer otopark var dendiyse, tipi de seçilmiş olmalı
    if (_model.hasOtopark && _model.otoparkTipi == null) return false;

    // 2. Kural: Kapalı otopark alanı gerekiyorsa, geçerli bir değer girilmiş olmalı
    if (_model.needsKapaliOtoparkAlani) {
      if (_model.kapaliOtoparkAlani == null ||
          _model.kapaliOtoparkAlani! < 5 ||
          _model.kapaliOtoparkAlani! > 20000) {
        return false;
      }
    }

    // 3. Kural: En az bir ana seçenek işaretlenmiş olmalı
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
      backgroundColor: const Color(0xFFF8F9FA),
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
                        style: AppStyles.questionTitle,
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
                        style: AppStyles.questionTitle,
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

                    // KAPALI OTOPARK ALANI SORUSU (Sadece A veya C şıkkı seçiliyse)
                    if (_model.needsKapaliOtoparkAlani) ...[
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          "Toplam kapalı otopark alanı kaç m²?",
                          style: AppStyles.questionTitle,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _kapaliOtoparkController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d{0,2}')),
                                ],
                                onChanged: _updateKapaliOtoparkAlani,
                                decoration: const InputDecoration(
                                  hintText: "Min: 5, Max: 20000",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(11),
                                  bottomRight: Radius.circular(11),
                                ),
                              ),
                              child: const Text(
                                "m²",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_model.kapaliOtoparkAlani != null && 
                          (_model.kapaliOtoparkAlani! < 5 || _model.kapaliOtoparkAlani! > 20000))
                        const Padding(
                          padding: EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            "Değer 5 ile 20000 arasında olmalıdır.",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ],
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
                onPressed: isButtonEnabled
                    ? _onNextPressed
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  disabledBackgroundColor: Colors.grey.shade300,
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
