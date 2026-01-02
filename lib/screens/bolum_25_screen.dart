import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_25_model.dart';
import 'bolum_26_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum25Screen extends StatefulWidget {
  const Bolum25Screen({super.key});

  @override
  State<Bolum25Screen> createState() => _Bolum25ScreenState();
}

class _Bolum25ScreenState extends State<Bolum25Screen> {
  Bolum25Model _model = Bolum25Model();
  bool _hasDonerMerdiven = false;
  bool _isCommercial = false;

  @override
  void initState() {
    super.initState();
    _checkAndRedirect();
  }

  void _checkAndRedirect() {
    final b20 = BinaStore.instance.bolum20;
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;
    
    int donerCount = int.tryParse(b20?.donerMerdivenSayisi.toString() ?? "0") ?? 0;
    int sahanliksizCount = int.tryParse(b20?.sahanliksizMerdivenSayisi.toString() ?? "0") ?? 0;

    // Ticari Alan Kontrolü
    bool hasTicari = (b6?.hasTicari ?? false) ||
                     (b10?.zemin?.label.contains("Ticari") ?? false) ||
                     (b10?.bodrumlar.any((e) => e?.label.contains("Ticari") ?? false) ?? false) ||
                     (b10?.normaller.any((e) => e?.label.contains("Ticari") ?? false) ?? false);

    if (donerCount > 0 || sahanliksizCount > 0) {
      setState(() {
        _hasDonerMerdiven = true;
        _isCommercial = hasTicari;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum26Screen()),
        );
      });
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'kapasite') _model = _model.copyWith(kapasite: choice);
      if (type == 'basamak') _model = _model.copyWith(basamak: choice);
      if (type == 'basKurtarma') _model = _model.copyWith(basKurtarma: choice);
    });
  }

  void _onNextPressed() {
    if (_model.kapasite == null || _model.basamak == null || _model.basKurtarma == null) {
      _showError("Lütfen tüm soruları yanıtlayınız.");
      return;
    }

    BinaStore.instance.bolum25 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum26Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasDonerMerdiven) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-25: Döner (Dairesel) Merdiven",
            subtitle: "Dairesel merdivenlerin tahliye uygunluğu",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_isCommercial) _buildCriticalWarning(),
                  
                  _buildSoru("Mevcut döner (dairesel) merdiveninizin kol genişliği ne kadar?", 'kapasite', 
                    [Bolum25Content.kapasiteOptionA, Bolum25Content.kapasiteOptionB, Bolum25Content.kapasiteOptionC], _model.kapasite),

                  _buildSoru("Dairesel merdivenin basamak genişliği ne kadar?", 'basamak', 
                    [Bolum25Content.basamakOptionA, Bolum25Content.basamakOptionB, Bolum25Content.basamakOptionC], _model.basamak),

                  _buildSoru("Dairesel merdivenden inerken üstteki basamakla aranızdaki boşluk ne kadar?", 'basKurtarma', 
                    [Bolum25Content.basKurtarmaOptionA, Bolum25Content.basKurtarmaOptionB, Bolum25Content.basKurtarmaOptionC], _model.basKurtarma),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildCriticalWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.gavel_rounded, color: Colors.red.shade900, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " ",
                  style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  " ",
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
              ],
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