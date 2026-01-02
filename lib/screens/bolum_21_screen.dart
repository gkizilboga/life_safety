import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_21_model.dart';
import 'bolum_22_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart'; // Görsel yolu için eklendi

class Bolum21Screen extends StatefulWidget {
  const Bolum21Screen({super.key});

  @override
  State<Bolum21Screen> createState() => _Bolum21ScreenState();
}

class _Bolum21ScreenState extends State<Bolum21Screen> {
  Bolum21Model _model = Bolum21Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        // Eğer "YGH Yok" seçilirse, diğer cevapları temizle
        if (choice.label == Bolum21Content.varlikOptionB.label) {
          _model = _model.copyWith(malzeme: null, kapi: null, esya: null);
        }
      } else if (type == 'malzeme') {
        _model = _model.copyWith(malzeme: choice);
      } else if (type == 'kapi') {
        _model = _model.copyWith(kapi: choice);
      } else if (type == 'esya') {
        _model = _model.copyWith(esya: choice);
      }
    });
  }

  bool _isReady() {
    if (_model.varlik == null) return false;
    // Eğer YGH varsa, diğer tüm sorular zorunludur
    if (_model.varlik?.label == Bolum21Content.varlikOptionA.label) {
      return _model.malzeme != null && _model.kapi != null && _model.esya != null;
    }
    return true; // YGH yoksa sadece varlık sorusu yeterli
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yangın Güvenlik Holü (YGH)",
      subtitle: "Merdiven önü koruma bölgelerinin analizi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum21 = _model;
        // saveToDisk() işlemi AnalysisPageLayout içinde otomatik yapılmaktadır.
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum22Screen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Varlık Sorusu
          _buildSoru(
            "1. Daire kapınızdan çıktığınızda merdivene girmeden evvel ufak bir odadan (yangın güvenlik holünden) geçiyor musunuz?", 
            'varlik', 
            [Bolum21Content.varlikOptionA, Bolum21Content.varlikOptionB], 
            _model.varlik
          ),

          // Diğer sorular SADECE YGH VARSA gösterilir
          if (_model.varlik?.label == Bolum21Content.varlikOptionA.label) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFECEFF1)),
            ),
            
            // 2. Malzeme Sorusu (GÖRSEL BUTONU BURADA)
            _buildSoru(
              "2. YGH duvarlarında, zemininde ve tavanında kullanılan malzeme nedir?", 
              'malzeme', 
              [
                Bolum21Content.malzemeOptionA, 
                Bolum21Content.malzemeOptionB,
                Bolum21Content.malzemeOptionC
              ], 
              _model.malzeme,
              assetPath: AppAssets.section21Ygh,
              assetTitle: "Yangın Güvenlik Holü Uygulama Detayı",
            ),

            // 3. Kapı Sorusu
            _buildSoru(
              "3. Bu YGH'ye giriş-çıkış sağlayan kapıların özelliği nedir?", 
              'kapi', 
              [
                Bolum21Content.kapiOptionA, 
                Bolum21Content.kapiOptionB,
                Bolum21Content.kapiOptionC
              ], 
              _model.kapi
            ),

            // 4. Eşya Sorusu
            _buildSoru(
              "4. YGH'nin içinde kaçışa engel olabilecek herhangi bir eşya (bisiklet, dolap vb.) bekletiliyor mu?", 
              'esya', 
              [
                Bolum21Content.esyaOptionA, 
                Bolum21Content.esyaOptionB,
                Bolum21Content.esyaOptionC
              ], 
              _model.esya
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected, {String? assetPath, String? assetTitle}) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
          
          // Eğer assetPath dolu gelirse teknik görsel butonunu yerleştir
          if (assetPath != null) ...[
            const SizedBox(height: 12),
            TechnicalDrawingButton(
              assetPath: assetPath,
              title: assetTitle ?? "Teknik Detay",
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