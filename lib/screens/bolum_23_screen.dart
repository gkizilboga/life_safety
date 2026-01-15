import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_23_model.dart';
import 'bolum_24_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum23Screen extends StatefulWidget {
  const Bolum23Screen({super.key});

  @override
  State<Bolum23Screen> createState() => _Bolum23ScreenState();
}

class _Bolum23ScreenState extends State<Bolum23Screen> {
  Bolum23Model _model = Bolum23Model();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // AKILLI ATLAMA MANTIĞI
    final b7 = BinaStore.instance.bolum7;
    // Eğer Bölüm 7'de normal asansör "Yok" (false) işaretlendiyse burayı atla
    if (b7 != null && b7.hasAsansor == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum24Screen()),
        );
      });
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'bodrum') _model = _model.copyWith(bodrum: choice);
      if (type == 'yanginModu') _model = _model.copyWith(yanginModu: choice);
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'levha') _model = _model.copyWith(levha: choice);
      if (type == 'havalandirma')
        _model = _model.copyWith(havalandirma: choice);
    });
  }

  void _onNextPressed() {
    if (_model.bodrum == null ||
        _model.yanginModu == null ||
        _model.konum == null ||
        _model.levha == null ||
        _model.havalandirma == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm soruları yanıtlayınız.")),
      );
      return;
    }

    BinaStore.instance.bolum23 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum24Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Eğer asansör yoksa boş ekran göster (Zaten initState hemen yönlendirecek)
    final b7 = BinaStore.instance.bolum7;
    if (b7 != null && b7.hasAsansor == false) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Normal (İnsan Taşıma) Asansör",
            subtitle: "",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru(
                    "Asansörünüz bodrum katlara da iniyor mu?",
                    'bodrum',
                    [
                      Bolum23Content.bodrumOptionA,
                      Bolum23Content.bodrumOptionB,
                      Bolum23Content.bodrumOptionC,
                      Bolum23Content.bodrumOptionD,
                    ],
                    _model.bodrum,
                  ),

                  _buildSoru(
                    "Yangın anında asansörler otomatik olarak zemin kata (veya binadan çıkış katına) iniyor mu?",
                    'yanginModu',
                    [
                      Bolum23Content.yanginModuOptionA,
                      Bolum23Content.yanginModuOptionB,
                      Bolum23Content.yanginModuOptionC,
                    ],
                    _model.yanginModu,
                  ),

                  _buildSoru(
                    "Asansör kapıları normal katlarda nereye açılıyor?",
                    'konum',
                    [
                      Bolum23Content.konumOptionA,
                      Bolum23Content.konumOptionB,
                      Bolum23Content.konumOptionC,
                    ],
                    _model.konum,
                  ),

                  _buildSoru(
                    "Asansör kapılarında 'YANGIN ANINDA KULLANMAYINIZ' uyarısı var mı?",
                    'levha',
                    [
                      Bolum23Content.levhaOptionA,
                      Bolum23Content.levhaOptionB,
                      Bolum23Content.levhaOptionC,
                    ],
                    _model.levha,
                  ),

                  _buildSoru(
                    "Asansör kuyusunun tepesinde havalandırma penceresi var mı?",
                    'havalandirma',
                    [
                      Bolum23Content.havalandirmaOptionA,
                      Bolum23Content.havalandirmaOptionB,
                      Bolum23Content.havalandirmaOptionC,
                    ],
                    _model.havalandirma,
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
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
