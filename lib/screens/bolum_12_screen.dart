import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_2_model.dart';
import 'package:life_safety/models/bolum_12_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_13_screen.dart';

class Bolum12Screen extends StatefulWidget {
  const Bolum12Screen({super.key});

  @override
  State<Bolum12Screen> createState() => _Bolum12ScreenState();
}

class _Bolum12ScreenState extends State<Bolum12Screen> {
  Bolum12Model _model = Bolum12Model();
  
  final TextEditingController _kolonCtrl = TextEditingController();
  final TextEditingController _kirisCtrl = TextEditingController();
  final TextEditingController _dosemeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // HAFIZA DÜZELTMESİ: Veri varsa geri yükle
    if (BinaStore.instance.bolum12 != null) {
      _model = BinaStore.instance.bolum12!;
      // Controller'ları da doldur (Betonarme manuel giriş için)
      if (_model.valPaspayiKolon != null) _kolonCtrl.text = _model.valPaspayiKolon.toString();
      if (_model.valPaspayiKiris != null) _kirisCtrl.text = _model.valPaspayiKiris.toString();
      if (_model.valPaspayiDoseme != null) _dosemeCtrl.text = _model.valPaspayiDoseme.toString();
    }
  }

  @override
  void dispose() {
    _kolonCtrl.dispose();
    _kirisCtrl.dispose();
    _dosemeCtrl.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    BinaStore.instance.bolum12 = _model;
    print("Bölüm 12 Kaydedildi.");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum13Screen()));
  }

  @override
  Widget build(BuildContext context) {
    final tasiyiciSistem = BinaStore.instance.bolum2?.efektifTasiyiciSistem;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Yapı Stabilitesi",
            subtitle: "Bölüm 12: Taşıyıcı Sistem Dayanımı",
            currentStep: 12,
            totalSteps: 15,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tasiyiciSistem == TasiyiciSistem.celik) _buildCelikUI(),
                  if (tasiyiciSistem == TasiyiciSistem.betonarme) _buildBetonUI(),
                  if (tasiyiciSistem == TasiyiciSistem.ahsap) _buildAhsapUI(),
                  if (tasiyiciSistem == TasiyiciSistem.yigma) _buildYigmaUI(),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  // --- UI WIDGETLARI (Aynı kalıyor, sadece initState eklendi) ---
  Widget _buildCelikUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ÇELİK YAPILAR İÇİN KONTROL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text("Çelik taşıyıcılarınızda (Kolon ve Kirişlerde) yangına karşı bir koruma/yalıtım var mı?", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        SelectableCard(
          title: "Evet, koruma var.",
          subtitle: "Boya, püskürtme sıva veya alçıpan ile kaplanmış.",
          value: CelikKorumaSecim.evetKorumaVar,
          groupValue: _model.resCelikKoruma,
          onChanged: (val) => setState(() => _model = _model.copyWith(resCelikKoruma: val)),
        ),
        SelectableCard(
          title: "Hayır, çelik profiller çıplak.",
          subtitle: "Profiller doğrudan görünüyor.",
          value: CelikKorumaSecim.hayirCiplak,
          groupValue: _model.resCelikKoruma,
          onChanged: (val) => setState(() => _model = _model.copyWith(resCelikKoruma: val)),
        ),
        SelectableCard(
          title: "Bilmiyorum / Emin Değilim",
          value: CelikKorumaSecim.bilmiyorum,
          groupValue: _model.resCelikKoruma,
          onChanged: (val) => setState(() => _model = _model.copyWith(resCelikKoruma: val)),
        ),
      ],
    );
  }

  Widget _buildBetonUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("BETONARME YAPILAR (PASPAYI)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text("Demirleri örten beton tabakasının kalınlığını (Paspayı) nasıl değerlendirelim?", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        SelectableCard(
          title: "Standartlara uygun kabul edilsin",
          subtitle: "Binam 2007 sonrası olduğu için uygun varsayılsın.",
          value: BetonYontemSecim.standart2007,
          groupValue: _model.resBetonYontem,
          onChanged: (val) => setState(() => _model = _model.copyWith(resBetonYontem: val)),
        ),
        SelectableCard(
          title: "Değerleri kendim gireceğim",
          subtitle: "Paspayı kalınlıklarını biliyorum.",
          value: BetonYontemSecim.manuelGiris,
          groupValue: _model.resBetonYontem,
          onChanged: (val) => setState(() => _model = _model.copyWith(resBetonYontem: val)),
        ),
        if (_model.resBetonYontem == BetonYontemSecim.manuelGiris) ...[
          const SizedBox(height: 10),
          _buildPaspayiField("Kolon Paspayı", _kolonCtrl, (v) => setState(() => _model = _model.copyWith(valPaspayiKolon: double.tryParse(v)))),
          _buildPaspayiField("Kiriş Paspayı", _kirisCtrl, (v) => setState(() => _model = _model.copyWith(valPaspayiKiris: double.tryParse(v)))),
          _buildPaspayiField("Döşeme Paspayı", _dosemeCtrl, (v) => setState(() => _model = _model.copyWith(valPaspayiDoseme: double.tryParse(v)))),
        ],
        SelectableCard(
          title: "Bilmiyorum",
          value: BetonYontemSecim.bilmiyorum,
          groupValue: _model.resBetonYontem,
          onChanged: (val) => setState(() => _model = _model.copyWith(resBetonYontem: val)),
        ),
      ],
    );
  }

  Widget _buildAhsapUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("AHŞAP YAPILAR İÇİN KONTROL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text("Ahşap taşıyıcılarınızın kalınlığı (kesiti) nasıldır?", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        SelectableCard(
          title: "İnce keresteler",
          subtitle: "10 cm'den ince kesitler.",
          value: AhsapKesitSecim.ince,
          groupValue: _model.resAhsapKesit,
          onChanged: (val) => setState(() => _model = _model.copyWith(resAhsapKesit: val)),
        ),
        SelectableCard(
          title: "Kalın kütükler",
          subtitle: "10 cm'den kalın kesitler.",
          value: AhsapKesitSecim.kalin,
          groupValue: _model.resAhsapKesit,
          onChanged: (val) => setState(() => _model = _model.copyWith(resAhsapKesit: val)),
        ),
        SelectableCard(
          title: "Bilmiyorum",
          value: AhsapKesitSecim.bilmiyorum,
          groupValue: _model.resAhsapKesit,
          onChanged: (val) => setState(() => _model = _model.copyWith(resAhsapKesit: val)),
        ),
      ],
    );
  }

  Widget _buildYigmaUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("KAGİR / YIĞMA YAPILAR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text("Taşıyıcı duvarlarınızın kalınlığı en az 19 cm mi?", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        SelectableCard(
          title: "Evet, 19 cm veya daha fazla.",
          value: YigmaDuvarSecim.kalin,
          groupValue: _model.resYigmaDuvar,
          onChanged: (val) => setState(() => _model = _model.copyWith(resYigmaDuvar: val)),
        ),
        SelectableCard(
          title: "Hayır, daha ince.",
          value: YigmaDuvarSecim.ince,
          groupValue: _model.resYigmaDuvar,
          onChanged: (val) => setState(() => _model = _model.copyWith(resYigmaDuvar: val)),
        ),
        SelectableCard(
          title: "Bilmiyorum",
          value: YigmaDuvarSecim.bilmiyorum,
          groupValue: _model.resYigmaDuvar,
          onChanged: (val) => setState(() => _model = _model.copyWith(resYigmaDuvar: val)),
        ),
      ],
    );
  }

  Widget _buildPaspayiField(String label, TextEditingController ctrl, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          suffixText: "mm",
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid() ? _onNextPressed : null,
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    final sys = BinaStore.instance.bolum2?.efektifTasiyiciSistem;
    if (sys == TasiyiciSistem.celik) return _model.resCelikKoruma != null;
    if (sys == TasiyiciSistem.ahsap) return _model.resAhsapKesit != null;
    if (sys == TasiyiciSistem.yigma) return _model.resYigmaDuvar != null;
    if (sys == TasiyiciSistem.betonarme) {
      if (_model.resBetonYontem == null) return false;
      if (_model.resBetonYontem == BetonYontemSecim.manuelGiris) {
        return _model.valPaspayiKolon != null && _model.valPaspayiKiris != null && _model.valPaspayiDoseme != null;
      }
      return true;
    }
    return false;
  }
}