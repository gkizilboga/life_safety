import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_12_model.dart';
import 'bolum_13_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum12Screen extends StatefulWidget {
  const Bolum12Screen({super.key});

  @override
  State<Bolum12Screen> createState() => _Bolum12ScreenState();
}

class _Bolum12ScreenState extends State<Bolum12Screen> {
  Bolum12Model _model = Bolum12Model();
  
  // Bölüm 2'den gelen taşıyıcı sistem bilgisi
  String? _tasiyiciSistemLabel;

  // Manuel giriş için controller'lar
  final TextEditingController _kolonPaspayiCtrl = TextEditingController();
  final TextEditingController _kirisPaspayiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Bölüm 2 verisini çek
    final bolum2 = BinaStore.instance.bolum2;
    _tasiyiciSistemLabel = bolum2?.secim?.label;
  }

  @override
  void dispose() {
    _kolonPaspayiCtrl.dispose();
    _kirisPaspayiCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'celik') {
        _model = _model.copyWith(celikKoruma: choice);
      } else if (type == 'beton') {
        _model = _model.copyWith(betonPaspayi: choice);
      } else if (type == 'ahsap') {
        _model = _model.copyWith(ahsapKesit: choice);
      } else if (type == 'yigma') {
        _model = _model.copyWith(yigmaDuvar: choice);
      }
    });
  }

  void _onNextPressed() {
    // Validasyon: İlgili soru cevaplanmış mı?
    
    // ÇELİK
    if (_tasiyiciSistemLabel == Bolum2Content.celik.label && _model.celikKoruma == null) {
      _showError("Lütfen binanızdaki çeliklerin korunma yöntemini seçiniz."); return;
    }
    
    // BETON
    if (_tasiyiciSistemLabel == Bolum2Content.betonarme.label || _tasiyiciSistemLabel == Bolum2Content.bilinmiyor.label) {
      if (_model.betonPaspayi == null) {
        _showError("Lütfen paspayı durumunu seçiniz."); return;
      }
      // Manuel giriş seçildiyse değerleri kaydet
      if (_model.betonPaspayi?.label == Bolum12Content.betonOptionB.label) {
        double? k = double.tryParse(_kolonPaspayiCtrl.text.replaceAll(',', '.'));
        double? ki = double.tryParse(_kirisPaspayiCtrl.text.replaceAll(',', '.'));
        if (k == null || ki == null) {
          _showError("Lütfen paspayı değerlerini giriniz."); return;
        }
        _model = _model.copyWith(kolonPaspayi: k, kirisPaspayi: ki);
      }
    }

    // AHŞAP
    if (_tasiyiciSistemLabel == Bolum2Content.ahsap.label && _model.ahsapKesit == null) {
      _showError("Lütfen ahşap kesit durumunu seçiniz."); return;
    }

    // YIĞMA
    if (_tasiyiciSistemLabel == Bolum2Content.yigma.label && _model.yigmaDuvar == null) {
      _showError("Lütfen duvar kalınlığı durumunu seçiniz."); return;
    }

    BinaStore.instance.bolum12 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum13Screen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // Taşıyıcı sisteme göre hangi widget'ın gösterileceğini belirle
    Widget content;

    if (_tasiyiciSistemLabel == Bolum2Content.celik.label) {
      content = _buildCelikSorusu();
    } else if (_tasiyiciSistemLabel == Bolum2Content.ahsap.label) {
      content = _buildAhsapSorusu();
    } else if (_tasiyiciSistemLabel == Bolum2Content.yigma.label) {
      content = _buildYigmaSorusu();
    } else {
      // Betonarme veya Bilinmiyor ise Beton sorusu sorulur
      content = _buildBetonSorusu();
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-12: Taşıyıcı Sistemin Yapısal Yangın Dayanımı",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: content,
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

  Widget _buildCelikSorusu() {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Çelik taşıyıcılarınızda (kolon ve kirişlerde) yangına karşı bir koruma veya yalıtım var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SelectableCard(
            choice: Bolum12Content.celikOptionA,
            isSelected: _model.celikKoruma?.label == Bolum12Content.celikOptionA.label,
            onTap: () => _handleSelection('celik', Bolum12Content.celikOptionA),
          ),
          SelectableCard(
            choice: Bolum12Content.celikOptionB,
            isSelected: _model.celikKoruma?.label == Bolum12Content.celikOptionB.label,
            onTap: () => _handleSelection('celik', Bolum12Content.celikOptionB),
          ),
          SelectableCard(
            choice: Bolum12Content.celikOptionC,
            isSelected: _model.celikKoruma?.label == Bolum12Content.celikOptionC.label,
            onTap: () => _handleSelection('celik', Bolum12Content.celikOptionC),
          ),
        ],
      ),
    );
  }

  Widget _buildBetonSorusu() {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Betonarme taşıyıcılarınızdaki demir donatıları örten beton tabakasının kalınlıkları hakkında nasıl bilgi girmek istersiniz?", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SelectableCard(
            choice: Bolum12Content.betonOptionA,
            isSelected: _model.betonPaspayi?.label == Bolum12Content.betonOptionA.label,
            onTap: () => _handleSelection('beton', Bolum12Content.betonOptionA),
          ),
          SelectableCard(
            choice: Bolum12Content.betonOptionB,
            isSelected: _model.betonPaspayi?.label == Bolum12Content.betonOptionB.label,
            onTap: () => _handleSelection('beton', Bolum12Content.betonOptionB),
          ),
          
          if (_model.betonPaspayi?.label == Bolum12Content.betonOptionB.label) ...[
            const SizedBox(height: 10),
            TextFormField(
              controller: _kolonPaspayiCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "Kolon Paspayı (mm)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _kirisPaspayiCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "Kiriş Paspayı (mm)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
          ],

          SelectableCard(
            choice: Bolum12Content.betonOptionC,
            isSelected: _model.betonPaspayi?.label == Bolum12Content.betonOptionC.label,
            onTap: () => _handleSelection('beton', Bolum12Content.betonOptionC),
          ),
        ],
      ),
    );
  }

  Widget _buildAhsapSorusu() {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ahşap taşıyıcılarınızın kalınlığı (kesiti) nasıldır?", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SelectableCard(
            choice: Bolum12Content.ahsapOptionA,
            isSelected: _model.ahsapKesit?.label == Bolum12Content.ahsapOptionA.label,
            onTap: () => _handleSelection('ahsap', Bolum12Content.ahsapOptionA),
          ),
          SelectableCard(
            choice: Bolum12Content.ahsapOptionB,
            isSelected: _model.ahsapKesit?.label == Bolum12Content.ahsapOptionB.label,
            onTap: () => _handleSelection('ahsap', Bolum12Content.ahsapOptionB),
          ),
        ],
      ),
    );
  }

  Widget _buildYigmaSorusu() {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Binanızın taşıyıcı duvarlarının kalınlığı en az 19 cm (yaklaşık bir tuğla boyu) var mı?", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SelectableCard(
            choice: Bolum12Content.yigmaOptionA,
            isSelected: _model.yigmaDuvar?.label == Bolum12Content.yigmaOptionA.label,
            onTap: () => _handleSelection('yigma', Bolum12Content.yigmaOptionA),
          ),
          SelectableCard(
            choice: Bolum12Content.yigmaOptionB,
            isSelected: _model.yigmaDuvar?.label == Bolum12Content.yigmaOptionB.label,
            onTap: () => _handleSelection('yigma', Bolum12Content.yigmaOptionB),
          ),
        ],
      ),
    );
  }
}