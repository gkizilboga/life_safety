import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_11_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_12_screen.dart';

class Bolum11Screen extends StatefulWidget {
  const Bolum11Screen({super.key});

  @override
  State<Bolum11Screen> createState() => _Bolum11ScreenState();
}

class _Bolum11ScreenState extends State<Bolum11Screen> {
  Bolum11Model _model = Bolum11Model();

  void _onNextPressed() {
    BinaStore.instance.bolum11 = _model;
    print("Bölüm 11 Kaydedildi.");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum12Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "İtfaiye Erişimi",
            subtitle: "Bölüm 11: İtfaiye Erişim Yolları",
            currentStep: 11,
            totalSteps: 15,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "İTFAİYE YAKLAŞIM MESAFESİ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "İtfaiye aracının park edebildiği noktanın, binanın EN UZAK cephesine veya en uç köşesine (örneğin arka cepheye) olan mesafesi 45 metreyi geçiyor mu?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.1)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 20, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Açıklama: Lütfen sadece bina giriş kapısını düşünmeyin. İtfaiye aracının durduğu yerden, binanın etrafını dolaşarak ulaşılması en zor olan arka köşesini düşünün.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ItfaiyeMesafeSecim>(
                          title: "A) Hayır, geçmiyor.",
                          subtitle: "En uzak nokta 45 metreden daha yakın",
                          value: ItfaiyeMesafeSecim.gecmiyor,
                          groupValue: _model.resItfaiyeMesafe,
                          onChanged: (val) => setState(() => _model = _model.copyWith(
                                resItfaiyeMesafe: val,
                                resEngelDurumu: null,
                                resZayifGecis: null,
                              )),
                        ),
                        SelectableCard<ItfaiyeMesafeSecim>(
                          title: "B) Evet, geçiyor.",
                          subtitle: "Mesafe 45 metreden fazla",
                          value: ItfaiyeMesafeSecim.geciyor,
                          groupValue: _model.resItfaiyeMesafe,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resItfaiyeMesafe: val)),
                        ),
                        SelectableCard<ItfaiyeMesafeSecim>(
                          title: "C) Bilmiyorum",
                          value: ItfaiyeMesafeSecim.bilmiyorum,
                          groupValue: _model.resItfaiyeMesafe,
                          onChanged: (val) => setState(() => _model = _model.copyWith(
                                resItfaiyeMesafe: val,
                                resEngelDurumu: null,
                                resZayifGecis: null,
                              )),
                        ),
                      ],
                    ),
                  ),
                  if (_model.resItfaiyeMesafe == ItfaiyeMesafeSecim.geciyor) ...[
                    const Divider(height: 40),
                    const Text(
                      "ENGEL VE BAHÇE DUVARLARI",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "İtfaiye aracının binaya yeterince yanaşmasını engelleyen bir bahçe duvarı, çevre duvarı veya kilitli bir kapı var mı?",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<EngelDurumuSecim>(
                            title: "A) Hayır, engel yok.",
                            subtitle: "İtfaiye aracı binanın dibine kadar yaklaşabilir.",
                            value: EngelDurumuSecim.engelYok,
                            groupValue: _model.resEngelDurumu,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resEngelDurumu: val, resZayifGecis: null)),
                          ),
                          SelectableCard<EngelDurumuSecim>(
                            title: "B) Evet, engel var.",
                            subtitle: "Duvar/kapı/çit var ve itfaiye aracı kolayca geçemez.",
                            value: EngelDurumuSecim.engelVar,
                            groupValue: _model.resEngelDurumu,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resEngelDurumu: val)),
                          ),
                          SelectableCard<EngelDurumuSecim>(
                            title: "C) Bilmiyorum",
                            value: EngelDurumuSecim.bilmiyorum,
                            groupValue: _model.resEngelDurumu,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resEngelDurumu: val, resZayifGecis: null)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_model.resEngelDurumu == EngelDurumuSecim.engelVar) ...[
                    const Divider(height: 40),
                    const Text(
                      "ZAYIFLATILMIŞ GEÇİŞ NOKTASI",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Bu duvarda 'Kırmızı Çarpı (X)' ile işaretlenmiş VEYA itfaiyenin kolayca yıkıp geçebileceği zayıf bir bölüm (en az 8 metre genişliğinde) var mı?",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    QuestionCard(
                      child: Column(
                        children: [
                          SelectableCard<ZayifGecisSecim>(
                            title: "A) Evet, var.",
                            value: ZayifGecisSecim.varSecenek,
                            groupValue: _model.resZayifGecis,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resZayifGecis: val)),
                          ),
                          SelectableCard<ZayifGecisSecim>(
                            title: "B) Hayır, yok.",
                            value: ZayifGecisSecim.yokSecenek,
                            groupValue: _model.resZayifGecis,
                            onChanged: (val) => setState(() => _model = _model.copyWith(resZayifGecis: val)),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  onPressed: _isFormValid() ? _onNextPressed : null,
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isFormValid() {
    if (_model.resItfaiyeMesafe == null) return false;
    if (_model.resItfaiyeMesafe == ItfaiyeMesafeSecim.geciyor) {
      if (_model.resEngelDurumu == null) return false;
      if (_model.resEngelDurumu == EngelDurumuSecim.engelVar) {
        if (_model.resZayifGecis == null) return false;
      }
    }
    return true;
  }
}