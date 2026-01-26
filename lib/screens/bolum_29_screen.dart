import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_29_model.dart';
import 'bolum_30_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum29Screen extends StatefulWidget {
  const Bolum29Screen({super.key});

  @override
  State<Bolum29Screen> createState() => _Bolum29ScreenState();
}

class _Bolum29ScreenState extends State<Bolum29Screen> {
  Bolum29Model _model = Bolum29Model();

  bool _askOtopark = false;
  bool _askKazan = false;
  bool _askCati = false;
  bool _askAsansor = false;
  bool _askJenerator = false;
  bool _askPano = false;
  bool _askTrafo = false;
  bool _askDepo = false;
  bool _askCop = false;
  bool _askSiginak = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum29 != null) {
      _model = BinaStore.instance.bolum29!;
    }
    _loadVisibility();

    // Eğer hiçbir teknik hacim yoksa otomatik atla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_shouldShowAnyQuestion()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum30Screen()),
        );
      }
    });
  }

  bool _shouldShowAnyQuestion() {
    return _askOtopark ||
        _askKazan ||
        _askCati ||
        _askAsansor ||
        _askJenerator ||
        _askPano ||
        _askTrafo ||
        _askDepo ||
        _askCop ||
        _askSiginak;
  }

  void _loadVisibility() {
    final b6 = BinaStore.instance.bolum6;
    final b7 = BinaStore.instance.bolum7;

    setState(() {
      _askOtopark = b6?.hasOtopark ?? false;
      _askKazan = b7?.hasKazan ?? false;
      _askCati = b7?.hasCati ?? false;
      _askAsansor =
          b7?.hasAsansor ?? false; // KRİTİK: Burası asansör varlığına bakıyor
      _askJenerator = b7?.hasJenerator ?? false;
      _askPano = b7?.hasElektrik ?? false;
      _askTrafo = b7?.hasTrafo ?? false;
      _askDepo = b6?.hasDepo ?? false;
      _askCop = b7?.hasCop ?? false;
      _askSiginak = b7?.hasSiginak ?? false;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'otopark')
        _model = _model.copyWith(otopark: choice);
      else if (type == 'kazan')
        _model = _model.copyWith(kazan: choice);
      else if (type == 'cati')
        _model = _model.copyWith(cati: choice);
      else if (type == 'asansor')
        _model = _model.copyWith(asansor: choice);
      else if (type == 'jenerator')
        _model = _model.copyWith(jenerator: choice);
      else if (type == 'pano')
        _model = _model.copyWith(pano: choice);
      else if (type == 'trafo')
        _model = _model.copyWith(trafo: choice);
      else if (type == 'depo')
        _model = _model.copyWith(depo: choice);
      else if (type == 'cop')
        _model = _model.copyWith(cop: choice);
      else if (type == 'siginak')
        _model = _model.copyWith(siginak: choice);
    });
  }

  // Butonun aktiflik kontrolü
  bool _isReady() {
    if (_askOtopark && _model.otopark == null) return false;
    if (_askKazan && _model.kazan == null) return false;
    if (_askCati && _model.cati == null) return false;
    if (_askAsansor && _model.asansor == null) return false;
    if (_askJenerator && _model.jenerator == null) return false;
    if (_askPano && _model.pano == null) return false;
    if (_askTrafo && _model.trafo == null) return false;
    if (_askDepo && _model.depo == null) return false;
    if (_askCop && _model.cop == null) return false;
    if (_askSiginak && _model.siginak == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Eğer hiçbir soru yoksa yükleme ikonu göster (Zaten otomatik geçecek)
    if (!_shouldShowAnyQuestion()) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AnalysisPageLayout(
      title: "Temizlik ve Düzen",
      subtitle: "Riskli alanların işletme güvenliği",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum29 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum30Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_askOtopark)
            _buildSoru(
              "Otoparkta yanıcı türden eşyalar (lastik, boya, eşya vb.) bulunuyor mu?",
              'otopark',
              [
                Bolum29Content.otoparkOptionA,
                Bolum29Content.otoparkOptionB,
                Bolum29Content.otoparkOptionC,
              ],
              _model.otopark,
            ),

          if (_askKazan)
            _buildSoru(
              "Kazan dairesinde eski eşya, mobilya, karton vb. bulunuyor mu?",
              'kazan',
              [
                Bolum29Content.kazanOptionA,
                Bolum29Content.kazanOptionB,
                Bolum29Content.kazanOptionC,
              ],
              _model.kazan,
            ),

          if (_askCati)
            _buildSoru(
              "Çatı arasında yanıcı malzemeler bulunuyor mu?",
              'cati',
              [
                Bolum29Content.catiOptionA,
                Bolum29Content.catiOptionB,
                Bolum29Content.catiOptionC,
              ],
              _model.cati,
            ),

          if (_askAsansor)
            _buildSoru(
              "Asansör makine dairesinde yanıcı malzemeler bulunuyor mu?",
              'asansor',
              [
                Bolum29Content.asansorOptionA,
                Bolum29Content.asansorOptionB,
                Bolum29Content.asansorOptionC,
              ],
              _model.asansor,
            ),

          if (_askJenerator)
            _buildSoru(
              "Jeneratör odasında ilgisiz malzemeler bulunuyor mu?",
              'jenerator',
              [
                Bolum29Content.jeneratorOptionA,
                Bolum29Content.jeneratorOptionB,
                Bolum29Content.jeneratorOptionC,
              ],
              _model.jenerator,
            ),

          if (_askPano)
            _buildSoru(
              "Elektrik pano odasında temizlik malzemesi, kağıt, eşya vb. bulunuyor mu?",
              'pano',
              [
                Bolum29Content.panoOptionA,
                Bolum29Content.panoOptionB,
                Bolum29Content.panoOptionC,
              ],
              _model.pano,
            ),

          if (_askTrafo)
            _buildSoru("Trafo odası temiz mi ve menfezler açık mı?", 'trafo', [
              Bolum29Content.trafoOptionA,
              Bolum29Content.trafoOptionB,
              Bolum29Content.trafoOptionC,
            ], _model.trafo),

          if (_askDepo)
            _buildSoru(
              "Depolarda parlayıcı maddeler (tiner, tüp, boya vb.) saklanıyor mu?",
              'depo',
              [
                Bolum29Content.depoOptionA,
                Bolum29Content.depoOptionB,
                Bolum29Content.depoOptionC,
              ],
              _model.depo,
            ),

          if (_askCop)
            _buildSoru("Çöp odası düzenli temizleniyor mu?", 'cop', [
              Bolum29Content.copOptionA,
              Bolum29Content.copOptionB,
              Bolum29Content.copOptionC,
            ], _model.cop),

          if (_askSiginak)
            _buildSoru(
              "Sığınakta yanıcı/patlayıcı maddeler depolanıyor mu?",
              'siginak',
              [
                Bolum29Content.siginakOptionA,
                Bolum29Content.siginakOptionB,
                Bolum29Content.siginakOptionC,
              ],
              _model.siginak,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
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
}
