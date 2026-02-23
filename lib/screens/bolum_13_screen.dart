import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_13_model.dart';
import 'bolum_14_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum13Screen extends StatefulWidget {
  const Bolum13Screen({super.key});

  @override
  State<Bolum13Screen> createState() => _Bolum13ScreenState();
}

class _Bolum13ScreenState extends State<Bolum13Screen> {
  Bolum13Model _model = Bolum13Model();

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
  bool _askSiginak = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum13 != null) {
      _model = BinaStore.instance.bolum13!;
    }
    _loadVisibilityLogic();

    // KRİTİK: Eğer hiçbir soru sorulmayacaksa otomatik olarak sonraki ekrana geç
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_shouldShowAnyQuestion()) {
        _onNextPressed();
      }
    });
  }

  bool _shouldShowAnyQuestion() {
    return _askOtopark ||
        _askKazan ||
        _askAsansor ||
        _askJenerator ||
        _askElektrik ||
        _askTrafo ||
        _askDepo ||
        _askCop ||
        _askDuvar ||
        _askTicari ||
        _askSiginak;
  }

  void _loadVisibilityLogic() {
    final b6 = BinaStore.instance.bolum6;
    final b7 = BinaStore.instance.bolum7;
    final b10 = BinaStore.instance.bolum10;

    // Bölüm 10'da herhangi bir katta "Ticari" seçilmiş mi kontrolü
    bool hasTicariInB10 = false;
    if (b10 != null) {
      hasTicariInB10 =
          (b10.zemin?.label.contains("Ticari") ?? false) ||
          (b10.bodrumlar.any((e) => e?.label.contains("Ticari") ?? false)) ||
          (b10.normaller.any((e) => e?.label.contains("Ticari") ?? false));
    }

    setState(() {
      _askOtopark = b6?.hasOtopark ?? false;
      _askKazan = b7?.hasKazan ?? false;
      _askAsansor = b7?.hasAsansor ?? false;
      _askJenerator = b7?.hasJenerator ?? false;
      _askElektrik = b7?.hasElektrik ?? false;
      _askTrafo = b7?.hasTrafo ?? false;
      _askDepo = b6?.hasDepo ?? false;
      _askCop = b7?.hasCop ?? false;
      _askDuvar = b7?.hasDuvar ?? false;
      // Hem Bölüm 6 hem de Bölüm 10'daki ticari alan seçimlerine bakıyoruz
      _askTicari = (b6?.hasTicari ?? false) || hasTicariInB10;
      _askSiginak = b7?.hasSiginak ?? false;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'otopark')
        _model = _model.copyWith(otoparkKapi: choice);
      else if (type == 'kazan')
        _model = _model.copyWith(kazanKapi: choice);
      else if (type == 'asansor')
        _model = _model.copyWith(asansorKapi: choice);
      else if (type == 'jenerator')
        _model = _model.copyWith(jeneratorKapi: choice);
      else if (type == 'elektrik')
        _model = _model.copyWith(elektrikKapi: choice);
      else if (type == 'trafo')
        _model = _model.copyWith(trafoKapi: choice);
      else if (type == 'depo')
        _model = _model.copyWith(depoKapi: choice);
      else if (type == 'cop')
        _model = _model.copyWith(copKapi: choice);
      else if (type == 'duvar')
        _model = _model.copyWith(ortakDuvar: choice);
      else if (type == 'ticari')
        _model = _model.copyWith(ticariKapi: choice);
      else if (type == 'otoparkAlan')
        _model = _model.copyWith(otoparkAlan: choice);
      else if (type == 'kazanAlan')
        _model = _model.copyWith(kazanAlan: choice);
      else if (type == 'siginakAlan')
        _model = _model.copyWith(siginakAlan: choice);
    });
  }

  void _onNextPressed() {
    BinaStore.instance.bolum13 = _model;
    Navigator.pushReplacement(
      // pushReplacement kullanarak geri dönüldüğünde boş ekrana düşmeyi engelliyoruz
      context,
      MaterialPageRoute(builder: (context) => const Bolum14Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Eğer hiçbir soru yoksa boş bir Scaffold döndür (Zaten initState otomatik geçirecek)
    if (!_shouldShowAnyQuestion()) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AnalysisPageLayout(
      title: "Teknik Hacimler",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: true,
      onNext: _onNextPressed,
      child: Column(
        children: [
          if (_askOtopark) ...[
            _buildSoru(
              "Otoparktan bina içine açılan kapının özelliği nedir?",
              'otopark',
              [
                Bolum13Content.otoparkOptionA,
                Bolum13Content.otoparkOptionB,
                Bolum13Content.otoparkOptionC,
                Bolum13Content.otoparkOptionD,
              ],
              _model.otoparkKapi,
            ),
            // ALT SORU: Otopark Alanı
            _buildSoru(
              "Otopark alanları tüm katlarda toplam kaç metrekare?",
              'otoparkAlan',
              [
                Bolum13Content.otoparkAlanOptionA,
                Bolum13Content.otoparkAlanOptionB,
                Bolum13Content.otoparkAlanOptionC,
                Bolum13Content.otoparkAlanOptionD,
                Bolum13Content.otoparkAlanOptionE,
              ],
              _model.otoparkAlan,
            ),
          ],

          if (_askKazan) ...[
            _buildSoruWithDef(
              "Kazan dairesinin duvarları ve kapısı nasıl?",
              "Yangın Kompartımanı",
              AppDefinitions.yanginKompartimani,
              'kazan',
              [
                Bolum13Content.kazanOptionA,
                Bolum13Content.kazanOptionB,
                Bolum13Content.kazanOptionC,
                Bolum13Content.kazanOptionD,
              ],
              _model.kazanKapi,
            ),
            // ALT SORU: Kazan Dairesi Alanı
            _buildSoru(
              "Binadaki kazan dairesi kaç metrekare?",
              'kazanAlan',
              [
                Bolum13Content.kazanAlanOptionA,
                Bolum13Content.kazanAlanOptionB,
                Bolum13Content.kazanAlanOptionC,
              ],
              _model.kazanAlan,
            ),
          ],

          if (_askAsansor)
            _buildSoru("Asansör kapısı nasıldır?", 'asansor', [
              Bolum13Content.asansorOptionA,
              Bolum13Content.asansorOptionB,
              Bolum13Content.asansorOptionC,
            ], _model.asansorKapi),

          if (_askJenerator)
            _buildSoru(
              "Jeneratör odasının duvar ve kapısı nasıl?",
              'jenerator',
              [
                Bolum13Content.jeneratorOptionA,
                Bolum13Content.jeneratorOptionB,
                Bolum13Content.jeneratorOptionC,
              ],
              _model.jeneratorKapi,
            ),

          if (_askElektrik)
            _buildSoru(
              "Elektrik odasının duvarı ve kapısı nasıl?",
              'elektrik',
              [
                Bolum13Content.elekOdasiOptionA,
                Bolum13Content.elekOdasiOptionB,
                Bolum13Content.elekOdasiOptionC,
              ],
              _model.elektrikKapi,
            ),

          if (_askTrafo)
            _buildSoru("Trafo odasının duvar ve kapısı nasıl?", 'trafo', [
              Bolum13Content.trafoOptionA,
              Bolum13Content.trafoOptionB,
              Bolum13Content.trafoOptionC,
            ], _model.trafoKapi),

          if (_askDepo)
            _buildSoru("Eşya deposunun duvar ve kapısı nasıl?", 'depo', [
              Bolum13Content.depoOptionA,
              Bolum13Content.depoOptionB,
              Bolum13Content.depoOptionC,
            ], _model.depoKapi),

          if (_askCop)
            _buildSoru("Çöp toplama odasının duvar ve kapısı nasıl?", 'cop', [
              Bolum13Content.copOptionA,
              Bolum13Content.copOptionB,
              Bolum13Content.copOptionC,
            ], _model.copKapi),

          // YENİ SORU: Sığınak Alanı
          if (_askSiginak)
            _buildSoru("Sığınak alanı kaç metrekare?", 'siginakAlan', [
              Bolum13Content.siginakAlanOptionA,
              Bolum13Content.siginakAlanOptionB,
              Bolum13Content.siginakAlanOptionC,
            ], _model.siginakAlan),

          if (_askDuvar)
            _buildSoru(
              "Yan bina ile ortak kullandığınız duvarın özelliği nedir?",
              'duvar',
              [
                Bolum13Content.ortakDuvarOptionA,
                Bolum13Content.ortakDuvarOptionB,
                Bolum13Content.ortakDuvarOptionC,
              ],
              _model.ortakDuvar,
            ),

          if (_askTicari)
            _buildSoru(
              "Ticari alanlardan konut merdivenine geçiş nasıl?",
              'ticari',
              [
                Bolum13Content.ticariOptionA,
                Bolum13Content.ticariOptionB,
                Bolum13Content.ticariOptionC,
                Bolum13Content.ticariOptionD,
              ],
              _model.ticariKapi,
            ),
        ],
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

  Widget _buildSoruWithDef(
    String title,
    String term,
    String def,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppStyles.questionTitle)),
              DefinitionButton(term: term, definition: def),
            ],
          ),
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
