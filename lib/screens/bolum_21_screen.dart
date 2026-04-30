import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_21_model.dart';
import 'bolum_22_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum21Screen extends StatefulWidget {
  const Bolum21Screen({super.key});

  @override
  State<Bolum21Screen> createState() => _Bolum21ScreenState();
}

class _Bolum21ScreenState extends State<Bolum21Screen> {
  Bolum21Model _model = Bolum21Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum21 != null) {
      _model = BinaStore.instance.bolum21!;
    } else {
      _applyAutoSelection();
    }
  }

  void _applyAutoSelection() {
    final b20 = BinaStore.instance.bolum20;
    final b10 = BinaStore.instance.bolum10;
    final double hYapi = BinaStore.instance.bolum3?.hYapi ?? 0.0;

    bool shouldBeNo = false;

    // 1. Kriter: Merdiven tiplerine göre kontrol (Bina içi/dışı kapalı yangın merdiveni yoksa)
    if (b20 != null) {
      final int totalSpecialStairs = b20.binaIciYanginMerdiveniSayisi +
          b20.binaDisiKapaliYanginMerdiveniSayisi +
          b20.bodrumBinaIciYanginMerdiveniSayisi +
          b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi;
      if (totalSpecialStairs == 0) shouldBeNo = true;
    }

    // 2. Kriter: Konut harici alan yoksa VE yapı yüksekliği 30.5m altındaysa
    if (b10 != null && hYapi < 30.5) {
      bool isAllKonut = (b10.zemin?.label == Bolum10Content.konut.label) &&
          b10.bodrumlar.every((e) => e?.label == Bolum10Content.konut.label) &&
          b10.normaller.every((e) => e?.label == Bolum10Content.konut.label);

      if (isAllKonut) shouldBeNo = true;
    }

    if (shouldBeNo) {
      _model = _model.copyWith(varlik: Bolum21Content.varlikOptionB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yangın Güvenlik Holü",
      screenType: widget.runtimeType,
      isNextEnabled: _model.varlik != null,
      onNext: () {
        BinaStore.instance.bolum21 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum22Screen()),
        );
      },
      child: Column(
        children: [
          _buildSoru(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "Merdiven(ler)in önünde Yangın Güvenlik Holü (YGH) var mı?",
                        style: AppStyles.questionTitle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => ImageModalHelper.show(
                        context,
                        assetPath: 'assets/images/sections/ygh_1.webp',
                        title: "YGH",
                      ),
                      child: Tooltip(
                        message: 'Görseli incele',
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF43A047).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.photo_camera,
                            color: Color(0xFF2E7D32),
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DefinitionButton(
                      term: "Yangın Güvenlik Holü (YGH)",
                      definition: AppDefinitions.yanginGuvenlikHolu,
                    ),
                  ],
                ),
              ],
            ),
            'varlik',
            [
              Bolum21Content.varlikOptionA,
              Bolum21Content.varlikOptionB,
              Bolum21Content.varlikOptionC,
            ],
            _model.varlik,
          ),

          if (_model.varlik?.label == Bolum21Content.varlikOptionA.label) ...[
            _buildSubQuestion(
              "YGH (Hol) içindeki kaplama malzemeleri yanmaz özellikte mi?",
              'malzeme',
              [
                Bolum21Content.malzemeOptionA,
                Bolum21Content.malzemeOptionB,
                Bolum21Content.malzemeOptionC,
              ],
              _model.malzeme,
            ),
            _buildSubQuestion(
              "YGH (Hol) kapıları yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan özellikte mi?",
              'kapi',
              [
                Bolum21Content.kapiOptionA,
                Bolum21Content.kapiOptionB,
                Bolum21Content.kapiOptionC,
              ],
              _model.kapi,
            ),
            _buildSubQuestion(
              "YGH (Hol) içinde gereksiz eşyalar var mı?",
              'esya',
              [
                Bolum21Content.esyaOptionA,
                Bolum21Content.esyaOptionB,
                Bolum21Content.esyaOptionC,
                Bolum21Content.esyaOptionD,
              ],
              _model.esya,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubQuestion(
    String title,
    String keyParam,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubQuestionTitle(title, style: AppStyles.questionTitle),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => setState(() {
                if (keyParam == 'malzeme')
                  _model = _model.copyWith(malzeme: opt);
                if (keyParam == 'kapi') _model = _model.copyWith(kapi: opt);
                if (keyParam == 'esya') _model = _model.copyWith(esya: opt);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(
    dynamic title,
    String keyParam,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
    Widget? footerWidget,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title is String)
            Text(title, style: AppStyles.questionTitle)
          else if (title is Widget)
            title,
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => setState(() {
                if (keyParam == 'varlik') {
                  _model = _model.copyWith(varlik: opt);
                }
                if (keyParam == 'malzeme')
                  _model = _model.copyWith(malzeme: opt);
                if (keyParam == 'kapi') _model = _model.copyWith(kapi: opt);
                if (keyParam == 'esya') _model = _model.copyWith(esya: opt);
              }),
            ),
          ),
          if (footerWidget != null) ...[
            const SizedBox(height: 12),
            footerWidget,
          ],
        ],
      ),
    );
  }
}
