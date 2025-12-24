import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_6_model.dart';
import 'bolum_7_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum6Screen extends StatefulWidget {
  const Bolum6Screen({super.key});

  @override
  State<Bolum6Screen> createState() => _Bolum6ScreenState();
}

class _Bolum6ScreenState extends State<Bolum6Screen> {
  Bolum6Model _model = Bolum6Model();

  void _toggleUsage(String type) {
    setState(() {
      bool newOtopark = _model.hasOtopark;
      bool newTicari = _model.hasTicari;
      bool newDepo = _model.hasDepo;
      bool newKonut = _model.isSadeceKonut;

      if (type == 'konut') {
        // Sadece Konut seçildiyse diğerlerini kapat
        newKonut = !newKonut;
        if (newKonut) {
          newOtopark = false;
          newTicari = false;
          newDepo = false;
        }
      } else {
        // Diğerleri seçildiyse "Sadece Konut"u kapat
        if (type == 'otopark') newOtopark = !newOtopark;
        if (type == 'ticari') newTicari = !newTicari;
        if (type == 'depo') newDepo = !newDepo;
        
        if (newOtopark || newTicari || newDepo) {
          newKonut = false;
        }
      }

      _model = _model.copyWith(
        hasOtopark: newOtopark,
        hasTicari: newTicari,
        hasDepo: newDepo,
        isSadeceKonut: newKonut,
        // Otopark seçimi kaldırılırsa tipini de sıfırla
        otoparkTipi: newOtopark ? _model.otoparkTipi : null, 
      );
    });
  }

  void _handleOtoparkTipi(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(otoparkTipi: choice);
    });
  }

  void _onNextPressed() {
    // Validasyon: Otopark varsa tipi seçilmeli
    if (_model.hasOtopark && _model.otoparkTipi == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen otopark tipini seçiniz.")),
      );
      return;
    }

    // Hiçbir şey seçilmediyse
    if (!_model.hasOtopark && !_model.hasTicari && !_model.hasDepo && !_model.isSadeceKonut) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen binadaki kullanım alanlarını işaretleyiniz.")),
      );
      return;
    }

    BinaStore.instance.bolum6 = _model;
    
    // Geçici olarak Bölüm 7'ye yönlendiriyoruz (Dosyası yoksa oluşturman gerekebilir)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum7Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-6: Kullanım Detayları",
            subtitle: "Binada konut harici neler var?",
            currentStep: 6,
            totalSteps: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "Binanızda aşağıdaki alanlardan hangileri var?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "(Birden fazla işaretleyebilirsiniz)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),

                  // ÇOKLU SEÇİM ALANI
                  SelectableCard(
                    choice: Bolum6Content.otoparkVar,
                    isSelected: _model.hasOtopark,
                    onTap: () => _toggleUsage('otopark'),
                  ),
                  SelectableCard(
                    choice: Bolum6Content.ticariVar,
                    isSelected: _model.hasTicari,
                    onTap: () => _toggleUsage('ticari'),
                  ),
                  SelectableCard(
                    choice: Bolum6Content.depoVar,
                    isSelected: _model.hasDepo,
                    onTap: () => _toggleUsage('depo'),
                  ),
                  SelectableCard(
                    choice: Bolum6Content.sadeceKonut,
                    isSelected: _model.isSadeceKonut,
                    onTap: () => _toggleUsage('konut'),
                  ),

                  // OTOPARK VARSA AÇILAN EK SORU
                  if (_model.hasOtopark) ...[
                    const Divider(height: 40, thickness: 2),
                    const Text(
                      "Otopark Tipi Nedir?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                    ),
                    const SizedBox(height: 15),
                    SelectableCard(
                      choice: Bolum6Content.otoparkKapali,
                      isSelected: _model.otoparkTipi?.label == Bolum6Content.otoparkKapali.label,
                      onTap: () => _handleOtoparkTipi(Bolum6Content.otoparkKapali),
                    ),
                    SelectableCard(
                      choice: Bolum6Content.otoparkAcik,
                      isSelected: _model.otoparkTipi?.label == Bolum6Content.otoparkAcik.label,
                      onTap: () => _handleOtoparkTipi(Bolum6Content.otoparkAcik),
                    ),
                    SelectableCard(
                      choice: Bolum6Content.otoparkYariAcik,
                      isSelected: _model.otoparkTipi?.label == Bolum6Content.otoparkYariAcik.label,
                      onTap: () => _handleOtoparkTipi(Bolum6Content.otoparkYariAcik),
                    ),
                  ],
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
}