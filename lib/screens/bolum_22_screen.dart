import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_22_model.dart';
import 'bolum_23_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum22Screen extends StatefulWidget {
  const Bolum22Screen({super.key});

  @override
  State<Bolum22Screen> createState() => _Bolum22ScreenState();
}

class _Bolum22ScreenState extends State<Bolum22Screen> {
  Bolum22Model _model = Bolum22Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        if (choice.label != Bolum22Content.varlikOptionB.label) {
          _model = _model.copyWith(
            konum: null, boyut: null, kabin: null, enerji: null, basinc: null
          );
        }
      } else if (type == 'konum') {
        _model = _model.copyWith(konum: choice);
      } else if (type == 'boyut') {
        _model = _model.copyWith(boyut: choice);
      } else if (type == 'kabin') {
        _model = _model.copyWith(kabin: choice);
      } else if (type == 'enerji') {
        _model = _model.copyWith(enerji: choice);
      } else if (type == 'basinc') {
        _model = _model.copyWith(basinc: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.varlik == null) return _showError("Lütfen itfaiye asansörü varlığı sorusunu yanıtlayınız.");

    if (_model.varlik?.label == Bolum22Content.varlikOptionB.label) {
      if (_model.konum == null) return _showError("Lütfen asansör kapı konumu sorusunu yanıtlayınız.");
      if (_model.boyut == null) return _showError("Lütfen YGH alan büyüklüğü sorusunu yanıtlayınız.");
      if (_model.kabin == null) return _showError("Lütfen kabin özelliği sorusunu yanıtlayınız.");
      if (_model.enerji == null) return _showError("Lütfen jeneratör bağlantısı sorusunu yanıtlayınız.");
      if (_model.basinc == null) return _showError("Lütfen kuyu basınçlandırma sorusunu yanıtlayınız.");
    }

    BinaStore.instance.bolum22 = _model;
    BinaStore.instance.saveToDisk();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum23Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(
            title: "İtfaiye (Acil Durum) Asansörü",
            subtitle: "Yüksek binalar için erişim denetimi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSoru(
                    "Binanızda İtfaiye (acil durum) asansörü var mı?", 
                    'varlik', 
                    [Bolum22Content.varlikOptionA, Bolum22Content.varlikOptionB, Bolum22Content.varlikOptionC], 
                    _model.varlik,
                    description: "Yalnızca 51,5 m ve üzeri binalarda zorunludur. Binanızda normal (insan taşıma) asansörü varsa bu soru için Hayır.. yanıtını işaretleyiniz."
                  ),

                  if (_model.varlik?.label == Bolum22Content.varlikOptionB.label) ...[
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
                    
                    _buildSoru("Bu İtfaiye (acil durum) asansörünün kapısı nereye açılıyor?", 'konum', 
                      [Bolum22Content.konumOptionA, Bolum22Content.konumOptionB, Bolum22Content.konumOptionC], _model.konum),

                    _buildSoru("İtfaiye asansörünün açıldığı yangın güvenlik holünün taban alanı yaklaşık kaç metrekaredir?", 'boyut', 
                      [Bolum22Content.boyutOptionA, Bolum22Content.boyutOptionB, Bolum22Content.boyutOptionC, Bolum22Content.boyutOptionD], _model.boyut),

                    _buildSoru("Kabin genişliği en az 1.8 m² ve en alt kattan en üst kata 1 dakika içerisinde çıkabiliyor mu?", 'kabin', 
                      [Bolum22Content.kabinOptionA, Bolum22Content.kabinOptionB, Bolum22Content.kabinOptionC], _model.kabin),

                    _buildSoru("Bu asansör, elektrik kesildiğinde en az 60 dakika çalışabilen bir jeneratöre bağlı mı?", 'enerji', 
                      [Bolum22Content.enerjiOptionA, Bolum22Content.enerjiOptionB, Bolum22Content.enerjiOptionC], _model.enerji),

                    _buildSoru("İtfaiye asansörünün kuyusu basınçlandırılmış mı? (Asansör kovasında duman birikmemesi için dışarıdan hava üfleyen sistem)", 'basinc', 
                      [Bolum22Content.basincOptionA, Bolum22Content.basincOptionB, Bolum22Content.basincOptionC], _model.basinc),
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
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

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected, {String? description}) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
          if (description != null) ...[
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.blue.shade800, fontWeight: FontWeight.w500, height: 1.3),
            ),
          ],
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