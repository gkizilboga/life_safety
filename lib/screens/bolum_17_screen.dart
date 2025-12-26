import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_17_model.dart';
import 'bolum_18_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum17Screen extends StatefulWidget {
  const Bolum17Screen({super.key});

  @override
  State<Bolum17Screen> createState() => _Bolum17ScreenState();
}

class _Bolum17ScreenState extends State<Bolum17Screen> {
  Bolum17Model _model = Bolum17Model();
  bool _askBitisik = false;

  @override
  void initState() {
    super.initState();
    // Bölüm 8'de "Bitişik Nizam" seçildiyse ilgili soruyu sor
    final b8 = BinaStore.instance.bolum8;
    if (b8?.secim?.label.contains("Bitişik") == true || b8?.secim?.label == "8-1-B") {
      _askBitisik = true;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'kaplama') _model = _model.copyWith(kaplama: choice);
      if (type == 'iskelet') _model = _model.copyWith(iskelet: choice);
      if (type == 'duvar') _model = _model.copyWith(bitisikDuvar: choice);
      
      if (type == 'isiklik') {
        _model = _model.copyWith(isiklik: choice);
        // Işıklık yoksa malzeme seçimini sıfırla
        if (choice.label == Bolum17Content.isiklikOptionA.label) {
          _model = _model.copyWith(isiklikMalzemesi: null);
        }
      }
    });
  }

  void _onNextPressed() {
    if (_model.kaplama == null) return _showError("Lütfen çatı kaplama malzemesini seçiniz.");
    if (_model.iskelet == null) return _showError("Lütfen çatı iskeleti ve yalıtımı sorusunu yanıtlayınız.");
    if (_askBitisik && _model.bitisikDuvar == null) return _showError("Lütfen çatı arası duvar sorusunu yanıtlayınız.");
    if (_model.isiklik == null) return _showError("Lütfen çatı ışıklık durumunu belirtiniz.");
    
    // Işıklık varsa malzeme seçilmeli
    if (_model.isiklik?.label == Bolum17Content.isiklikOptionB.label && _model.isiklikMalzemesi == null) {
      return _showError("Lütfen ışıklık malzemesini seçiniz.");
    }

    BinaStore.instance.bolum17 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum18Screen()),
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
            title: "Bölüm-17: Çatı",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Kaplama Malzemesi
                  _buildSoru("Çatınızın en üst katmanında (yağmurun değdiği yüzeyde) hangi malzeme kullanıldığını biliyor musunuz?", 'kaplama', 
                    [
                      Bolum17Content.kaplamaOptionA, 
                      Bolum17Content.kaplamaOptionB, 
                      Bolum17Content.kaplamaOptionC,
                      Bolum17Content.kaplamaOptionD,
                      Bolum17Content.kaplamaOptionE,
                      Bolum17Content.kaplamaOptionF
                    ], _model.kaplama),

                  // 2. İskelet ve Yalıtım
                  _buildSoru("Çatıyı taşıyan iskelet (makaslar/kirişler) ve altındaki ısı yalıtımı nasıl?", 'iskelet', 
                    [Bolum17Content.iskeletOptionA, Bolum17Content.iskeletOptionB, Bolum17Content.iskeletOptionC], _model.iskelet),

                  // 3. Bitişik Nizam Duvarı
                  if (_askBitisik)
                    _buildSoru("Çatınız yan binanın çatısına bitişik mi? Arada yangını kesecek bir duvar var mı?", 'duvar', 
                      [Bolum17Content.bitisikOptionA, Bolum17Content.bitisikOptionB, Bolum17Content.bitisikOptionC], _model.bitisikDuvar),

                  // 4. Işıklık
                  _buildSoru("Çatınızda camlı ışıklık, fener veya aydınlatma kubbesi var mı?", 'isiklik', 
                    [Bolum17Content.isiklikOptionA, Bolum17Content.isiklikOptionB], _model.isiklik),

                  // Alt Soru: Işıklık Malzemesi
                  if (_model.isiklik?.label == Bolum17Content.isiklikOptionB.label) 
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Işıklık malzemesi nedir?", style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Radio<String>(
                                value: "cam", 
                                groupValue: _model.isiklikMalzemesi, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(isiklikMalzemesi: v))
                              ),
                              const Text("Cam"),
                              const SizedBox(width: 20),
                              Radio<String>(
                                value: "plastik", 
                                groupValue: _model.isiklikMalzemesi, 
                                onChanged: (v) => setState(() => _model = _model.copyWith(isiklikMalzemesi: v))
                              ),
                              const Text("Plastik / Mika"),
                            ],
                          )
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