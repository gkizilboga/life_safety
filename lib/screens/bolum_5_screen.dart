import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_4_model.dart';
import '../../models/bolum_5_model.dart';
import 'bolum_6_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';
import '../../utils/input_validator.dart';
import '../../models/choice_result.dart';

class Bolum5Screen extends StatefulWidget {
  const Bolum5Screen({super.key});

  @override
  State<Bolum5Screen> createState() => _Bolum5ScreenState();
}

class _Bolum5ScreenState extends State<Bolum5Screen> {
  Bolum5Model _model = Bolum5Model();
  final TextEditingController _tabanCtrl = TextEditingController();
  final TextEditingController _normalCtrl = TextEditingController();
  final TextEditingController _bodrumCtrl = TextEditingController();
  final TextEditingController _toplamCtrl = TextEditingController();

  int _nKat = 0;
  int _bKat = 0;
  bool _isCalculated = false;
  bool _isConfirmed = false;

  String? _tabanError;
  String? _normalError;
  String? _bodrumError;
  String? _toplamError;

  @override
  void initState() {
    super.initState();
    final Bolum3Model? b3 = BinaStore.instance.bolum3;
    _nKat = b3?.normalKatSayisi ?? 0;
    _bKat = b3?.bodrumKatSayisi ?? 0;

    _tabanCtrl.addListener(_validate);
    _normalCtrl.addListener(_validate);
    _bodrumCtrl.addListener(_validate);
    _toplamCtrl.addListener(_validate);
  }

  void _validate() {
    setState(() {
      double? tot = double.tryParse(_toplamCtrl.text.replaceAll(',', '.'));
      if (_toplamCtrl.text.isNotEmpty && tot != null && tot > 250000) {
        _toplamError = "Toplam inşaat alanı 250.000 m²'den büyük olamaz.";
      } else {
        _toplamError = null;
      }
    });
  }

  @override
  void dispose() {
    _tabanCtrl.dispose();
    _normalCtrl.dispose();
    _bodrumCtrl.dispose();
    _toplamCtrl.dispose();
    super.dispose();
  }

  void _otomatikHesapla() {
    FocusScope.of(context).unfocus();
    double tAlani = InputValidator.parseFlex(_tabanCtrl.text) ?? 0.0;
    double nAlani = InputValidator.parseFlex(_normalCtrl.text) ?? 0.0;
    double bAlani = InputValidator.parseFlex(_bodrumCtrl.text) ?? 0.0;

    if (tAlani > 0 && nAlani > 0) {
      double toplam = tAlani + (_nKat * nAlani) + (_bKat * bAlani);
      setState(() {
        _toplamCtrl.text = toplam.toStringAsFixed(2);
        _isCalculated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Lütfen zemin ve normal katlara ait alan bilgilerini giriniz.",
          ),
        ),
      );
    }
  }

  void _onNextPressed() {
    _model = _model.copyWith(
      tabanAlani: InputValidator.parseFlex(_tabanCtrl.text),
      normalKatAlani: InputValidator.parseFlex(_normalCtrl.text),
      bodrumKatAlani: InputValidator.parseFlex(_bodrumCtrl.text),
      toplamInsaatAlani: InputValidator.parseFlex(_toplamCtrl.text),
    );
    BinaStore.instance.bolum5 = _model;
    BinaStore.instance.saveToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum6Screen()),
    );
  }

  bool _isFormValid() {
    if (!_isConfirmed) return false;
    if (_toplamCtrl.text.isEmpty) return false;
    return _tabanError == null &&
        _normalError == null &&
        _bodrumError == null &&
        _toplamError == null;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kat Alan Bilgileri",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isFormValid(),
      onNext: _onNextPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Brüt Alan Girişi (m²)",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
          ),
          QuestionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputLabel(Bolum5Content.oturumAlani),
                _buildNumberInput(_tabanCtrl, "Örn: 500", error: _tabanError),

                const SizedBox(height: 16),
                _buildInputLabel(Bolum5Content.normalKatAlani),
                _buildNumberInput(_normalCtrl, "Örn: 500", error: _normalError),

                if (_bKat > 0) ...[
                  const SizedBox(height: 16),
                  _buildInputLabel(Bolum5Content.bodrumKatAlani),
                  _buildNumberInput(
                    _bodrumCtrl,
                    "Örn: 500",
                    error: _bodrumError,
                  ),
                ],

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _otomatikHesapla,
                    icon: const Icon(Icons.calculate_outlined, size: 20),
                    label: const Text("TOPLAM BRÜT ALANI HESAPLA"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(thickness: 1, color: Color(0xFFECEFF1)),
                ),

                _buildInputLabel(Bolum5Content.toplamInsaat),
                _buildNumberInput(
                  _toplamCtrl,
                  "Toplam m²",
                  isBold: true,
                  error: _toplamError,
                ),

                if (_isCalculated) _buildSummaryCard(),

                const SizedBox(height: 20),
                _buildConfirmationBox(),
              ],
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

  Widget _buildInputLabel(ChoiceResult content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.uiTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF455A64),
          ),
        ),
        if (content.uiSubtitle.isNotEmpty)
          Text(
            content.uiSubtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildNumberInput(
    TextEditingController controller,
    String hint, {
    bool isBold = false,
    String? error,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [InputValidator.flexDecimal],
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        errorText: error,
        suffixText: "m²",
        filled: true,
        fillColor: isBold ? const Color(0xFFECEFF1) : Colors.white,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "HESAPLAMA DETAYI",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow("Zemin Kat:", "${_tabanCtrl.text} m²"),
          _buildSummaryRow(
            "Normal Katlar ($_nKat adet):",
            "${((InputValidator.parseFlex(_normalCtrl.text) ?? 0) * _nKat).toStringAsFixed(2)} m²",
          ),
          if (_bKat > 0)
            _buildSummaryRow(
              "Bodrum Katlar ($_bKat adet):",
              "${((InputValidator.parseFlex(_bodrumCtrl.text) ?? 0) * _bKat).toStringAsFixed(2)} m²",
            ),
          const Divider(),
          _buildSummaryRow(
            "Toplam İnşaat Alanı:",
            "${_toplamCtrl.text} m²",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
