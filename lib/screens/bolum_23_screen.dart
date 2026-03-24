import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_23_model.dart';
import 'bolum_24_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum23Screen extends StatefulWidget {
  const Bolum23Screen({super.key});

  @override
  State<Bolum23Screen> createState() => _Bolum23ScreenState();
}

class _Bolum23ScreenState extends State<Bolum23Screen> {
  Bolum23Model _model = Bolum23Model();
  bool _hasBodrum = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum23 != null) {
      _model = BinaStore.instance.bolum23!;
    }

    // Bodrum kat var mı kontrol et
    final b3 = BinaStore.instance.bolum3;
    _hasBodrum = (b3?.bodrumKatSayisi ?? 0) >= 1;

    // AKILLI ATLAMA MANTIĞI
    final b7 = BinaStore.instance.bolum7;
    // Eğer Bölüm 7'de normal asansör "Yok" (false) işaretlendiyse burayı atla
    if (b7 != null && b7.hasAsansor == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum24Screen()),
        );
      });
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'bodrum') _model = _model.copyWith(bodrum: choice);
      if (type == 'yanginModu') _model = _model.copyWith(yanginModu: choice);
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'levha') _model = _model.copyWith(levha: choice);
      if (type == 'havalandirma')
        _model = _model.copyWith(havalandirma: choice);
    });
  }

  void _onNextPressed() {
    BinaStore.instance.bolum23 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum24Screen()),
    );
  }

  bool _isFormComplete() {
    // Bodrum sorusu sadece bodrum varsa zorunlu
    if (_hasBodrum && _model.bodrum == null) return false;
    if (_model.yanginModu == null) return false;
    if (_model.konum == null) return false;
    if (_model.levha == null) return false;
    if (_model.havalandirma == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Eğer asansör yoksa boş ekran göster (Zaten initState hemen yönlendirecek)
    final b7 = BinaStore.instance.bolum7;
    if (b7 != null && b7.hasAsansor == false) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AnalysisPageLayout(
      title: "Normal Asansör",
      screenType: widget.runtimeType,
      isNextEnabled: _isFormComplete(),
      onNext: _onNextPressed,
      child: Column(
        children: [
          // BODRUM SORUSU: Sadece bodrumKatSayisi >= 1 ise göster
          if (_hasBodrum)
            _buildSoru(
              "Normal asansörünüz bodrum katlara da iniyor mu?",
              'bodrum',
              [
                Bolum23Content.bodrumOptionA,
                Bolum23Content.bodrumOptionB,
                Bolum23Content.bodrumOptionC,
                Bolum23Content.bodrumOptionD,
              ],
              _model.bodrum,
            ),

          _buildSoru(
            "YANGIN ANINDA asansörler otomatik olarak zemin kata (veya binadan çıkış katına) iniyor mu?",
            'yanginModu',
            [
              Bolum23Content.yanginModuOptionA,
              Bolum23Content.yanginModuOptionB,
              Bolum23Content.yanginModuOptionC,
            ],
            _model.yanginModu,
          ),

          _buildSoru(
            "Asansör kapıları normal katlarda nereye açılıyor?",
            'konum',
            [
              Bolum23Content.konumOptionA,
              Bolum23Content.konumOptionB,
              Bolum23Content.konumOptionC,
            ],
            _model.konum,
          ),

          _buildSoru(
            "Asansör kapılarında 'YANGIN ANINDA KULLANMAYINIZ' uyarısı asılı mı?",
            'levha',
            [
              Bolum23Content.levhaOptionA,
              Bolum23Content.levhaOptionB,
              Bolum23Content.levhaOptionC,
            ],
            _model.levha,
          ),

          _buildSoru(
            "Asansör kuyusunun tepesinde havalandırma penceresi var mı?",
            'havalandirma',
            [
              Bolum23Content.havalandirmaOptionA,
              Bolum23Content.havalandirmaOptionB,
              Bolum23Content.havalandirmaOptionC,
            ],
            _model.havalandirma,
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
}
