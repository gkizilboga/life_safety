import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_36_model.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import 'report_summary_screen.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';

class Bolum36Screen extends StatefulWidget {
  const Bolum36Screen({super.key});
  @override
  State<Bolum36Screen> createState() => _Bolum36ScreenState();
}

class _Bolum36ScreenState extends State<Bolum36Screen> {
  Bolum36Model _model = Bolum36Model();

  final GlobalKey _konumKey = GlobalKey();
  final GlobalKey _genislikKey = GlobalKey();
  final GlobalKey _kapiKey = GlobalKey();

  int _cntDisCelik = 0;
  int _totalValidCikisSayisi = 0;
  bool _hasKorunumlu = false;
  bool _hasKorunumsuz = false;

  @override
  void initState() {
    super.initState();
    final saved = BinaStore.instance.bolum36;
    if (saved != null) {
      _model = saved;
    }

    final b20 = BinaStore.instance.bolum20;
    int icKapali = b20?.binaIciYanginMerdiveniSayisi ?? 0;
    int disKapali = b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0;
    int normal = b20?.normalMerdivenSayisi ?? 0;
    int doner = b20?.donerMerdivenSayisi ?? 0;
    int disAcik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    int sahanliksiz = b20?.sahanliksizMerdivenSayisi ?? 0;
    int dengelenmis =
        (b20?.dengelenmisMerdivenSayisi ?? 0) +
        (b20?.isBodrumIndependent == true
            ? (b20?.bodrumDengelenmisMerdivenSayisi ?? 0)
            : 0);

    _cntDisCelik = disAcik;
    _totalValidCikisSayisi =
        icKapali + disKapali + normal + doner + disAcik + dengelenmis;

    _hasKorunumlu = (icKapali + disKapali) > 0;
    _hasKorunumsuz = (normal + doner + disAcik + sahanliksiz + dengelenmis) > 0;
  }

  List<ChoiceResult> _getFilteredCikisKatiOptions() {
    final b3 = BinaStore.instance.bolum3;
    final int nKat = b3?.normalKatSayisi ?? 0;
    final int bKat = b3?.bodrumKatSayisi ?? 0;

    List<ChoiceResult> options = [Bolum36Content.cikisKatiOptionA];
    if (nKat > 0) options.add(Bolum36Content.cikisKatiOptionB);
    if (bKat > 0) options.add(Bolum36Content.cikisKatiOptionC);
    return options;
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'cikisKati') _model = _model.copyWith(cikisKati: choice);
      if (type == 'disMerd') _model = _model.copyWith(disMerd: choice);
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'kapiTipi') _model = _model.copyWith(kapiTipi: choice);

      if (_model.areWidthsSame) {
        // Birleşik Giriş Aktif ise hem korunumlu hem korunumsuz alanlara yaz
        if (type == 'genislikUnified') {
          _model = _model.copyWith(
            genislikKorunumlu: choice,
            genislikKorunumsuz: choice,
          );
        }
        if (type == 'koridorGenislikUnified') {
          _model = _model.copyWith(
            koridorGenislikKorunumlu: choice,
            koridorGenislikKorunumsuz: choice,
          );
        }
        if (type == 'kapiGenislikUnified') {
          _model = _model.copyWith(
            kapiGenislikKorunumlu: choice,
            kapiGenislikKorunumsuz: choice,
          );
        }
      } else {
        // Ayrı giriş aktif
        if (type == 'genislikKorunumlu')
          _model = _model.copyWith(genislikKorunumlu: choice);
        if (type == 'genislikKorunumsuz')
          _model = _model.copyWith(genislikKorunumsuz: choice);
        if (type == 'koridorGenislikKorunumlu')
          _model = _model.copyWith(koridorGenislikKorunumlu: choice);
        if (type == 'koridorGenislikKorunumsuz')
          _model = _model.copyWith(koridorGenislikKorunumsuz: choice);
        if (type == 'kapiGenislikKorunumlu')
          _model = _model.copyWith(kapiGenislikKorunumlu: choice);
        if (type == 'kapiGenislikKorunumsuz')
          _model = _model.copyWith(kapiGenislikKorunumsuz: choice);
      }
    });
  }


  bool get _isFormValid {
    if (_model.cikisKati == null) return false;
    if (_cntDisCelik > 0 && _model.disMerd == null) return false;
    if (_totalValidCikisSayisi > 1 && _model.konum == null) return false;

    if (_hasKorunumlu) {
      if (_model.genislikKorunumlu == null) return false;
      if (_model.koridorGenislikKorunumlu == null) return false;
      if (_model.kapiGenislikKorunumlu == null) return false;
    }
    if (_hasKorunumsuz) {
      if (_model.genislikKorunumsuz == null) return false;
      if (_model.koridorGenislikKorunumsuz == null) return false;
      if (_model.kapiGenislikKorunumsuz == null) return false;
    }
    if (_model.kapiTipi == null) return false;

    return true;
  }

  void _onFinishPressed() {
    // Otomatik rapor üretimi rapor motoruna (Handler) taşındığı için buradan kaldırıldı.
    // merdivenDegerlendirme sadece manuel mühendis notları için kalacak.
    BinaStore.instance.bolum36 = _model;
    BinaStore.instance.markAsCompleted();
    BinaStore.instance.saveToDisk(immediate: true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleTransitionScreen(
          module: ReportModule.modul5,
          onContinue: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportSummaryScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Genel Değerlendirme",
      screenType: widget.runtimeType,
      isNextEnabled: _isFormValid,
      onNext: _onFinishPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSoruHeader(Bolum36Content.questionCikisKati),
          _buildSoruCard(
            'cikisKati',
            _getFilteredCikisKatiOptions(),
            _model.cikisKati,
          ),
          if (_cntDisCelik > 0) ...[
            _buildSoruHeader(Bolum36Content.questionDisMerd),
            _buildSoruCard('disMerd', [
              Bolum36Content.disMerdOptionA,
              Bolum36Content.disMerdOptionB,
              Bolum36Content.disMerdOptionC,
            ], _model.disMerd),
          ],
          SizedBox(key: _konumKey, height: 1),
          if (_totalValidCikisSayisi > 1) ...[
            _buildSoruHeader(Bolum36Content.questionKonum),
            _buildSoruCard('konum', [
              Bolum36Content.konumOptionA,
              Bolum36Content.konumOptionB,
              Bolum36Content.konumOptionC,
            ], _model.konum),
          ],
          SizedBox(key: _genislikKey, height: 1),

          // --- Birleşik Giriş Toggle ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Benzer Genişlikler",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const Text(
                        "Merdiven, koridor ve kapılar benzer genişlikte mi?",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _model.areWidthsSame,
                  onChanged: (val) {
                    setState(() {
                      if (val) {
                        // OFF -> ON geçişinde Korunumlu değerlerini Korunumsuz'a kopyala (Sync)
                        _model = _model.copyWith(
                          areWidthsSame: true,
                          genislikKorunumsuz: _model.genislikKorunumlu,
                          koridorGenislikKorunumsuz:
                              _model.koridorGenislikKorunumlu,
                          kapiGenislikKorunumsuz: _model.kapiGenislikKorunumlu,
                        );
                      } else {
                        _model = _model.copyWith(areWidthsSame: false);
                      }
                    });
                  },
                  activeColor: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_model.areWidthsSame) ...[
            _buildSoruHeader("${Bolum36Content.questionMerdGenislik} (Tümü)"),
            _buildSoruCard('genislikUnified', [
              Bolum36WidthContent.merdGenislikA,
              Bolum36WidthContent.merdGenislikB,
              Bolum36WidthContent.merdGenislikC,
              Bolum36WidthContent.merdGenislikD,
              Bolum36WidthContent.merdGenislikBilinmiyor,
            ], _model.genislikKorunumlu),
            _buildSoruHeader(
              "${Bolum36Content.questionKoridorGenislik} (Tümü)",
            ),
            _buildSoruCard('koridorGenislikUnified', [
              Bolum36WidthContent.koridorGenislikA,
              Bolum36WidthContent.koridorGenislikB,
              Bolum36WidthContent.koridorGenislikC,
              Bolum36WidthContent.koridorGenislikD,
              Bolum36WidthContent.koridorGenislikE,
              Bolum36WidthContent.koridorGenislikBilinmiyor,
            ], _model.koridorGenislikKorunumlu),
            _buildSoruHeader(
              "${Bolum36Content.questionKapiGenislik} (Tümü)",
              imagePath: AppAssets.section27YanginKapisi,
              imageTitle: "Yangın Kapısı Temiz Genişlik Detayı",
            ),
            _buildSoruCard('kapiGenislikUnified', [
              Bolum36WidthContent.kapiGenislikKritik,
              Bolum36WidthContent.kapiGenislikOlumlu,
              Bolum36WidthContent.kapiGenislikBilinmiyor,
            ], _model.kapiGenislikKorunumlu),
          ] else ...[
            if (_hasKorunumlu) ...[
              _buildSoruHeader(
                "Korunumlu ${Bolum36Content.questionMerdGenislik}",
              ),
              _buildSoruCard('genislikKorunumlu', [
                Bolum36WidthContent.merdGenislikA,
                Bolum36WidthContent.merdGenislikB,
                Bolum36WidthContent.merdGenislikC,
                Bolum36WidthContent.merdGenislikD,
                Bolum36WidthContent.merdGenislikBilinmiyor,
              ], _model.genislikKorunumlu),
              _buildSoruHeader(
                "Korunumlu Merdivene Giden ${Bolum36Content.questionKoridorGenislik}",
              ),
              _buildSoruCard('koridorGenislikKorunumlu', [
                Bolum36WidthContent.koridorGenislikA,
                Bolum36WidthContent.koridorGenislikB,
                Bolum36WidthContent.koridorGenislikC,
                Bolum36WidthContent.koridorGenislikD,
                Bolum36WidthContent.koridorGenislikE,
                Bolum36WidthContent.koridorGenislikBilinmiyor,
              ], _model.koridorGenislikKorunumlu),
              _buildSoruHeader(
                "Korunumlu Merdiven ${Bolum36Content.questionKapiGenislik}",
                imagePath: AppAssets.section27YanginKapisi,
                imageTitle: "Yangın Kapısı Temiz Genişlik Detayı",
              ),
              _buildSoruCard('kapiGenislikKorunumlu', [
                Bolum36WidthContent.kapiGenislikKritik,
                Bolum36WidthContent.kapiGenislikOlumlu,
                Bolum36WidthContent.kapiGenislikBilinmiyor,
              ], _model.kapiGenislikKorunumlu),
            ],
            if (_hasKorunumsuz) ...[
              _buildSoruHeader(
                "Korunumsuz ${Bolum36Content.questionMerdGenislik}",
              ),
              _buildSoruCard('genislikKorunumsuz', [
                Bolum36WidthContent.merdGenislikA,
                Bolum36WidthContent.merdGenislikB,
                Bolum36WidthContent.merdGenislikC,
                Bolum36WidthContent.merdGenislikD,
                Bolum36WidthContent.merdGenislikBilinmiyor,
              ], _model.genislikKorunumsuz),
              _buildSoruHeader(
                "Korunumsuz Merdivene Giden ${Bolum36Content.questionKoridorGenislik}",
              ),
              _buildSoruCard('koridorGenislikKorunumsuz', [
                Bolum36WidthContent.koridorGenislikA,
                Bolum36WidthContent.koridorGenislikB,
                Bolum36WidthContent.koridorGenislikC,
                Bolum36WidthContent.koridorGenislikD,
                Bolum36WidthContent.koridorGenislikE,
                Bolum36WidthContent.koridorGenislikBilinmiyor,
              ], _model.koridorGenislikKorunumsuz),
              _buildSoruHeader(
                "Korunumsuz Merdiven ${Bolum36Content.questionKapiGenislik}",
                imagePath: AppAssets.section27YanginKapisi,
                imageTitle: "Yangın Kapısı Temiz Genişlik Detayı",
              ),
              _buildSoruCard('kapiGenislikKorunumsuz', [
                Bolum36WidthContent.kapiGenislikKritik,
                Bolum36WidthContent.kapiGenislikOlumlu,
                Bolum36WidthContent.kapiGenislikBilinmiyor,
              ], _model.kapiGenislikKorunumsuz),
            ],
          ],

          if (BinaStore.instance.bolum20?.isBodrumIndependent == true)
            CustomInfoNote(
              type: InfoNoteType.info,
              text:
                  "Bodrum kat merdivenleri üst katlardan bağımsız olduğu için, aşağıdaki genişlik beyanlarınızın hem Zemin + Normal katlar hem de Bodrum katlarını kapsadığını veya en dezavantajlı (en dar) kısmı referans aldığınızı unutmayınız.",
              icon: Icons.info_outline,
              margin: const EdgeInsets.only(top: 8, bottom: 20),
            ),
          _buildSoruHeader(Bolum36Content.questionKapiTipi),
          _buildSoruCard('kapiTipi', [
            Bolum36Content.kapiTipiOptionA,
            Bolum36Content.kapiTipiOptionB,
            Bolum36Content.kapiTipiOptionC,
          ], _model.kapiTipi),
          SizedBox(key: _kapiKey, height: 1),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSoruHeader(String title, {String? imagePath, String? imageTitle}) {
    if (imagePath != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: QuestionHeaderWithImage(
          questionText: title,
          imageAssetPath: imagePath,
          imageTitle: imageTitle ?? "Görseli İncele",
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 20),
      child: Text(title, style: AppStyles.questionTitle),
    );
  }

  Widget _buildSoruCard(
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        children: options
            .map(
              (opt) => SelectableCard(
                choice: opt,
                isSelected: selected?.label == opt.label,
                onTap: () => _handleSelection(key, opt),
              ),
            )
            .toList(),
      ),
    );
  }
}
