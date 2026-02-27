import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../utils/app_theme.dart';
import 'bolum_4_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../utils/input_validator.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/bolum_4_model.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';
import 'bolum_5_screen.dart';

class Bolum3Screen extends StatefulWidget {
  const Bolum3Screen({super.key});
  @override
  State<Bolum3Screen> createState() => _Bolum3ScreenState();
}

class _Bolum3ScreenState extends State<Bolum3Screen> {
  final _normalCountCtrl = TextEditingController();
  final _bodrumCountCtrl = TextEditingController();
  final _zeminHCtrl = TextEditingController();
  final _normalHCtrl = TextEditingController();
  final _bodrumHCtrl = TextEditingController();

  bool _isUnknown = true;
  bool _isConfirmed = false;
  String? _zeminErr;
  String? _normalErr;
  String? _bodrumErr;
  String? _normalCountErr;
  String? _bodrumCountErr;

  @override
  void initState() {
    super.initState();

    // Load existing data if available
    final existing = BinaStore.instance.bolum3;
    if (existing != null) {
      _normalCountCtrl.text = existing.normalKatSayisi.toString();
      _bodrumCountCtrl.text = existing.bodrumKatSayisi.toString();
      _zeminHCtrl.text = existing.zeminYuksekligi.toString();
      _normalHCtrl.text = existing.normalYuksekligi.toString();
      _bodrumHCtrl.text = existing.bodrumYuksekligi.toString();
      _isUnknown = existing.yukseklikBilinmiyor;
      _isConfirmed = existing.isConfirmed;
    }

    _normalCountCtrl.addListener(_validateCounts);
    _bodrumCountCtrl.addListener(_validateCounts);
    _zeminHCtrl.addListener(_validate);
    _normalHCtrl.addListener(_validate);
    _bodrumHCtrl.addListener(_validate);
  }

  @override
  void dispose() {
    _normalCountCtrl.dispose();
    _bodrumCountCtrl.dispose();
    _zeminHCtrl.dispose();
    _normalHCtrl.dispose();
    _bodrumHCtrl.dispose();
    super.dispose();
  }

  void _validateCounts() {
    setState(() {
      // Normal kat: 0-20
      int? normalCount = int.tryParse(_normalCountCtrl.text);
      if (_normalCountCtrl.text.isNotEmpty) {
        if (normalCount == null || normalCount < 0 || normalCount > 20) {
          _normalCountErr = "0 ile 20 arasında bir değer giriniz.";
        } else {
          _normalCountErr = null;
        }
      } else {
        _normalCountErr = null;
      }

      // Bodrum kat: 0-10
      int? bodrumCount = int.tryParse(_bodrumCountCtrl.text);
      if (_bodrumCountCtrl.text.isNotEmpty) {
        if (bodrumCount == null || bodrumCount < 0 || bodrumCount > 10) {
          _bodrumCountErr = "0 ile 10 arasında bir değer giriniz.";
        } else {
          _bodrumCountErr = null;
        }
      } else {
        // Empty is allowed, treated as 0
        _bodrumCountErr = null;
      }
    });
  }

  void _validate() {
    setState(() {
      _zeminErr = _checkLimit(_zeminHCtrl.text, 2.0, 7.0);
      _normalErr = _checkLimit(_normalHCtrl.text, 2.0, 4.5);
      _bodrumErr = _checkLimit(_bodrumHCtrl.text, 2.0, 7.0);
    });
  }

  String? _checkLimit(String text, double min, double max) {
    return InputValidator.validateNumber(
      text,
      min: min,
      max: max,
      unit: "m",
      isRequired: false,
    );
  }

  Map<String, dynamic> _calculateValues() {
    int n = int.tryParse(_normalCountCtrl.text) ?? 0;
    int b = int.tryParse(_bodrumCountCtrl.text) ?? 0;

    double zH = _isUnknown
        ? 3.50
        : (InputValidator.parseFlex(_zeminHCtrl.text) ?? 0.0);
    double nH = _isUnknown
        ? 3.00
        : (InputValidator.parseFlex(_normalHCtrl.text) ?? 0.0);
    double bH = _isUnknown
        ? 3.50
        : (InputValidator.parseFlex(_bodrumHCtrl.text) ?? 0.0);

    double hBina = zH + (n * nH);
    double hYapi = hBina + (b * bH);
    bool isYuksek = (hBina >= 21.50) || (hYapi >= 30.50);

    return {
      'n': n,
      'b': b,
      'zH': zH,
      'nH': nH,
      'bH': bH,
      'hBina': hBina,
      'hYapi': hYapi,
      'isYuksek': isYuksek,
    };
  }

  bool _isReady() {
    if (!_isConfirmed) return false;
    if (_normalCountCtrl.text.isEmpty) return false;
    // Kat sayısı limit kontrolü
    if (_normalCountErr != null || _bodrumCountErr != null) return false;
    if (!_isUnknown) {
      if (_zeminHCtrl.text.isEmpty || _normalHCtrl.text.isEmpty) return false;
      int bCount = int.tryParse(_bodrumCountCtrl.text) ?? 0;
      if (bCount > 0 && _bodrumHCtrl.text.isEmpty) return false;
      if (_zeminErr != null || _normalErr != null || _bodrumErr != null)
        return false;
    }
    return true;
  }

  void _onNextPressed() {
    final vals = _calculateValues();

    BinaStore.instance.bolum3 = Bolum3Model(
      normalKatSayisi: vals['n'],
      bodrumKatSayisi: vals['b'],
      zeminYuksekligi: vals['zH'],
      normalYuksekligi: vals['nH'],
      bodrumYuksekligi: vals['bH'],
      hBina: vals['hBina'],
      hYapi: vals['hYapi'],
      isYuksekBina: vals['isYuksek'],
      yukseklikBilinmiyor: _isUnknown,
      isConfirmed: true,
    );

    // --- INTEGRATED SECTION 4 LOGIC ---
    double hBina = vals['hBina'] ?? 0.0;
    double hYapi = vals['hYapi'] ?? 0.0;

    var secilenSinif = Bolum4Content.yukseklikSinifiDusuk;
    if (hYapi >= 51.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiMaksimum;
    } else if (hYapi >= 30.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiCokYuksek;
    } else if (hBina >= 21.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiYuksek;
    }

    BinaStore.instance.bolum4 = Bolum4Model(
      binaYukseklikSinifi: secilenSinif,
      hesaplananBinaYuksekligi: hBina,
      hesaplananYapiYuksekligi: hYapi,
    );
    // ---------------------------------

    BinaStore.instance.saveToDisk(immediate: true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum5Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vals = _calculateValues();
    final bool isLocked = BinaStore.instance.bolum11 != null;

    return AnalysisPageLayout(
      title: "Kat Yükseklik Bilgileri",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady() || isLocked,
      onNext: () {
        if (!isLocked)
          _onNextPressed();
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Bolum5Screen()),
          );
        }
      },
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: isLocked,
            child: Opacity(
              opacity: isLocked ? 0.6 : 1.0,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.translucent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Kat adetleri nedir?"),
                    _buildInput(
                      "Normal Kat Sayısı (Zemin Üstü)",
                      _normalCountCtrl,
                      hint: "0 - 20 arası",
                      error: _normalCountErr,
                    ),
                    _buildInput(
                      "Bodrum Kat Sayısı (Zemin Altı)",
                      _bodrumCountCtrl,
                      hint: "0 - 10 arası",
                      error: _bodrumCountErr,
                    ),

                    const SizedBox(height: 10),
                    _buildSectionTitle("Kat yükseklikleri nedir?"),
                    TechnicalDrawingButton(
                      assetPath: AppAssets.section3KatYuksekligi,
                      title: "Kat Yüksekliği Nasıl Ölçülür?",
                    ),
                    const SizedBox(height: 8),
                    SelectableCard(
                      choice: Bolum3Content.biliniyor,
                      isSelected: !_isUnknown,
                      onTap: () => setState(() => _isUnknown = false),
                    ),
                    SelectableCard(
                      choice: Bolum3Content.bilinmiyor,
                      isSelected: _isUnknown,
                      onTap: () => setState(() => _isUnknown = true),
                    ),

                    if (!_isUnknown) ...[
                      const SizedBox(height: 20),
                      _buildInput(
                        "Zemin Kat Yüksekliği (m)",
                        _zeminHCtrl,
                        isDecimal: true,
                        hint: "Örn: 3.50",
                        error: _zeminErr,
                      ),
                      _buildInput(
                        "Normal Kat Yüksekliği (m)",
                        _normalHCtrl,
                        isDecimal: true,
                        hint: "Örn: 3.00",
                        error: _normalErr,
                      ),
                      if ((int.tryParse(_bodrumCountCtrl.text) ?? 0) > 0)
                        _buildInput(
                          "Bodrum Kat Yüksekliği (m)",
                          _bodrumHCtrl,
                          isDecimal: true,
                          hint: "Örn: 3.50",
                          error: _bodrumErr,
                        ),
                    ],

                    const SizedBox(height: 20),
                    _buildSectionTitle("Yükseklik Bilgisi"),
                    _buildSummaryCard(vals),

                    const SizedBox(height: 12),
                    ConfirmationCheckbox(
                      value: _isConfirmed,
                      onChanged: (val) =>
                          setState(() => _isConfirmed = val ?? false),
                      text: "Yukarıdaki bilgilerin doğruluğunu teyit ediyorum.",
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLocked)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Temel veriler kilitlenmiştir. İleriki bölümlerdeki hesaplamaların (kapasite, sistem vb.) bozulmaması için bu aşamadan sonra yükseklik bilgisi değiştirilemez. Değiştirmek isterseniz yeni bir analiz başlatmalısınız.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> vals) {
    bool isYuksek = vals['isYuksek'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1A237E).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric(
                "hBina (Bodrum Hariç)",
                "${vals['hBina'].toStringAsFixed(2)}m",
              ),
              _buildMetric(
                "hYapi (Bodrum Dahil)",
                "${vals['hYapi'].toStringAsFixed(2)}m",
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Toplam Kat Sayısı Gösterimi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.layers_outlined,
                  size: 16,
                  color: Color(0xFF1A237E),
                ),
                const SizedBox(width: 8),
                Text(
                  "Toplam Kat Sayısı: ${(vals['n'] + vals['b'] + 1)} Kat",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF1A237E).withOpacity(0.1),
              ),
            ),
            child: Text(
              isYuksek ? "YÜKSEK BİNA" : "YÜKSEK OLMAYAN BİNA",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1A237E),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title, style: AppStyles.questionTitle),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController ctrl, {
    bool isDecimal = false,
    String? hint,
    String? error,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
        inputFormatters: isDecimal
            ? [InputValidator.flexDecimal]
            : [InputValidator.positiveInteger],
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: error,
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8, // Reduced from 12 for compactness
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
