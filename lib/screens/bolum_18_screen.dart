import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_18_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_19_screen.dart'; // Sonraki aşama

class Bolum18Screen extends StatefulWidget {
  const Bolum18Screen({super.key});

  @override
  State<Bolum18Screen> createState() => _Bolum18ScreenState();
}

class _Bolum18ScreenState extends State<Bolum18Screen> {
  Bolum18Model _model = Bolum18Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum18 != null) {
      _model = BinaStore.instance.bolum18!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum18 = _model;
    print("Bölüm 18 Kaydedildi.");
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum19Screen()));
  }

  @override
  Widget build(BuildContext context) {
    // Global Değişkeni Burada Çekiyoruz
    final bool isHighBuilding = BinaStore.instance.bolum4?.isGenelYuksekBina ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Yapı Malzemeleri",
            subtitle: "Bölüm 18: Kaplamalar ve Tesisat",
            currentStep: 18,
            totalSteps: 36,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ADIM-1: DUVAR KAPLAMALARI",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Daire içlerinde veya koridor duvarlarında; kağıt, ahşap, plastik veya köpük (içten yalıtım) gibi bir kaplama var mı?",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, sadece sıva ve boya.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resDuvarKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDuvarKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, ahşap/plastik/köpük var.",
                          subtitle: isHighBuilding 
                            ? "🚨 KIRMIZI RİSK: Yüksek binalarda yasaktır." 
                            : "⚠️ UYARI: Kolay alevlenici olabilir.",
                          value: ChoiceResult(
                            label: "B", 
                            reportText: isHighBuilding 
                              ? "🚨 KIRMIZI RİSK. Yüksek binalarda duvar kaplamaları ‘en az zor alevlenici' sınıfta olmalıdır. Ahşap, plastik veya köpük gibi malzemeler yangını koridor boyunca hızla yayar." 
                              : "⚠️ UYARI. Duvarlarda kullanılan köpük veya plastik malzemeler 'Normal Alevlenici' sınıfta olmalıdır. Kolay tutuşan malzemeler yangın yükünü artırır."
                          ),
                          groupValue: _model.resDuvarKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDuvarKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Evet, duvar kağıdı var.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "C", reportText: "✅ OLUMLU GÖRÜNÜYOR. Standart duvar kağıtları genelde kabul edilir."),
                          groupValue: _model.resDuvarKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDuvarKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Bilmiyorum.",
                          subtitle: "❓ BİLİNMİYOR",
                          value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Duvar kaplama malzemesi bilinmiyor. 21,5m üzeri binalarda yanıcı kaplama malzemesi kullanımı büyük risk taşır."),
                          groupValue: _model.resDuvarKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDuvarKaplama: val)),
                        ),
                      ],
                    ),
                  ),

                  if (isHighBuilding) ...[
                    const Divider(height: 40),
                    const Text(
                      "ADIM-2: TESİSAT BORULARI",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Binanız yüksek katlı olduğu için tesisat şaftlarından geçen plastik pis su borularında (Pimaş) önlem alınmış mı?",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Sessiz Boru veya Döküm.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR (Zor Yanıcı)",
                            value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resTesisatBoru,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTesisatBoru: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Standart PVC + Yangın Kelepçesi.",
                            subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                            value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                            groupValue: _model.resTesisatBoru,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTesisatBoru: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Standart PVC (Kelepçe Yok).",
                            subtitle: "🚨 KIRMIZI RİSK: Yangın üst kata geçer.",
                            value: ChoiceResult(label: "C", reportText: "🚨 KIRMIZI RİSK. 21,5m ve üzeri binalarda standart plastik borular yangın anında eriyerek yok olur ve döşemede delik açılır. Yangın Kelepçesi ZORUNLUDUR."),
                            groupValue: _model.resTesisatBoru,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTesisatBoru: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "D) Bilmiyorum / Göremiyorum.",
                            subtitle: "❓ BİLİNMİYOR",
                            value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Tesisat borularının yangın dayanımı bilinmiyor. Yüksek binalarda yangın kesici (kelepçe) olup olmadığı hayati önem taşır."),
                            groupValue: _model.resTesisatBoru,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resTesisatBoru: val)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // DÜZELTME: isHighBuilding değişkenini buraya parametre olarak gönderiyoruz
          _buildBottomButton(isHighBuilding),
        ],
      ),
    );
  }

  // DÜZELTME: Fonksiyon artık parametre alıyor
  Widget _buildBottomButton(bool isHighBuilding) {
    return Container(
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
            // Parametreyi validasyon fonksiyonuna iletiyoruz
            onPressed: _isFormValid(isHighBuilding) ? _onNextPressed : null,
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid(bool isHighBuilding) {
    if (_model.resDuvarKaplama == null) return false;
    if (isHighBuilding && _model.resTesisatBoru == null) return false;
    return true;
  }
}