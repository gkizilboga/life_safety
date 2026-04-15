import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_25_model.dart';
import 'bolum_26_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart';

class Bolum25Screen extends StatefulWidget {
  const Bolum25Screen({super.key});

  @override
  State<Bolum25Screen> createState() => _Bolum25ScreenState();
}

class _Bolum25ScreenState extends State<Bolum25Screen> {
  Bolum25Model _model = Bolum25Model();
  bool _isCommercial = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum25 != null) {
      _model = BinaStore.instance.bolum25!;
    }
    _checkLogicAndRedirect();
  }

  void _checkLogicAndRedirect() {
    final b20 = BinaStore.instance.bolum20;
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;

    int donerCount = b20?.donerMerdivenSayisi ?? 0;

    if (donerCount == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum26Screen()),
        );
      });
    }

    bool hasTicari =
        (b6?.hasTicari ?? false) ||
        (b10?.zemin?.label.contains("Ticari") ?? false) ||
        (b10?.bodrumlar.any((e) => e?.label.contains("Ticari") ?? false) ??
            false) ||
        (b10?.normaller.any((e) => e?.label.contains("Ticari") ?? false) ??
            false);

    setState(() {
      _isCommercial = hasTicari;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'genislik') _model = _model.copyWith(genislik: choice);
      if (type == 'basamak') _model = _model.copyWith(basamak: choice);
      if (type == 'basKurtarma') _model = _model.copyWith(basKurtarma: choice);
      if (type == 'yukseklik') _model = _model.copyWith(yukseklik: choice);
    });
  }

  bool _isReady() {
    return _model.genislik != null &&
        _model.basamak != null &&
        _model.basKurtarma != null &&
        _model.yukseklik != null;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Dairesel Merdiven",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum25 = _model;
        BinaStore.instance.saveToDisk();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleTransitionScreen(
              module: ReportModule.modul3,
              onContinue: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Bolum26Screen(),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuidanceBanner(),
          if (_isCommercial) _buildCommercialWarning(),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Binadaki dairesel merdivenin ölçüleri:",
              style: AppStyles.questionTitle,
            ),
          ),
          const SizedBox(height: 8),
          _buildSoru("Merdiven kol genişliği nedir?", 'genislik', [
            Bolum25Content.genislikOptionA,
            Bolum25Content.genislikOptionB,
            Bolum25Content.genislikOptionC,
          ], _model.genislik),
          _buildSoru("Basamak genişliği nedir?", 'basamak', [
            Bolum25Content.basamakOptionA,
            Bolum25Content.basamakOptionB,
            Bolum25Content.basamakOptionC,
          ], _model.basamak),
          _buildSoru("Baş kurtarma yüksekliği nedir?", 'basKurtarma', [
            Bolum25Content.basKurtarmaOptionA,
            Bolum25Content.basKurtarmaOptionB,
            Bolum25Content.basKurtarmaOptionC,
          ], _model.basKurtarma),
          _buildSoru(
            "Dairesel merdivenin (bina boyunca) toplam yüksekliği nedir?",
            'yukseklik',
            [
              Bolum25Content.daireselYukseklikOptionA,
              Bolum25Content.daireselYukseklikOptionB,
              Bolum25Content.daireselYukseklikOptionC,
            ],
            _model.yukseklik,
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceBanner() {
    return const CustomInfoNote(
      type: InfoNoteType.info,
      text:
          "Binanızda dairesel merdiven olduğunu belirttiğiniz için bu bölüm açılmıştır. Eğer binanızda dairesel merdiven yok ise lütfen Bölüm-20'ye dönerek merdiven sayılarını güncelleyin.",
      icon: Icons.info_outline_rounded,
    );
  }

  Widget _buildCommercialWarning() {
    // Kaldırıldı - artık bu kutuya gerek yok
    return const SizedBox.shrink();
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
