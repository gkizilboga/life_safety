import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_30_model.dart';
import 'bolum_31_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum30Screen extends StatefulWidget {
  const Bolum30Screen({super.key});

  @override
  State<Bolum30Screen> createState() => _Bolum30ScreenState();
}

class _Bolum30ScreenState extends State<Bolum30Screen> {
  Bolum30Model _model = Bolum30Model();
  final TextEditingController _kapasiteCtrl = TextEditingController();
  bool _hasKazan = false;

  @override
  void initState() {
    super.initState();
    _checkKazan();
  }

  void _checkKazan() {
    final b7 = BinaStore.instance.bolum7;
    if (b7?.hasKazan == true) {
      _hasKazan = true;
    }
  }

  @override
  void dispose() {
    _kapasiteCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'kapi') _model = _model.copyWith(kapi: choice);
      if (type == 'hava') _model = _model.copyWith(hava: choice);
      if (type == 'tup') _model = _model.copyWith(tup: choice);
      
      if (type == 'yakit') {
        _model = _model.copyWith(yakit: choice);
        // Sıvı yakıt değilse drenajı sıfırla
        if (choice.label == Bolum30Content.yakitOptionA.label) {
          _model = _model.copyWith(drenaj: null);
        }
      }
      
      if (type == 'drenaj') _model = _model.copyWith(drenaj: choice);
    });
  }

  void _onNextPressed() {
    if (_hasKazan) {
      if (_model.konum == null) return _showError("Lütfen kazan dairesi konumunu seçiniz.");
      
      // Kapasite Opsiyonel Olabilir veya Zorunlu
      double? kap = double.tryParse(_kapasiteCtrl.text.replaceAll(',', '.'));
      _model = _model.copyWith(kapasite: kap);

      if (_model.kapi == null) return _showError("Lütfen çıkış kapısı sayısını seçiniz.");
      if (_model.hava == null) return _showError("Lütfen havalandırma durumunu seçiniz.");
      if (_model.yakit == null) return _showError("Lütfen yakıt türünü seçiniz.");

      if (_model.yakit?.label == Bolum30Content.yakitOptionB.label && _model.drenaj == null) {
        return _showError("Lütfen drenaj kanalı durumunu seçiniz.");
      }

      if (_model.tup == null) return _showError("Lütfen yangın tüpü durumunu seçiniz.");
    }

    BinaStore.instance.bolum30 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum31Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasKazan) {
      return Scaffold(
        appBar: AppBar(title: const Text("Bölüm-30")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Binanızda Kazan Dairesi bulunmadığı için bu bölüm atlanmıştır."),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _onNextPressed, child: const Text("DEVAM ET"))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-30: Kazan Dairesi",
            subtitle: "Isı merkezinin güvenliği.",
            currentStep: 20, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Konum
                  _buildSoru("Kazan dairesinin konumu ve kapısının açıldığı yer nasıl?", 'konum', 
                    [
                      Bolum30Content.konumOptionA, 
                      Bolum30Content.konumOptionB, 
                      Bolum30Content.konumOptionC
                    ], _model.konum),

                  // 2. Kapasite (Sayısal)
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kazan kapasitesi (kW/kcal) biliniyorsa giriniz (Opsiyonel):", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _kapasiteCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            hintText: "Örn: 350",
                            suffixText: "kW",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Kapı Sayısı
                  _buildSoru("Kazan dairesinin kaç adet çıkış kapısı var?", 'kapi', 
                    [Bolum30Content.kapiOptionA, Bolum30Content.kapiOptionB], _model.kapi),

                  // 4. Havalandırma
                  _buildSoru("İçeriye temiz hava girmesini ve kirli havanın çıkmasını sağlayan menfezler var mı?", 'hava', 
                    [Bolum30Content.havaOptionA, Bolum30Content.havaOptionB], _model.hava),

                  // 5. Yakıt Tipi
                  _buildSoru("Kazanınız sıvı yakıtlı (Mazot/Fuel-oil) mı?", 'yakit', 
                    [Bolum30Content.yakitOptionA, Bolum30Content.yakitOptionB], _model.yakit),

                  // Alt Soru: Drenaj (Sıvı yakıt ise)
                  if (_model.yakit?.label == Bolum30Content.yakitOptionB.label) ...[
                    const Divider(height: 30),
                    _buildSoru("Zeminde dökülen yakıtı toplayacak kanallar ve bir pis su çukuru var mı?", 'drenaj', 
                      [Bolum30Content.drenajOptionA, Bolum30Content.drenajOptionB], _model.drenaj),
                  ],

                  // 6. Yangın Tüpü
                  _buildSoru("Kazan dairesinde yangın söndürme tüpü ve yangın dolabı var mı?", 'tup', 
                    [
                      Bolum30Content.tupOptionA, 
                      Bolum30Content.tupOptionB, 
                      Bolum30Content.tupOptionC
                    ], _model.tup),
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
          )).toList(),
        ],
      ),
    );
  }
}