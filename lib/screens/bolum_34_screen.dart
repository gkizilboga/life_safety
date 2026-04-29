import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_34_model.dart';
import 'bolum_35_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum34Screen extends StatefulWidget {
  const Bolum34Screen({super.key});

  @override
  State<Bolum34Screen> createState() => _Bolum34ScreenState();
}

class _Bolum34ScreenState extends State<Bolum34Screen> {
  Bolum34Model _model = Bolum34Model();
  bool _isEligible = false;

  // Dinamik bayraklar - hangi kat tiplerinde ticari alan var?
  bool _hasTicariZemin = false;
  bool _hasTicariBodrum = false;
  bool _hasTicariNormal = false;
  bool _hasBodrumKat = false; // Bina'da bodrum kat var mı?
  int _activeTicariFloorCount = 0;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum34 != null) {
      _model = BinaStore.instance.bolum34!;
    }
    _checkEligibilityAndDetermineQuestions();
  }

  void _checkEligibilityAndDetermineQuestions() {
    final b3 = BinaStore.instance.bolum3;
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;

    // Reset flags
    _hasTicariZemin = false;
    _hasTicariBodrum = false;
    _hasTicariNormal = false;

    // Bölüm 3'ten bodrum kat sayısını al
    _hasBodrumKat = (b3?.bodrumKatSayisi ?? 0) > 0;

    // Bölüm 6'da işaretlenmiş mi?
    bool hasTicariInB6 = b6?.hasTicari ?? false;

    // Bölüm 10'dan kat bazında ticari kullanım kontrolü
    if (b10 != null) {
      // Zemin katta ticari var mı?
      _hasTicariZemin = b10.zemin?.label.contains("Ticari") ?? false;

      // Bodrum katlarda ticari var mı? (sadece bodrum kat varsa kontrol et)
      if (_hasBodrumKat) {
        _hasTicariBodrum = b10.bodrumlar.any(
          (e) => e?.label.contains("Ticari") ?? false,
        );
      }

      // Normal katlarda ticari var mı?
      _hasTicariNormal = b10.normaller.any(
        (e) => e?.label.contains("Ticari") ?? false,
      );
    }

    // En az bir kat tipinde ticari alan varsa veya Bölüm 6'da ticari işaretlenmişse eligible
    bool hasAnyTicari = _hasTicariZemin || _hasTicariBodrum || _hasTicariNormal;

    _activeTicariFloorCount = (_hasTicariZemin ? 1 : 0) + (_hasTicariBodrum ? 1 : 0) + (_hasTicariNormal ? 1 : 0);

    // Bölüm 6'da ticari var ama Bölüm 10'da hiçbir katta ticari seçilmemişse,
    // varsayılan olarak zemin kat sorusunu göster
    if (hasTicariInB6 && !hasAnyTicari) {
      _hasTicariZemin = true;
      hasAnyTicari = true;
    }

    if (hasTicariInB6 || hasAnyTicari) {
      setState(() {
        _isEligible = true;
      });
    } else {
      // Ticari alan yoksa doğrudan Bölüm 35'e atla
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum35Screen()),
        );
      });
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'zemin') {
        _model = _model.copyWith(zemin: choice);
      } else if (type == 'bodrum') {
        _model = _model.copyWith(bodrum: choice);
      } else if (type == 'normal') {
        _model = _model.copyWith(normal: choice);
      } else if (type == 'mutfak') {
        _model = _model.copyWith(mutfakBacasi: choice);
      } else if (type == 'cikisUnified') {
        _model = _model.copyWith(
          zemin: _hasTicariZemin ? choice : null,
          normal: _hasTicariNormal ? choice : null,
          bodrum: (_hasBodrumKat && _hasTicariBodrum) ? choice : null,
        );
      }
    });
  }

  bool _canProceed() {
    if (_model.areTicariCikisSame && _activeTicariFloorCount > 0) {
      if (_model.zemin == null && _model.normal == null && _model.bodrum == null) return false;
    } else {
      if (_hasTicariZemin && _model.zemin == null) return false;
      if (_hasBodrumKat && _hasTicariBodrum && _model.bodrum == null)
        return false;
      if (_hasTicariNormal && _model.normal == null) return false;
    }

    // Uzman önerisi: Mutfak bacası sorusu ticari alan varsa her zaman sorulmalı
    if (_model.mutfakBacasi == null) return false;

    return true;
  }

  void _onNextPressed() {
    if (!_canProceed()) {
      if (_model.areTicariCikisSame && _activeTicariFloorCount > 0 && _model.zemin == null && _model.normal == null && _model.bodrum == null) {
        return _showError("Lütfen ticari çıkış durumunu seçiniz.");
      } else {
        if (_hasTicariZemin && _model.zemin == null) {
          return _showError("Lütfen zemin kat ticari çıkış durumunu seçiniz.");
        }
        if (_hasBodrumKat && _hasTicariBodrum && _model.bodrum == null) {
          return _showError("Lütfen bodrum kat ticari çıkış durumunu seçiniz.");
        }
        if (_hasTicariNormal && _model.normal == null) {
          return _showError("Lütfen normal kat ticari çıkış durumunu seçiniz.");
        }
      }
      if (_model.mutfakBacasi == null) {
        return _showError("Lütfen ticari mutfak bacası durumunu seçiniz.");
      }
    }

    BinaStore.instance.bolum34 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum35Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEligible) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Her build'da taze hesapla - kullanıcı geri gidip Bölüm 13'ü değiştirmiş olabilir
    final b13 = BinaStore.instance.bolum13;
    final bool showWarningZemin = b13?.ticariKapiZemin?.label.contains("13-11-C") ?? false;
    final bool showWarningNormal = b13?.ticariKapiNormal?.label.contains("13-11-C") ?? false;
    final bool showWarningBodrum = b13?.ticariKapiBodrum?.label.contains("13-11-C") ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(title: "Ticari Alanlar", screenType: widget.runtimeType),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Tek katta ticari alan varsa toggle göstermeden direkt kat adıyla sor
                  if (_activeTicariFloorCount == 1) ...[
                    if (_hasTicariZemin) ...[
                      if (showWarningZemin)
                        _buildInfoNote(
                          "Bölüm 13'te zemin kat ticari alanı için 'Geçiş Yok' demiştiniz. Tutarlılık açısından burada 'Bağımsız Çıkış Var' (Evet) seçeneğini işaretlemeniz tavsiye edilir.",
                          isWarning: true,
                        ),
                      _buildSoru(
                        "Zemin kattaki ticari alanların doğrudan sokağa/bahçeye açılan kendilerine ait kapıları var mı?",
                        'zemin',
                        [
                          Bolum34Content.zeminOptionA,
                          Bolum34Content.zeminOptionB,
                          Bolum34Content.zeminOptionC,
                        ],
                        _model.zemin,
                      ),
                    ],
                    if (_hasBodrumKat && _hasTicariBodrum) ...[
                      if (showWarningBodrum)
                        _buildInfoNote(
                          "Bölüm 13'te bodrum kat ticari alanı için 'Geçiş Yok' demiştiniz. Tutarlılık açısından burada 'Bağımsız Çıkış Var' (Evet) seçeneğini işaretlemeniz tavsiye edilir.",
                          isWarning: true,
                        ),
                      _buildSoru(
                        "Bodrum kattaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni veya çıkışları var mı?",
                        'bodrum',
                        [
                          Bolum34Content.bodrumOptionA,
                          Bolum34Content.bodrumOptionB,
                          Bolum34Content.bodrumOptionC,
                        ],
                        _model.bodrum,
                      ),
                    ],
                    if (_hasTicariNormal) ...[
                      if (showWarningNormal)
                        _buildInfoNote(
                          "Bölüm 13'te normal kat ticari alanı için 'Geçiş Yok' demiştiniz. Tutarlılık açısından burada 'Bağımsız Çıkış Var' (Evet) seçeneğini işaretlemeniz tavsiye edilir.",
                          isWarning: true,
                        ),
                      _buildSoru(
                        "Normal katlardaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni veya çıkışları var mı?",
                        'normal',
                        [
                          Bolum34Content.normalOptionA,
                          Bolum34Content.normalOptionB,
                          Bolum34Content.normalOptionC,
                        ],
                        _model.normal,
                      ),
                    ],
                  ] else if (_activeTicariFloorCount > 1) ...[
                    // Birden fazla katta ticari alan varsa toggle göster
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 20),
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
                                  "Benzer Bağımsız Çıkış Özellikleri",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                const Text(
                                  "Ticari alanların hepsinin sokağa açılan çıkış özellikleri aynı mı?",
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _model.areTicariCikisSame,
                            onChanged: (val) {
                              setState(() {
                                if (val) {
                                  ChoiceResult? base = _model.zemin ?? _model.normal ?? _model.bodrum;
                                  _model = _model.copyWith(
                                    areTicariCikisSame: true,
                                    zemin: _hasTicariZemin ? base : null,
                                    normal: _hasTicariNormal ? base : null,
                                    bodrum: (_hasBodrumKat && _hasTicariBodrum) ? base : null,
                                  );
                                } else {
                                  _model = _model.copyWith(areTicariCikisSame: false);
                                }
                              });
                            },
                            activeColor: AppColors.primaryBlue,
                          ),
                        ],
                      ),
                    ),

                    // Toggle ON: tek unified soru
                    if (_model.areTicariCikisSame) ...[
                      if ((_hasTicariZemin && showWarningZemin) ||
                          (_hasTicariNormal && showWarningNormal) ||
                          (_hasBodrumKat && _hasTicariBodrum && showWarningBodrum))
                        _buildInfoNote(
                          "Bölüm 13'te bazı ticari alanlar için konut bölümüne 'Geçiş Yok' demiştiniz. Tutarlılık açısından burada ticari alanların 'Bağımsız Çıkış Var' (Evet) seçeneğini işaretlemeniz tavsiye edilir.",
                          isWarning: true,
                        ),
                      _buildSoru(
                        "Ticari alanların hepsinin doğrudan sokağa açılan kendilerine ait kapıları var mı?",
                        'cikisUnified',
                        [
                          Bolum34Content.zeminOptionA,
                          Bolum34Content.zeminOptionB,
                          Bolum34Content.zeminOptionC,
                        ],
                        _model.zemin ?? _model.normal ?? _model.bodrum,
                      ),
                    ] else ...[
                      // Toggle OFF: her kat için ayrı soru
                      if (_hasTicariZemin) ...[
                        if (showWarningZemin)
                          _buildInfoNote(
                            "Bölüm 13'te zemin kat ticari alanı için 'Geçiş Yok' demiştiniz. Tutarlılık açısından burada 'Bağımsız Çıkış Var' (Evet) seçeneğini işaretlemeniz tavsiye edilir.",
                            isWarning: true,
                          ),
                        _buildSoru(
                          "Zemin kattaki ticari alanların doğrudan sokağa/bahçeye açılan kendilerine ait kapıları var mı?",
                          'zemin',
                          [
                            Bolum34Content.zeminOptionA,
                            Bolum34Content.zeminOptionB,
                            Bolum34Content.zeminOptionC,
                          ],
                          _model.zemin,
                        ),
                      ],
                      if (_hasBodrumKat && _hasTicariBodrum) ...[
                        if (showWarningBodrum)
                          _buildInfoNote(
                            "Bölüm 13'te bodrum kat ticari alanı için 'Geçiş Yok' demiştiniz. Tutarlılık açısından burada 'Bağımsız Çıkış Var' (Evet) seçeneğini işaretlemeniz tavsiye edilir.",
                            isWarning: true,
                          ),
                        _buildSoru(
                          "Bodrum kattaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni veya çıkışları var mı?",
                          'bodrum',
                          [
                            Bolum34Content.bodrumOptionA,
                            Bolum34Content.bodrumOptionB,
                            Bolum34Content.bodrumOptionC,
                          ],
                          _model.bodrum,
                        ),
                      ],
                      if (_hasTicariNormal) ...[
                        if (showWarningNormal)
                          _buildInfoNote(
                            "Bölüm 13'te normal kat ticari alanı için 'Geçiş Yok' demiştiniz. Tutarlılık açısından burada 'Bağımsız Çıkış Var' (Evet) seçeneğini işaretlemeniz tavsiye edilir.",
                            isWarning: true,
                          ),
                        _buildSoru(
                          "Normal katlardaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni veya çıkışları var mı?",
                          'normal',
                          [
                            Bolum34Content.normalOptionA,
                            Bolum34Content.normalOptionB,
                            Bolum34Content.normalOptionC,
                          ],
                          _model.normal,
                        ),
                      ],
                    ],
                  ],

                  // --- YENİ SORU: MUTFAK BACASI ---
                  _buildSoru(
                    "Ticari işletmelere ait mutfak/davlumbaz bacaları, konut bacalarından tamamen bağımsız ve korunumlu bir şaft içinden mi geçiyor?",
                    'mutfak',
                    [
                      Bolum34Content.mutfakBacasiOptionA,
                      Bolum34Content.mutfakBacasiOptionB,
                      Bolum34Content.mutfakBacasiOptionC,
                    ],
                    _model.mutfakBacasi,
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

  Widget _buildInfoNote(String text, {bool isWarning = false}) {
    return CustomInfoNote(
      type: isWarning ? InfoNoteType.warning : InfoNoteType.info,
      text: text,
      icon: isWarning ? Icons.warning_amber_rounded : Icons.arrow_downward,
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
