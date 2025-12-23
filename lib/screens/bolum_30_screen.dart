import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_30_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_31_screen.dart';

class Bolum30Screen extends StatefulWidget {
  const Bolum30Screen({super.key});

  @override
  State<Bolum30Screen> createState() => _Bolum30ScreenState();
}

class _Bolum30ScreenState extends State<Bolum30Screen> {
  Bolum30Model _model = Bolum30Model();
  bool _isSkipped = false;

  final TextEditingController _alanCtrl = TextEditingController();
  final TextEditingController _gucCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // KONTROL: Kazan dairesi yoksa atla
    final bool hasKazan = BinaStore.instance.bolum7?.hasKazanDairesi ?? false;
    if (!hasKazan) {
      _isSkipped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed(); 
      });
    }

    if (BinaStore.instance.bolum30 != null) {
      _model = BinaStore.instance.bolum30!;
      if (_model.valKazanAlan != null) _alanCtrl.text = _model.valKazanAlan.toString();
      if (_model.valKazanGuc != null) _gucCtrl.text = _model.valKazanGuc.toString();
    }
  }

  @override
  void dispose() {
    _alanCtrl.dispose();
    _gucCtrl.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (!_isSkipped) {
      BinaStore.instance.bolum30 = _model;
      print("Bölüm 30 Kaydedildi. Büyük Kazan mı?: ${_model.isBuyukKazan}");
    } else {
      print("Bölüm 30 Atlandı (Kazan Yok).");
    }
    
    // VERİ GİRİŞİ BİTTİ - RAPOR EKRANINA GİDİŞ
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum31Screen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tebrikler! Tüm veri girişi tamamlandı.")));
  }

  @override
  Widget build(BuildContext context) {
    if (_isSkipped) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kazan Dairesi",
            subtitle: "Bölüm 30: Isı Merkezi Güvenliği",
            currentStep: 30,
            totalSteps: 30,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: KONUM
                  const Text("ADIM-1: KONUM", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Kazan dairesinin konumu ve kapısının açıldığı yer nasıl?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Koridora veya hole açılıyor.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKazanKonum,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKonum: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Direkt merdiven boşluğuna açılıyor.",
                          subtitle: "🚨 KRİTİK RİSK: Yasaktır.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Kazan dairesi kapısı ASLA doğrudan merdiven boşluğuna açılamaz!"),
                          groupValue: _model.resKazanKonum,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKonum: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Binadan ayrı (bahçede).",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "C", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKazanKonum,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKonum: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Kazan dairesinin kapısının nereye açıldığı bilinmiyor."),
                          groupValue: _model.resKazanKonum,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKonum: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2: KAPASİTE
                  const Divider(height: 40),
                  const Text("ADIM-2: ALAN VE KAPASİTE", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Kazan dairesinin büyüklüğünü nasıl girmek istersiniz?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<KazanKapasiteYontem>(
                          title: "Tahmini Seçim (Kutucuklar)",
                          value: KazanKapasiteYontem.tahmini,
                          groupValue: _model.resKazanKapasiteYontem,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKapasiteYontem: val)),
                        ),
                        SelectableCard<KazanKapasiteYontem>(
                          title: "Net Değer Girişi (Sayısal)",
                          value: KazanKapasiteYontem.sayisal,
                          groupValue: _model.resKazanKapasiteYontem,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKapasiteYontem: val)),
                        ),
                        
                        if (_model.resKazanKapasiteYontem == KazanKapasiteYontem.tahmini) ...[
                          const Divider(),
                          const Text("Alan 100 m²'den büyük mü?", style: TextStyle(fontWeight: FontWeight.bold)),
                          _buildSubOption("Evet (>100m²)", "Büyük Kazan", "A1", _model.resKazanTahminAlan, (v) => setState(() => _model = _model.copyWith(resKazanTahminAlan: v))),
                          _buildSubOption("Hayır (<100m²)", "Küçük Kazan", "A2", _model.resKazanTahminAlan, (v) => setState(() => _model = _model.copyWith(resKazanTahminAlan: v))),
                          _buildSubOption("Bilmiyorum", "Bilinmiyor", "A3", _model.resKazanTahminAlan, (v) => setState(() => _model = _model.copyWith(resKazanTahminAlan: v))),
                          
                          const SizedBox(height: 10),
                          const Text("Kapasite 350 kW'tan fazla mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                          _buildSubOption("Evet (>350kW)", "Yüksek Kapasite", "B1", _model.resKazanTahminGuc, (v) => setState(() => _model = _model.copyWith(resKazanTahminGuc: v))),
                          _buildSubOption("Hayır (<350kW)", "Düşük Kapasite", "B2", _model.resKazanTahminGuc, (v) => setState(() => _model = _model.copyWith(resKazanTahminGuc: v))),
                          _buildSubOption("Bilmiyorum", "Bilinmiyor", "B3", _model.resKazanTahminGuc, (v) => setState(() => _model = _model.copyWith(resKazanTahminGuc: v))),
                        ],

                        if (_model.resKazanKapasiteYontem == KazanKapasiteYontem.sayisal) ...[
                          const Divider(),
                          TextField(
                            controller: _alanCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Alan (m²)", border: OutlineInputBorder()),
                            onChanged: (v) => setState(() => _model = _model.copyWith(valKazanAlan: double.tryParse(v))),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _gucCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Kapasite (kW)", border: OutlineInputBorder()),
                            onChanged: (v) => setState(() => _model = _model.copyWith(valKazanGuc: double.tryParse(v))),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ADIM-3: KAPI SAYISI
                  const Divider(height: 40),
                  const Text("ADIM-3: KAPI SAYISI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Kazan dairesinin kaç adet çıkış kapısı var?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) 1 Adet Kapı.",
                          subtitle: _model.isBuyukKazan ? "🚨 RİSK: Büyük kazanlarda 2 kapı şart." : "✅ OLUMLU",
                          value: ChoiceResult(label: "A", reportText: _model.isBuyukKazan ? "🚨 KRİTİK RİSK. Büyük kazan dairelerinde EN AZ 2 adet çıkış kapısı zorunludur." : "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKazanKapiSayisi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKapiSayisi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) 2 Adet (veya daha fazla).",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKazanKapiSayisi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKapiSayisi: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Kapı sayısı bilinmiyor."),
                          groupValue: _model.resKazanKapiSayisi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanKapiSayisi: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-4: HAVALANDIRMA
                  const Divider(height: 40),
                  const Text("ADIM-4: HAVALANDIRMA", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("İçeriye temiz hava girmesini ve kirli havanın çıkmasını sağlayan menfezler var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Evet, altta ve üstte menfezler var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKazanHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanHavalandirma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Hayır, sadece pencere var veya yok.",
                          subtitle: "🚨 RİSK: Zehirlenme tehlikesi.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KIRMIZI RİSK. Temiz hava girişi ve kirli hava çıkışı sağlanmazsa karbonmonoksit zehirlenmesi riski doğar."),
                          groupValue: _model.resKazanHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanHavalandirma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Havalandırma durumu bilinmiyor."),
                          groupValue: _model.resKazanHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanHavalandirma: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-5: DRENAJ (SIVI YAKIT)
                  const Divider(height: 40),
                  const Text("ADIM-5: YAKIT TİPİ VE DRENAJ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Kazanınız sıvı yakıtlı (Mazot/Fuel-oil) mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, Doğalgazlı veya Kömürlü.",
                          value: ChoiceResult(label: "A", reportText: "Sıvı yakıt değil."),
                          groupValue: _model.resKazanYakitTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanYakitTipi: val, resKazanDrenaj: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, Sıvı Yakıtlı.",
                          value: ChoiceResult(label: "B", reportText: "Sıvı yakıtlı."),
                          groupValue: _model.resKazanYakitTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanYakitTipi: val)),
                        ),
                        if (_model.resKazanYakitTipi?.label == "B") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Zeminde drenaj kanalı ve pis su çukuru var mı?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Evet.", "✅ OLUMLU", "A", _model.resKazanDrenaj, (v) => setState(() => _model = _model.copyWith(resKazanDrenaj: v))),
                          _buildSubOption("Hayır.", "⚠️ UYARI: Sızıntı riski.", "B", _model.resKazanDrenaj, (v) => setState(() => _model = _model.copyWith(resKazanDrenaj: v))),
                          _buildSubOption("Bilmiyorum.", "❓ BİLİNMİYOR", "C", _model.resKazanDrenaj, (v) => setState(() => _model = _model.copyWith(resKazanDrenaj: v))),
                        ],
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Yakıt tipi bilinmiyor."),
                          groupValue: _model.resKazanYakitTipi,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanYakitTipi: val, resKazanDrenaj: null)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-6: YANGIN SÖNDÜRME
                  const Divider(height: 40),
                  const Text("ADIM-6: YANGIN SÖNDÜRME CİHAZLARI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text("Kazan dairesinde yangın söndürme tüpü ve yangın dolabı var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SelectableCard<ChoiceResult>(
                          title: "A) Evet, 6kg'lık tüp var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKazanYanginTupu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanYanginTupu: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, tüp ve yangın dolabı var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKazanYanginTupu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanYanginTupu: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Hayır, hiçbiri yok.",
                          subtitle: "🚨 KRİTİK RİSK: Zorunludur.",
                          value: ChoiceResult(label: "C", reportText: "🚨 KRİTİK RİSK. Kazan dairesinde EN AZ 1 adet 6 kg'lık tüp bulunması yasal zorunluluktur."),
                          groupValue: _model.resKazanYanginTupu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanYanginTupu: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Yangın söndürme cihazı varlığı bilinmiyor."),
                          groupValue: _model.resKazanYanginTupu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKazanYanginTupu: val)),
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

  Widget _buildSubOption(String text, String subText, String label, ChoiceResult? group, Function(ChoiceResult) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: SelectableCard(
        title: text,
        subtitle: subText,
        value: ChoiceResult(label: label, reportText: subText),
        groupValue: group,
        onChanged: (v) => onSelected(v!),
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
    if (_isSkipped) return true;
    if (_model.resKazanKonum == null) return false;
    if (_model.resKazanKapasiteYontem == null) return false;
    
    if (_model.resKazanKapasiteYontem == KazanKapasiteYontem.tahmini) {
      if (_model.resKazanTahminAlan == null || _model.resKazanTahminGuc == null) return false;
    } else {
      if (_model.valKazanAlan == null || _model.valKazanGuc == null) return false;
    }

    if (_model.resKazanKapiSayisi == null) return false;
    if (_model.resKazanHavalandirma == null) return false;
    if (_model.resKazanYakitTipi == null) return false;
    if (_model.resKazanYakitTipi?.label == "B" && _model.resKazanDrenaj == null) return false;
    if (_model.resKazanYanginTupu == null) return false;

    return true;
  }
}