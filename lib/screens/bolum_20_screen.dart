import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_21_screen.dart';
// import 'package:life_safety/screens/bolum_21_screen.dart'; // Sonraki aşama

class Bolum20Screen extends StatefulWidget {
  const Bolum20Screen({super.key});

  @override
  State<Bolum20Screen> createState() => _Bolum20ScreenState();
}

class _Bolum20ScreenState extends State<Bolum20Screen> {
  Bolum20Model _model = Bolum20Model();

  // Controller'lar (Sayısal girişler için)
  final TextEditingController _cNormal = TextEditingController();
  final TextEditingController _cYanginBeton = TextEditingController();
  final TextEditingController _cYanginCelik = TextEditingController();
  final TextEditingController _cDisCelik = TextEditingController();
  final TextEditingController _cDoner = TextEditingController();
  final TextEditingController _cSahanliksiz = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum20 != null) {
      _model = BinaStore.instance.bolum20!;
      // Controllerları geri yükle
      _cNormal.text = _model.cntNormalMerdiven == 0 ? "" : _model.cntNormalMerdiven.toString();
      _cYanginBeton.text = _model.cntYanginMerdiveniBeton == 0 ? "" : _model.cntYanginMerdiveniBeton.toString();
      _cYanginCelik.text = _model.cntYanginMerdiveniCelik == 0 ? "" : _model.cntYanginMerdiveniCelik.toString();
      _cDisCelik.text = _model.cntDisCelikMerdiven == 0 ? "" : _model.cntDisCelikMerdiven.toString();
      _cDoner.text = _model.cntDonerMerdiven == 0 ? "" : _model.cntDonerMerdiven.toString();
      _cSahanliksiz.text = _model.cntSahanliksizMerdiven == 0 ? "" : _model.cntSahanliksizMerdiven.toString();
    }
  }

  @override
  void dispose() {
    _cNormal.dispose();
    _cYanginBeton.dispose();
    _cYanginCelik.dispose();
    _cDisCelik.dispose();
    _cDoner.dispose();
    _cSahanliksiz.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    // VALIDATION
    final int normalKat = BinaStore.instance.normalKatSayisi;
    final int bodrumKat = BinaStore.instance.bodrumKatSayisi;
    final bool isTekKatli = (normalKat == 0 && bodrumKat == 0);

    if (isTekKatli) {
      if (_model.resTekKatCikis == null) {
        _showError("Lütfen çıkış şeklini seçiniz.");
        return;
      }
    } else {
      // Çok katlı bina kontrolü
      if (_model.toplamMerdivenSayisi == 0) {
        _showError("Hatalı Giriş: Çok katlı bir binada en az 1 adet merdiven bulunmak zorundadır. Lütfen sayı giriniz.");
        return;
      }
      if (bodrumKat > 0 && _model.resBodrumMerdivenDevam == null) {
        _showError("Lütfen bodrum merdiveni durumunu seçiniz.");
        return;
      }
      if (_model.resRampaVarMi == null) {
        _showError("Lütfen rampa durumunu seçiniz.");
        return;
      }
    }

    BinaStore.instance.bolum20 = _model;
    print("Bölüm 20 Kaydedildi.");
    print("Flag - Normal Merdiven: ${_model.hasNormalMerdiven}");
    print("Flag - Yangın Merdiveni: ${_model.hasYanginMerdiveni}");
    print("Flag - Tip: ${_model.merdivenTipi}");

Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum21Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final int normalKat = BinaStore.instance.normalKatSayisi;
    final int bodrumKat = BinaStore.instance.bodrumKatSayisi;
    final bool isTekKatli = (normalKat == 0 && bodrumKat == 0);

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Merdivenler",
            subtitle: "Bölüm 20: Çıkış İmkanları",
            currentStep: 20, // Adım sayısını genel akışa göre güncelleyebilirsiniz
            totalSteps: 20,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isTekKatli) _buildTekKatliUI() else _buildCokKatliUI(bodrumKat > 0),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  // --- DURUM A: TEK KATLI BİNA UI ---
  Widget _buildTekKatliUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("TEK KATLI BİNA ÇIKIŞI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A237E))),
        const SizedBox(height: 10),
        const Text("Binanız tek katlı olduğu için, dışarıya (sokağa/bahçeye) çıkışınız nasıl?", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        SelectableCard(
          title: "A) Düz ayak çıkılıyor.",
          subtitle: "✅ OLUMLU GÖRÜNÜYOR (Zeminle aynı seviyede).",
          value: TekKatCikisSecim.duzAyak,
          groupValue: _model.resTekKatCikis,
          onChanged: (val) => setState(() => _model = _model.copyWith(resTekKatCikis: val)),
        ),
        SelectableCard(
          title: "B) Çıkışta Rampa var.",
          subtitle: "Eğimli yol mevcut.",
          value: TekKatCikisSecim.rampa,
          groupValue: _model.resTekKatCikis,
          onChanged: (val) => setState(() => _model = _model.copyWith(resTekKatCikis: val)),
        ),
        SelectableCard(
          title: "C) Çıkışta merdiven var.",
          subtitle: "Birkaç basamak mevcut.",
          value: TekKatCikisSecim.merdiven,
          groupValue: _model.resTekKatCikis,
          onChanged: (val) => setState(() => _model = _model.copyWith(resTekKatCikis: val)),
        ),
      ],
    );
  }

  // --- DURUM B: ÇOK KATLI BİNA UI ---
  Widget _buildCokKatliUI(bool hasBodrum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("MERDİVEN TİPLERİ VE SAYILARI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A237E))),
        const SizedBox(height: 10),
        const Text("Binanızda aşağıdaki merdiven türlerinden kaçar tane var? (Yoksa boş bırakınız)", style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 20),

        _buildCounterInput("1. Normal Apartman Merdiveni", "Günlük kullanılan ana merdiven.", _cNormal, (v) => _model = _model.copyWith(cntNormalMerdiven: int.tryParse(v) ?? 0)),
        _buildCounterInput("2. Bina İçi 'Kapalı' Yangın Merdiveni", "Betonarme, duvarlarla kapalı.", _cYanginBeton, (v) => _model = _model.copyWith(cntYanginMerdiveniBeton: int.tryParse(v) ?? 0)),
        _buildCounterInput("3. Bina Dışı 'Kapalı' Yangın Merdiveni", "Çelik, etrafı kapatılmış.", _cYanginCelik, (v) => _model = _model.copyWith(cntYanginMerdiveniCelik: int.tryParse(v) ?? 0)),
        _buildCounterInput("4. Bina Dışı 'Açık' Çelik Merdiven", "Dış cepheye asılı, açıkta.", _cDisCelik, (v) => _model = _model.copyWith(cntDisCelikMerdiven: int.tryParse(v) ?? 0)),
        _buildCounterInput("5. Döner (Spiral) Merdiven", "Yuvarlak, dönerek inilen.", _cDoner, (v) => _model = _model.copyWith(cntDonerMerdiven: int.tryParse(v) ?? 0)),
        _buildCounterInput("6. Sahanlıksız Merdiven", "Düz sahanlığı olmayan, dönemeçli.", _cSahanliksiz, (v) => _model = _model.copyWith(cntSahanliksizMerdiven: int.tryParse(v) ?? 0)),

        const Divider(height: 40),
        
        if (hasBodrum) ...[
          const Text("BODRUM DEVAMLILIĞI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          const SizedBox(height: 10),
          const Text("Bodrum kata inen merdiveniniz, üst katlara çıkan merdivenin devamı mı?", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 15),
          SelectableCard(
            title: "A) Evet, devam ediyor.",
            value: BodrumDevamSecim.evetDevam,
            groupValue: _model.resBodrumMerdivenDevam,
            onChanged: (val) => setState(() => _model = _model.copyWith(resBodrumMerdivenDevam: val)),
          ),
          SelectableCard(
            title: "B) Hayır, farklı yerde.",
            value: BodrumDevamSecim.hayirAyri,
            groupValue: _model.resBodrumMerdivenDevam,
            onChanged: (val) => setState(() => _model = _model.copyWith(resBodrumMerdivenDevam: val)),
          ),
          const SizedBox(height: 20),
        ],

        const Text("RAMPA KULLANIMI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 10),
        const Text("Binadan sokağa çıkarken merdiven yerine rampa (eğimli yol) kullanılıyor mu?", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _buildRadioBtn("Evet", RampaSecim.evet)),
            const SizedBox(width: 10),
            Expanded(child: _buildRadioBtn("Hayır", RampaSecim.hayir)),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterInput(String title, String subtitle, TextEditingController ctrl, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (val) {
                setState(() {
                  onChanged(val);
                });
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "0",
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioBtn(String title, RampaSecim val) {
    bool isSelected = _model.resRampaVarMi == val;
    return GestureDetector(
      onTap: () => setState(() => _model = _model.copyWith(resRampaVarMi: val)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A237E) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
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
            onPressed: _onNextPressed,
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }
}