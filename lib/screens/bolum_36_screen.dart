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

  String _evaluateStairsAndExits() {
    final store = BinaStore.instance;
    final b4 = store.bolum4;
    final b33 = store.bolum33;
    final b34 = store.bolum34;

    double hBina = b4?.hesaplananBinaYuksekligi ?? 0.0;
    double hYapi = b4?.hesaplananYapiYuksekligi ?? 0.0;

    List<String> notes = [];

    // Sahanlıksız, Dengelenmiş, Dış Açık Çelik ve Basınçlandırma kuralları
    // tümüyle report_engine.dart içindeki Section36Handler'a taşındı.
    // Bu metod (Manuel Değerlendirme olarak kullanılacak) artık SADECE merdiven/koridor genişliklerini hesaplar.

    // --- Genişlik Kontrolleri (ChoiceResult tabanlı Yeni Kurgu) ---
    int yukBodrum = b33?.yukBodrum ?? 0;
    double hPrimary = hYapi >= hBina ? hYapi : hBina;
    bool isYuksekBina = hPrimary >= (21.50 - 0.001);

    int effectiveLoad = 0;
    if (b33 != null) {
      bool zeminIndependent = b34?.zemin?.label.contains("34-1-A") ?? false;
      int yukZemin = zeminIndependent ? 0 : (b33.yukZemin ?? 0);
      int yukNormal = b33.yukNormal ?? 0;
      effectiveLoad = [
        yukZemin,
        yukNormal,
        yukBodrum,
      ].reduce((a, b) => a > b ? a : b);
    }

    int minMerdiven = 120;
    int minKoridor = 110;

    // Kural 4: Yük >= 2001
    if (effectiveLoad >= 2001) {
      minMerdiven = 200;
      minKoridor = 200;
    }
    // Kural 3: 501 <= Yük < 2001 (Her yükseklikte)
    else if (effectiveLoad >= 501) {
      minMerdiven = 150;
      minKoridor = 150;
    }
    // Kural 2: Yüksek Bina ve Yük < 501
    else if (isYuksekBina) {
      minMerdiven = 120;
      minKoridor = 120;
    }
    // Kural 1: Yüksek Değil ve Yük < 501
    else {
      minMerdiven = 120; // Normalde min 120 cm merdiven kuralı (Madde 44)
      minKoridor = 110;
    }

    List<int>? getMerdRange(ChoiceResult? c) {
      if (c == null) return null;
      if (c.label == "36-Merd-A") return [0, 119];
      if (c.label == "36-Merd-B") return [120, 150];
      if (c.label == "36-Merd-C") return [151, 200];
      if (c.label == "36-Merd-D") return [201, 9999];
      return null; // Bilinmiyor veya null
    }

    List<int>? getKoriRange(ChoiceResult? c) {
      if (c == null) return null;
      if (c.label == "36-Koridor-A") return [0, 99];
      if (c.label == "36-Koridor-B") return [100, 120];
      if (c.label == "36-Koridor-C") return [121, 150];
      if (c.label == "36-Koridor-D") return [151, 200];
      if (c.label == "36-Koridor-E") return [201, 9999];
      return null; // Bilinmiyor veya null
    }

    void checkWidths(
      String prefix,
      ChoiceResult? sChoice,
      ChoiceResult? cChoice,
      ChoiceResult? kapiChoice,
    ) {
      List<String> violations = [];

      var sRange = getMerdRange(sChoice);
      bool hasSpiral =
          (BinaStore.instance.bolum20?.donerMerdivenSayisi ?? 0) > 0 ||
          (BinaStore.instance.bolum20?.bodrumDonerMerdivenSayisi ?? 0) > 0;

      if (sRange != null) {
        // User instruction: For spiral-related checks (or if spiral exists in building),
        // use upper bound (range[1]). Otherwise use safe-logic (range[0]).
        int comparisonValue = hasSpiral ? sRange[1] : sRange[0];
        if (comparisonValue < minMerdiven) {
          violations.add(
            "Merdiven genişliği yetersiz (Gereken: En Az $minMerdiven cm, Mevcut: ${sChoice!.uiTitle})",
          );
        }
      }

      var cRange = getKoriRange(cChoice);
      if (cRange != null) {
        // Safe logic for corridors as well
        if (cRange[0] < minKoridor) {
          violations.add(
            "Koridor genişliği yetersiz (Gereken: En Az $minKoridor cm, Mevcut: ${cChoice!.uiTitle})",
          );
        }
      }

      if (kapiChoice != null) {
        if (kapiChoice.label == "36-Kapi-A") {
          violations.add(
            "Kapı temiz geçiş genişliği yetersiz (Gereken: En Az 80 cm, Mevcut: ${kapiChoice.uiTitle})",
          );
        }
      }

      if (violations.isNotEmpty) {
        notes.add(
          "KRİTİK RİSK: $prefix kaçış yollarına ait genişlik ihlalleri tespit edildi:\n- ${violations.join("\n- ")}",
        );
      } else {
        bool hasUnknown =
            (sChoice?.label.endsWith("-E") == true) ||
            (cChoice?.label.endsWith("-F") == true) ||
            (kapiChoice?.label.endsWith("-C") == true) ||
            (sChoice?.label.contains("Bilinmiyor") == true) ||
            (cChoice?.label.contains("Bilinmiyor") == true) ||
            (kapiChoice?.label.contains("Bilinmiyor") == true);

        if (!hasUnknown &&
            sChoice != null &&
            cChoice != null &&
            kapiChoice != null) {
          notes.add(
            "OLUMLU: $prefix kaçış yollarına ait merdiven ve koridor genişlikleri Yönetmelik kriterlerine göre yeterlidir.",
          );
        }
      }
    }

    if (_model.areWidthsSame) {
      checkWidths(
        "GENEL",
        _model.genislikKorunumlu,
        _model.koridorGenislikKorunumlu,
        _model.kapiGenislikKorunumlu,
      );
    } else {
      if (_hasKorunumlu) {
        checkWidths(
          "KORUNUMLU",
          _model.genislikKorunumlu,
          _model.koridorGenislikKorunumlu,
          _model.kapiGenislikKorunumlu,
        );
      }
      if (_hasKorunumsuz) {
        checkWidths(
          "KORUNUMSUZ",
          _model.genislikKorunumsuz,
          _model.koridorGenislikKorunumsuz,
          _model.kapiGenislikKorunumsuz,
        );
      }
    }

    if (notes.isEmpty) {
      return "OLUMLU: Merdiven özellikleri yeterli gözükmektedir.";
    } else {
      return notes.join("\n\n");
    }
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
    String finalReport = _evaluateStairsAndExits();
    _model = _model.copyWith(
      merdivenDegerlendirme: finalReport.length > 2000
          ? finalReport.substring(0, 2000)
          : finalReport,
    );
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
            _buildSoruHeader("${Bolum36Content.questionKapiGenislik} (Tümü)"),
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

  Widget _buildSoruHeader(String title) {
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
