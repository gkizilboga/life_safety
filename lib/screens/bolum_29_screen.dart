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
    _loadVisibility();
    
    // KRİTİK: Eğer hiçbir soru sorulmayacaksa otomatik olarak sonraki ekrana geç
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_shouldShowAnyQuestion()) {
        _onNextPressed();
      }
    });
  }

  // Herhangi bir soru gösterilecek mi kontrolü
  bool _shouldShowAnyQuestion() {
    return _askOtopark || _askKazan || _askCati || _askAsansor || 
           _askJenerator || _askPano || _askTrafo || _askDepo || 
           _askCop || _askSiginak;
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
      _askSiginak = b7?.hasSiginak ?? false;
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
      else if (type == 'siginak') _model = _model.copyWith(siginak: choice);
    });
  }

  void _onNextPressed() {
    // Sadece görünür olan soruların cevaplanıp cevaplanmadığını kontrol et
    if (_askOtopark && _model.otopark == null) return _showError("Otopark sorusunu yanıtlayınız.");
    if (_askKazan && _model.kazan == null) return _showError("Kazan dairesi sorusunu yanıtlayınız.");
    if (_askCati && _model.cati == null) return _showError("Çatı arası sorusunu yanıtlayınız.");
    if (_askAsansor && _model.asansor == null) return _showError("Asansör odası sorusunu yanıtlayınız.");
    if (_askJenerator && _model.jenerator == null) return _showError("Jeneratör odası sorusunu yanıtlayınız.");
    if (_askPano && _model.pano == null) return _showError("Pano odası sorusunu yanıtlayınız.");
    if (_askTrafo && _model.trafo == null) return _showError("Trafo odası sorusunu yanıtlayınız.");
    if (_askDepo && _model.depo == null) return _showError("Depo sorusunu yanıtlayınız.");
    if (_askCop && _model.cop == null) return _showError("Çöp odası sorusunu yanıtlayınız.");
    if (_askSiginak && _model.siginak == null) return _showError("Sığınak sorusunu yanıtlayınız.");

    BinaStore.instance.bolum29 = _model;
    BinaStore.instance.saveToDisk(); // VERİYİ DİSKE YAZ
    
    // Eğer otomatik atlama yapılıyorsa pushReplacement, normal geçişse push kullanıyoruz
    if (!_shouldShowAnyQuestion()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Bolum30Screen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum30Screen()));
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // Eğer hiçbir soru yoksa boş ekran yerine yükleme ikonu göster (Zaten otomatik geçecek)
    if (!_shouldShowAnyQuestion()) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-29: Temizlik ve Düzen",
            subtitle: "Özel riskli alanların işletme güvenliği",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_askOtopark) _buildSoru("Otoparkta yanıcı eşyalar (lastik, boya vb.) yığılıyor mu?", 'otopark', 
                    [Bolum29Content.otoparkOptionA, Bolum29Content.otoparkOptionB, Bolum29Content.otoparkOptionC], _model.otopark),

                  if (_askKazan) _buildSoru("Kazan dairesinde ilgisiz eski eşya, karton vb. saklanıyor mu?", 'kazan', 
                    [Bolum29Content.kazanOptionA, Bolum29Content.kazanOptionB, Bolum29Content.kazanOptionC], _model.kazan),

                  if (_askCati) _buildSoru("Çatı arasında yanıcı malzemeler saklanıyor mu?", 'cati', 
                    [Bolum29Content.catiOptionA, Bolum29Content.catiOptionB, Bolum29Content.catiOptionC], _model.cati),

                  if (_askAsansor) _buildSoru("Asansör makine dairesinde yanıcı ürünler var mı?", 'asansor', 
                    [Bolum29Content.asansorOptionA, Bolum29Content.asansorOptionB, Bolum29Content.asansorOptionC], _model.asansor),

                  if (_askJenerator) _buildSoru("Jeneratör odasında ilgisiz malzemeler depolanıyor mu?", 'jenerator', 
                    [Bolum29Content.jeneratorOptionA, Bolum29Content.jeneratorOptionB, Bolum29Content.jeneratorOptionC], _model.jenerator),

                  if (_askPano) _buildSoru("Elektrik pano odasında temizlik malzemesi, kağıt vb. var mı?", 'pano', 
                    [Bolum29Content.panoOptionA, Bolum29Content.panoOptionB, Bolum29Content.panoOptionC], _model.pano),

                  if (_askTrafo) _buildSoru("Trafo odası temiz mi ve menfezler açık mı?", 'trafo', 
                    [Bolum29Content.trafoOptionA, Bolum29Content.trafoOptionB, Bolum29Content.trafoOptionC], _model.trafo),

                  if (_askDepo) _buildSoru("Depolarda parlayıcı maddeler (tiner, tüp vb.) saklanıyor mu?", 'depo', 
                    [Bolum29Content.depoOptionA, Bolum29Content.depoOptionB, Bolum29Content.depoOptionC], _model.depo),

                  if (_askCop) _buildSoru("Çöp odası düzenli temizleniyor mu?", 'cop', 
                    [Bolum29Content.copOptionA, Bolum29Content.copOptionB, Bolum29Content.copOptionC], _model.cop),

                  if (_askSiginak) _buildSoru("Sığınakta yanıcı/patlayıcı maddeler depolanıyor mu?", 'siginak', 
                    [Bolum29Content.siginakOptionA, Bolum29Content.siginakOptionB, Bolum29Content.siginakOptionC], _model.siginak),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
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
          )),
        ],
      ),
    );
  }
}