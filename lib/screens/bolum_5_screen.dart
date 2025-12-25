import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_5_model.dart';
import 'bolum_6_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';

class Bolum5Screen extends StatefulWidget {
  const Bolum5Screen({super.key});

  @override
  State<Bolum5Screen> createState() => _Bolum5ScreenState();
}

class _Bolum5ScreenState extends State<Bolum5Screen> {
  Bolum5Model _model = Bolum5Model();

  final TextEditingController _tabanController = TextEditingController();
  final TextEditingController _katController = TextEditingController();
  final TextEditingController _toplamController = TextEditingController();

  @override
  void dispose() {
    _tabanController.dispose();
    _katController.dispose();
    _toplamController.dispose();
    super.dispose();
  }

  void _otomatikHesapla() {
    // Bölüm 3 verilerini çek
    final Bolum3Model? bolum3 = BinaStore.instance.bolum3;
    
    // Varsayılan değerler (eğer bölüm 3 boşsa)
    int katSayisi = (bolum3?.normalKatSayisi ?? 1) + (bolum3?.bodrumKatSayisi ?? 0) + 1; // +1 Zemin

    // Kullanıcının girdiği kat alanını al
    double? kAlani = double.tryParse(_katController.text.replaceAll(',', '.'));

    if (kAlani != null) {
      double tahmin = kAlani * katSayisi;
      setState(() {
        _toplamController.text = tahmin.toStringAsFixed(2);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Otomatik Hesaplandı: $katSayisi kat x $kAlani m²"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen önce 'Standart Kat Alanı'nı giriniz."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onNextPressed() {
    // Validasyon: Toplam alan boş olamaz
    if (_toplamController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen Toplam İnşaat Alanını giriniz veya Otomatik Hesaplatınız."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _model = _model.copyWith(
      tabanAlani: double.tryParse(_tabanController.text.replaceAll(',', '.')),
      katAlani: double.tryParse(_katController.text.replaceAll(',', '.')),
      toplamInsaatAlani: double.tryParse(_toplamController.text.replaceAll(',', '.')),
    );

    BinaStore.instance.bolum5 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum6Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-5: Bina Kat Alanı Bilgileri",
            subtitle: " ",
            currentStep: 5,
            totalSteps: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Bolum5Content.oturumAlani.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(Bolum5Content.oturumAlani.uiSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 5),
                        _buildNumberInput(_tabanController),
                        
                        const SizedBox(height: 20),
                        
                        Text(Bolum5Content.katBrut.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(Bolum5Content.katBrut.uiSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 5),
                        _buildNumberInput(_katController),

                        const SizedBox(height: 20),
                        const Divider(thickness: 2),
                        const SizedBox(height: 10),

                        // OTOMATİK HESAPLA BUTONU (BÜYÜTÜLDÜ)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _otomatikHesapla,
                            icon: const Icon(Icons.calculate, size: 24),
                            label: const Text(
                              "OTOMATİK HESAPLA",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 15),

                        Text(Bolum5Content.toplamInsaat.uiTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(Bolum5Content.toplamInsaat.uiSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 5),
                        _buildNumberInput(_toplamController),
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
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  child: const Text("KAYDET VE DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInput(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        hintText: "m² giriniz",
        suffixText: "m²",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}