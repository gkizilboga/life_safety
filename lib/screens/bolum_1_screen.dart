import 'package:flutter/material.dart';
import '../data/bina_store.dart'; 
import '../models/bolum_1_model.dart';
import 'bolum_2_screen.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/selectable_card.dart';
import '../utils/app_content.dart';
import '../models/choice_result.dart';

class Bolum1Screen extends StatefulWidget {
  const Bolum1Screen({super.key});

  @override
  State<Bolum1Screen> createState() => _Bolum1ScreenState();
}

class _Bolum1ScreenState extends State<Bolum1Screen> {
  Bolum1Model _model = Bolum1Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;

    if (_model.secim?.label == Bolum1Content.ruhsatSonrasi.label) {
      _navigateToNext();
    } else {
      _showWarningDialog();
    }
  }

  void _navigateToNext() {
    BinaStore.instance.bolum1 = _model;
    BinaStore.instance.saveToDisk(); // EKLE
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum2Screen()));
  }

  Future<void> _showWarningDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
              SizedBox(width: 10),
              Expanded(child: Text('UYARI', style: TextStyle(fontSize: 18))),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '⚠️ DİKKAT: Bu uygulamada esasen 19.12.2007 ve sonrası yapı ruhsatı almış binalar hakkında değerlendirme yapılmaktadır.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'Binanız belirtilen tarihten önce ruhsat almış olmasına rağmen güncel yönetmelikteki "Yeni Bina" hükümlerine göre analiz edilmesini talep ediyorsunuz. Kesin risk analizi için uzman kontrolü ve görüşü almanız tavsiye edilir.\n\n',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToNext();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              child: const Text('Anladım, Devam Et'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-1: Yapı Ruhsat / İnşa Tarihi",
            subtitle: " ",
            screenType: widget.runtimeType, // Hata veren ScreenType yerine orijinali
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Yapı Ruhsat / İnşa Tarihi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Binanızın yapı ruhsatı hangi tarihte alındı veya yapım tarihi nedir?",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.4),
                  ),
                  const SizedBox(height: 25),
QuestionCard(
  child: Column(
    children: [
      SelectableCard(
        choice: Bolum1Content.ruhsatSonrasi,
        isSelected: _model.secim?.label == Bolum1Content.ruhsatSonrasi.label,
        onTap: () => _handleSelection(Bolum1Content.ruhsatSonrasi),
      ),
      const SizedBox(height: 12),
      SelectableCard(
        choice: Bolum1Content.ruhsatOncesi,
        isSelected: _model.secim?.label == Bolum1Content.ruhsatOncesi.label,
        onTap: () => _handleSelection(Bolum1Content.ruhsatOncesi),
      ),
    ],
  ),
),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _model.secim == null ? null : _onNextPressed,
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