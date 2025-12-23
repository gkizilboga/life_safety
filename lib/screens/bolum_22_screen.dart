import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_22_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_23_screen.dart';
// import 'package:life_safety/screens/bolum_23_screen.dart'; // Sonraki aşama

class Bolum22Screen extends StatefulWidget {
  const Bolum22Screen({super.key});

  @override
  State<Bolum22Screen> createState() => _Bolum22ScreenState();
}

class _Bolum22ScreenState extends State<Bolum22Screen> {
  Bolum22Model _model = Bolum22Model();
  bool _isSkipped = false; // Bina alçaksa atlama kontrolü

  @override
  void initState() {
    super.initState();
    // KONTROL: Bina 51.50m'den alçaksa bu bölümü atla
    final bool isLimit5150 = BinaStore.instance.bolum4?.isLimitYapi5150 ?? false;
    if (!isLimit5150) {
      _isSkipped = true;
      // Otomatik geçiş için bir sonraki frame'i bekle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed(); 
      });
    }

    // HAFIZA: Veri varsa geri yükle
    if (BinaStore.instance.bolum22 != null) {
      _model = BinaStore.instance.bolum22!;
    }
  }

  void _onNextPressed() {
    if (!_isSkipped) {
      BinaStore.instance.bolum22 = _model;
      print("Bölüm 22 Kaydedildi.");
    } else {
      print("Bölüm 22 Atlandı (Bina < 51.50m).");
    }
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum23Screen()));
  }

  @override
  Widget build(BuildContext context) {
    // Eğer atlanıyorsa boş ekran göster (Hızlı geçiş için)
    if (_isSkipped) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "İtfaiye Asansörü",
            subtitle: "Bölüm 22: Acil Durum Asansörü",
            currentStep: 22,
            totalSteps: 25,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: VARLIK VE KONUM
                  const Text("ADIM-1: İTFAİYE ASANSÖRÜ VARLIĞI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text(
                          "Yapı yüksekliği 51.50 metreyi aştığı için yönetmeliğe göre İtfaiye Asansörü bulunması zorunludur. Binanızda bu asansör var mı?",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, sadece normal asansörler var.",
                          subtitle: "🚨 KRİTİK RİSK: Zorunludur!",
                          value: ChoiceResult(label: "A", reportText: "🚨 KRİTİK RİSK. 51.50 metreden yüksek binalarda İtfaiye Asansörü olması ZORUNLUDUR."),
                          groupValue: _model.resItfaiyeAsansorVar,
                          onChanged: (val) => setState(() => _model = Bolum22Model(resItfaiyeAsansorVar: val)), // Diğerlerini sıfırla
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, var.",
                          value: ChoiceResult(label: "B", reportText: "İtfaiye asansörü mevcut."),
                          groupValue: _model.resItfaiyeAsansorVar,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeAsansorVar: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          subtitle: "❓ BİLİNMİYOR: Yönetimden teyit ediniz.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Binada itfaiye asansörü olup olmadığı bilinmiyor. Yüksek binalarda hayati önem taşır."),
                          groupValue: _model.resItfaiyeAsansorVar,
                          onChanged: (val) => setState(() => _model = Bolum22Model(resItfaiyeAsansorVar: val)), // Diğerlerini sıfırla
                        ),
                      ],
                    ),
                  ),

                  // SADECE "EVET" SEÇİLİRSE DEVAM ET
                  if (_model.resItfaiyeAsansorVar?.label == "B") ...[
                    const Divider(height: 40),
                    const Text("KONUM VE YGH İLİŞKİSİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),
                    
                    // SORU 2: YERİ
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text("Bu İtfaiye Asansörünün kapısı nereye açılıyor?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Doğrudan koridora/lobiye.",
                            subtitle: "🚨 RİSK: Duman kuyuya girer.",
                            value: ChoiceResult(label: "A", reportText: "🚨 RİSK. İtfaiye asansörleri doğrudan koridora açılamaz. YGH'ye açılması zorunludur."),
                            groupValue: _model.resItfaiyeAsansorYeri,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeAsansorYeri: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Yangın Güvenlik Holü'ne (YGH) açılıyor.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resItfaiyeAsansorYeri,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeAsansorYeri: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. İtfaiye asansörünün nereye açıldığı bilinmiyor."),
                            groupValue: _model.resItfaiyeAsansorYeri,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeAsansorYeri: val)),
                          ),
                        ],
                      ),
                    ),

                    // SORU 3: YGH BOYUTU
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text("İtfaiye asansörünün açıldığı YGH‘ nin taban alanı yaklaşık kaç metrekare?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Küçük (6 m²'den az).",
                            subtitle: "🚨 RİSK: Yetersiz alan.",
                            value: ChoiceResult(label: "A", reportText: "🚨 RİSK. YGH alanı EN AZ 6 m² olmalıdır."),
                            groupValue: _model.resYghBoyut,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghBoyut: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Standart (6-10 m² arası).",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resYghBoyut,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghBoyut: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Büyük (10 m²'den fazla).",
                            subtitle: "⚠️ UYARI: Duman kontrolü zorlaşır.",
                            value: ChoiceResult(label: "C", reportText: "⚠️ UYARI. YGH alanı 10 m²'yi geçmemelidir."),
                            groupValue: _model.resYghBoyut,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghBoyut: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "D) Bilmiyorum.",
                            value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Holün boyutları bilinmiyor."),
                            groupValue: _model.resYghBoyut,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resYghBoyut: val)),
                          ),
                        ],
                      ),
                    ),

                    // ADIM-2: TEKNİK ÖZELLİKLER
                    const Divider(height: 40),
                    const Text("ADIM-2: TEKNİK ÖZELLİKLER", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),

                    // SORU 1: KABİN
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text("Kabin sedye girecek kadar geniş (1.8 m²) ve hızı yeterli mi?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, geniş ve hızlı.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resItfaiyeTeknikKabin,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikKabin: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, küçük veya yavaş.",
                            subtitle: "🚨 RİSK: Tahliye gecikir.",
                            value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Kabin en az 1.8 m² olmalı ve hızlı olmalıdır."),
                            groupValue: _model.resItfaiyeTeknikKabin,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikKabin: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Asansörün teknik kapasitesi bilinmiyor."),
                            groupValue: _model.resItfaiyeTeknikKabin,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikKabin: val)),
                          ),
                        ],
                      ),
                    ),

                    // SORU 2: JENERATÖR
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text("Jeneratöre bağlı mı ve kabloları yangına dayanıklı mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, bağlı ve dayanıklı.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resItfaiyeTeknikEnerji,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikEnerji: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, jeneratör yok.",
                            subtitle: "🚨 KRİTİK RİSK: Çalışmaz.",
                            value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. İtfaiye asansörü jeneratöre bağlı olmak zorundadır."),
                            groupValue: _model.resItfaiyeTeknikEnerji,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikEnerji: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Acil durum enerji beslemesi bilinmiyor."),
                            groupValue: _model.resItfaiyeTeknikEnerji,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikEnerji: val)),
                          ),
                        ],
                      ),
                    ),

                    // SORU 3: BASINÇLANDIRMA
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text("Kuyu basınçlandırılmış mı? (İçeriden dışarıya hava üflüyor mu?)", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, var.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resItfaiyeTeknikBasinc,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikBasinc: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır.",
                            subtitle: "🚨 RİSK: Duman dolar.",
                            value: ChoiceResult(label: "B", reportText: "🚨 RİSK. İtfaiye asansör kuyusu basınçlandırılmalıdır."),
                            groupValue: _model.resItfaiyeTeknikBasinc,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikBasinc: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Kuyu basınçlandırma durumu bilinmiyor."),
                            groupValue: _model.resItfaiyeTeknikBasinc,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeTeknikBasinc: val)),
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
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_isSkipped) return true; // Atlandıysa validasyon yok
    if (_model.resItfaiyeAsansorVar == null) return false;
    
    // Eğer "Evet" (B) seçildiyse diğer sorular zorunlu
    if (_model.resItfaiyeAsansorVar?.label == "B") {
      if (_model.resItfaiyeAsansorYeri == null) return false;
      if (_model.resYghBoyut == null) return false;
      if (_model.resItfaiyeTeknikKabin == null) return false;
      if (_model.resItfaiyeTeknikEnerji == null) return false;
      if (_model.resItfaiyeTeknikBasinc == null) return false;
    }
    return true;
  }
}