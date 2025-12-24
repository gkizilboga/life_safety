import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_29_model.dart';
import 'bolum_30_screen.dart'; // Sonraki ekran
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

  // Soruların görünürlüğü
  bool _askOtopark = false;
  bool _askKazan = false;
  bool _askCati = false;
  bool _askAsansor = false;
  bool _askJenerator = false;
  bool _askPano = false;
  bool _askTrafo = false;
  bool _askDepo = false;
  bool _askCop = false;

  @override
  void initState() {
    super.initState();
    _loadVisibility();
  }

  void _loadVisibility() {
    final b6 = BinaStore.instance.bolum6;
    final b7 = BinaStore.instance.bolum7;

    setState(() {
      _askOtopark = (b6?.hasOtopark ?? false) || (b7?.hasOtopark ?? false);
      _askKazan = b7?.hasKazan ?? false;
      _askCati = b7?.hasCati ?? false;
      _askAsansor = b7?.hasAsansor ?? false;
      _askJenerator = b7?.hasJenerator ?? false;
      _askPano = b7?.hasElektrik ?? false;
      _askTrafo = b7?.hasTrafo ?? false;
      _askDepo = (b6?.hasDepo ?? false) || (b7?.hasDepo ?? false);
      _askCop = b7?.hasCop ?? false;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'otopark') _model = _model.copyWith(otopark: choice);
      else if (type == 'kazan') _model = _model.copyWith(kazan: choice);
      else if (type == 'cati') _model = _model.copyWith(cati: choice);
      else if (type == 'asansor') _model = _model.copyWith(asansor: choice);
      else if (type == 'jenerator') _model = _model.copyWith(jenerator: choice);
      else if (type == 'pano') _model = _model.copyWith(pano: choice);
      else if (type == 'trafo') _model = _model.copyWith(trafo: choice);
      else if (type == 'depo') _model = _model.copyWith(depo: choice);
      else if (type == 'cop') _model = _model.copyWith(cop: choice);
    });
  }

  void _onNextPressed() {
    // Validasyon
    if (_askOtopark && _model.otopark == null) return _showError("Lütfen otopark temizliği sorusunu yanıtlayınız.");
    if (_askKazan && _model.kazan == null) return _showError("Lütfen kazan dairesi temizliği sorusunu yanıtlayınız.");
    if (_askCati && _model.cati == null) return _showError("Lütfen çatı arası temizliği sorusunu yanıtlayınız.");
    if (_askAsansor && _model.asansor == null) return _showError("Lütfen makine dairesi temizliği sorusunu yanıtlayınız.");
    if (_askJenerator && _model.jenerator == null) return _showError("Lütfen jeneratör odası temizliği sorusunu yanıtlayınız.");
    if (_askPano && _model.pano == null) return _showError("Lütfen pano odası temizliği sorusunu yanıtlayınız.");
    if (_askTrafo && _model.trafo == null) return _showError("Lütfen trafo odası temizliği sorusunu yanıtlayınız.");
    if (_askDepo && _model.depo == null) return _showError("Lütfen depo düzeni sorusunu yanıtlayınız.");
    if (_askCop && _model.cop == null) return _showError("Lütfen çöp odası temizliği sorusunu yanıtlayınız.");

    BinaStore.instance.bolum29 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum30Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-29: Temizlik ve Düzen",
            subtitle: "Riskli alanlarda depolama kontrolü.",
            currentStep: 19, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_askOtopark) _buildSoru("Otoparkın köşelerinde, kolon aralarında eski lastikler, koliler veya yanıcı eşyalar yığılı mı?", 'otopark', 
                    [Bolum29Content.otoparkOptionA, Bolum29Content.otoparkOptionB], _model.otopark),

                  if (_askKazan) _buildSoru("Kazan dairesinde veya yakıt tankı çevresinde eski eşya, odun, kömür çuvalı veya kağıt saklanıyor mu?", 'kazan', 
                    [Bolum29Content.kazanOptionA, Bolum29Content.kazanOptionB], _model.kazan),

                  if (_askCati) _buildSoru("Çatı arasında eski eşyalar, ahşap malzemeler, arşiv, evrak vb. yanıcı ürünler saklanıyor mu?", 'cati', 
                    [Bolum29Content.catiOptionA, Bolum29Content.catiOptionB], _model.cati),

                  if (_askAsansor) _buildSoru("Çatıdaki asansör motorunun olduğu odada yağ tenekeleri, temizlik malzemeleri veya eski eşyalar var mı?", 'asansor', 
                    [Bolum29Content.asansorOptionA, Bolum29Content.asansorOptionB], _model.asansor),

                  if (_askJenerator) _buildSoru("Jeneratör odasında jeneratörle ilgisiz yanıcı başka malzemeler depolanıyor mu?", 'jenerator', 
                    [Bolum29Content.jeneratorOptionA, Bolum29Content.jeneratorOptionB], _model.jenerator),

                  if (_askPano) _buildSoru("Elektrik panolarının olduğu odada veya dolapta temizlik malzemesi veya kağıt saklanıyor mu?", 'pano', 
                    [Bolum29Content.panoOptionA, Bolum29Content.panoOptionB], _model.pano),

                  if (_askTrafo) _buildSoru("Trafo odasının havalandırma menfezleri açık mı ve içerisi temiz mi?", 'trafo', 
                    [Bolum29Content.trafoOptionA, Bolum29Content.trafoOptionB, Bolum29Content.trafoOptionC], _model.trafo),

                  if (_askDepo) _buildSoru("Bu depolarda yanıcı, parlayıcı maddeler (Tiner, Boya, Benzin, Tüp) saklanıyor mu?", 'depo', 
                    [Bolum29Content.depoOptionA, Bolum29Content.depoOptionB], _model.depo),

                  if (_askCop) _buildSoru("Çöp odası düzenli temizleniyor mu, yoksa çöpler birikip koku/gaz yapıyor mu?", 'cop', 
                    [Bolum29Content.copOptionA, Bolum29Content.copOptionB], _model.cop),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
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
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )).toList(),
        ],
      ),
    );
  }
}