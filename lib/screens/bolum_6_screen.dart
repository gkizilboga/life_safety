import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart'; // EKLENDİ
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/screens/bolum_7_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart'; // ModernHeader

class Bolum6Screen extends StatefulWidget {
  const Bolum6Screen({super.key});

  @override
  State<Bolum6Screen> createState() => _Bolum6ScreenState();
}

class _Bolum6ScreenState extends State<Bolum6Screen> {
  Bolum6Model _model = Bolum6Model();

  @override
  void initState() {
    super.initState();
    // Hafızadaki veriyi geri yükle
    if (BinaStore.instance.bolum6 != null) {
      _model = BinaStore.instance.bolum6!;
    }
  }

  // ADIM-1: Checkbox Mantığı
  void _toggleOtopark(bool? value) {
    setState(() {
      _model = _model.copyWith(
        hasOtoparkGenel: value ?? false,
        hasSadeceKonut: false,
        otoparkAciklikTipi: (value == false) ? null : _model.otoparkAciklikTipi,
      );
    });
  }

  void _toggleTicari(bool? value) {
    setState(() {
      _model = _model.copyWith(
        hasTicari: value ?? false,
        hasSadeceKonut: false,
      );
    });
  }

  void _toggleDepo(bool? value) {
    setState(() {
      _model = _model.copyWith(
        hasDepo: value ?? false,
        hasSadeceKonut: false,
      );
    });
  }

  void _toggleSadeceKonut(bool? value) {
    setState(() {
      if (value == true) {
        _model = _model.copyWith(
          hasSadeceKonut: true,
          hasOtoparkGenel: false,
          hasTicari: false,
          hasDepo: false,
          otoparkAciklikTipi: null,
        );
      } else {
        _model = _model.copyWith(hasSadeceKonut: false);
      }
    });
  }

  // ADIM-2: Radio Button Mantığı
  void _setOtoparkTipi(OtoparkAciklikTipi? value) {
    setState(() {
      _model = _model.copyWith(otoparkAciklikTipi: value);
    });
  }

  void _onNextPressed() {
    if (!_model.isAnySelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen en az bir kullanım türü seçiniz.")),
      );
      return;
    }

    if (_model.hasOtoparkGenel && _model.otoparkAciklikTipi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Otoparkınızın durumunu seçiniz.")),
      );
      return;
    }

    _navigateToNext();
  }

  void _navigateToNext() {
    // VERİYİ DEPOYA KAYDET
    BinaStore.instance.bolum6 = _model;
    print("Bölüm 6 Kaydedildi. Otopark Statüsü: ${_model.otoparkStatus}");
    
    // Bölüm 7 artık veriyi Store'dan çekecek, parametreye gerek yok.
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum7Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. MODERN BAŞLIK
          ModernHeader(
            title: "Konut Harici Alanlar",
            subtitle: "Bölüm 6: Kullanım Amacı",
            currentStep: 6,
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
                    "KONUT HARİCİ ALANLAR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ADIM-1
                  const Text("KULLANIM AMACI SORGUSU", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Text("Binanızda konut haricinde aşağıdaki alanlardan hangileri var?", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),

                  _buildCheckboxOption(
                    title: "A) Binanın altında otopark var",
                    subtitle: "Bodrum veya zemin katta.",
                    value: _model.hasOtoparkGenel,
                    onChanged: _model.hasSadeceKonut ? null : _toggleOtopark,
                  ),
                  _buildCheckboxOption(
                    title: "B) Ticari alan var",
                    subtitle: "Dükkan, Mağaza, Ofis, İşyeri, İşyerlerine ait depo alanı vb.",
                    value: _model.hasTicari,
                    onChanged: _model.hasSadeceKonut ? null : _toggleTicari,
                  ),
                  _buildCheckboxOption(
                    title: "C) Depo alanı var",
                    subtitle: "Konut sakinlere ait eşya deposu vb.",
                    value: _model.hasDepo,
                    onChanged: _model.hasSadeceKonut ? null : _toggleDepo,
                  ),
                  const Divider(),
                  _buildCheckboxOption(
                    title: "D) Konut dışında binada başka bir alan yok",
                    subtitle: "Sadece daireler var.",
                    value: _model.hasSadeceKonut,
                    onChanged: _toggleSadeceKonut,
                    isExclusive: true,
                  ),

                  // ADIM-2
                  if (_model.hasOtoparkGenel) ...[
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("OTOPARK TİPİ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1A237E))),
                          const SizedBox(height: 10),
                          const Text("Otoparkınızın dış havayla temas eden duvarlarında, karşılıklı rüzgar akışını sağlayan açıklıklar var mı?", style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 15),
                          
                          _buildRadioOption(
                            title: "A) Otoparkın tüm duvarları kapalı",
                            subtitle: "Toprak altında veya duvarları örülü.",
                            value: OtoparkAciklikTipi.tamKapali,
                          ),
                          _buildRadioOption(
                            title: "B) Otoparkın karşılıklı iki cephesi tamamen açık",
                            subtitle: "Veya toplam cephe alanının yarısı kadar duvarlarda boşluk var. (Doğal rüzgar esiyor).",
                            value: OtoparkAciklikTipi.karsilikliAcik,
                          ),
                          _buildRadioOption(
                            title: "C) Otoparkın sadece tek bir cephesinde açıklık var",
                            subtitle: "Veya küçük pencereler var.",
                            value: OtoparkAciklikTipi.tekCepheAcik,
                          ),

                          if (_model.otoparkStatus != null)
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _model.isYariAcik ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(_model.isYariAcik ? Icons.check_circle : Icons.warning, color: _model.isYariAcik ? Colors.green.shade800 : Colors.orange.shade900),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("OTOPARK DURUMU: ${_model.otoparkStatus}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const Text("Otopark durumu, verdiğiniz fiziksel bilgilere göre sistem tarafından belirlenmiştir.", style: TextStyle(fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildCheckboxOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool?)? onChanged,
    bool isExclusive = false,
  }) {
    return CheckboxListTile(
      title: Text(title, style: TextStyle(fontWeight: isExclusive ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1A237E),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String subtitle,
    required OtoparkAciklikTipi value,
  }) {
    return RadioListTile<OtoparkAciklikTipi>(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      groupValue: _model.otoparkAciklikTipi,
      onChanged: _setOtoparkTipi,
      activeColor: const Color(0xFF1A237E),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}