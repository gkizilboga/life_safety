import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_25_model.dart';
import 'bolum_26_screen.dart'; // Sonraki ekran
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

  @override
  void initState() {
    super.initState();
    _checkAndRedirect();
  }

  void _checkAndRedirect() {
    // Bölüm 20'den döner merdiven sayısını kontrol et
    final b20 = BinaStore.instance.bolum20;
    
    if ((b20?.donerMerdivenSayisi ?? 0) > 0) {
      setState(() {
        _hasDonerMerdiven = true;
      });
    } else {
      // Eğer döner merdiven yoksa, bu sayfayı "Görünmez" olarak geç.
      // WidgetsBinding kullanarak ekran çizildikten hemen sonra diğer sayfaya atlıyoruz.
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
    if (_model.kapasite == null) return _showError("Lütfen kapasite sorusunu yanıtlayınız.");
    if (_model.basamak == null) return _showError("Lütfen basamak genişliği sorusunu yanıtlayınız.");
    if (_model.basKurtarma == null) return _showError("Lütfen baş kurtarma yüksekliği sorusunu yanıtlayınız.");

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
    // Eğer döner merdiven yoksa ekranın geri kalanını hiç çizmiyoruz,
    // sadece kısa bir geçiş anı için boş bir Scaffold veya yükleniyor gösteriyoruz.
    if (!_hasDonerMerdiven) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-25: Döner (Dairesel) Merdiven",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Mevcut döner (dairesel) merdiveninizin genişliği ve hizmet ettiği kişi sayısı nedir?", 'kapasite', 
                    [Bolum25Content.kapasiteOptionA, Bolum25Content.kapasiteOptionB], _model.kapasite),

                  _buildSoru("Dairesel merdivenin basamaklarına bastığınızda, ayağınızın tam sığdığı kısım yeterli genişlikte mi?", 'basamak', 
                    [Bolum25Content.basamakOptionA, Bolum25Content.basamakOptionB], _model.basamak),

                  _buildSoru("Dairesel merdivenden inerken üstteki basamak veya tavan, başınıza ne kadar yakın?", 'basKurtarma', 
                    [Bolum25Content.basKurtarmaOptionA, Bolum25Content.basKurtarmaOptionB], _model.basKurtarma),
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
          )),
        ],
      ),
    );
  }
}