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
      }
      if (type == 'bodrum') {
        _model = _model.copyWith(bodrum: choice);
      }
      if (type == 'normal') {
        _model = _model.copyWith(normal: choice);
      }
    });
  }

  bool _canProceed() {
    // Sadece gösterilen sorular için validasyon
    if (_hasTicariZemin && _model.zemin == null) return false;
    if (_hasBodrumKat && _hasTicariBodrum && _model.bodrum == null)
      return false;
    if (_hasTicariNormal && _model.normal == null) return false;
    return true;
  }

  void _onNextPressed() {
    if (!_canProceed()) {
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

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Ticari Alanlar",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- ZEMİN KAT SORUSU ---
                  if (_hasTicariZemin)
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

                  // --- BODRUM KAT SORUSU ---
                  if (_hasBodrumKat && _hasTicariBodrum) ...[
                    if (_hasTicariZemin && _model.zemin != null)
                      _buildInfoNote(
                        "Zemin kat tespiti yapıldı. Lütfen bodrum kat ticari alan çıkışlarını da kontrol ediniz.",
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

                  // --- NORMAL KAT SORUSU ---
                  if (_hasTicariNormal) ...[
                    if ((_hasTicariZemin && _model.zemin != null) ||
                        (_hasTicariBodrum && _model.bodrum != null))
                      _buildInfoNote(
                        "Lütfen normal katlardaki ticari alan çıkışlarını da kontrol ediniz.",
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
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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

