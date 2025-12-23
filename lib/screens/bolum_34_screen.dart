import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_10_model.dart'; // Kullanım Amacı Enum
import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult
import 'package:life_safety/models/bolum_34_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_35_screen.dart';
class Bolum34Screen extends StatefulWidget {
  const Bolum34Screen({super.key});

  @override
  State<Bolum34Screen> createState() => _Bolum34ScreenState();
}

class _Bolum34ScreenState extends State<Bolum34Screen> {
  Bolum34Model _model = Bolum34Model();
  bool _isSkipped = false;
  
  // Hangi soruların sorulacağını belirleyen bayraklar
  bool _askZemin = false;
  bool _askBodrum = false;

  @override
  void initState() {
    super.initState();
    _checkConditions();

    if (BinaStore.instance.bolum34 != null) {
      _model = BinaStore.instance.bolum34!;
    }
  }

  void _checkConditions() {
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;
    final int bodrumSayisi = BinaStore.instance.bodrumKatSayisi;

    // 1. GENEL KONTROL: Ticari alan yoksa modülü atla
    if (b6?.hasTicari != true) {
      _isSkipped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed();
      });
      return;
    }

    // 2. ZEMİN KAT KONTROLÜ: Zemin Konut veya Otopark DEĞİLSE (Yani Ticarise) sor
    if (b10?.kullanimZemin != KullanimAmaci.konut && 
        b10?.kullanimZemin != KullanimAmaci.teknikOtopark) {
      _askZemin = true;
    }

    // 3. BODRUM KAT KONTROLÜ: Bodrum var ve içinde Ticari varsa sor
    if (bodrumSayisi > 0 && b10 != null) {
      // Bodrum listesinde ticari var mı kontrol et
      bool bodrumdaTicariVar = b10.kullanimBodrum.any((kullanim) => 
          kullanim == KullanimAmaci.azYogunTicari || 
          kullanim == KullanimAmaci.ortaYogunTicari || 
          kullanim == KullanimAmaci.yuksekYogunTicari);
      
      if (bodrumdaTicariVar) {
        _askBodrum = true;
      }
    }

    // Eğer sorulacak hiçbir soru yoksa yine atla
    if (!_askZemin && !_askBodrum) {
      _isSkipped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed();
      });
    }
  }

  void _onNextPressed() {
    if (!_isSkipped) {
      BinaStore.instance.bolum34 = _model;
      print("Bölüm 34 Kaydedildi.");
    } else {
      print("Bölüm 34 Atlandı (Ticari Alan Yok veya Kriter Dışı).");
    }
    
    // FİNAL: SONUÇ EKRANINA GİT
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum35Screen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ANALİZ TAMAMLANDI! Rapor oluşturuluyor...")));
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
            title: "Ticari Çıkışlar",
            subtitle: "Bölüm 34: Bağımsız Çıkış Kontrolü",
            currentStep: 34,
            totalSteps: 34,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TİCARİ ALANLARIN BAĞIMSIZ ÇIKIŞLARI",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Binanızdaki ticari alanların (dükkan, mağaza vb.) bina ortak alanlarından bağımsız çıkışları olup olmadığını belirleyelim.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 25),

                  // ADIM-1: ZEMİN KAT
                  if (_askZemin) ...[
                    const Text("ADIM-1: ZEMİN KAT TİCARİ ÇIKIŞLARI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text(
                            "Zemin kattaki dükkan, mağaza veya restoranların doğrudan sokağa/bahçeye açılan kendilerine ait kapıları var mı?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, var.",
                            subtitle: "✅ OLUMLU: Bağımsız çıkış.",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR. Zemin kattaki ticari alanların kendi bağımsız çıkışları olduğu için, bina ana girişine ve merdivenlerine ek yük getirmezler. Mevcut çıkışlar yeterlidir."),
                            groupValue: _model.resTicariCikisZemin,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTicariCikisZemin: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, yok.",
                            subtitle: "⚠️ UYARI: Bina girişini kullanıyorlar.",
                            value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Bina ana giriş kapısının genişliği bu ekstra yükü kaldıracak kapasitede olmalıdır."),
                            groupValue: _model.resTicariCikisZemin,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTicariCikisZemin: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir."),
                            groupValue: _model.resTicariCikisZemin,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTicariCikisZemin: val)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 40),
                  ],

                  // ADIM-2: BODRUM KAT
                  if (_askBodrum) ...[
                    const Text("ADIM-2: BODRUM KAT TİCARİ ÇIKIŞLARI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text(
                            "Bodrum kattaki ticari alanların (restaurant, kafe, spor salonu vb.) doğrudan dışarıya çıkan kendilerine ait bir merdiveni veya rampası var mı?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, var.",
                            subtitle: "✅ OLUMLU: Bağımsız çıkış.",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR. Bodrum kattaki ticari kullanımın kendine ait bağımsız kaçış yolu olması büyük avantajdır."),
                            groupValue: _model.resTicariCikisBodrum,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTicariCikisBodrum: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, yok.",
                            subtitle: "🚨 RİSK: Ortak merdiven kullanılıyor.",
                            value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Bodrum kattaki ticari alanın kalabalığı, bina sakinleriyle aynı merdiveni kullanacak. Bu durum kaçış anında merdivende tıkanıklığa yol açabilir."),
                            groupValue: _model.resTicariCikisBodrum,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTicariCikisBodrum: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir."),
                            groupValue: _model.resTicariCikisBodrum,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTicariCikisBodrum: val)),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    if (_isSkipped) return true;
    if (_askZemin && _model.resTicariCikisZemin == null) return false;
    if (_askBodrum && _model.resTicariCikisBodrum == null) return false;
    return true;
  }
}