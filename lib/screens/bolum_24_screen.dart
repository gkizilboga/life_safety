import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_24_model.dart';
import 'bolum_25_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum24Screen extends StatefulWidget {
  const Bolum24Screen({super.key});

  @override
  State<Bolum24Screen> createState() => _Bolum24ScreenState();
}

class _Bolum24ScreenState extends State<Bolum24Screen> {
  Bolum24Model _model = Bolum24Model();
  final ScrollController _scrollController = ScrollController();

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
      if (type == 'tip') {
        _model = _model.copyWith(tip: choice);
        if (choice.label != Bolum24Content.tipOptionB.label) {
          _model = _model.copyWith(pencere: null, kapi: null);
        } else {
          _scrollToBottom();
        }
      } else if (type == 'pencere') {
        _model = _model.copyWith(pencere: choice);
      } else if (type == 'kapi') {
        _model = _model.copyWith(kapi: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.tip == null) return _showError("Lütfen koridor tipini seçiniz.");
    if (_model.tip?.label == Bolum24Content.tipOptionB.label) {
      if (_model.pencere == null) return _showError("Lütfen pencere durumunu seçiniz.");
      if (_model.kapi == null) return _showError("Lütfen kapı özelliğini seçiniz.");
    }
    BinaStore.instance.bolum24 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum25Screen()));
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
            title: "Bölüm-24: Dış Kaçış Geçitleri",
            subtitle: "Açık kaçış yollarının güvenlik analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Daire kapınızdan veya kat koridorlarınızdan bina dışına çıkarken nasıl çıkıyorsunuz?", 'tip', 
                    [Bolum24Content.tipOptionA, Bolum24Content.tipOptionB, Bolum24Content.tipOptionC], _model.tip),

                  if (_model.tip?.label == Bolum24Content.tipOptionB.label) ...[
                    _buildInfoNote("Açık kaçış yolu tespit edildiği için ek güvenlik soruları açılmıştır."),
                    _buildSoru("Bu açık kaçış yoluna bakan dairelere ait pencereler var mı?", 'pencere', 
                      [Bolum24Content.pencereOptionA, Bolum24Content.pencereOptionB, Bolum24Content.pencereOptionC], _model.pencere),
                    _buildSoru("Bu açık kaçış yoluna açılan daire kapınızın özelliği nedir?", 'kapi', 
                      [Bolum24Content.kapiOptionA, Bolum24Content.kapiOptionB, Bolum24Content.kapiOptionC], _model.kapi),
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