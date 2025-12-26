import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_26_model.dart';
import 'bolum_27_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum26Screen extends StatefulWidget {
  const Bolum26Screen({super.key});

  @override
  State<Bolum26Screen> createState() => _Bolum26ScreenState();
}

class _Bolum26ScreenState extends State<Bolum26Screen> {
  Bolum26Model _model = Bolum26Model();

  // Otopark sorusunu sormak için Bölüm 6'da otopark var mı kontrolü
  bool _askOtopark = false;

  @override
  void initState() {
    super.initState();
    // Bölüm 6'da otopark varsa rampa sorusunu da soralım
    final b6 = BinaStore.instance.bolum6;
    if (b6?.hasOtopark == true) {
      _askOtopark = true;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        // Rampa yoksa detayları temizle
        if (choice.label == Bolum26Content.varlikOptionA.label) {
          _model = _model.copyWith(egim: null, sahanlik: null);
        }
      } else if (type == 'egim') {
        _model = _model.copyWith(egim: choice);
      } else if (type == 'sahanlik') {
        _model = _model.copyWith(sahanlik: choice);
      } else if (type == 'otopark') {
        _model = _model.copyWith(otopark: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.varlik == null) return _showError("Lütfen kaçış rampası sorusunu yanıtlayınız.");

    // Rampa varsa detaylar zorunlu
    if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) {
      if (_model.egim == null) return _showError("Lütfen rampa eğimini seçiniz.");
      if (_model.sahanlik == null) return _showError("Lütfen sahanlık durumunu seçiniz.");
    }

    if (_askOtopark && _model.otopark == null) return _showError("Lütfen otopark rampası sorusunu yanıtlayınız.");

    BinaStore.instance.bolum26 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum27Screen()),
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
            title: "Bölüm-26: Kaçış Rampaları",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Varlık
                  _buildSoru("Binadan çıkarken ve bina içerisinde kullanmak zorunda kaldığınız eğimli bir rampa var mı?", 'varlik', 
                    [Bolum26Content.varlikOptionA, Bolum26Content.varlikOptionB], _model.varlik),

                  // Diğer sorular SADECE RAMPA VARSA gösterilir
                  if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) ...[
                    const Divider(height: 30),
                    
                    // 2. Eğim
                    _buildSoru("Bu rampanın eğimi (dikliği) ve zemin kaplaması nasıldır?", 'egim', 
                      [Bolum26Content.egimOptionA, Bolum26Content.egimOptionB], _model.egim),

                    // 3. Sahanlık
                    _buildSoru("Rampanın başlangıcında ve bitişinde sahanlık var mı?", 'sahanlik', 
                      [Bolum26Content.sahanlikOptionA, Bolum26Content.sahanlikOptionB], _model.sahanlik),
                  ],

                  // 4. Otopark Rampası (Sadece otopark varsa sorulur)
                  if (_askOtopark)
                    _buildSoru("Otoparkınızdan dışarı çıkan araç rampasını acil durumda kaçış yolu olarak kullanabilir misiniz?", 'otopark', 
                      [Bolum26Content.otoparkOptionA, Bolum26Content.otoparkOptionB], _model.otopark),
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