import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_23_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_24_screen.dart';

class Bolum23Screen extends StatefulWidget {
  const Bolum23Screen({super.key});

  @override
  State<Bolum23Screen> createState() => _Bolum23ScreenState();
}

class _Bolum23ScreenState extends State<Bolum23Screen> {
  Bolum23Model _model = Bolum23Model();
  bool _isSkipped = false;

  @override
  void initState() {
    super.initState();
    // KONTROL: Binada normal asansör yoksa bu bölümü atla
    final bool hasAsansor = BinaStore.instance.bolum7?.hasAsansorNormal ?? false;
    if (!hasAsansor) {
      _isSkipped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed(); 
      });
    }

    // HAFIZA: Veri varsa geri yükle
    if (BinaStore.instance.bolum23 != null) {
      _model = BinaStore.instance.bolum23!;
    }
  }

  void _onNextPressed() {
    if (!_isSkipped) {
      BinaStore.instance.bolum23 = _model;
      print("Bölüm 23 Kaydedildi.");
    } else {
      print("Bölüm 23 Atlandı (Asansör Yok).");
    }
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum24Screen()));
  }

  @override
  Widget build(BuildContext context) {
    if (_isSkipped) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isHighBuilding = BinaStore.instance.bolum4?.isGenelYuksekBina ?? false;
    final int bodrumKatSayisi = BinaStore.instance.bodrumKatSayisi;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Normal Asansör",
            subtitle: "Bölüm 23: Asansör Güvenliği",
            currentStep: 23,
            totalSteps: 25,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: BODRUM KATLARA ERİŞİM
                  if (bodrumKatSayisi > 0) ...[
                    const Text("ADIM-1: BODRUM KATLARA ERİŞİM", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text(
                            "Asansörünüz bodrum kata (Otopark, Depo veya Kazan Dairesi katına) iniyor mu? İniyorsa kapısı nereye açılıyor?",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          SelectableCard<ChoiceResult>(
                            title: "A) Asansör bodruma inmiyor.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resAsansorBodrumHol,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorBodrumHol: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) İniyor ve kapısı hole açılıyor.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR (Yangın kapılarıyla ayrılmış)",
                            value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resAsansorBodrumHol,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorBodrumHol: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) İniyor ve direkt Otoparka/Depoya açılıyor.",
                            subtitle: "🚨 KRİTİK RİSK: Arada YGH yok.",
                            value: ChoiceResult(label: "C", reportText: "🚨 KRİTİK RİSK. Asansör kuyuları binanın bacası gibidir. Bodrumdaki duman direkt kuyuya girer."),
                            groupValue: _model.resAsansorBodrumHol,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorBodrumHol: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "D) Bilmiyorum.",
                            value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Asansör kuyuları binanın bacası gibidir. Bodrumda asansör önünde mutlaka 'Yangın Güvenlik Holü' olmalıdır."),
                            groupValue: _model.resAsansorBodrumHol,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorBodrumHol: val)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 40),
                  ],

                  // ADIM-2: YANGIN UYARI SİSTEMİ (Sadece Yüksek Binalarda)
                  if (isHighBuilding) ...[
                    const Text("ADIM-2: YANGIN UYARI SİSTEMİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          const Text(
                            "Binanızda yangın alarmı çaldığında asansörler otomatik olarak zemin kata inip kapılarını açıyor mu?",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          SelectableCard<ChoiceResult>(
                            title: "A) Evet, otomatik iniyor.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resAsansorYanginModu,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorYanginModu: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Hayır, olduğu yerde kalıyor.",
                            subtitle: "🚨 RİSK: Yangın Modu yok.",
                            value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Yüksek binalarda asansörlerin 'Yangın Modu' olması zorunludur."),
                            groupValue: _model.resAsansorYanginModu,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorYanginModu: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum / Denk gelmedim.",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Asansörün yangın senaryosu bilinmiyor. Hayati önem taşır."),
                            groupValue: _model.resAsansorYanginModu,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorYanginModu: val)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 40),
                  ],

                  // ADIM-3: ASANSÖR KAPISININ KONUMU
                  const Text("ADIM-3: ASANSÖR KAPISININ KONUMU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text(
                          "Asansör kapıları (zemin üstü) normal katlarda nereye açılıyor?",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SelectableCard<ChoiceResult>(
                          title: "A) Kat koridoruna veya asansör holüne.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resAsansorMerdivenIliski,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorMerdivenIliski: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Doğrudan Yangın Merdiveninin içine.",
                          subtitle: "🚨 KRİTİK RİSK: Yasaktır.",
                          value: ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Asansör kapıları ASLA yangın merdiveni yuvasına açılamaz."),
                          groupValue: _model.resAsansorMerdivenIliski,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorMerdivenIliski: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Asansör kapısının konumu net değil."),
                          groupValue: _model.resAsansorMerdivenIliski,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorMerdivenIliski: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-4: UYARI LEVHALARI
                  const Divider(height: 40),
                  const Text("ADIM-4: UYARI LEVHALARI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text(
                          "Asansör kapılarının üzerinde veya yanında 'YANGIN ANINDA KULLANILMAZ' uyarısı var mı?",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SelectableCard<ChoiceResult>(
                          title: "A) Evet, her katta var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resAsansorLevha,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorLevha: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Hayır, yok.",
                          subtitle: "⚠️ UYARI: Yasal zorunluluktur.",
                          value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Panik anında insanlar asansöre yönelebilir. Bu levha zorunludur."),
                          groupValue: _model.resAsansorLevha,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorLevha: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum / Dikkat etmedim.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Uyarı levhalarının varlığı bilinmiyor."),
                          groupValue: _model.resAsansorLevha,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorLevha: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-5: KUYU HAVALANDIRMASI
                  const Divider(height: 40),
                  const Text("ADIM-5: KUYU HAVALANDIRMASI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        const Text(
                          "Asansör kuyusunun en tepesinde dumanın tahliyesi için bir havalandırma penceresi/menfezi var mı?",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        SelectableCard<ChoiceResult>(
                          title: "A) Evet, dışarıya açılan menfez var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resAsansorHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorHavalandirma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Hayır, kuyu tamamen kapalı.",
                          subtitle: "🚨 RİSK: Duman tahliye edilemez.",
                          value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Asansör kuyusuna sızan dumanın tahliye edilmesi için 'Duman Tahliye Bacası' zorunludur."),
                          groupValue: _model.resAsansorHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorHavalandirma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum / Göremiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Kuyu havalandırması bilinmiyor."),
                          groupValue: _model.resAsansorHavalandirma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsansorHavalandirma: val)),
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
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_isSkipped) return true;
    
    final int bodrumKatSayisi = BinaStore.instance.bodrumKatSayisi;
    final bool isHighBuilding = BinaStore.instance.bolum4?.isGenelYuksekBina ?? false;

    if (bodrumKatSayisi > 0 && _model.resAsansorBodrumHol == null) return false;
    if (isHighBuilding && _model.resAsansorYanginModu == null) return false;
    if (_model.resAsansorMerdivenIliski == null) return false;
    if (_model.resAsansorLevha == null) return false;
    if (_model.resAsansorHavalandirma == null) return false;

    return true;
  }
}