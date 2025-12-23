import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_10_model.dart'; // Katsayı için
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_27_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_28_screen.dart';

class Bolum27Screen extends StatefulWidget {
  const Bolum27Screen({super.key});

  @override
  State<Bolum27Screen> createState() => _Bolum27ScreenState();
}

class _Bolum27ScreenState extends State<Bolum27Screen> {
  Bolum27Model _model = Bolum27Model();
  int _tahminiKullaniciYuku = 0;

  @override
  void initState() {
    super.initState();
    _calculateUserLoad(); // Yükü hesapla
    
    if (BinaStore.instance.bolum27 != null) {
      _model = BinaStore.instance.bolum27!;
    }
  }

  // ADIM-3 İçin Basit Yük Hesabı
  void _calculateUserLoad() {
    final double alan = BinaStore.instance.bolum5?.alanKatBrut ?? 0;
    final KullanimAmaci kullanim = BinaStore.instance.bolum10?.kullanimNormal.first ?? KullanimAmaci.konut;
    
    // Katsayıyı al (Model 10'daki extension'dan)
    double katsayi = 10.0; // Varsayılan Konut
    if (kullanim == KullanimAmaci.konut) katsayi = 10.0;
    else if (kullanim == KullanimAmaci.azYogunTicari) katsayi = 10.0;
    else if (kullanim == KullanimAmaci.ortaYogunTicari) katsayi = 5.0;
    else if (kullanim == KullanimAmaci.yuksekYogunTicari) katsayi = 1.5;
    else if (kullanim == KullanimAmaci.teknikOtopark) katsayi = 30.0;

    if (alan > 0) {
      setState(() {
        _tahminiKullaniciYuku = (alan / katsayi).ceil();
      });
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum27 = _model;
    print("Bölüm 27 Kaydedildi.");
    
    // VERİ GİRİŞİ BİTTİ - RAPOR EKRANINA GİDİŞ
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum28Screen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tebrikler! Tüm veri girişi tamamlandı.")));
  }

  @override
  Widget build(BuildContext context) {
    final bool isKalabalik = _tahminiKullaniciYuku > 50;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kaçış Kapıları",
            subtitle: "Bölüm 27: Kapı ve Donanımlar",
            currentStep: 27,
            totalSteps: 27,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: BOYUT VE EŞİK
                  const Text("ADIM-1: BOYUT VE EŞİK KONTROLÜ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Yangın merdivenine veya kaçış koridoruna açılan kapıların genişliği ve zemini nasıldır?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Geniş ve eşiksiz (Düz ayak).",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKapiBoyutEsik,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiBoyutEsik: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Dar (<80cm) veya eşik/kasis var.",
                          subtitle: "🚨 RİSK: Düşme tehlikesi.",
                          value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Kaçış kapılarında temiz geçiş genişliği en az 80 cm olmalıdır. Eşik bulunması yasaktır."),
                          groupValue: _model.resKapiBoyutEsik,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiBoyutEsik: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Kapı ölçüleri ve eşik durumu bilinmiyor."),
                          groupValue: _model.resKapiBoyutEsik,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiBoyutEsik: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2: AÇILMA YÖNÜ
                  const Divider(height: 40),
                  const Text("ADIM-2: AÇILMA YÖNÜ VE TİPİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Kaçış kapıları hangi yöne açılıyor ve tipi nedir?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Dışarıya (Kaçış yönüne) açılıyor.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKapiYonu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiYonu: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) İçeriye (Koridora) açılıyor.",
                          subtitle: "⚠️ UYARI: Kalabalıkta sıkışabilir.",
                          value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Kullanıcı yükü 50 kişiyi geçen katlarda kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır."),
                          groupValue: _model.resKapiYonu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiYonu: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Döner kapı, turnike veya sürgülü.",
                          subtitle: "🚨 KRİTİK RİSK: Yasaktır.",
                          value: ChoiceResult(label: "C", reportText: "🚨 KRİTİK RİSK. Kaçış yollarında döner kapı ve turnike kullanılması yasaktır!"),
                          groupValue: _model.resKapiYonu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiYonu: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Kapı açılma yönü bilinmiyor."),
                          groupValue: _model.resKapiYonu,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiYonu: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3: KİLİT VE PANİK BAR
                  const Divider(height: 40),
                  const Text("ADIM-3: KİLİT MEKANİZMASI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Kaçış yollarındaki kapıları açmak için kullanılan mekanizma nasıldır?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Panik Bar var (İtince açılıyor).",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKapiMekanizma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiMekanizma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Normal kapı kolu var.",
                          subtitle: isKalabalik 
                            ? "⚠️ UYARI: Nüfus > 50 olduğu için Panik Bar şart." 
                            : "✅ OLUMLU (Nüfus az olduğu için kabul edilebilir).",
                          value: ChoiceResult(
                            label: "B", 
                            reportText: isKalabalik 
                              ? "⚠️ UYARI. Hesaplamalarımıza göre binanızın en az bir katında kullanıcı yükü 50 kişiyi aşmaktadır. Bu durumda 'Panik Bar' kullanılması ZORUNLUDUR." 
                              : "✅ OLUMLU GÖRÜNÜYOR. (Düşük yoğunlukta kapı kolu kabul edilebilir)."
                          ),
                          groupValue: _model.resKapiMekanizma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiMekanizma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Kilitli / Anahtar gerekiyor.",
                          subtitle: "🚨 KRİTİK RİSK: Asla kilitlenemez!",
                          value: ChoiceResult(label: "C", reportText: "🚨 KRİTİK RİSK. Kaçış kapıları içeriden ASLA kilitlenemez!"),
                          groupValue: _model.resKapiMekanizma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiMekanizma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Kilit mekanizması bilinmiyor."),
                          groupValue: _model.resKapiMekanizma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiMekanizma: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-4: YANGIN DAYANIMI
                  const Divider(height: 40),
                  const Text("ADIM-4: YANGIN DAYANIMI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Kaçış yollarındaki kapıların malzemesi ve kapanma özelliği nasıldır?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Metal yangın kapısı + Hidrolik var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resKapiDayanim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiDayanim: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Metal ama otomatik kapanmıyor.",
                          subtitle: "🚨 RİSK: Açık kalırsa duman dolar.",
                          value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Yangın kapıları her zaman kapalı durmalı veya otomatik kapanmalıdır."),
                          groupValue: _model.resKapiDayanim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiDayanim: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Ahşap, PVC veya Cam kapı.",
                          subtitle: "🚨 KRİTİK RİSK: Yangına dayanmaz.",
                          value: ChoiceResult(label: "C", reportText: "🚨 KRİTİK RİSK. Kaçış merdiveni kapıları yangına en az 60-90 dakika dayanıklı olmalıdır."),
                          groupValue: _model.resKapiDayanim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiDayanim: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Kapının yangın dayanımı bilinmiyor."),
                          groupValue: _model.resKapiDayanim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resKapiDayanim: val)),
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
    if (_model.resKapiBoyutEsik == null) return false;
    if (_model.resKapiYonu == null) return false;
    if (_model.resKapiMekanizma == null) return false;
    if (_model.resKapiDayanim == null) return false;
    return true;
  }
}