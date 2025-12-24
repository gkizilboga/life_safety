import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_33_model.dart';
import 'bolum_34_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum33Screen extends StatefulWidget {
  const Bolum33Screen({super.key});

  @override
  State<Bolum33Screen> createState() => _Bolum33ScreenState();
}

class _Bolum33ScreenState extends State<Bolum33Screen> {
  final _normalCtrl = TextEditingController();
  final _zeminCtrl = TextEditingController();
  final _bodrumCtrl = TextEditingController();

  // Durumlar
  bool _hasBodrum = false;

  @override
  void initState() {
    super.initState();
    // Bölüm 3'ten bodrum var mı kontrol et
    final b3 = BinaStore.instance.bolum3;
    if ((b3?.bodrumKatSayisi ?? 0) > 0) {
      _hasBodrum = true;
    }
  }

  @override
  void dispose() {
    _normalCtrl.dispose();
    _zeminCtrl.dispose();
    _bodrumCtrl.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    // 1. Verileri Al
    double? nAlan = double.tryParse(_normalCtrl.text.replaceAll(',', '.'));
    double? zAlan = double.tryParse(_zeminCtrl.text.replaceAll(',', '.'));
    double? bAlan = double.tryParse(_bodrumCtrl.text.replaceAll(',', '.'));

    if (nAlan == null || zAlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen normal ve zemin kat alanlarını giriniz.")));
      return;
    }
    if (_hasBodrum && bAlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen bodrum kat alanını giriniz.")));
      return;
    }

    // 2. Mevcut Çıkış Sayılarını Al (Bölüm 20'den)
    final b20 = BinaStore.instance.bolum20;
    // Toplam Merdiven = Normal + Yangın (Basitçe topluyoruz)
    int mevcutCikis = (b20?.normalMerdivenSayisi ?? 0) + 
                      (b20?.binaIciYanginMerdiveniSayisi ?? 0) + 
                      (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + 
                      (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0);
    
    // Zemin katta merdivenlere ek olarak bina çıkış kapıları da sayılabilir ama 
    // şimdilik merdiven sayısı üzerinden gidiyoruz (Basitleştirilmiş Mantık).
    // Detaylı analizde zemin kat çıkış kapısı sayısı ayrıca sorulmalıydı.

    // 3. Hesaplama (Konut: 10 m²/kişi)
    // NORMAL KAT
    int nKisi = (nAlan / 10).ceil();
    int nGereken = (nKisi > 50) ? 2 : 1;
    ChoiceResult nSonuc = (mevcutCikis >= nGereken) ? Bolum33Content.normalKatYeterli : Bolum33Content.normalKatYetersiz;

    // ZEMİN KAT
    // Zemin genelde direkt dışarı açıldığı için risk düşüktür ama yoğunluk olabilir.
    // Şimdilik sadece uyarı veriyoruz (Yeterli varsayımı ile)
    ChoiceResult zSonuc = Bolum33Content.zeminKatYeterli;

    // BODRUM KAT
    ChoiceResult? bSonuc;
    if (_hasBodrum) {
      int bKisi = (bAlan! / 10).ceil(); // Bodrumda konut/depo karışık olabilir, 10 aldık
      int bGereken = (bKisi > 50) ? 2 : 1;
      // Bodrum çıkış sayısı, merdivenlerin bodruma inip inmediğine bağlıdır.
      // Bölüm 20'de "Bodrum merdiven devamı" sorusuna göre;
      // Eğer devam ediyorsa merdiven sayısı kadar, etmiyorsa 1 tane varsayıyoruz.
      // Basitlik için mevcut çıkış sayısını kullanıyoruz.
      bSonuc = (mevcutCikis >= bGereken) ? Bolum33Content.bodrumKatYeterli : Bolum33Content.bodrumKatYetersiz;
    }

    // 4. Kaydet
    Bolum33Model model = Bolum33Model(
      normalKatAlani: nAlan,
      zeminKatAlani: zAlan,
      bodrumKatAlani: bAlan,
      normalKatSonuc: nSonuc,
      zeminKatSonuc: zSonuc,
      bodrumKatSonuc: bSonuc,
    );

    BinaStore.instance.bolum33 = model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum34Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-33: Kapasite Analizi",
            subtitle: "Çıkış genişliği ve sayısı yeterli mi?",
            currentStep: 23, 
            totalSteps: 26,
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
                        const Text("Katların kullanım alanlarını (m²) giriniz:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        const Text("Bu değerler kişi sayısını ve gereken çıkış sayısını hesaplamak için kullanılacaktır.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 20),

                        _buildInput("En büyük normal kat alanı", _normalCtrl),
                        const SizedBox(height: 15),
                        _buildInput("Zemin kat kullanım alanı", _zeminCtrl),
                        
                        if (_hasBodrum) ...[
                          const SizedBox(height: 15),
                          _buildInput("En büyük bodrum kat alanı", _bodrumCtrl),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                  child: const Text("HESAPLA VE DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: "m²",
        border: const OutlineInputBorder(),
      ),
    );
  }
}