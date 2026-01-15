import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_34_model.dart';
import 'bolum_35_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum34Screen extends StatefulWidget {
  const Bolum34Screen({super.key});

  @override
  State<Bolum34Screen> createState() => _Bolum34ScreenState();
}

class _Bolum34ScreenState extends State<Bolum34Screen> {
  Bolum34Model _model = Bolum34Model();
  bool _isEligible = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkEligibilityAndRedirect();
  }

  void _checkEligibilityAndRedirect() {
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;

    // Bölüm 6'da işaretlenmiş mi?
    bool hasTicariInB6 = b6?.hasTicari ?? false;

    // Bölüm 10'da herhangi bir katta ticari seçilmiş mi?
    bool hasTicariInB10 = false;
    if (b10 != null) {
      hasTicariInB10 =
          (b10.zemin?.label.contains("Ticari") ?? false) ||
          (b10.bodrumlar.any((e) => e?.label.contains("Ticari") ?? false)) ||
          (b10.normaller.any((e) => e?.label.contains("Ticari") ?? false));
    }

    if (hasTicariInB6 || hasTicariInB10) {
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
      if (type == 'zemin') {
        _model = _model.copyWith(zemin: choice);
        _scrollToBottom(); // Zemin seçilince bodrum sorusuna kaydır
      }
      if (type == 'bodrum') {
        _model = _model.copyWith(bodrum: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_isEligible) {
      if (_model.zemin == null)
        return _showError("Lütfen zemin kat ticari çıkış durumunu seçiniz.");
      if (_model.bodrum == null)
        return _showError("Lütfen bodrum kat ticari çıkış durumunu seçiniz.");
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
            subtitle: "İşyeri vb. hacimlerin tahliyesi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
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

                  if (_model.zemin != null) ...[
                    _buildInfoNote(
                      "Zemin kat tespiti yapıldı. Lütfen bodrum kat ticari alan çıkışlarını da kontrol ediniz.",
                    ),
                    _buildSoru(
                      "Bodrum kattaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni ve çıkışları var mı?",
                      'bodrum',
                      [
                        Bolum34Content.bodrumOptionA,
                        Bolum34Content.bodrumOptionB,
                        Bolum34Content.bodrumOptionC,
                      ],
                      _model.bodrum,
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
