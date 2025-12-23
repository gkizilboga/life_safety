import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
// import 'package:life_safety/screens/sonuc_ekrani.dart'; // FİNAL

class Bolum36Screen extends StatefulWidget {
  const Bolum36Screen({super.key});

  @override
  State<Bolum36Screen> createState() => _Bolum36ScreenState();
}

class _Bolum36ScreenState extends State<Bolum36Screen> {
  Bolum36Model _model = Bolum36Model();
  
  final TextEditingController _koridorGenislikCtrl = TextEditingController();
  final TextEditingController _kapiGenislikCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _performPreCalculation(); // Ön Hesaplama

    if (BinaStore.instance.bolum36 != null) {
      _model = BinaStore.instance.bolum36!;
      if (_model.valKoridorGenislik != null) _koridorGenislikCtrl.text = _model.valKoridorGenislik.toString();
      if (_model.valCikisKapiGenislik != null) _kapiGenislikCtrl.text = _model.valCikisKapiGenislik.toString();
    }
  }

  @override
  void dispose() {
    _koridorGenislikCtrl.dispose();
    _kapiGenislikCtrl.dispose();
    super.dispose();
  }

  // ADIM-0: ÖN HESAPLAMA
  void _performPreCalculation() {
    final b20 = BinaStore.instance.bolum20;
    final b4 = BinaStore.instance.bolum4;

    if (b20 == null || b4 == null) return;

    // 1. Döner Merdiven Kontrolü
    int validDoner = b20.cntDonerMerdiven;
    bool isDonerElendi = false;
    if (b4.isLimitBina0950) { // Bina > 9.50m
      validDoner = 0;
      isDonerElendi = b20.cntDonerMerdiven > 0;
    }

    // 2. Dış Açık Çelik Merdiven Kontrolü
    int validDisCelik = b20.cntDisCelikMerdiven;
    bool isDisCelikElendi = false;
    if (b4.isLimitBina2150) { // Bina > 21.50m
      validDisCelik = 0;
      isDisCelikElendi = b20.cntDisCelikMerdiven > 0;
    }

    // 3. Toplam Hesaplama
    int toplamCikis = b20.cntNormalMerdiven + 
                      b20.cntYanginMerdiveniBeton + 
                      b20.cntYanginMerdiveniCelik + 
                      validDoner + 
                      validDisCelik;

    setState(() {
      _model = _model.copyWith(
        calcToplamCikisSayisi: toplamCikis,
        isDonerMerdivenElendi: isDonerElendi,
        isDisCelikMerdivenElendi: isDisCelikElendi,
      );
    });
  }

  void _onNextPressed() {
    if (!_isFormValid()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ EKSİK BİLGİ"),
          content: const Text("Lütfen tüm alanları doldurunuz ve seçim yapınız."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))],
        ),
      );
      return;
    }

    BinaStore.instance.bolum36 = _model;
    print("Bölüm 36 Kaydedildi. Toplam Geçerli Çıkış: ${_model.calcToplamCikisSayisi}");
    
    // FİNAL: SONUÇ EKRANINA GİT
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const SonucEkrani()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ANALİZ TAMAMLANDI! Rapor oluşturuluyor...")));
  }

  @override
  Widget build(BuildContext context) {
    final bool isHighBuilding = BinaStore.instance.bolum4?.isGenelYuksekBina ?? false;
    final int disCelikSayisi = BinaStore.instance.bolum20?.cntDisCelikMerdiven ?? 0;
    final bool isLimit2150 = BinaStore.instance.bolum4?.isLimitBina2150 ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kaçış Yolu Kapasitesi",
            subtitle: "Bölüm 36: Genişlik ve Sayı Kontrolü",
            currentStep: 36,
            totalSteps: 36,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-0: OTOMATİK BİLGİLENDİRME
                  if (_model.isDonerMerdivenElendi == true || _model.isDisCelikMerdivenElendi == true)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.orange),
                              SizedBox(width: 10),
                              Expanded(child: Text("DİKKAT: BAZI MERDİVENLERİNİZ ÇIKIŞ SAYILMADI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Yönetmelik gereği bina yüksekliğinizden dolayı;\n"
                            "${_model.isDonerMerdivenElendi == true ? '• Döner merdivenleriniz,\n' : ''}"
                            "${_model.isDisCelikMerdivenElendi == true ? '• Dışarıdaki açık çelik merdivenleriniz,\n' : ''}"
                            "Yasal Kaçış Yolu (Çıkış) olarak hesaba katılmamıştır.",
                            style: TextStyle(fontSize: 13, color: Colors.orange.shade900),
                          ),
                        ],
                      ),
                    ),

                  // ADIM-1: DIŞ KAÇIŞ MERDİVENİ
                  if (disCelikSayisi > 0) ...[
                    const Text("ADIM-1: DIŞ KAÇIŞ MERDİVENİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),
                    
                    if (isLimit2150)
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                        child: const Text("🚨 KRİTİK RİSK: Yönetmeliğe göre bina yüksekliği 21.50 metreden fazla olan binalarda, bina dışında açık kaçış merdivenlerine izin verilmez.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),

                    QuestionCard(
                      child: Column(
                        children: [
                          const Text("Dışarıdaki yangın merdivenine 3 metre mesafede pencere veya kapı var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Hayır, duvarlar sağır.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resDisMerdivenMesafe,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDisMerdivenMesafe: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Evet, pencere/kapı var.",
                            subtitle: "🚨 RİSK: Alev sıçrayabilir.",
                            value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Açık dış kaçış merdiveninin 3 metre yakınında korunumsuz pencere veya kapı bulunamaz."),
                            groupValue: _model.resDisMerdivenMesafe,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDisMerdivenMesafe: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Dış merdiven çevresindeki açıklıklar bilinmiyor."),
                            groupValue: _model.resDisMerdivenMesafe,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resDisMerdivenMesafe: val)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 40),
                  ],

                  // ADIM-2: MERDİVEN KONUMU
                  if ((_model.calcToplamCikisSayisi ?? 0) > 1) ...[
                    const Text("ADIM-2: MERDİVEN KONUMU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text("Kaçış merdivenleri birbirine göre nasıl konumlanmış?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Birbirlerine uzaklar (Zıt uçlar).",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resMerdivenKonum,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resMerdivenKonum: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Yan yanalar veya çok yakınlar.",
                            subtitle: "🚨 KRİTİK RİSK: Alternatif sayılmaz.",
                            value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Yan yana yapılan merdivenler 'Alternatif Çıkış' sayılmaz."),
                            groupValue: _model.resMerdivenKonum,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resMerdivenKonum: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Merdiven konumları net değil."),
                            groupValue: _model.resMerdivenKonum,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resMerdivenKonum: val)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 40),
                  ],

                  // ADIM-3: KORİDOR GENİŞLİĞİ
                  const Text("ADIM-3: KORİDOR VE MERDİVEN GENİŞLİĞİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Merdiveninizin ve ona giden koridorun temiz genişliği kaç cm?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _koridorGenislikCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Genişlik (cm)", border: OutlineInputBorder()),
                          onChanged: (v) => setState(() => _model = _model.copyWith(valKoridorGenislik: double.tryParse(v))),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-4: ÇIKIŞ KAPISI
                  const Divider(height: 40),
                  const Text("ADIM-4: ÇIKIŞ KAPISI TÜRÜ VE GENİŞLİĞİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Çıkış kapınızın tipi nedir?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<CikisKapiTipi>(
                          title: "A) Tek Kanatlı Kapı.",
                          value: CikisKapiTipi.tekKanat,
                          groupValue: _model.resCikisKapiTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCikisKapiTipi: val)),
                        ),
                        SelectableCard<CikisKapiTipi>(
                          title: "B) Çift Kanatlı Kapı.",
                          value: CikisKapiTipi.ciftKanat,
                          groupValue: _model.resCikisKapiTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCikisKapiTipi: val)),
                        ),
                        const SizedBox(height: 15),
                        const Text("Kapı tam açıldığında net geçiş genişliği kaç cm?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _kapiGenislikCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Genişlik (cm)", border: OutlineInputBorder()),
                          onChanged: (v) => setState(() => _model = _model.copyWith(valCikisKapiGenislik: double.tryParse(v))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid() ? _onNextPressed : null,
            child: const Text("ANALİZİ TAMAMLA"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    final int disCelikSayisi = BinaStore.instance.bolum20?.cntDisCelikMerdiven ?? 0;
    
    if (disCelikSayisi > 0 && _model.resDisMerdivenMesafe == null) return false;
    if ((_model.calcToplamCikisSayisi ?? 0) > 1 && _model.resMerdivenKonum == null) return false;
    if (_model.valKoridorGenislik == null) return false;
    if (_model.resCikisKapiTipi == null) return false;
    if (_model.valCikisKapiGenislik == null) return false;

    return true;
  }
}