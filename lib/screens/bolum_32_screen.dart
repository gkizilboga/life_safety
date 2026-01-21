import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_32_model.dart';
import 'bolum_33_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum32Screen extends StatefulWidget {
  const Bolum32Screen({super.key});

  @override
  State<Bolum32Screen> createState() => _Bolum32ScreenState();
}

class _Bolum32ScreenState extends State<Bolum32Screen> {
  Bolum32Model _model = Bolum32Model();
  bool _hasJenerator = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum32 != null) {
      _model = BinaStore.instance.bolum32!;
    }
    _checkJeneratorAndRedirect();
  }

  void _checkJeneratorAndRedirect() {
    final b7 = BinaStore.instance.bolum7;
    if (b7?.hasJenerator == true) {
      setState(() => _hasJenerator = true);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum33Screen()),
        );
      });
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'yapi') _model = _model.copyWith(yapi: choice);
      if (type == 'yakit') _model = _model.copyWith(yakit: choice);
      if (type == 'cevre') _model = _model.copyWith(cevre: choice);
      if (type == 'egzoz') _model = _model.copyWith(egzoz: choice);
    });
  }

  void _onNextPressed() {
    if (_hasJenerator) {
      if (_model.yapi == null)
        return _showError("Lütfen yapı özelliklerini seçiniz.");
      if (_model.yakit == null)
        return _showError("Lütfen yakıt depolama şeklini seçiniz.");
      if (_model.cevre == null)
        return _showError("Lütfen çevresel risk durumunu seçiniz.");
      if (_model.egzoz == null)
        return _showError("Lütfen egzoz durumunu seçiniz.");
    }

    BinaStore.instance.bolum32 = _model;
    BinaStore.instance.saveToDisk(); // VERİYİ DİSKE YAZ
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum33Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasJenerator)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Jeneratör Odası",
            subtitle: "Bina Yedek Güç Kaynağı",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru(
                    "Jeneratör odasının duvarları yangına dayanıklı mı ve kapısı nereye açılıyor?",
                    'yapi',
                    [
                      Bolum32Content.yapiOptionA,
                      Bolum32Content.yapiOptionB,
                      Bolum32Content.yapiOptionC,
                      Bolum32Content.yapiOptionD,
                    ],
                    _model.yapi,
                  ),

                  _buildSoru(
                    "Jeneratörün yakıtı nerede ve nasıl depolanıyor?",
                    'yakit',
                    [
                      Bolum32Content.yakitOptionA,
                      Bolum32Content.yakitOptionB,
                      Bolum32Content.yakitOptionC,
                    ],
                    _model.yakit,
                  ),

                  if (_model.yakit != null)
                    _buildInfoNote(
                      "Yakıt deposu jeneratör odası dışındaysa, boru hattının yangına dayanıklı şaft içinden geçmesi önerilir.",
                    ),

                  _buildSoru(
                    "Jeneratör odasının içinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?",
                    'cevre',
                    [
                      Bolum32Content.cevreOptionA,
                      Bolum32Content.cevreOptionB,
                      Bolum32Content.cevreOptionC,
                      Bolum32Content.cevreOptionD,
                    ],
                    _model.cevre,
                  ),

                  _buildSoru(
                    "Jeneratörün egzoz borusu nereye veriliyor ve oda havalandırılıyor mu?",
                    'egzoz',
                    [
                      Bolum32Content.egzozOptionA,
                      Bolum32Content.egzozOptionB,
                      Bolum32Content.egzozOptionC,
                    ],
                    _model.egzoz,
                  ),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF0D47A1),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
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
    );
  }

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => _handleSelection(key, opt),
            ),
          ),
        ],
      ),
    );
  }
}
