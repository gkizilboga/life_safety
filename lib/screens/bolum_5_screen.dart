import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart'; // EKLENDİ
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/screens/bolum_6_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart'; // ModernHeader

class Bolum5Screen extends StatefulWidget {
  // Constructor'dan parametreler kaldırıldı
  const Bolum5Screen({super.key});

  @override
  State<Bolum5Screen> createState() => _Bolum5ScreenState();
}

class _Bolum5ScreenState extends State<Bolum5Screen> {
  Bolum5Model _model = Bolum5Model();

  final TextEditingController _alanOturumCtrl = TextEditingController();
  final TextEditingController _alanKatBrutCtrl = TextEditingController();
  final TextEditingController _alanToplamInsaatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Hafızadaki veriyi geri yükle
    if (BinaStore.instance.bolum5 != null) {
      _model = BinaStore.instance.bolum5!;
      if (_model.alanOturum != null) _alanOturumCtrl.text = _model.alanOturum.toString();
      if (_model.alanKatBrut != null) _alanKatBrutCtrl.text = _model.alanKatBrut.toString();
      if (_model.alanToplamInsaat != null) _alanToplamInsaatCtrl.text = _model.alanToplamInsaat.toString();
    }
  }

  @override
  void dispose() {
    _alanOturumCtrl.dispose();
    _alanKatBrutCtrl.dispose();
    _alanToplamInsaatCtrl.dispose();
    super.dispose();
  }

  void _calculateAutoTotalArea() {
    // VERİLERİ DEPODAN ÇEK
    final int normalKat = BinaStore.instance.normalKatSayisi;
    final int bodrumKat = BinaStore.instance.bodrumKatSayisi;
    
    if ((_model.alanKatBrut ?? 0) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Otomatik hesaplama için önce 'Standart Kat Alanı'nı giriniz.")),
      );
      return;
    }

    int toplamKat = normalKat + bodrumKat + 1;
    double tahminiAlan = (_model.alanKatBrut!) * toplamKat;

    setState(() {
      _model = _model.copyWith(alanToplamInsaat: tahminiAlan);
      _alanToplamInsaatCtrl.text = tahminiAlan.toStringAsFixed(2);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tahmini alan hesaplandı: $toplamKat kat x ${_model.alanKatBrut} m²")),
    );
  }

  void _onNextPressed() {
    if (!_model.isAlanlarGirildi) {
      _showErrorDialog("Doğru analiz için lütfen tüm alan bilgilerini giriniz.");
      return;
    }

    if (!_model.isMantiksalHataYok) {
      _showErrorDialog("Hatalı Giriş: Oturum alanı veya kat alanı, toplam inşaat alanından büyük olamaz.");
      return;
    }

    _navigateToNext();
  }

  void _navigateToNext() {
    // VERİYİ DEPOYA KAYDET
    BinaStore.instance.bolum5 = _model;
    print("Bölüm 5 Kaydedildi. Toplam İnşaat Alanı: ${_model.alanToplamInsaat}");

    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum6Screen()));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("⚠️ Hata"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam")),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Anladım")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. MODERN BAŞLIK
          ModernHeader(
            title: "Alan Bilgileri",
            subtitle: "Bölüm 5: Bina Alan Bilgileri",
            currentStep: 5,
            totalSteps: 21,
            onBack: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "BİNA ALAN BİLGİLERİ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 1. BİNA OTURUM ALANI
                  _buildAreaInput(
                    label: "Bina Oturum (Taban) Alanı",
                    controller: _alanOturumCtrl,
                    onChanged: (val) => setState(() => _model = _model.copyWith(alanOturum: double.tryParse(val))),
                    infoTitle: "Bina Oturum (Taban) Alanı Nedir?",
                    infoMessage: "Binanın zeminde kapladığı alan büyüklüğüdür. Bahçe dahil değildir, sadece binanın taban alanıdır.",
                  ),
                  const SizedBox(height: 20),

                  // 2. STANDART KAT ALANI
                  _buildAreaInput(
                    label: "Standart Kat Alanı",
                    controller: _alanKatBrutCtrl,
                    onChanged: (val) => setState(() => _model = _model.copyWith(alanKatBrut: double.tryParse(val))),
                    infoTitle: "Standart Kat Alanı Nedir?",
                    infoMessage: "Kat holleri, merdivenler, balkonlar dahil, o katın tamamının duvar dışından dışına brüt ölçüsüdür.",
                  ),
                  const SizedBox(height: 20),

                  // 3. TOPLAM İNŞAAT ALANI ve OTOMATİK BUTONU
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _buildAreaInput(
                          label: "Toplam İnşaat Alanı",
                          controller: _alanToplamInsaatCtrl,
                          onChanged: (val) => setState(() => _model = _model.copyWith(alanToplamInsaat: double.tryParse(val))),
                          infoTitle: "Toplam İnşaat Alanı Nedir?",
                          infoMessage: "Bodrumlar, zemin kat, normal katlar ve çatı arası dahil tüm katların alanlarının toplamıdır.",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _calculateAutoTotalArea,
                      icon: const Icon(Icons.calculate),
                      label: const Text("OTOMATİK HESAPLA"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: const Color(0xFF1A237E),
                        side: const BorderSide(color: Color(0xFF1A237E)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SABİT BUTON ALANI
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
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaInput({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    required String infoTitle,
    required String infoMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.blue),
              onPressed: () => _showInfoDialog(infoTitle, infoMessage),
              tooltip: "Bilgi",
            ),
          ],
        ),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: "0.00",
            suffixText: "m²",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ],
    );
  }
}