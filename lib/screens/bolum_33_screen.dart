import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_10_model.dart'; // Katsayılar için
import 'package:life_safety/models/bolum_20_model.dart'; // Merdiven sayıları için
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_34_screen.dart';

class Bolum33Screen extends StatefulWidget {
  const Bolum33Screen({super.key});

  @override
  State<Bolum33Screen> createState() => _Bolum33ScreenState();
}

class _Bolum33ScreenState extends State<Bolum33Screen> {
  Bolum33Model _model = Bolum33Model();
  
  final TextEditingController _zeminAlanCtrl = TextEditingController();
  final TextEditingController _normalAlanCtrl = TextEditingController();
  final TextEditingController _bodrumAlanCtrl = TextEditingController();

  bool _isCalculated = false; // Hesapla butonuna basıldı mı?

  @override
  void initState() {
    super.initState();
    // Önceki verileri yükle (Varsa)
    if (BinaStore.instance.bolum33 != null) {
      _model = BinaStore.instance.bolum33!;
      if (_model.valAlanZemin != null) _zeminAlanCtrl.text = _model.valAlanZemin.toString();
      if (_model.valAlanNormal != null) _normalAlanCtrl.text = _model.valAlanNormal.toString();
      if (_model.valAlanBodrum != null) _bodrumAlanCtrl.text = _model.valAlanBodrum.toString();
      if (_model.resRaporZemin != null) _isCalculated = true;
    }
  }

  @override
  void dispose() {
    _zeminAlanCtrl.dispose();
    _normalAlanCtrl.dispose();
    _bodrumAlanCtrl.dispose();
    super.dispose();
  }

  // --- HESAPLAMA MOTORU ---
  void _calculate() {
    // 1. Girdileri Al
    final double alanZemin = double.tryParse(_zeminAlanCtrl.text) ?? 0;
    final double alanNormal = double.tryParse(_normalAlanCtrl.text) ?? 0;
    final double alanBodrum = double.tryParse(_bodrumAlanCtrl.text) ?? 0;

    if (alanZemin <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen zemin kat alanını giriniz.")));
      return;
    }

    // 2. Katsayıları Al (Bölüm 10'dan)
    final b10 = BinaStore.instance.bolum10;
    double katsayiZemin = b10?.kullanimZemin?.katsayi ?? 10.0;
    
    // Normal katlar için en yoğun kullanımı (en küçük katsayıyı) baz alıyoruz (Güvenlik payı)
    double katsayiNormal = 10.0;
    if (b10?.kullanimNormal.isNotEmpty == true) {
       // Listeden en küçük katsayıyı bul (En yoğun kullanım)
       katsayiNormal = b10!.kullanimNormal
           .where((e) => e != null)
           .map((e) => e!.katsayi)
           .reduce((curr, next) => curr < next ? curr : next);
    }

    double katsayiBodrum = 30.0; // Varsayılan teknik
    if (b10?.kullanimBodrum.isNotEmpty == true) {
       katsayiBodrum = b10!.kullanimBodrum
           .where((e) => e != null)
           .map((e) => e!.katsayi)
           .reduce((curr, next) => curr < next ? curr : next);
    }

    // 3. Yük Hesabı (Kişi Sayısı)
    int yukZemin = (alanZemin / katsayiZemin).ceil();
    int yukNormal = (alanNormal / katsayiNormal).ceil();
    int yukBodrum = (alanBodrum / katsayiBodrum).ceil();

    // 4. Gerekli Çıkış Sayısı Hesabı
    int getRequiredExits(int load) {
      if (load > 1000) return 4;
      if (load > 500) return 3;
      if (load > 50) return 2;
      return 1;
    }

    int rekZemin = getRequiredExits(yukZemin);
    int rekNormal = getRequiredExits(yukNormal);
    int rekBodrum = getRequiredExits(yukBodrum);

    // 5. Mevcut Çıkışları Al (Bölüm 20'den)
    final b20 = BinaStore.instance.bolum20;
    int mevcutUst = b20?.toplamMerdivenSayisi ?? 1; // En az 1 varsayalım
    
    // Bodrum merdiveni devam ediyorsa üsttekilerle aynı, etmiyorsa ayrı sayılmalı.
    // Basitleştirme: Bodrum devam ediyorsa mevcutUst ile aynı kabul ediyoruz.
    int mevcutBodrum = (b20?.resBodrumMerdivenDevam == BodrumDevamSecim.evetDevam) 
        ? mevcutUst 
        : (mevcutUst > 0 ? 1 : 0); // Ayrıysa en az 1 varsayalım veya kullanıcıya sormak gerekirdi.

    // 6. Rapor Mesajlarını Oluştur
    String msgNormal = mevcutUst >= rekNormal 
        ? "✅ Normal katlardaki çıkış sayısı yeterli." 
        : "🚨 Normal katlarda kullanıcı yüküne göre $rekNormal çıkış gerekirken, sadece $mevcutUst çıkış var. YETERSİZ.";
    
    String msgZemin = mevcutUst >= rekZemin 
        ? "✅ Zemin kat çıkış kapasitesi uygun görünüyor." 
        : "⚠️ Zemin kattaki yoğunluk nedeniyle $rekZemin adet bağımsız çıkış kapısı gerekmektedir.";

    String msgBodrum = mevcutBodrum >= rekBodrum 
        ? "✅ Bodrum katlardaki çıkış sayısı yeterli." 
        : "🚨 Bodrum katlarda kullanıcı yüküne göre $rekBodrum çıkış gerekirken, bodruma inen sadece $mevcutBodrum adet merdiven var. YETERSİZ.";

    // 7. Kaydet ve Güncelle
    setState(() {
      _model = Bolum33Model(
        valAlanZemin: alanZemin,
        valAlanNormal: alanNormal,
        valAlanBodrum: alanBodrum,
        calcYukZemin: yukZemin,
        calcYukNormal: yukNormal,
        calcYukBodrum: yukBodrum,
        calcGerekliCikisZemin: rekZemin,
        calcGerekliCikisNormal: rekNormal,
        calcGerekliCikisBodrum: rekBodrum,
        valMevcutCikisUst: mevcutUst,
        valMevcutCikisBodrum: mevcutBodrum,
        resRaporZemin: msgZemin,
        resRaporNormal: msgNormal,
        resRaporBodrum: msgBodrum,
      );
      _isCalculated = true;
    });
  }

  void _onNextPressed() {
    BinaStore.instance.bolum33 = _model;
    print("Bölüm 33 Kaydedildi.");
    
    // FİNAL: SONUÇ EKRANINA GİT
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum34Screen()));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ANALİZ TAMAMLANDI! Rapor oluşturuluyor...")));
  }

  @override
  Widget build(BuildContext context) {
    final int normalKat = BinaStore.instance.normalKatSayisi;
    final int bodrumKat = BinaStore.instance.bodrumKatSayisi;
    final double? hintAlanBrut = BinaStore.instance.bolum5?.alanKatBrut;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kullanıcı Yükü",
            subtitle: "Bölüm 33: Kapasite Hesabı",
            currentStep: 33, // Final adım
            totalSteps: 33,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("ADIM-1: KAT ALANLARININ GİRİLMESİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  
                  // ZEMİN KAT
                  _buildDecimalField(
                    "Zemin Kat Alanı (m²)", 
                    _zeminAlanCtrl, 
                    hint: hintAlanBrut != null ? "Brüt: $hintAlanBrut m²" : null
                  ),
                  
                  // NORMAL KAT
                  if (normalKat > 0)
                    _buildDecimalField("En Büyük Normal Kat Alanı (m²)", _normalAlanCtrl),

                  // BODRUM KAT
                  if (bodrumKat > 0)
                    _buildDecimalField("En Büyük Bodrum Kat Alanı (m²)", _bodrumAlanCtrl),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text("HESAPLA VE ANALİZ ET"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade800,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  // SONUÇ EKRANI (Hesaplandıysa Göster)
                  if (_isCalculated) ...[
                    const Divider(height: 40),
                    const Text("📊 KAÇIŞ KAPASİTESİ ANALİZİ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),

                    if (normalKat > 0)
                      _buildResultCard(
                        "NORMAL KATLAR", 
                        _model.calcYukNormal, 
                        _model.calcGerekliCikisNormal, 
                        _model.valMevcutCikisUst, 
                        _model.resRaporNormal
                      ),

                    _buildResultCard(
                      "ZEMİN KAT", 
                      _model.calcYukZemin, 
                      _model.calcGerekliCikisZemin, 
                      _model.valMevcutCikisUst, // Zemin için de üst kat merdivenleri referans
                      _model.resRaporZemin
                    ),

                    if (bodrumKat > 0)
                      _buildResultCard(
                        "BODRUM KATLAR", 
                        _model.calcYukBodrum, 
                        _model.calcGerekliCikisBodrum, 
                        _model.valMevcutCikisBodrum, 
                        _model.resRaporBodrum
                      ),
                  ],
                ],
              ),
            ),
          ),
          
          // FİNAL BUTONU
          if (_isCalculated)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onNextPressed,
                    child: const Text("RAPORU OLUŞTUR"),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDecimalField(String label, TextEditingController ctrl, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: "m²",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, int? yuk, int? gerekli, int? mevcut, String? mesaj) {
    bool isSuccess = mesaj?.startsWith("✅") ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSuccess ? Colors.green.shade200 : Colors.red.shade200),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          _buildRow("Tahmini Kişi Sayısı:", "$yuk Kişi"),
          _buildRow("Gereken Çıkış:", "$gerekli Adet"),
          _buildRow("Mevcut Çıkış:", "$mevcut Adet"),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              mesaj ?? "",
              style: TextStyle(
                color: isSuccess ? Colors.green.shade900 : Colors.red.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}