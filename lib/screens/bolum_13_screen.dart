import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_13_model.dart';
import 'bolum_14_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum13Screen extends StatefulWidget {
  const Bolum13Screen({super.key});

  @override
  State<Bolum13Screen> createState() => _Bolum13ScreenState();
}

class _Bolum13ScreenState extends State<Bolum13Screen> {
  Bolum13Model _model = Bolum13Model();
  final ScrollController _scrollController = ScrollController();
  
  final GlobalKey _otoparkKey = GlobalKey();
  final GlobalKey _kazanKey = GlobalKey();
  final GlobalKey _asansorKey = GlobalKey();
  final GlobalKey _jeneratorKey = GlobalKey();
  final GlobalKey _elektrikKey = GlobalKey();
  final GlobalKey _trafoKey = GlobalKey();
  final GlobalKey _depoKey = GlobalKey();
  final GlobalKey _copKey = GlobalKey();
  final GlobalKey _duvarKey = GlobalKey();
  final GlobalKey _ticariKey = GlobalKey();

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

  @override
  void initState() {
    super.initState();
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
        _askTicari;
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
      _askOtopark = (b6?.hasOtopark ?? false) || (b7?.hasOtopark ?? false);
      _askKazan = b7?.hasKazan ?? false;
      _askAsansor = b7?.hasAsansor ?? false;
      _askJenerator = b7?.hasJenerator ?? false;
      _askElektrik = b7?.hasElektrik ?? false;
      _askTrafo = b7?.hasTrafo ?? false;
      _askDepo = (b6?.hasDepo ?? false) || (b7?.hasDepo ?? false);
      _askCop = b7?.hasCop ?? false;
      _askDuvar = b7?.hasDuvar ?? false;
      // Hem Bölüm 6 hem de Bölüm 10'daki ticari alan seçimlerine bakıyoruz
      _askTicari = (b6?.hasTicari ?? false) || hasTicariInB10;
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
      
      _scrollToNextAfter(type);
    });
  }

  void _scrollToNextAfter(String currentKey) {
    // Define the order of keys
    final order = [
      'otopark', 'kazan', 'asansor', 'jenerator', 'elektrik', 
      'trafo', 'depo', 'cop', 'duvar', 'ticari'
    ];
    
    int index = order.indexOf(currentKey);
    if (index == -1 || index == order.length - 1) return;

    // Find the next visible question
    GlobalKey? targetKey;
    for (int i = index + 1; i < order.length; i++) {
      String nextType = order[i];
      if (_shouldAsk(nextType)) {
        targetKey = _getKeyForType(nextType);
        break;
      }
    }

    if (targetKey != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (targetKey!.currentContext != null) {
          Scrollable.ensureVisible(
            targetKey.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            alignment: 0.1, // Aligns to near top
          );
        }
      });
    }
  }

  bool _shouldAsk(String type) {
    switch (type) {
      case 'otopark': return _askOtopark;
      case 'kazan': return _askKazan;
      case 'asansor': return _askAsansor;
      case 'jenerator': return _askJenerator;
      case 'elektrik': return _askElektrik;
      case 'trafo': return _askTrafo;
      case 'depo': return _askDepo;
      case 'cop': return _askCop;
      case 'duvar': return _askDuvar;
      case 'ticari': return _askTicari;
      default: return false;
    }
  }

  GlobalKey _getKeyForType(String type) {
    switch (type) {
      case 'otopark': return _otoparkKey;
      case 'kazan': return _kazanKey;
      case 'asansor': return _asansorKey;
      case 'jenerator': return _jeneratorKey;
      case 'elektrik': return _elektrikKey;
      case 'trafo': return _trafoKey;
      case 'depo': return _depoKey;
      case 'cop': return _copKey;
      case 'duvar': return _duvarKey;
      case 'ticari': return _ticariKey;
      default: return GlobalKey();
    }
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

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Teknik Hacimler",
            subtitle: "Özel riskli alanların duvar ve kapı özellikleri",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_askOtopark)
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
                      keyParam: _otoparkKey,
                    ),

                  if (_askKazan)
                    _buildSoruWithDef(
                      "Kazan dairesinin duvarları ve kapısı nasıldır?",
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
                      keyParam: _kazanKey,
                    ),

                  if (_askAsansor)
                    _buildSoru("Asansör kapısı nasıldır?", 'asansor', [
                      Bolum13Content.asansorOptionA,
                      Bolum13Content.asansorOptionB,
                      Bolum13Content.asansorOptionC,
                    ], _model.asansorKapi, keyParam: _asansorKey),

                  if (_askJenerator)
                    _buildSoru(
                      "Jeneratör odasının duvar ve kapısı nasıldır?",
                      'jenerator',
                      [
                        Bolum13Content.jeneratorOptionA,
                        Bolum13Content.jeneratorOptionB,
                        Bolum13Content.jeneratorOptionC,
                      ],
                      _model.jeneratorKapi,
                      keyParam: _jeneratorKey,
                    ),

                  if (_askElektrik)
                    _buildSoru(
                      "Elektrik odalarının duvarları ve kapıları nasıldır?",
                      'elektrik',
                      [
                        Bolum13Content.elekOdasiOptionA,
                        Bolum13Content.elekOdasiOptionB,
                        Bolum13Content.elekOdasiOptionC,
                      ],
                      _model.elektrikKapi,
                      keyParam: _elektrikKey,
                    ),

                  if (_askTrafo)
                    _buildSoru("Trafo odasının kapısı nasıldır?", 'trafo', [
                      Bolum13Content.trafoOptionA,
                      Bolum13Content.trafoOptionB,
                      Bolum13Content.trafoOptionC,
                    ], _model.trafoKapi, keyParam: _trafoKey),

                  if (_askDepo)
                    _buildSoru("Eşya depolarının kapıları nasıldır?", 'depo', [
                      Bolum13Content.depoOptionA,
                      Bolum13Content.depoOptionB,
                      Bolum13Content.depoOptionC,
                    ], _model.depoKapi, keyParam: _depoKey),

                  if (_askCop)
                    _buildSoru(
                      "Çöp toplama odalarının kapıları nasıldır?",
                      'cop',
                      [
                        Bolum13Content.copOptionA,
                        Bolum13Content.copOptionB,
                        Bolum13Content.copOptionC,
                      ],
                      _model.copKapi,
                      keyParam: _copKey,
                    ),

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
                      keyParam: _duvarKey,
                    ),

                  if (_askTicari)
                    _buildSoru(
                      "Ticari alanlardan konut merdivenine geçiş nasıldır?",
                      'ticari',
                      [
                        Bolum13Content.ticariOptionA,
                        Bolum13Content.ticariOptionB,
                        Bolum13Content.ticariOptionC,
                      ],
                      _model.ticariKapi,
                      keyParam: _ticariKey,
                    ),
                ],
              ),
            ),
          ),
          Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
    Key? keyParam,
  }) {
    return QuestionCard(
      key: keyParam,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Color(0xFF4A148C), // Koyu Mor - Soru rengi
          )),
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
    ChoiceResult? selected, {
    Key? keyParam,
  }) {
    return QuestionCard(
      key: keyParam,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF4A148C),
                )),
              ),
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
