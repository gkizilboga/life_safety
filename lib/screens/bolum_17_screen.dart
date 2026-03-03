import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_17_model.dart';
import 'bolum_18_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../utils/app_theme.dart';
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
    if (BinaStore.instance.bolum17 != null) {
      _model = BinaStore.instance.bolum17!;
    }
    final b8 = BinaStore.instance.bolum8;
    if (b8?.secim?.label.contains("Bitişik") == true ||
        b8?.secim?.label == "8-1-B") {
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
        if (choice.label != Bolum17Content.isiklikOptionB.label) {
          _model = _model.copyWith(isiklikMalzemesi: null);
        }
      }
    });
  }

  bool get _isComplete {
    if (_model.kaplama == null) return false;
    if (_model.iskelet == null) return false;
    if (_askBitisik && _model.bitisikDuvar == null) return false;
    if (_model.isiklik == null) return false;
    if (_model.isiklik?.label == Bolum17Content.isiklikOptionB.label &&
        _model.isiklikMalzemesi == null) {
      return false;
    }
    return true;
  }

  void _onNextPressed() {
    BinaStore.instance.bolum17 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum18Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Çatı",
      screenType: widget.runtimeType,
      isNextEnabled: _isComplete,
      onNext: _onNextPressed,
      child: Column(
        children: [
          _buildSoru(
            "Çatınızın en üst katmanında hangi malzeme kullanılıyor?",
            'kaplama',
            [
              Bolum17Content.kaplamaOptionA,
              Bolum17Content.kaplamaOptionB,
              Bolum17Content.kaplamaOptionC,
              Bolum17Content.kaplamaOptionD,
              Bolum17Content.kaplamaOptionE,
              Bolum17Content.kaplamaOptionF,
            ],
            _model.kaplama,
          ),

          _buildSoru(
            "Çatıyı taşıyan iskelet ve altındaki ısı yalıtımı nedir?",
            'iskelet',
            [
              Bolum17Content.iskeletOptionA,
              Bolum17Content.iskeletOptionB,
              Bolum17Content.iskeletOptionC,
            ],
            _model.iskelet,
          ),

          if (_askBitisik)
            _buildSoru(
              "Çatılar arasında yangını kesecek bir duvar var mı?",
              'duvar',
              [
                Bolum17Content.bitisikOptionA,
                Bolum17Content.bitisikOptionB,
                Bolum17Content.bitisikOptionC,
              ],
              _model.bitisikDuvar,
            ),

          _buildSoru(
            "Çatınızda ışıklık var mı?",
            'isiklik',
            [
              Bolum17Content.isiklikOptionA,
              Bolum17Content.isiklikOptionB,
              Bolum17Content.isiklikOptionC,
            ],
            _model.isiklik,
            compact: true,
          ),

          if (_model.isiklik?.label == Bolum17Content.isiklikOptionB.label) ...[
            _buildInfoNote("Işıklık bulunduğu için malzeme türü seçilmelidir."),
            QuestionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Işıklık malzemesi nedir?",
                    style: AppStyles.questionTitle,
                  ),
                  const SizedBox(height: 12),
                  // Temperli Cam seçeneği
                  InkWell(
                    onTap: () => setState(
                      () => _model = _model.copyWith(isiklikMalzemesi: "cam"),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: _model.isiklikMalzemesi == "cam"
                            ? const Color(0xFF1A237E).withOpacity(0.1)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _model.isiklikMalzemesi == "cam"
                              ? const Color(0xFF1A237E)
                              : Colors.grey.shade300,
                          width: _model.isiklikMalzemesi == "cam" ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "cam",
                            groupValue: _model.isiklikMalzemesi,
                            activeColor: const Color(0xFF1A237E),
                            onChanged: (v) => setState(
                              () =>
                                  _model = _model.copyWith(isiklikMalzemesi: v),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              "Temperli ve yangına dayanıklı cam ışıklık",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Plastik seçeneği
                  InkWell(
                    onTap: () => setState(
                      () =>
                          _model = _model.copyWith(isiklikMalzemesi: "plastik"),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _model.isiklikMalzemesi == "plastik"
                            ? const Color(0xFF1A237E).withOpacity(0.1)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _model.isiklikMalzemesi == "plastik"
                              ? const Color(0xFF1A237E)
                              : Colors.grey.shade300,
                          width: _model.isiklikMalzemesi == "plastik" ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "plastik",
                            groupValue: _model.isiklikMalzemesi,
                            activeColor: const Color(0xFF1A237E),
                            onChanged: (v) => setState(
                              () =>
                                  _model = _model.copyWith(isiklikMalzemesi: v),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              "Plastik, Pleksi veya Polikarbon ışıklık",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE65100),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
    bool compact = false,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          SizedBox(height: compact ? 4 : 10),
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

