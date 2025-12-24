import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_13_model.dart';
import 'bolum_14_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum13Screen extends StatefulWidget {
  const Bolum13Screen({super.key});

  @override
  State<Bolum13Screen> createState() => _Bolum13ScreenState();
}

class _Bolum13ScreenState extends State<Bolum13Screen> {
  Bolum13Model _model = Bolum13Model();

  // Hangi soruların sorulacağını belirleyen bayraklar
  bool _askOtopark = false;
  bool _askKazan = false;
  bool _askAsansor = false;
  bool _askJenerator = false;
  bool _askElektrik = false;
  bool _askTrafo = false;
  bool _askDepo = false;
  bool _askCop = false;
  bool _askDuvar = false;
  bool _askTicari = false;

  @override
  void initState() {
    super.initState();
    _loadVisibilityLogic();
  }

  void _loadVisibilityLogic() {
    final b6 = BinaStore.instance.bolum6;
    final b7 = BinaStore.instance.bolum7;

    setState(() {
      _askOtopark = (b6?.hasOtopark ?? false) || (b7?.hasOtopark ?? false);
      _askKazan = b7?.hasKazan ?? false;
      _askAsansor = b7?.hasAsansor ?? false;
      _askJenerator = b7?.hasJenerator ?? false;
      _askElektrik = b7?.hasElektrik ?? false;
      _askTrafo = b7?.hasTrafo ?? false;
      _askDepo = (b6?.hasDepo ?? false) || (b7?.hasDepo ?? false);
      _askCop = b7?.hasCop ?? false;
      _askDuvar = b7?.hasDuvar ?? false;
      _askTicari = b6?.hasTicari ?? false;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'otopark') _model = _model.copyWith(otoparkKapi: choice);
      else if (type == 'kazan') _model = _model.copyWith(kazanKapi: choice);
      else if (type == 'asansor') _model = _model.copyWith(asansorKapi: choice);
      else if (type == 'jenerator') _model = _model.copyWith(jeneratorKapi: choice);
      else if (type == 'elektrik') _model = _model.copyWith(elektrikKapi: choice);
      else if (type == 'trafo') _model = _model.copyWith(trafoKapi: choice);
      else if (type == 'depo') _model = _model.copyWith(depoKapi: choice);
      else if (type == 'cop') _model = _model.copyWith(copKapi: choice);
      else if (type == 'duvar') _model = _model.copyWith(ortakDuvar: choice);
      else if (type == 'ticari') _model = _model.copyWith(ticariKapi: choice);
    });
  }

  void _onNextPressed() {
    // Validasyon: Görünen her soru cevaplanmalı
    if (_askOtopark && _model.otoparkKapi == null) return _showError("Lütfen otopark kapısı sorusunu yanıtlayınız.");
    if (_askKazan && _model.kazanKapi == null) return _showError("Lütfen kazan dairesi sorusunu yanıtlayınız.");
    if (_askAsansor && _model.asansorKapi == null) return _showError("Lütfen asansör sorusunu yanıtlayınız.");
    if (_askJenerator && _model.jeneratorKapi == null) return _showError("Lütfen jeneratör sorusunu yanıtlayınız.");
    if (_askElektrik && _model.elektrikKapi == null) return _showError("Lütfen elektrik odası sorusunu yanıtlayınız.");
    if (_askTrafo && _model.trafoKapi == null) return _showError("Lütfen trafo odası sorusunu yanıtlayınız.");
    if (_askDepo && _model.depoKapi == null) return _showError("Lütfen depo kapısı sorusunu yanıtlayınız.");
    if (_askCop && _model.copKapi == null) return _showError("Lütfen çöp odası sorusunu yanıtlayınız.");
    if (_askDuvar && _model.ortakDuvar == null) return _showError("Lütfen ortak duvar sorusunu yanıtlayınız.");
    if (_askTicari && _model.ticariKapi == null) return _showError("Lütfen ticari alan sorusunu yanıtlayınız.");

    BinaStore.instance.bolum13 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum14Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // Eğer hiçbir riskli alan yoksa otomatik geçilebilir veya boş mesaj gösterilebilir
    if (!_askOtopark && !_askKazan && !_askAsansor && !_askJenerator && 
        !_askElektrik && !_askTrafo && !_askDepo && !_askCop && !_askDuvar && !_askTicari) {
       return Scaffold(
        appBar: AppBar(title: const Text("Bölüm-13")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Binanızda riskli alan bulunmadığı için bu bölüm atlanmıştır."),
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
            title: "Bölüm-13: Yangın Kapıları",
            subtitle: "Riskli alanların kapıları ve duvarları.",
            currentStep: 3,
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_askOtopark) _buildSoru("Otoparktan bina içine (merdiven veya asansör holüne) açılan kapınızın özelliği nedir?", 'otopark', 
                    [Bolum13Content.otoparkOptionA, Bolum13Content.otoparkOptionB, Bolum13Content.otoparkOptionC, Bolum13Content.otoparkOptionD], _model.otoparkKapi),

                  if (_askKazan) _buildSoru("Kazan dairesinin duvarları ve kapısı nasıldır?", 'kazan', 
                    [Bolum13Content.kazanOptionA, Bolum13Content.kazanOptionB, Bolum13Content.kazanOptionC, Bolum13Content.kazanOptionD], _model.kazanKapi),

                  if (_askAsansor) _buildSoru("Binanızdaki normal asansörün kapısı nasıldır?", 'asansor', 
                    [Bolum13Content.asansorOptionA, Bolum13Content.asansorOptionB, Bolum13Content.asansorOptionC], _model.asansorKapi),

                  if (_askJenerator) _buildSoru("Jeneratör odasının duvar ve kapısı nasıldır?", 'jenerator', 
                    [Bolum13Content.jeneratorOptionA, Bolum13Content.jeneratorOptionB, Bolum13Content.jeneratorOptionC], _model.jeneratorKapi),

                  if (_askElektrik) _buildSoru("Binadaki elektrik odalarının duvarları ve kapıları nasıldır?", 'elektrik', 
                    [Bolum13Content.elekOdasiOptionA, Bolum13Content.elekOdasiOptionB, Bolum13Content.elekOdasiOptionC], _model.elektrikKapi),

                  if (_askTrafo) _buildSoru("Trafo odasının kapısı nasıldır?", 'trafo', 
                    [Bolum13Content.trafoOptionA, Bolum13Content.trafoOptionB, Bolum13Content.trafoOptionC], _model.trafoKapi),

                  if (_askDepo) _buildSoru("Eşya deposunun veya depolarının kapısı nasıldır?", 'depo', 
                    [Bolum13Content.depoOptionA, Bolum13Content.depoOptionB, Bolum13Content.depoOptionC], _model.depoKapi),

                  if (_askCop) _buildSoru("Çöp toplama odasının kapısı ve havalandırması nasıldır?", 'cop', 
                    [Bolum13Content.copOptionA, Bolum13Content.copOptionB, Bolum13Content.copOptionC], _model.copKapi),

                  if (_askDuvar) _buildSoru("Yan bina ile ortak kullandığınız duvarın cinsi nedir?", 'duvar', 
                    [Bolum13Content.ortakDuvarOptionA, Bolum13Content.ortakDuvarOptionB, Bolum13Content.ortakDuvarOptionC], _model.ortakDuvar),

                  if (_askTicari) _buildSoru("Konutların altındaki dükkan veya ofisten konut merdivenine geçiş nasıl?", 'ticari', 
                    [Bolum13Content.ticariOptionA, Bolum13Content.ticariOptionB, Bolum13Content.ticariOptionC], _model.ticariKapi),
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

  // Soru Widget'ını oluşturan yardımcı fonksiyon (Kod tekrarını önler)
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