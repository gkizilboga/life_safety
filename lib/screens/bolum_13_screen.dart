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
  bool _askTicariZemin = false;
  bool _askTicariNormal = false;
  bool _askTicariBodrum = false;
  int _activeTicariFloorCount = 0;
  bool _askSiginak = false;
  bool _askEndustriyelMutfak = false;

  // Otopark alan otomatik hesap
  bool _autoOtoparkAlani = false;
  double? _hesaplananOtoparkAlani;

  // Depo bodrum alan otomatik hesap
  bool _askDepoBodrumAlan = false;
  bool _autoDepoBodrumAlani = false;
  double? _hesaplananDepoBodrumAlani;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum13 != null) {
      _model = BinaStore.instance.bolum13!;
    }
    _loadVisibilityLogic();
    _applyOtoparkAutoSelection();

    // KRİTİK: Eğer hiçbir soru sorulmayacaksa otomatik olarak sonraki ekrana geç
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_shouldShowAnyQuestion()) {
        _onNextPressed();
      }
    });
  }

  /// Bölüm 6'daki kapaliOtoparkAlani değerine veya Bölüm 10'daki kat kullanımlarına göre otomatik şık seçer.
  void _applyOtoparkAutoSelection() {
    final b6 = BinaStore.instance.bolum6;
    if (b6 == null) return;

    // 1. Öncelik: Bölüm 6'da kullanıcı tarafından manuel girilen kapalı otopark alanı
    double? alan = b6.kapaliOtoparkAlani;

    // 2. Öncelik: Eğer Bölüm 6'da alan girilmemişse, Bölüm 10'daki kat kullanımlarından (10-E) hesapla
    if (alan == null || alan == 0) {
      final b5 = BinaStore.instance.bolum5;
      final b10 = BinaStore.instance.bolum10;
      if (b5 != null && b10 != null) {
        double calculatedTotal = 0;
        if (b10.zemin?.label == "10-E") calculatedTotal += b5.tabanAlani ?? 0;
        for (var b in b10.bodrumlar) {
          if (b?.label == "10-E") calculatedTotal += b5.bodrumKatAlani ?? 0;
        }
        for (var n in b10.normaller) {
          if (n?.label == "10-E") calculatedTotal += b5.normalKatAlani ?? 0;
        }
        if (calculatedTotal > 0) alan = calculatedTotal;
      }
    }

    if (alan == null || alan == 0) return;

    _hesaplananOtoparkAlani = alan;

    // Daha önce kullanıcı seçim yapmışsa otomatik seçim yapma (Kullanıcı müdahalesini koru)
    if (BinaStore.instance.bolum13?.otoparkAlan != null) return;

    _autoOtoparkAlani = true;
    ChoiceResult otomatikSecim;
    if (alan < 600) {
      otomatikSecim = Bolum13Content.otoparkAlanOptionA;
    } else if (alan <= 1000) {
      otomatikSecim = Bolum13Content.otoparkAlanOptionB;
    } else if (alan <= 2000) {
      otomatikSecim = Bolum13Content.otoparkAlanOptionC;
    } else {
      otomatikSecim = Bolum13Content.otoparkAlanOptionD;
    }
    _model = _model.copyWith(otoparkAlan: otomatikSecim);
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
        _askTicariZemin ||
        _askTicariNormal ||
        _askTicariBodrum ||
        _askSiginak ||
        _askEndustriyelMutfak;
  }

  void _loadVisibilityLogic() {
    final b6 = BinaStore.instance.bolum6;
    final b7 = BinaStore.instance.bolum7;

    setState(() {
      _askOtopark = b6?.hasOtopark ?? false;
      _askKazan = b7?.hasKazan ?? false;
      _askAsansor = b7?.hasAsansor ?? false;
      _askJenerator = b7?.hasJenerator ?? false;
      _askElektrik = b7?.hasElektrik ?? false;
      _askTrafo = b7?.hasTrafo ?? false;
      _askDepo = b6?.hasDepo ?? false;
      _askCop = b7?.hasCop ?? false;

      final b5 = BinaStore.instance.bolum5;
      final b10 = BinaStore.instance.bolum10;
      double totalBodrumDepoAlan = 0;
      List<String> depoBodrumKatlar = [];

      if (b5 != null && b10 != null) {
        for (int i = 0; i < b10.bodrumlar.length; i++) {
          if (b10.bodrumlar[i]?.label == "10-E") {
            totalBodrumDepoAlan += b5.bodrumKatAlani ?? 0;
            depoBodrumKatlar.add("${i + 1}. Bodrum Kat");
          }
        }
      }
      
      _hesaplananDepoBodrumAlani = totalBodrumDepoAlan > 0 ? totalBodrumDepoAlan : null;
      
      _askDepoBodrumAlan = _askDepo || ((b5?.bodrumKatAlani ?? 0) > 2000) || totalBodrumDepoAlan > 0;

      if (_hesaplananDepoBodrumAlani != null && BinaStore.instance.bolum13?.depoBodrumAlan == null) {
        _autoDepoBodrumAlani = true;
        ChoiceResult autoChoice = _hesaplananDepoBodrumAlani! <= 2000 
            ? Bolum13Content.depoBodrumAlanOptionA 
            : Bolum13Content.depoBodrumAlanOptionB;
        _model = _model.copyWith(depoBodrumAlan: autoChoice);
      }
      _askDuvar = b7?.hasDuvar ?? false;

      bool hasTicariZemin =
          (b6?.hasTicari ?? false) ||
          (b10?.zemin?.uiTitle.toLowerCase().contains("ticari") ?? false);
      bool hasTicariBodrum =
          b10?.bodrumlar.any(
            (e) => e?.uiTitle.toLowerCase().contains("ticari") ?? false,
          ) ??
          false;
      bool hasTicariNormal =
          b10?.normaller.any(
            (e) => e?.uiTitle.toLowerCase().contains("ticari") ?? false,
          ) ??
          false;

      _askTicariZemin = hasTicariZemin;
      _askTicariBodrum = hasTicariBodrum;
      _askTicariNormal = hasTicariNormal;

      _activeTicariFloorCount =
          (hasTicariZemin ? 1 : 0) +
          (hasTicariBodrum ? 1 : 0) +
          (hasTicariNormal ? 1 : 0);

      _askSiginak = b7?.hasSiginak ?? false;
      _askEndustriyelMutfak =
          b6?.buyukRestoran?.label == Bolum6Content.buyukRestoranVar.label;

      // YENİ: Ticari alan geçişleri için otomatik seçim. 
      // Türkiye'de genelde ticari alanların dışarıya kendi bağımsız çıkışları olduğu için 
      // varsayılan olarak "Geçiş Yok / Bağımsız Çıkış Var" (13-11-C) seçiyoruz.
      if (BinaStore.instance.bolum13 == null) {
        if (hasTicariZemin && _model.ticariKapiZemin == null) {
          _model = _model.copyWith(ticariKapiZemin: Bolum13Content.ticariOptionC);
        }
        if (hasTicariBodrum && _model.ticariKapiBodrum == null) {
          _model = _model.copyWith(ticariKapiBodrum: Bolum13Content.ticariOptionC);
        }
        if (hasTicariNormal && _model.ticariKapiNormal == null) {
          _model = _model.copyWith(ticariKapiNormal: Bolum13Content.ticariOptionC);
        }
      }
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
      else if (type == 'ticariZemin')
        _model = _model.copyWith(ticariKapiZemin: choice);
      else if (type == 'ticariNormal')
        _model = _model.copyWith(ticariKapiNormal: choice);
      else if (type == 'ticariBodrum')
        _model = _model.copyWith(ticariKapiBodrum: choice);
      else if (type == 'ticariUnified') {
        _model = _model.copyWith(
          ticariKapiZemin: _askTicariZemin ? choice : null,
          ticariKapiNormal: _askTicariNormal ? choice : null,
          ticariKapiBodrum: _askTicariBodrum ? choice : null,
        );
      } else if (type == 'otoparkAlan')
        _model = _model.copyWith(otoparkAlan: choice);
      else if (type == 'kazanAlan')
        _model = _model.copyWith(kazanAlan: choice);
      else if (type == 'siginakAlan')
        _model = _model.copyWith(siginakAlan: choice);
      else if (type == 'endustriyelMutfak')
        _model = _model.copyWith(endustriyelMutfakKapi: choice);
      else if (type == 'depoBodrumAlan')
        _model = _model.copyWith(depoBodrumAlan: choice);
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
      title: "Özel Riskli Alanlar",
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
            _buildSoruOtoparkAlan(),
          ],

          if (_askKazan) ...[
            _buildSoruWithDef(
              "Kazan dairesinin duvarları ve kapısı yangın dayanımlı mı?",
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
            _buildSoru("Kazan dairesi kaç metrekare?", 'kazanAlan', [
              Bolum13Content.kazanAlanOptionA,
              Bolum13Content.kazanAlanOptionB,
              Bolum13Content.kazanAlanOptionC,
            ], _model.kazanAlan),
          ],

          if (_askAsansor)
            _buildSoru("Asansör kapısı yangın dayanımlı mı?", 'asansor', [
              Bolum13Content.asansorOptionA,
              Bolum13Content.asansorOptionB,
              Bolum13Content.asansorOptionC,
            ], _model.asansorKapi),

          if (_askJenerator)
            _buildSoru(
              "Jeneratör odasının duvarı ve kapısı yangın dayanımlı mı?",
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
              "Elektrik odasının duvarı ve kapısı yangın dayanımlı mı?",
              'elektrik',
              [
                Bolum13Content.elekOdasiOptionA,
                Bolum13Content.elekOdasiOptionB,
                Bolum13Content.elekOdasiOptionC,
              ],
              _model.elektrikKapi,
            ),

          if (_askTrafo)
            _buildSoru(
              "Trafo odasının duvarı ve kapısı yangın dayanımlı mı?",
              'trafo',
              [
                Bolum13Content.trafoOptionA,
                Bolum13Content.trafoOptionB,
                Bolum13Content.trafoOptionC,
              ],
              _model.trafoKapi,
            ),

          if (_askDepo) ...[
            _buildSoru(
              "Apartmana ait (ortak) eşya deposunun duvarı ve kapısı yangın dayanımlı mı?",
              'depo',
              [
                Bolum13Content.depoOptionA,
                Bolum13Content.depoOptionB,
                Bolum13Content.depoOptionC,
              ],
              _model.depoKapi,
            ),
          ],
          
          if (_askDepoBodrumAlan) ...[
            _buildSoruDepoBodrumAlan(),
          ],

          if (_askCop)
            _buildSoru(
              "Çöp toplama odasının duvarı ve kapısı yangın dayanımlı mı?",
              'cop',
              [
                Bolum13Content.copOptionA,
                Bolum13Content.copOptionB,
                Bolum13Content.copOptionC,
              ],
              _model.copKapi,
            ),

          // YENİ SORU: Sığınak Alanı
          if (_askSiginak)
            _buildSoru("Sığınak kaç metrekare?", 'siginakAlan', [
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

          // Tek katta ticari alan varsa toggle göstermeden direkt kat adıyla sor
          if (_activeTicariFloorCount == 1) ...[
            if (_askTicariZemin)
              _buildSoru(
                "Zemin kattaki ticari alanlardan konut merdivenine geçiş yangın dayanımlı mı?",
                'ticariZemin',
                [
                  Bolum13Content.ticariOptionA,
                  Bolum13Content.ticariOptionB,
                  Bolum13Content.ticariOptionC,
                  Bolum13Content.ticariOptionD,
                ],
                _model.ticariKapiZemin,
              ),
            if (_askTicariNormal)
              _buildSoru(
                "Normal katlardaki ticari alanlardan konut merdivenine geçiş yangın dayanımlı mı?",
                'ticariNormal',
                [
                  Bolum13Content.ticariOptionA,
                  Bolum13Content.ticariOptionB,
                  Bolum13Content.ticariOptionC,
                  Bolum13Content.ticariOptionD,
                ],
                _model.ticariKapiNormal,
              ),
            if (_askTicariBodrum)
              _buildSoru(
                "Bodrum katlardaki ticari alanlardan konut merdivenine geçiş yangın dayanımlı mı?",
                'ticariBodrum',
                [
                  Bolum13Content.ticariOptionA,
                  Bolum13Content.ticariOptionB,
                  Bolum13Content.ticariOptionC,
                  Bolum13Content.ticariOptionD,
                ],
                _model.ticariKapiBodrum,
              ),
          ] else if (_activeTicariFloorCount > 1) ...[
            // Birden fazla katta ticari alan varsa toggle göster
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Benzer Geçiş Özellikleri",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const Text(
                          "Tüm ticari alanlardan konut bölümüne geçiş özellikleri aynı mı?",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _model.areTicariKapiSame,
                    onChanged: (val) {
                      setState(() {
                        if (val) {
                          ChoiceResult? base =
                              _model.ticariKapiZemin ??
                              _model.ticariKapiNormal ??
                              _model.ticariKapiBodrum;
                          _model = _model.copyWith(
                            areTicariKapiSame: true,
                            ticariKapiZemin: _askTicariZemin ? base : null,
                            ticariKapiNormal: _askTicariNormal ? base : null,
                            ticariKapiBodrum: _askTicariBodrum ? base : null,
                          );
                        } else {
                          _model = _model.copyWith(areTicariKapiSame: false);
                        }
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                  ),
                ],
              ),
            ),

            // Toggle ON: tek unified soru
            if (_model.areTicariKapiSame) ...[
              _buildSoru(
                "Tüm ticari alanlardan konut merdivenine geçiş yangın dayanımlı mı?",
                'ticariUnified',
                [
                  Bolum13Content.ticariOptionA,
                  Bolum13Content.ticariOptionB,
                  Bolum13Content.ticariOptionC,
                  Bolum13Content.ticariOptionD,
                ],
                _model.ticariKapiZemin ??
                    _model.ticariKapiNormal ??
                    _model.ticariKapiBodrum,
              ),
            ] else ...[
              // Toggle OFF: her kat için ayrı soru
              if (_askTicariZemin)
                _buildSoru(
                  "Zemin kattaki ticari alanlardan konut merdivenine geçiş yangın dayanımlı mı?",
                  'ticariZemin',
                  [
                    Bolum13Content.ticariOptionA,
                    Bolum13Content.ticariOptionB,
                    Bolum13Content.ticariOptionC,
                    Bolum13Content.ticariOptionD,
                  ],
                  _model.ticariKapiZemin,
                ),
              if (_askTicariNormal)
                _buildSoru(
                  "Normal katlardaki ticari alanlardan konut merdivenine geçiş yangın dayanımlı mı?",
                  'ticariNormal',
                  [
                    Bolum13Content.ticariOptionA,
                    Bolum13Content.ticariOptionB,
                    Bolum13Content.ticariOptionC,
                    Bolum13Content.ticariOptionD,
                  ],
                  _model.ticariKapiNormal,
                ),
              if (_askTicariBodrum)
                _buildSoru(
                  "Bodrum katlardaki ticari alanlardan konut merdivenine geçiş yangın dayanımlı mı?",
                  'ticariBodrum',
                  [
                    Bolum13Content.ticariOptionA,
                    Bolum13Content.ticariOptionB,
                    Bolum13Content.ticariOptionC,
                    Bolum13Content.ticariOptionD,
                  ],
                  _model.ticariKapiBodrum,
                ),
            ],
          ],

          if (_askEndustriyelMutfak)
            _buildSoruWithDef(
              "Büyük restoran mutfağının kapısı ve duvarları yangın dayanımlı mı?",
              "Yangın Kompartımanı",
              AppDefinitions.yanginKompartimani,
              'endustriyelMutfak',
              [
                Bolum13Content.endustriyelMutfakOptionA,
                Bolum13Content.endustriyelMutfakOptionB,
                Bolum13Content.endustriyelMutfakOptionC,
                Bolum13Content.endustriyelMutfakOptionD,
              ],
              _model.endustriyelMutfakKapi,
            ),
        ],
      ),
    );
  }

  Widget _buildSoruOtoparkAlan() {
    final bool hesaplandi =
        _autoOtoparkAlani && _hesaplananOtoparkAlani != null;

    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Otopark alanları tüm katlarda toplam kaç metrekare?",
            style: AppStyles.questionTitle,
          ),
          if (_hesaplananOtoparkAlani != null && _hesaplananOtoparkAlani! > 0) ...[
            const SizedBox(height: 10),
            CustomInfoNote(
              type: InfoNoteType.warning,
              text:
                  "Hatırlatma: Binanızda 'depo, teknik hacim, otopark' olarak toplamda ${_formatM2(_hesaplananOtoparkAlani)} m² 'lik alan belirtmiştiniz.",
              icon: Icons.lightbulb_outline,
            ),
          ],
          if (hesaplandi) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFCC02), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFFF57F17),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Otopark kat alanı Bölüm 6'daki bilgilerinize göre "
                      "${_formatM2(_hesaplananOtoparkAlani)} m² olarak "
                      "tespit edilmiştir; aşağıdaki seçenek otomatik işaretlenmiştir. "
                      "Farklı bir durum varsa başka bir seçenek işaretleyebilirsiniz.",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6D4C41),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          ...[
            Bolum13Content.otoparkAlanOptionA,
            Bolum13Content.otoparkAlanOptionB,
            Bolum13Content.otoparkAlanOptionC,
            Bolum13Content.otoparkAlanOptionD,
            Bolum13Content.otoparkAlanOptionE,
          ].map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: _model.otoparkAlan?.label == opt.label,
              onTap: () {
                setState(() {
                  _autoOtoparkAlani =
                      false; // Kullanıcı değiştirdi, notı kaldır
                });
                _handleSelection('otoparkAlan', opt);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoruDepoBodrumAlan() {
    final bool hesaplandi = _autoDepoBodrumAlani && _hesaplananDepoBodrumAlani != null;

    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bodrum katlardaki bu depolama alanlarının toplamı kaç metrekare?",
            style: AppStyles.questionTitle,
          ),

          if (hesaplandi) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFCC02), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFFF57F17),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Bodrum depo alanı Bölüm 6 ve Bölüm 10'daki bilgilerinize göre "
                      "${_formatM2(_hesaplananDepoBodrumAlani)} m² olarak "
                      "tespit edilmiştir; aşağıdaki seçenek otomatik işaretlenmiştir. "
                      "Farklı bir durum varsa başka bir seçenek işaretleyebilirsiniz.",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6D4C41),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          ...[
            Bolum13Content.depoBodrumAlanOptionA,
            Bolum13Content.depoBodrumAlanOptionB,
            Bolum13Content.depoBodrumAlanOptionC,
          ].map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: _model.depoBodrumAlan?.label == opt.label,
              onTap: () {
                setState(() {
                  _autoDepoBodrumAlani = false; // Kullanıcı değiştirdi, notu kaldır
                });
                _handleSelection('depoBodrumAlan', opt);
              },
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

  String _formatM2(double? val) {
    if (val == null) return "0";
    // Tamsayı kısmını ayır
    String s = val.toStringAsFixed(2); // Ondalık desteği için 2 hane alıyoruz
    List<String> parts = s.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : "";

    // Binlik ayracı (nokta) ekle
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(reg, (Match m) => '${m[1]}.');

    // Eğer ondalık kısım sadece sıfırsa gösterme
    if (decimalPart == "00" || decimalPart == "0") {
      return integerPart;
    }
    
    // Değilse virgül ile ekle (gereksiz sıfırları temizle)
    decimalPart = decimalPart.replaceAll(RegExp(r'0+$'), '');
    return "$integerPart,$decimalPart";
  }
}
