import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_28_model.dart';
import 'bolum_29_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum28Screen extends StatefulWidget {
  const Bolum28Screen({super.key});

  @override
  State<Bolum28Screen> createState() => _Bolum28ScreenState();
}

class _Bolum28ScreenState extends State<Bolum28Screen> {
  Bolum28Model _model = Bolum28Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum28 != null) {
      _model = BinaStore.instance.bolum28!;
    } else {
      // Çoğu apartman dairesi tek katlı olduğu ve 20m mesafeyi aşmadığı için 
      // bu şıkları varsayılan olarak işaretleyip kullanıcıyı hızlandırıyoruz.
      _model = _model.copyWith(
        mesafe: Bolum28Content.mesafeOptionA,
        dubleks: Bolum28Content.dubleksOptionA,
      );
    }
  }

  bool _isSmallBuilding() {
    final b3 = BinaStore.instance.bolum3;
    int toplamKat = (b3?.normalKatSayisi ?? 0) + (b3?.bodrumKatSayisi ?? 0) + 1;
    return toplamKat <= 4;
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mesafe') _model = _model.copyWith(mesafe: choice);

      if (type == 'dubleks') {
        _model = _model.copyWith(dubleks: choice);
        if (choice.label != Bolum28Content.dubleksOptionB.label) {
          _model = _model.copyWith(alan: null, cikis: null);
        }
      }

      if (type == 'alan') {
        _model = _model.copyWith(alan: choice);
        if (choice.label != Bolum28Content.alanOption2.label) {
          _model = _model.copyWith(cikis: null);
        }
      }

      if (type == 'cikis') _model = _model.copyWith(cikis: choice);
    });
  }

  void _onNextPressed() {
    if (_model.mesafe == null)
      return _showError("Lütfen mesafe sorusunu yanıtlayınız.");
    if (_model.dubleks == null)
      return _showError("Lütfen daire tipini seçiniz.");

    if (_model.dubleks?.label == Bolum28Content.dubleksOptionB.label) {
      if (_model.alan == null)
        return _showError("Lütfen üst kat alanını belirtiniz.");
      if (_model.alan?.label == Bolum28Content.alanOption2.label &&
          _model.cikis == null) {
        return _showError("Lütfen üst kat çıkış kapısı durumunu belirtiniz.");
      }
    }

    BinaStore.instance.bolum28 = _model;
    BinaStore.instance.saveToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum29Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Daire İçi Kaçış Mesafesi",
      screenType: widget.runtimeType,
      isNextEnabled: true,
      onNext: _onNextPressed,
      child: Column(
        children: [
          if (_isSmallBuilding())
            _buildInfoNote(
              "Rehber Bilgi: 4 kat ve altı binalarda daire içi kaçış mesafeleri genellikle 20 metrelik yasal sınırın altındadır. Yine de en uzak noktayı göz kararı teyit etmeniz önerilir.",
            ),
          _buildSoru(
            "Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan mesafe ne kadardır?",
            'mesafe',
            [
              Bolum28Content.mesafeOptionA,
              Bolum28Content.mesafeOptionB,
              Bolum28Content.mesafeOptionC,
              Bolum28Content.mesafeOptionD,
            ],
            _model.mesafe,
          ),

          _buildSoru("Daireniz dubleks (iki katlı) mi?", 'dubleks', [
            Bolum28Content.dubleksOptionA,
            Bolum28Content.dubleksOptionB,
          ], _model.dubleks),

          if (_model.dubleks?.label == Bolum28Content.dubleksOptionB.label) ...[
            _buildInfoNote(
              "Dubleks daire seçildiği için üst kat alan bilgisi gereklidir.",
            ),
            _buildSoru("Üst katınızın alanı 70 m²'den büyük mü?", 'alan', [
              Bolum28Content.alanOption1,
              Bolum28Content.alanOption2,
            ], _model.alan),
          ],

          if (_model.alan?.label == Bolum28Content.alanOption2.label) ...[
            _buildInfoNote(
              "70 m² üzeri dublekslerde ikinci çıkış kapısı sorgulanmaktadır.",
            ),
            _buildSoru(
              "Üst kattan apartman koridoruna açılan ikinci bir çelik kapı(çıkış) var mı?",
              'cikis',
              [Bolum28Content.cikisOptionA, Bolum28Content.cikisOptionB],
              _model.cikis,
            ),
          ],
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
}
