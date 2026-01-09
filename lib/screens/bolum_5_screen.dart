import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_5_model.dart';
import 'bolum_6_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';
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
      double? t = double.tryParse(_tabanCtrl.text.replaceAll(',', '.'));
      if (_tabanCtrl.text.isNotEmpty && t != null && t > 2500) {
        _tabanError = "Zemin kat alanı 2500 m²'den büyük olamaz.";
      } else {
        _tabanError = null;
      }

      double? n = double.tryParse(_normalCtrl.text.replaceAll(',', '.'));
      if (_normalCtrl.text.isNotEmpty && n != null && n > 2500) {
        _normalError = "Normal kat alanı 2500 m²'den büyük olamaz.";
      } else {
        _normalError = null;
      }

      double? b = double.tryParse(_bodrumCtrl.text.replaceAll(',', '.'));
      if (_bodrumCtrl.text.isNotEmpty && b != null && b > 10000) {
        _bodrumError = "Bodrum kat alanı 10.000 m²'den büyük olamaz.";
      } else {
        _bodrumError = null;
      }

      double? tot = double.tryParse(_toplamCtrl.text.replaceAll(',', '.'));
      if (_toplamCtrl.text.isNotEmpty && tot != null && tot > 150000) {
        _toplamError = "Toplam inşaat alanı 150.000 m²'den büyük olamaz.";
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
    double? tAlani = double.tryParse(_tabanCtrl.text.replaceAll(',', '.'));
    double? nAlani = double.tryParse(_normalCtrl.text.replaceAll(',', '.'));
    double? bAlani = double.tryParse(_bodrumCtrl.text.replaceAll(',', '.')) ?? 0;

    if (tAlani != null && nAlani != null) {
      double toplam = tAlani + (_nKat * nAlani) + (_bKat * bAlani);
      setState(() {
        _toplamCtrl.text = toplam.toStringAsFixed(2);
        _isCalculated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen Zemin ve Normal Kat alanlarını giriniz.")),
      );
    }
  }

  void _onNextPressed() {
    _model = _model.copyWith(
      tabanAlani: double.tryParse(_tabanCtrl.text.replaceAll(',', '.')),
      normalKatAlani: double.tryParse(_normalCtrl.text.replaceAll(',', '.')),
      bodrumKatAlani: double.tryParse(_bodrumCtrl.text.replaceAll(',', '.')),
      toplamInsaatAlani: double.tryParse(_toplamCtrl.text.replaceAll(',', '.')),
    );
    BinaStore.instance.bolum5 = _model;
    BinaStore.instance.saveToDisk(); 
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum6Screen()));
  }

  bool _isFormValid() {
    if (_toplamCtrl.text.isEmpty) return false;
    return _tabanError == null && _normalError == null && _bodrumError == null && _toplamError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(
            title: "Kat Alan Bilgileri",
            subtitle: "İnşaat alanı ve kullanıcı yükü temeli",
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
                      "Bina Brüt Alan Girişi (m²)",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF263238)),
                    ),
                  ),
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel(Bolum5Content.oturumAlani),
                        _buildNumberInput(_tabanCtrl, "Örn: 250", error: _tabanError),
                        
                        const SizedBox(height: 16),
                        _buildInputLabel(Bolum5Content.normalKatAlani),
                        _buildNumberInput(_normalCtrl, "Örn: 250", error: _normalError),

                        if (_bKat > 0) ...[
                          const SizedBox(height: 16),
                          _buildInputLabel(Bolum5Content.bodrumKatAlani),
                          _buildNumberInput(_bodrumCtrl, "Örn: 250", error: _bodrumError),
                        ],

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _otomatikHesapla,
                            icon: const Icon(Icons.calculate_outlined, size: 20),
                            label: const Text("TOPLAM ALANI HESAPLA"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(thickness: 1, color: Color(0xFFECEFF1)),
                        ),

                        _buildInputLabel(Bolum5Content.toplamInsaat),
                        _buildNumberInput(_toplamCtrl, "Toplam m²", isBold: true, error: _toplamError),

                        if (_isCalculated) _buildSummaryCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: _isFormValid() ? _onNextPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("KAYDET VE DEVAM ET", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(ChoiceResult content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF455A64))),
        Text(content.uiSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNumberInput(TextEditingController controller, String hint, {bool isBold = false, String? error}) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        errorText: error,
        suffixText: "m²",
        filled: true,
        fillColor: isBold ? const Color(0xFFECEFF1) : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          const Text("HESAPLAMA DETAYI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32), fontSize: 13)),
          const SizedBox(height: 8),
          _buildSummaryRow("Zemin Kat:", "${_tabanCtrl.text} m²"),
          _buildSummaryRow("Normal Katlar ($_nKat adet):", "${(double.tryParse(_normalCtrl.text.replaceAll(',', '.')) ?? 0) * _nKat} m²"),
          if (_bKat > 0) _buildSummaryRow("Bodrum Katlar ($_bKat adet):", "${(double.tryParse(_bodrumCtrl.text.replaceAll(',', '.')) ?? 0) * _bKat} m²"),
          const Divider(),
          _buildSummaryRow("Toplam İnşaat Alanı:", "${_toplamCtrl.text} m²", isTotal: true),
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
          Text(label, style: TextStyle(fontSize: 13, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}