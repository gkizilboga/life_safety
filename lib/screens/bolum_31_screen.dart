import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_31_model.dart';
import 'bolum_32_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum31Screen extends StatefulWidget {
  const Bolum31Screen({super.key});

  @override
  State<Bolum31Screen> createState() => _Bolum31ScreenState();
}

class _Bolum31ScreenState extends State<Bolum31Screen> {
  Bolum31Model _model = Bolum31Model();
  bool _hasTrafo = false;

  @override
  void initState() {
    super.initState();
    _checkTrafo();
  }

  void _checkTrafo() {
    final b7 = BinaStore.instance.bolum7;
    if (b7?.hasTrafo == true) {
      _hasTrafo = true;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'yapi') _model = _model.copyWith(yapi: choice);
      if (type == 'cevre') _model = _model.copyWith(cevre: choice);
      
      if (type == 'tip') {
        _model = _model.copyWith(tip: choice);
        // Kuru tip seçilirse alt soruları temizle
        if (choice.label == Bolum31Content.tipOptionA.label) {
          _model = _model.copyWith(cukur: null, sondurme: null);
        }
      }
      
      if (type == 'cukur') _model = _model.copyWith(cukur: choice);
      if (type == 'sondurme') _model = _model.copyWith(sondurme: choice);
    });
  }

  void _onNextPressed() {
    if (_hasTrafo) {
      if (_model.yapi == null) return _showError("Lütfen trafo odası yapı özelliklerini seçiniz.");
      if (_model.tip == null) return _showError("Lütfen trafo tipini seçiniz.");

      // Yağlı tipse detaylar zorunlu
      if (_model.tip?.label == Bolum31Content.tipOptionB.label) {
        if (_model.cukur == null) return _showError("Lütfen yağ toplama çukuru durumunu seçiniz.");
        if (_model.sondurme == null) return _showError("Lütfen otomatik söndürme durumunu seçiniz.");
      }

      if (_model.cevre == null) return _showError("Lütfen çevresel risk durumunu seçiniz.");
    }

    BinaStore.instance.bolum31 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum32Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasTrafo) {
      return Scaffold(
        appBar: AppBar(title: const Text("Bölüm-31")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Binanızda Trafo bulunmadığı için bu bölüm atlanmıştır."),
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
            title: "Bölüm-31: Trafo Odası",
            subtitle: "Yüksek gerilim güvenliği.",
            currentStep: 21, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Yapı Özellikleri
                  _buildSoru("Trafo odasının duvarları ve kapısı yangına dayanıklı mı?", 'yapi', 
                    [
                      Bolum31Content.yapiOptionA, 
                      Bolum31Content.yapiOptionB, 
                      Bolum31Content.yapiOptionC
                    ], _model.yapi),

                  // 2. Trafo Tipi
                  _buildSoru("Binanızdaki trafo 'Yağlı Tip' mi yoksa 'Kuru Tip' mi?", 'tip', 
                    [Bolum31Content.tipOptionA, Bolum31Content.tipOptionB], _model.tip),

                  // Alt Sorular (Yağlı Tip ise)
                  if (_model.tip?.label == Bolum31Content.tipOptionB.label) ...[
                    const Divider(height: 30),
                    _buildSoru("Trafonun altında 'Yağ Toplama Çukuru' ve ızgara var mı?", 'cukur', 
                      [Bolum31Content.cukurOptionA, Bolum31Content.cukurOptionB], _model.cukur),

                    _buildSoru("Trafo odasında otomatik yangın algılama veya söndürme sistemi var mı?", 'sondurme', 
                      [Bolum31Content.sondurmeOptionA, Bolum31Content.sondurmeOptionB], _model.sondurme),
                  ],

                  // 3. Çevresel Riskler
                  _buildSoru("Trafo odasının içinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?", 'cevre', 
                    [
                      Bolum31Content.cevreOptionA, 
                      Bolum31Content.cevreOptionB, 
                      Bolum31Content.cevreOptionC
                    ], _model.cevre),
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