import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_16_model.dart';
import 'bolum_17_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum16Screen extends StatefulWidget {
  const Bolum16Screen({super.key});

  @override
  State<Bolum16Screen> createState() => _Bolum16ScreenState();
}

class _Bolum16ScreenState extends State<Bolum16Screen> {
  Bolum16Model _model = Bolum16Model();

  // Bitişik Nizam sorusunu sadece Bölüm 8'de "Bitişik" seçildiyse soracağız
  bool _askBitisik = false;

  @override
  void initState() {
    super.initState();
    // Bölüm 8 verisini kontrol et
    final b8 = BinaStore.instance.bolum8;
    // Eğer Bitişik Nizam seçildiyse (8-1-B), burada ilgili soru sorulur.
    // Not: Label kontrolü yerine, Bolum8Model'e isBitisik getter'ı eklemek daha temiz olurdu 
    // ama şimdilik AppContent üzerinden kontrol ediyoruz.
    // Bolum8Content.bitisikNizam.label == "8-1-B" (Varsayalım)
    if (b8?.secim?.label.contains("Bitişik") == true || b8?.secim?.label == "8-1-B") {
      _askBitisik = true;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mantolama') {
        _model = _model.copyWith(mantolama: choice);
        // Seçim değişirse alt soruyu sıfırla
        if (choice.label != Bolum16Content.giydirmeOptionC.label) {
          _model = _model.copyWith(giydirmeBoslukYalitim: null);
        }
      }
      if (type == 'sagir') {
        _model = _model.copyWith(sagirYuzey: choice);
        // Seçim değişirse alt soruyu sıfırla
        if (choice.label != Bolum16Content.sagirYuzeyOptionB.label) {
          _model = _model.copyWith(sagirYuzeySprinkler: null);
        }
      }
      if (type == 'bitisik') _model = _model.copyWith(bitisikNizam: choice);
    });
  }

  void _onNextPressed() {
    // Validasyonlar
    if (_model.mantolama == null) return _showError("Lütfen cephe kaplama sorusunu yanıtlayınız.");
    
    // Giydirme cephe ise boşluk sorusu zorunlu
    if (_model.mantolama?.label == Bolum16Content.giydirmeOptionC.label && _model.giydirmeBoslukYalitim == null) {
      return _showError("Lütfen cephe arkasındaki boşluk yalıtım durumunu belirtiniz.");
    }

    if (_model.sagirYuzey == null) return _showError("Lütfen pencere altı duvar yüksekliği sorusunu yanıtlayınız.");
    
    // Sağır yüzey yetersizse sprinkler sorusu zorunlu
    if (_model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label && _model.sagirYuzeySprinkler == null) {
      return _showError("Lütfen cephe sprinkler durumunu belirtiniz.");
    }

    if (_askBitisik && _model.bitisikNizam == null) return _showError("Lütfen bitişik bina yükseklik sorusunu yanıtlayınız.");

    BinaStore.instance.bolum16 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum17Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-16: Binanın Dış Cephe Özellikleri",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Cephe Malzemesi
                  _buildSoru("Binanızın dış cephesinde kullanılan kaplama veya ısı yalıtım sistemi nedir?", 'mantolama', 
                    [
                      Bolum16Content.mantolamaOptionA, 
                      Bolum16Content.mantolamaOptionB, 
                      Bolum16Content.giydirmeOptionC,
                      Bolum16Content.mantolamaOptionD,
                      Bolum16Content.mantolamaOptionE
                    ], _model.mantolama),

                  // Alt Soru: Giydirme Cephe Varsa
                  if (_model.mantolama?.label == Bolum16Content.giydirmeOptionC.label) 
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Cephe ile döşeme arasındaki boşluklar yangına dayanıklı malzeme ile kapatılmış mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true, 
                                groupValue: _model.giydirmeBoslukYalitim, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(giydirmeBoslukYalitim: v))
                              ),
                              const Text("Evet (Boşluk Yok)"),
                              const SizedBox(width: 10),
                              Radio<bool>(
                                value: false, 
                                groupValue: _model.giydirmeBoslukYalitim, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(giydirmeBoslukYalitim: v))
                              ),
                              const Text("Hayır (Boşluk Var)"),
                            ],
                          )
                        ],
                      ),
                    ),

                  // 2. Sağır Yüzey
                  _buildSoru("Alt katın penceresinin üst kenarı ile üst katın penceresinin alt kenarı arasındaki dolu duvar yüksekliği ne kadar?", 'sagir', 
                    [Bolum16Content.sagirYuzeyOptionA, Bolum16Content.sagirYuzeyOptionB, Bolum16Content.sagirYuzeyOptionC], _model.sagirYuzey),

                  // Alt Soru: Sağır Yüzey Yetersizse
                  if (_model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label) 
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Cepheye bakan özel Sprinkler (Yağmurlama) sistemi var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Radio<bool>(
                                value: true, 
                                groupValue: _model.sagirYuzeySprinkler, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(sagirYuzeySprinkler: v))
                              ),
                              const Text("Evet Var"),
                              const SizedBox(width: 20),
                              Radio<bool>(
                                value: false, 
                                groupValue: _model.sagirYuzeySprinkler, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(sagirYuzeySprinkler: v))
                              ),
                              const Text("Hayır Yok"),
                            ],
                          )
                        ],
                      ),
                    ),

                  // 3. Bitişik Nizam (Sadece bitişikse sorulur)
                  if (_askBitisik)
                    _buildSoru("Binanız bitişik nizamda ve yan binadan daha yüksek mi?", 'bitisik', 
                      [Bolum16Content.bitisikOptionA, Bolum16Content.bitisikOptionB, Bolum16Content.bitisikOptionC], _model.bitisikNizam),
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
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )),
        ],
      ),
    );
  }
}