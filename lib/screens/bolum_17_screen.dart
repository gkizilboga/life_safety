import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_8_model.dart'; // Nizam Durumu Enum
import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult
import 'package:life_safety/models/bolum_17_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_18_screen.dart';
// import 'package:life_safety/logic/hesaplama_motoru.dart'; // Sonraki Aşama (Rapor)

class Bolum17Screen extends StatefulWidget {
  const Bolum17Screen({super.key});

  @override
  State<Bolum17Screen> createState() => _Bolum17ScreenState();
}

class _Bolum17ScreenState extends State<Bolum17Screen> {
  Bolum17Model _model = Bolum17Model();

  @override
  void initState() {
    super.initState();
    // HAFIZA: Veri varsa geri yükle
    if (BinaStore.instance.bolum17 != null) {
      _model = BinaStore.instance.bolum17!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum17 = _model;
    print("Bölüm 17 Kaydedildi.");
    
    // BURASI VERİ GİRİŞİNİN FİNALİDİR.
    // Buradan sonra Hesaplama Motoru çalıştırılacak.
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum18Screen()));
  }

  @override
  Widget build(BuildContext context) {
    // Global Değişkenleri Çek
    final bool isHighBuilding = BinaStore.instance.bolum4?.isGenelYuksekBina ?? false;
    final bool isBitisik = BinaStore.instance.bolum8?.secim == NizamDurumu.bitisik;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Çatılar",
            subtitle: "Bölüm 17: Çatı ve Yalıtım",
            currentStep: 17, // Toplam adım sayısı arttıysa burayı güncelleyebiliriz
            totalSteps: 17,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1: ÇATI KAPLAMA
                  const Text("ADIM-1: ÇATI KAPLAMA MALZEMESİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Çatınızın en üst katmanında (yağmurun değdiği yüzeyde) hangi malzeme kullanıldığını biliyor musunuz?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Kiremit, Metal Kenet, Beton veya Taş.",
                          subtitle: "✅ UYGUN (Hiç yanmaz malzeme)",
                          value: ChoiceResult(label: "A", reportText: "✅ UYGUN"),
                          groupValue: _model.resCatiKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Shingle, Onduline veya Membran.",
                          subtitle: "⚠️ UYARI: Bitümlü örtüler yanıcıdır.",
                          value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Bitümlü örtüler yanıcıdır. 'BROOF' sertifikalı olmalıdır."),
                          groupValue: _model.resCatiKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Sandviç Panel (İçi köpük dolgulu).",
                          subtitle: "🚨 RİSK: Yanıcı madde dolgulu.",
                          value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Yanıcı madde dolgulu paneller yangını hızla yayar. Taşyünü vb. gibi yanmaz malzeme dolgulu olmalıdır."),
                          groupValue: _model.resCatiKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "D) Sandviç Panel (İçi taşyünü dolgulu).",
                          subtitle: "✅ UYGUN (Hiç yanmaz)",
                          value: ChoiceResult(label: "D", reportText: "✅ UYGUN"),
                          groupValue: _model.resCatiKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "E) Ahşap kaplama.",
                          subtitle: "🚨 KRİTİK RİSK",
                          value: ChoiceResult(label: "E", reportText: "🚨 KRİTİK RİSK. Ahşap kaplama kullanılması uygun değildir."),
                          groupValue: _model.resCatiKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "F) Bilmiyorum.",
                          subtitle: "❓ BİLİNMİYOR",
                          value: ChoiceResult(label: "F", reportText: "❓ BİLİNMİYOR. Çatı kaplama malzemeniz bilinmiyor. Yanıcı bir malzeme kullanıldıysa tüm bina risk altındadır. Uzman Görüşü alınması tavsiye edilir."),
                          groupValue: _model.resCatiKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiKaplama: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2: ÇATI ALTI YALITIMI
                  const Divider(height: 40),
                  const Text("ADIM-2: ÇATI ALTI YALITIMI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Çatıyı taşıyan iskelet ve altındaki ısı yalıtımı nasıl?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Taşıyıcılar Beton/Çelik. Yalıtım Taşyünü.",
                          subtitle: "✅ UYGUN (Hiç Yanmaz)",
                          value: ChoiceResult(label: "A", reportText: "✅ UYGUN. Çatı taşıyıcı sisteminin ve yalıtımının yanmaz malzemeden olması yangın güvenliği için en ideal durumdur."),
                          groupValue: _model.resCatiYalitim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiYalitim: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Taşıyıcılar Ahşap. Yalıtım Köpük.",
                          subtitle: isHighBuilding ? "🚨 KRİTİK RİSK (Yüksek Bina)" : "⚠️ UYARI (Yanıcı)",
                          value: ChoiceResult(
                            label: "B", 
                            reportText: isHighBuilding 
                              ? "🚨 KRİTİK RİSK. Yüksek binalarda ahşap çatı yasaktır." 
                              : "⚠️ UYARI. Ahşap çatılarda yanıcı köpük kullanımı risklidir."
                          ),
                          groupValue: _model.resCatiYalitim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiYalitim: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          subtitle: "❓ BİLİNMİYOR",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Çatı iskeletinin durumu bilinmiyor. Yüksek binalarda ahşap çatı büyük risk taşır. Uzman Görüşü alınması tavsiye edilir."),
                          groupValue: _model.resCatiYalitim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiYalitim: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3: BİTİŞİK NİZAM (Sadece Bitişikse)
                  if (isBitisik) ...[
                    const Divider(height: 40),
                    const Text("ADIM-3: BİTİŞİK NİZAMDA ÇATI GEÇİŞİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 8),
                    const Text("Çatınız yan binanın çatısına bitişik mi? Arada yangını kesecek bir duvar var mı?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ChoiceResult>(
                            title: "A) Arada yüksek bir duvar var.",
                            subtitle: "✅ UYGUN",
                            value: ChoiceResult(label: "A", reportText: "✅ UYGUN. Yangın duvarı mevcut."),
                            groupValue: _model.resBitisikCati,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resBitisikCati: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "B) Çatılar birbirine değiyor.",
                            subtitle: "🚨 RİSK: Yangın geçişi olabilir.",
                            value: ChoiceResult(label: "B", reportText: "🚨 RİSK. Bitişik nizam binalarda, çatılar arasında yangın geçişini engelleyecek 'Yangın Duvarı' olması zorunludur."),
                            groupValue: _model.resBitisikCati,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resBitisikCati: val)),
                          ),
                          SelectableCard<ChoiceResult>(
                            title: "C) Bilmiyorum.",
                            subtitle: "❓ BİLİNMİYOR",
                            value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Komşu bina ile çatı birleşim detayınız bilinmiyor."),
                            groupValue: _model.resBitisikCati,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resBitisikCati: val)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ADIM-4: ÇATI IŞIKLIĞI
                  const Divider(height: 40),
                  const Text("ADIM-4: ÇATI IŞIKLIĞI VE FENERLER", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Çatınızda camlı ışıklık, fener veya aydınlatma kubbesi var mı?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, yok.",
                          subtitle: "✅ UYGUN",
                          value: ChoiceResult(label: "A", reportText: "✅ UYGUN. Çatıda ışıklık olmaması riski azaltır."),
                          groupValue: _model.resCatiIsiklik,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiIsiklik: val, resIsiklikMalzeme: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, var.",
                          value: ChoiceResult(label: "B", reportText: "Işıklık mevcut."),
                          groupValue: _model.resCatiIsiklik,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiIsiklik: val)),
                        ),
                        if (_model.resCatiIsiklik?.label == "B") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Malzemesi nedir?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Temperli Cam", "✅ UYGUN", "A", _model.resIsiklikMalzeme, (v) => setState(() => _model = _model.copyWith(resIsiklikMalzeme: v))),
                          _buildSubOption("Plastik/Pleksi", "⚠️ UYARI: Eriyip damlayabilir.", "B", _model.resIsiklikMalzeme, (v) => setState(() => _model = _model.copyWith(resIsiklikMalzeme: v))),
                        ],
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          subtitle: "❓ BİLİNMİYOR",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Çatıda ışıklık olup olmadığı bilinmiyor."),
                          groupValue: _model.resCatiIsiklik,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resCatiIsiklik: val, resIsiklikMalzeme: null)),
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
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_model.resCatiKaplama == null) return false;
    if (_model.resCatiYalitim == null) return false;
    
    final bool isBitisik = BinaStore.instance.bolum8?.secim == NizamDurumu.bitisik;
    if (isBitisik && _model.resBitisikCati == null) return false;

    if (_model.resCatiIsiklik == null) return false;
    if (_model.resCatiIsiklik?.label == "B" && _model.resIsiklikMalzeme == null) return false;

    return true;
  }
}