import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_34_model.dart';
import 'bolum_35_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum34Screen extends StatefulWidget {
  const Bolum34Screen({super.key});

  @override
  State<Bolum34Screen> createState() => _Bolum34ScreenState();
}

class _Bolum34ScreenState extends State<Bolum34Screen> {
  Bolum34Model _model = Bolum34Model();
  bool _isEligible = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum34 != null) {
      _model = BinaStore.instance.bolum34!;
    }
    _checkEligibility();
  }

  void _checkEligibility() {
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;

    // Bölüm 6'da veya Bölüm 10'da herhangi bir katta ticari kullanım varsa bu bölüm aktiftir.
    bool checkTic(ChoiceResult? c) {
      if (c == null) return false;
      final l = c.label;
      return l.startsWith("10-B") || l.startsWith("10-C") || l.startsWith("10-D");
    }

    bool hasAnyTicari = (b6?.hasTicari ?? false) ||
        checkTic(b10?.zemin) ||
        (b10?.bodrumlar.any(checkTic) ?? false) ||
        (b10?.normaller.any(checkTic) ?? false);

    if (hasAnyTicari) {
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

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(mutfakBacasi: choice);
    });
  }

  bool _canProceed() {
    return _model.mutfakBacasi != null;
  }

  void _onNextPressed() {
    if (!_canProceed()) {
      return _showError("Lütfen ticari mutfak bacası durumunu seçiniz.");
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
          ModernHeader(title: "Ticari Alanlar", screenType: widget.runtimeType),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru(
                    "Ticari işletmelere ait mutfak/davlumbaz bacaları, konut bacalarından tamamen bağımsız ve korunumlu bir şaft içinden mi geçiyor?",
                    [
                      Bolum34Content.mutfakBacasiOptionA,
                      Bolum34Content.mutfakBacasiOptionB,
                      Bolum34Content.mutfakBacasiOptionC,
                    ],
                    _model.mutfakBacasi,
                  ),
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
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => _handleSelection(opt),
            ),
          ),
        ],
      ),
    );
  }
}
