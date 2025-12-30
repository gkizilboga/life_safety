import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_35_model.dart';
import 'bolum_36_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum35Screen extends StatefulWidget {
  const Bolum35Screen({super.key});

  @override
  State<Bolum35Screen> createState() => _Bolum35ScreenState();
}

class _Bolum35ScreenState extends State<Bolum35Screen> {
  Bolum35Model _model = Bolum35Model();
  final _mesafeCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _tekCikis = true;
  int _limitTekYon = 15;
  int _limitCiftYon = 30;

  @override
  void initState() {
    super.initState();
    _calculateLimits();
  }

  @override
  void dispose() {
    _mesafeCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _calculateLimits() {
    final b20 = BinaStore.instance.bolum20;
    final b9 = BinaStore.instance.bolum9;
    
    int toplamCikis = (b20?.normalMerdivenSayisi ?? 0) + 
                      (b20?.binaIciYanginMerdiveniSayisi ?? 0) + 
                      (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + 
                      (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0);
    
    bool hasSprinkler = b9?.secim?.label == "9-1-A";

    setState(() {
      _tekCikis = (toplamCikis <= 1);
      _limitTekYon = hasSprinkler ? 30 : 15;
      _limitCiftYon = hasSprinkler ? 75 : 30;
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  ChoiceResult _getDynamicChoice(ChoiceResult original, int limit) {
    return ChoiceResult(
      label: original.label,
      uiTitle: original.uiTitle.replaceAll("[LİMİT]", limit.toString()),
      uiSubtitle: original.uiSubtitle.replaceAll("[LİMİT]", limit.toString()),
      reportText: original.reportText.replaceAll("[LİMİT]", limit.toString()),
    );
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tekYon') {
        _model = _model.copyWith(tekYon: choice);
        if (choice.label == "35-1-A") _scrollToBottom();
      }
      if (type == 'ciftYon') {
        _model = _model.copyWith(ciftYon: choice);
        if (choice.label == "35-2-A") _scrollToBottom();
      }
      if (type == 'cikmaz') {
        _model = _model.copyWith(cikmaz: choice);
        if (choice.label == Bolum35Content.cikmazOptionB.label) {
          _scrollToBottom();
        } else {
          _model = _model.copyWith(cikmazMesafe: null);
        }
      }
      if (type == 'cikmazMesafe') {
        _model = _model.copyWith(cikmazMesafe: choice);
        if (choice.label == "35-3-C") _scrollToBottom();
      }
    });
  }

  void _onNextPressed() {
    if (_tekCikis && _model.tekYon == null) return _showError("Lütfen mesafeyi seçiniz.");
    if (!_tekCikis && _model.ciftYon == null) return _showError("Lütfen mesafeyi seçiniz.");
    if (!_tekCikis && _model.cikmaz == null) return _showError("Lütfen çıkmaz koridor durumunu seçiniz.");
    if (_model.cikmaz?.label == Bolum35Content.cikmazOptionB.label && _model.cikmazMesafe == null) {
      return _showError("Lütfen çıkmaz koridor mesafesini seçiniz.");
    }

    if (_mesafeCtrl.text.isNotEmpty) {
      _model = _model.copyWith(manuelMesafe: double.tryParse(_mesafeCtrl.text.replaceAll(',', '.')));
    }

    BinaStore.instance.bolum35 = _model;
    BinaStore.instance.saveToDisk();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum36Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800));
  }

  @override
  Widget build(BuildContext context) {
    bool showManualInput = (_model.tekYon?.label == "35-1-A" || 
                            _model.ciftYon?.label == "35-2-A" || 
                            _model.cikmazMesafe?.label == "35-3-C");

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-35: Kaçış Mesafeleri", 
            subtitle: "Daire kapısından merdivene ulaşım analizi", 
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_tekCikis) 
                    _buildSoru("Daire kapınızdan çıktığınızda bina merdiven kapısına kadar olan mesafe kaç metredir?", 'tekYon', 
                      [
                        Bolum35Content.tekYonOptionA,
                        _getDynamicChoice(Bolum35Content.tekYonOptionB, _limitTekYon),
                        _getDynamicChoice(Bolum35Content.tekYonOptionC, _limitTekYon),
                        Bolum35Content.tekYonOptionD
                      ], _model.tekYon)
                  else ...[
                    _buildSoru("Daire kapınızdan çıktığınızda, size EN YAKIN yangın merdivenine olan mesafe kaç metredir?", 'ciftYon', 
                      [
                        Bolum35Content.ciftYonOptionA,
                        _getDynamicChoice(Bolum35Content.ciftYonOptionB, _limitCiftYon),
                        _getDynamicChoice(Bolum35Content.ciftYonOptionC, _limitCiftYon),
                        Bolum35Content.ciftYonOptionD
                      ], _model.ciftYon),
                    
                    _buildSoru("Daireniz koridorun sonunda, 'Çıkmaz' bir noktada mı?", 'cikmaz', 
                      [Bolum35Content.cikmazOptionA, Bolum35Content.cikmazOptionB], _model.cikmaz),

                    if (_model.cikmaz?.label == Bolum35Content.cikmazOptionB.label) ...[
                      _buildInfoNote("Çıkmaz koridor tespiti yapıldı. Lütfen yol ayrımına kadar olan mesafeyi belirtiniz."),
                      _buildSoru("Daire kapınızdan, koridordaki yol ayrımına kadar olan mesafe kaç metredir?", 'cikmazMesafe', 
                        [
                          Bolum35Content.cikmazMesafeOptionA,
                          _getDynamicChoice(Bolum35Content.cikmazMesafeOptionB, _limitTekYon),
                          _getDynamicChoice(Bolum35Content.cikmazMesafeOptionC, _limitTekYon),
                          Bolum35Content.cikmazMesafeOptionD
                        ], _model.cikmazMesafe),
                    ],
                  ],

                  if (showManualInput) ...[
                    _buildInfoNote("Lütfen net mesafeyi metre cinsinden aşağıya yazınız."),
                    QuestionCard(
                      child: TextFormField(
                        controller: _mesafeCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: "Net Mesafeyi Giriniz (m)", 
                          suffixText: "metre", 
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.straighten),
                        ),
                      ),
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
      margin: const EdgeInsets.only(bottom: 15),
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
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 13))),
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
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