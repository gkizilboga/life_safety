import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import 'bolum_4_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';

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

  bool _isUnknown = false;
  bool _isConfirmed = false;
  String? _zeminErr;
  String? _normalErr;
  String? _bodrumErr;

  @override
  void initState() {
    super.initState();
    _normalCountCtrl.addListener(() => setState(() {}));
    _bodrumCountCtrl.addListener(() => setState(() {}));
    _zeminHCtrl.addListener(_validate);
    _normalHCtrl.addListener(_validate);
    _bodrumHCtrl.addListener(_validate);
  }

  void _validate() {
    setState(() {
      _zeminErr = _checkLimit(_zeminHCtrl.text, 2.0, 7.0);
      _normalErr = _checkLimit(_normalHCtrl.text, 2.0, 4.5);
      _bodrumErr = _checkLimit(_bodrumHCtrl.text, 2.0, 7.0);
    });
  }

  String? _checkLimit(String text, double min, double max) {
    if (text.isEmpty) return null;
    double? val = double.tryParse(text.replaceAll(',', '.'));
    if (val == null || val < min || val > max)
      return "$min - $max m arası giriniz";
    return null;
  }

  Map<String, dynamic> _calculateValues() {
    int n = int.tryParse(_normalCountCtrl.text) ?? 0;
    int b = int.tryParse(_bodrumCountCtrl.text) ?? 0;

    double zH = _isUnknown
        ? 3.50
        : (double.tryParse(_zeminHCtrl.text.replaceAll(',', '.')) ?? 0.0);
    double nH = _isUnknown
        ? 3.00
        : (double.tryParse(_normalHCtrl.text.replaceAll(',', '.')) ?? 0.0);
    double bH = _isUnknown
        ? 3.50
        : (double.tryParse(_bodrumHCtrl.text.replaceAll(',', '.')) ?? 0.0);

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
    if (_normalCountCtrl.text.isEmpty || _bodrumCountCtrl.text.isEmpty)
      return false;
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

    BinaStore.instance.saveToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum4Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vals = _calculateValues();

    return AnalysisPageLayout(
      title: "Kat Bilgileri",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: _onNextPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Kat Sayıları"),
          _buildInput("Normal Kat Sayısı (Zemin Üstü)", _normalCountCtrl),
          _buildInput("Bodrum Kat Sayısı (Zemin Altı)", _bodrumCountCtrl),

          const SizedBox(height: 10),
          _buildSectionTitle("Kat Yükseklikleri"),
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

          const SizedBox(height: 30),
          _buildConfirmationBox(),
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
          const Divider(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isYuksek
                  ? const Color(0xFFE53935)
                  : const Color(0xFF43A047),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isYuksek ? "YÜKSEK BİNA" : "YÜKSEK OLMAYAN BİNA",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isConfirmed
              ? const Color(0xFF1A237E)
              : const Color(0xFFE0E0E0),
        ),
      ),
      child: CheckboxListTile(
        value: _isConfirmed,
        onChanged: (val) => setState(() => _isConfirmed = val ?? false),
        activeColor: const Color(0xFF1A237E),
        title: const Text(
          "Yukarıdaki bilgilerin doğruluğunu teyit ediyorum.",
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        dense: true,
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
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E),
        ),
      ),
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
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
            : [FilteringTextInputFormatter.digitsOnly],
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
            vertical: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
