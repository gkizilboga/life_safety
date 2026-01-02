import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import 'bolum_4_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart'; // Görsel yolu için gerekli

class Bolum3Screen extends StatefulWidget {
  const Bolum3Screen({super.key});

  @override
  State<Bolum3Screen> createState() => _Bolum3ScreenState();
}

class _Bolum3ScreenState extends State<Bolum3Screen> {
  Bolum3Model _model = Bolum3Model();

  // Controller'lar
  final _normalKatCtrl = TextEditingController();
  final _bodrumKatCtrl = TextEditingController();
  final _zeminHCtrl = TextEditingController();
  final _normalHCtrl = TextEditingController();
  final _bodrumHCtrl = TextEditingController();

  bool _showSummary = false; 
  bool _isConfirmed = false; 

  @override
  void dispose() {
    _normalKatCtrl.dispose();
    _bodrumKatCtrl.dispose();
    _zeminHCtrl.dispose();
    _normalHCtrl.dispose();
    _bodrumHCtrl.dispose();
    super.dispose();
  }

  void _handleYukseklikTercihi(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(yukseklikTercihi: choice);
      _showSummary = false; 
      _isConfirmed = false;
    });
  }

  void _hesaplaVeGoster() {
    int? nKat = int.tryParse(_normalKatCtrl.text);
    int? bKat = int.tryParse(_bodrumKatCtrl.text);

    if (nKat == null) return _showError("Lütfen normal kat sayısını giriniz.");
    if (nKat > 20) return _showError("Normal kat sayısı 20'den fazla olamaz.");
    if (bKat != null && bKat > 10) return _showError("Bodrum kat sayısı 10'dan fazla olamaz.");
    if (_model.yukseklikTercihi == null) return _showError("Lütfen yükseklik tercihini seçiniz.");

    double zH = 3.50;
    double nH = 3.00;
    double bH = 3.50;

    if (_model.yukseklikTercihi?.label == Bolum3Content.yukseklikBiliniyor.label) {
      zH = double.tryParse(_zeminHCtrl.text.replaceAll(',', '.')) ?? 0;
      nH = double.tryParse(_normalHCtrl.text.replaceAll(',', '.')) ?? 0;
      bH = double.tryParse(_bodrumHCtrl.text.replaceAll(',', '.')) ?? 0;

      if (zH < 2.0 || zH > 7.0) return _showError("Zemin kat yüksekliği 2.00m - 7.00m arasında olmalıdır.");
      if (nKat > 0 && (nH < 2.0 || nH > 4.5)) return _showError("Normal kat yüksekliği 2.00m - 4.50m arasında olmalıdır.");
      if ((bKat ?? 0) > 0 && (bH < 2.0 || bH > 7.0)) return _showError("Bodrum kat yüksekliği 2.00m - 7.00m arasında olmalıdır.");
    }

    double hBina = zH + (nKat * nH);
    double hBodrum = (bKat ?? 0) * bH;
    double hYapi = hBina + hBodrum;
    bool isYuksek = hBina > 21.50;

    setState(() {
      _model = _model.copyWith(
        normalKatSayisi: nKat,
        bodrumKatSayisi: bKat ?? 0,
        zeminKatYuksekligi: zH,
        normalKatYuksekligi: nH,
        bodrumKatYuksekligi: bH,
        hBina: hBina,
        hYapi: hYapi,
        isYuksekBina: isYuksek,
      );
      _showSummary = true;
      _isConfirmed = false;
    });

    FocusScope.of(context).unfocus();
  }

  void _onNextPressed() {
    if (!_isConfirmed) return;
    BinaStore.instance.bolum3 = _model;
    BinaStore.instance.saveToDisk(); // EKLE
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum4Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(
            title: "Kat ve Yükseklik Bilgileri",
            subtitle: "Binanın kat adetleri ve yükseklik analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TEKNİK GÖRSEL BUTONU ---
                  TechnicalDrawingButton(
                    assetPath: AppAssets.section3Katlar,
                    title: "Kat Grupları ve Yükseklik Tanımları",
                  ),
                  const SizedBox(height: 12),

                  // --- KAT SAYILARI ---
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Bolum3Content.normalKatGiris.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _normalKatCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() => _showSummary = false),
                          decoration: InputDecoration(
                            hintText: "Örn: 5",
                            helperText: Bolum3Content.normalKatGiris.uiSubtitle,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(Bolum3Content.bodrumKatGiris.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _bodrumKatCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() => _showSummary = false),
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
                        const Text("Kat Yükseklik Detayları", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
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
                        if (_model.yukseklikTercihi?.label == Bolum3Content.yukseklikBiliniyor.label) ...[
                          const Divider(height: 30),
                          _buildHeightInput("Zemin Kat Yüksekliği (m)", _zeminHCtrl),
                          const SizedBox(height: 12),
                          _buildHeightInput("Normal Kat Yüksekliği (m)", _normalHCtrl),
                          const SizedBox(height: 12),
                          _buildHeightInput("Bodrum Kat Yüksekliği (m)", _bodrumHCtrl),
                        ],
                      ],
                    ),
                  ),

                  if (!_showSummary)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _hesaplaVeGoster,
                          icon: const Icon(Icons.calculate_outlined),
                          label: const Text("HESAPLA VE ÖZETİ GÖSTER"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),

                  if (_showSummary) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBBDEFB), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(child: Text("YÜKSEKLİK HESAP ÖZETİ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1565C0)))),
                          const Divider(height: 25),
                          _buildSummaryRow("Zemin Üstü:", "${_model.normalKatSayisi} Kat"),
                          _buildSummaryRow("Zemin Altı:", "${_model.bodrumKatSayisi} Kat"),
                          const SizedBox(height: 12),
                          _buildSummaryRow("Bina Yüksekliği (H):", "${_model.hBina?.toStringAsFixed(2)} m"),
                          _buildSummaryRow("Yapı Yüksekliği (H_yapı):", "${_model.hYapi?.toStringAsFixed(2)} m"),
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (_model.isYuksekBina ?? false) ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              (_model.isYuksekBina ?? false) ? "SINIF: YÜKSEK BİNA" : "SINIF: YÜKSEK OLMAYAN BİNA",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                            value: _isConfirmed,
                            onChanged: (val) => setState(() => _isConfirmed = val ?? false),
                            title: const Text("Hesaplanan yükseklik değerlerini onaylıyorum.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: const Color(0xFF1A237E),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          if (_showSummary)
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isConfirmed ? _onNextPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("ONAYLA VE DEVAM ET", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeightInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => setState(() => _showSummary = false),
      decoration: InputDecoration(
        labelText: label,
        hintText: "Örn: 3.00",
        suffixText: "m",
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF455A64))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF263238))),
        ],
      ),
    );
  }
}