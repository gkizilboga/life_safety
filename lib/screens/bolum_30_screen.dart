import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_30_model.dart';
import 'bolum_31_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart'; 

class Bolum30Screen extends StatefulWidget {
  const Bolum30Screen({super.key});

  @override
  State<Bolum30Screen> createState() => _Bolum30ScreenState();
}

class _Bolum30ScreenState extends State<Bolum30Screen> {
  Bolum30Model _model = Bolum30Model();
  final TextEditingController _kapasiteCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasKazan = false;
  String? _kapasiteErr;

  @override
  void initState() {
    super.initState();
    _checkKazanAndRedirect();
    _kapasiteCtrl.addListener(_validate);
  }

  void _checkKazanAndRedirect() {
    final b7 = BinaStore.instance.bolum7;
    if (b7?.hasKazan == true) {
      setState(() => _hasKazan = true);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Bolum31Screen()));
      });
    }
  }

  void _validate() {
    setState(() {
      if (_model.kapasiteBilinmiyor) {
        _kapasiteErr = null;
        return;
      }
      if (_kapasiteCtrl.text.isNotEmpty) {
        int? val = int.tryParse(_kapasiteCtrl.text);
        if (val == null || val < 10 || val > 1500) {
          _kapasiteErr = "10 ile 1500 kW arasında bir tam sayı giriniz.";
        } else {
          _kapasiteErr = null;
        }
      } else {
        _kapasiteErr = null;
      }
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

  @override
  void dispose() {
    _kapasiteCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'kapi') _model = _model.copyWith(kapi: choice);
      if (type == 'hava') _model = _model.copyWith(hava: choice);
      if (type == 'tup') _model = _model.copyWith(tup: choice);
      
      if (type == 'yakit') {
        _model = _model.copyWith(yakit: choice);
        if (choice.label == Bolum30Content.yakitOptionB.label) {
          _scrollToBottom();
        } else {
          _model = _model.copyWith(drenaj: null);
        }
      }
      if (type == 'drenaj') _model = _model.copyWith(drenaj: choice);
    });
  }

  bool get _isFormValid {
    if (!_hasKazan) return true;
    if (_model.konum == null) return false;
    if (!_model.kapasiteBilinmiyor && (_kapasiteCtrl.text.isEmpty || _kapasiteErr != null)) return false;
    if (_model.kapi == null) return false;
    if (_model.hava == null) return false;
    if (_model.yakit == null) return false;
    if (_model.yakit?.label == Bolum30Content.yakitOptionB.label && _model.drenaj == null) return false;
    if (_model.tup == null) return false;
    return true;
  }

  void _onNextPressed() {
    if (_hasKazan) {
      int? kap = _model.kapasiteBilinmiyor ? null : int.tryParse(_kapasiteCtrl.text);
      _model = _model.copyWith(kapasite: kap);

      if (!_model.kapasiteBilinmiyor && kap != null && kap > 350 && _model.kapi?.label == Bolum30Content.kapiOptionA.label) {
        return _showError("350 kW üzerindeki kazan dairelerinde en az 2 adet çıkış kapısı zorunludur.");
      }
    }

    BinaStore.instance.bolum30 = _model;
    BinaStore.instance.saveToDisk();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleTransitionScreen(
          module: ReportModule.modul4,
          onContinue: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Bolum31Screen()),
            );
          },
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800));
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasKazan) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-30: Kazan Dairesi / Isı Merkezi",
            subtitle: "Isıl kapasite ve havalandırma analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Kazan dairesinin konumu ve kapısının açıldığı yer nasıl?", 'konum', 
                    [Bolum30Content.konumOptionA, Bolum30Content.konumOptionB, Bolum30Content.konumOptionC, Bolum30Content.konumOptionD], _model.konum),

                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kazan kapasitesi (kW) giriniz:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _kapasiteCtrl,
                          enabled: !_model.kapasiteBilinmiyor,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            hintText: "Örn: 350", 
                            suffixText: "kW", 
                            border: const OutlineInputBorder(),
                            errorText: _kapasiteErr,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard(
                          choice: Bolum30Content.kapasiteBilinmiyorOption,
                          isSelected: _model.kapasiteBilinmiyor,
                          onTap: () {
                            setState(() {
                              _model = _model.copyWith(kapasiteBilinmiyor: !_model.kapasiteBilinmiyor);
                              if (_model.kapasiteBilinmiyor) {
                                _kapasiteCtrl.clear();
                                _kapasiteErr = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  _buildSoru("Kazan dairesinin kaç adet çıkış kapısı var?", 'kapi', 
                    [Bolum30Content.kapiOptionA, Bolum30Content.kapiOptionB, Bolum30Content.kapiOptionC], _model.kapi),

                  _buildSoru("İçeriye temiz hava girmesini ve kirli havanın çıkmasını sağlayan menfezler var mı?", 'hava', 
                    [Bolum30Content.havaOptionA, Bolum30Content.havaOptionB, Bolum30Content.havaOptionC], _model.hava),

                  _buildSoru("Kazanınız sıvı yakıtlı (Mazot/Fuel-oil) mı?", 'yakit', 
                    [Bolum30Content.yakitOptionA, Bolum30Content.yakitOptionB, Bolum30Content.yakitOptionC], _model.yakit),

                  if (_model.yakit?.label == Bolum30Content.yakitOptionB.label) ...[
                    _buildInfoNote("Sıvı yakıtlı kazanlar için drenaj ve sızıntı kontrolü gereklidir."),
                    _buildSoru("Zeminde dökülen yakıtı toplayacak kanallar ve bir pis su çukuru var mı?", 'drenaj', 
                      [Bolum30Content.drenajOptionA, Bolum30Content.drenajOptionB, Bolum30Content.drenajOptionC], _model.drenaj),
                  ],

                  _buildSoru("Kazan dairesinde yangın söndürme tüpü ve yangın dolabı var mı?", 'tup', 
                    [Bolum30Content.tupOptionA, Bolum30Content.tupOptionB, Bolum30Content.tupOptionC, Bolum30Content.tupOptionD], _model.tup),
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
            onPressed: _isFormValid ? _onNextPressed : null, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              disabledBackgroundColor: Colors.grey.shade300,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("DEVAM ET", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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