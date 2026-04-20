import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_31_model.dart';
import 'bolum_32_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

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
    if (BinaStore.instance.bolum31 != null) {
      _model = BinaStore.instance.bolum31!;
    }
    _checkAndRedirect();
  }

  void _checkAndRedirect() {
    final b7 = BinaStore.instance.bolum7;
    if (b7?.hasTrafo == true) {
      setState(() => _hasTrafo = true);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum32Screen()),
        );
      });
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'yapi') _model = _model.copyWith(yapi: choice);
      if (type == 'cevre') _model = _model.copyWith(cevre: choice);
      if (type == 'tip') {
        _model = _model.copyWith(tip: choice);
        if (choice.label != Bolum31Content.tipOptionB.label) {
          _model = _model.copyWith(cukur: null, sondurme: null);
        }
      }
      if (type == 'cukur') _model = _model.copyWith(cukur: choice);
      if (type == 'sondurme') _model = _model.copyWith(sondurme: choice);
    });
  }

  void _onNextPressed() {
    if (_hasTrafo) {
      if (_model.yapi == null)
        return _showError("Lütfen kapı-duvar özelliklerini seçiniz.");
      if (_model.tip == null) return _showError("Lütfen trafo tipini seçiniz.");
      if (_model.tip?.label == Bolum31Content.tipOptionB.label) {
        if (_model.cukur == null)
          return _showError("Lütfen yağ toplama çukuru durumunu seçiniz.");
        if (_model.sondurme == null)
          return _showError("Lütfen otomatik sistemleri seçiniz.");
      }
      if (_model.cevre == null)
        return _showError("Lütfen çevresel risk durumunu seçiniz.");
    }

    BinaStore.instance.bolum31 = _model;
    BinaStore.instance.saveToDisk(); // BU SATIRI EKLE
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
    if (!_hasTrafo)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Trafo Odası",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru(
                    "Trafo odasının duvarları ve kapısı yangına dayanıklı mı?",
                    'yapi',
                    [
                      Bolum31Content.yapiOptionA,
                      Bolum31Content.yapiOptionB,
                      Bolum31Content.yapiOptionC,
                      Bolum31Content.yapiOptionD,
                    ],
                    _model.yapi,
                  ),

                  _buildSoru(
                    "Binanızdaki trafo 'Yağlı Tip' mi yoksa 'Kuru Tip' mi?",
                    'tip',
                    [
                      Bolum31Content.tipOptionA,
                      Bolum31Content.tipOptionB,
                      Bolum31Content.tipOptionC,
                    ],
                    _model.tip,
                  ),

                  if (_model.tip?.label == Bolum31Content.tipOptionB.label) ...[
                    _buildInfoNote(
                      "Yağlı tip trafolar için sızıntı ve söndürme detayları doldurulmalıdır.",
                    ),
                    _buildSubQuestion(
                      "Trafonun altında yağ toplama çukuru ve ızgara var mı?",
                      'cukur',
                      [
                        Bolum31Content.cukurOptionA,
                        Bolum31Content.cukurOptionB,
                        Bolum31Content.cukurOptionC,
                      ],
                      _model.cukur,
                    ),
                    _buildSubQuestion(
                      "Trafo odasında otomatik yangın algılama veya söndürme sistemi var mı?",
                      'sondurme',
                      [
                        Bolum31Content.sondurmeOptionA,
                        Bolum31Content.sondurmeOptionB,
                        Bolum31Content.sondurmeOptionC,
                        Bolum31Content.sondurmeOptionD,
                        Bolum31Content.sondurmeOptionE,
                      ],
                      _model.sondurme,
                    ),
                  ],

                  _buildSoru(
                    "Trafo odasının içerisinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?",
                    'cevre',
                    [
                      Bolum31Content.cevreOptionA,
                      Bolum31Content.cevreOptionB,
                      Bolum31Content.cevreOptionC,
                      Bolum31Content.cevreOptionD,
                    ],
                    _model.cevre,
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
    return CustomInfoNote(
      type: InfoNoteType.info,
      text: text,
      icon: Icons.arrow_downward,
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
          const SizedBox(height: 10),
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

  Widget _buildSubQuestion(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionTitle(title),
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

