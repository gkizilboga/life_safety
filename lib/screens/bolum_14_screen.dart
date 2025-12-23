import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_14_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_15_screen.dart';


class Bolum14Screen extends StatefulWidget {
  const Bolum14Screen({super.key});

  @override
  State<Bolum14Screen> createState() => _Bolum14ScreenState();
}

class _Bolum14ScreenState extends State<Bolum14Screen> {
  Bolum14Model _model = Bolum14Model();

  @override
  void initState() {
    super.initState();
    _calculateRequirements();
  }

  void _calculateRequirements() {
    final b4 = BinaStore.instance.bolum4;
    final b3 = BinaStore.instance.bolum3;

    final bool isLimit3050 = b4?.isLimitBina3050 ?? false;
    final bool isLimit2150 = b4?.isLimitBina2150 ?? false;
    final double hBodrum = b3?.hBodrum ?? 0.0;

    int duvarDk = 60;
    int kapakDk = 30;
    String mesaj = "";

    if (isLimit3050) {
      duvarDk = 120;
      kapakDk = 90;
      mesaj = "Binanız 30.50 metreden yüksek olduğu için tüm şaft duvarları en az 120 dk, kapakları ise 90 dk duman sızdırmaz ve yangına dayanıklı olmalıdır.";
    } else if (isLimit2150) {
      duvarDk = 90;
      kapakDk = 60;
      mesaj = "Binanız 21.50m - 30.50m aralığında olup ‘Yüksek Bina’ sınıfındadır. Tesisat şaftı ve yangın duvarlarınızın en az 90 dk, kapakların ise 60 dk dayanıklı olması gerekmektedir.";
    } else if (!isLimit2150 && hBodrum >= 10.00) {
      duvarDk = 90;
      kapakDk = 60;
      mesaj = "DİKKAT: Binanız alçak olsa da, bodrum kat derinliğiniz 10 metreyi aştığı için bodrum katlarınız yüksek risk taşımaktadır. Bodrumdaki duvar ve kapak dayanımları (90dk/60dk), üst katlardan (60dk/30dk) daha yüksek seçilmelidir.";
    } else {
      duvarDk = 60;
      kapakDk = 30;
      mesaj = "Binanızın yüksekliği ve bodrum derinliği standart sınırlar içindedir. Duvarlar 60 dk, kapaklar 30 dk dayanıklı olmalıdır.";
    }

    setState(() {
      _model = Bolum14Model(
        valGerekenDuvarDk: duvarDk,
        valGerekenKapakDk: kapakDk,
        resDuvarRaporMesaji: mesaj,
      );
    });
  }

void _onNextPressed() {
    // Önce Bölüm 14 verilerini merkeze (BinaStore) kaydet
    BinaStore.instance.bolum14 = _model;
    print("Bölüm 14 Kaydedildi. Duvar: ${_model.valGerekenDuvarDk}dk");

    // Şimdi Bölüm 15 ekranına git
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum15Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Yangın Duvarları",
            subtitle: "Bölüm 14: Dayanım Süreleri",
            currentStep: 14,
            totalSteps: 15,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "HESAPLANAN GEREKLİLİKLER",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Bina yüksekliği ve bodrum derinliğine göre sistem tarafından hesaplanmıştır.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(child: _buildResultCard("Duvar Dayanımı", "${_model.valGerekenDuvarDk}", "Dakika")),
                      const SizedBox(width: 15),
                      Expanded(child: _buildResultCard("Kapak Dayanımı", "${_model.valGerekenKapakDk}", "Dakika")),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade800),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _model.resDuvarRaporMesaji,
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
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

  Widget _buildResultCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A237E),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1A237E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}