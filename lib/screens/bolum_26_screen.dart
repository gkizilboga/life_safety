import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_26_model.dart';
import 'bolum_27_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum26Screen extends StatefulWidget {
  const Bolum26Screen({super.key});

  @override
  State<Bolum26Screen> createState() => _Bolum26ScreenState();
}

class _Bolum26ScreenState extends State<Bolum26Screen> {
  Bolum26Model _model = Bolum26Model();
  bool _askOtopark = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final b6 = BinaStore.instance.bolum6;
    if (b6?.hasOtopark == true) {
      _askOtopark = true;
    }
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

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        if (choice.label != Bolum26Content.varlikOptionB.label) {
          _model = _model.copyWith(egim: null, sahanlik: null);
        } else {
          _scrollToBottom();
        }
      } else if (type == 'egim') {
        _model = _model.copyWith(egim: choice);
      } else if (type == 'sahanlik') {
        _model = _model.copyWith(sahanlik: choice);
      } else if (type == 'otopark') {
        _model = _model.copyWith(otopark: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.varlik == null) return _showError("Lütfen kaçış rampası sorusunu yanıtlayınız.");
    if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) {
      if (_model.egim == null || _model.sahanlik == null) return _showError("Lütfen rampa detaylarını yanıtlayınız.");
    }
    if (_askOtopark && _model.otopark == null) return _showError("Lütfen otopark rampası sorusunu yanıtlayınız.");

    BinaStore.instance.bolum26 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum27Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-26: Kaçış Rampaları",
            subtitle: "Rampa eğimi ve sahanlık analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Binada kullanmak zorunda kaldığınız eğimli bir rampa var mı?", 'varlik', 
                    [Bolum26Content.varlikOptionA, Bolum26Content.varlikOptionB, Bolum26Content.varlikOptionC], _model.varlik),

                  if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) ...[
                    _buildInfoNote("Rampa tespit edildiği için eğim ve sahanlık soruları açılmıştır."),
                    _buildSoru("Bu rampanın eğimi ve zemin kaplaması nasıl?", 'egim', 
                      [Bolum26Content.egimOptionA, Bolum26Content.egimOptionB, Bolum26Content.egimOptionC], _model.egim),
                    _buildSoru("Rampanın başlangıcında ve bitişinde sahanlık (düzlük) var mı?", 'sahanlik', 
                      [Bolum26Content.sahanlikOptionA, Bolum26Content.sahanlikOptionB, Bolum26Content.sahanlikOptionC], _model.sahanlik),
                  ],

                  if (_askOtopark)
                    _buildSoru("Otopark araç rampasını acil durumda kaçış yolu olarak kullanabilir misiniz?", 'otopark', 
                      [Bolum26Content.otoparkOptionA, Bolum26Content.otoparkOptionB, Bolum26Content.otoparkOptionC], _model.otopark),
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