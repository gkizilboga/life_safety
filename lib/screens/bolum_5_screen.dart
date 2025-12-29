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

  @override
  void initState() {
    super.initState();
    final Bolum3Model? b3 = BinaStore.instance.bolum3;
    _nKat = b3?.normalKatSayisi ?? 0;
    _bKat = b3?.bodrumKatSayisi ?? 0;
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
    if (_toplamCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen Toplam İnşaat Alanını giriniz.")),
      );
      return;
    }

    _model = _model.copyWith(
      tabanAlani: double.tryParse(_tabanCtrl.text.replaceAll(',', '.')),
      normalKatAlani: double.tryParse(_normalCtrl.text.replaceAll(',', '.')),
      bodrumKatAlani: double.tryParse(_bodrumCtrl.text.replaceAll(',', '.')),
      toplamInsaatAlani: double.tryParse(_toplamCtrl.text.replaceAll(',', '.')),
    );

    BinaStore.instance.bolum5 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum6Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-5: Kat Alan Bilgileri",
            subtitle: "İnşaat alanı ve kullanıcı yükü temeli",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel(Bolum5Content.oturumAlani),
                        _buildNumberInput(_tabanCtrl),
                        
                        const SizedBox(height: 20),
                        _buildInputLabel(Bolum5Content.normalKatAlani),
                        _buildNumberInput(_normalCtrl),

                        if (_bKat > 0) ...[
                          const SizedBox(height: 20),
                          _buildInputLabel(Bolum5Content.bodrumKatAlani),
                          _buildNumberInput(_bodrumCtrl),
                        ],

                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _otomatikHesapla,
                            icon: const Icon(Icons.calculate),
                            label: const Text("OTOMATİK HESAPLA"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 25),
                        const Divider(thickness: 1.5),
                        const SizedBox(height: 15),

                        _buildInputLabel(Bolum5Content.toplamInsaat),
                        _buildNumberInput(_toplamCtrl),

                        if (_isCalculated) _buildSummaryCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildInputLabel(ChoiceResult content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(content.uiSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNumberInput(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        hintText: "m²",
        suffixText: "m²",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hesaplama Özeti:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 5),
          Text("• Zemin Kat: ${_tabanCtrl.text} m²"),
          Text("• Normal Katlar ($_nKat adet): ${double.tryParse(_normalCtrl.text) ?? 0 * _nKat} m²"),
          if (_bKat > 0) Text("• Bodrum Katlar ($_bKat adet): ${double.tryParse(_bodrumCtrl.text) ?? 0 * _bKat} m²"),
          const Divider(),
          Text("Toplam: ${_toplamCtrl.text} m²", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onNextPressed,
            child: const Text("KAYDET VE DEVAM ET"),
          ),
        ),
      ),
    );
  }
}