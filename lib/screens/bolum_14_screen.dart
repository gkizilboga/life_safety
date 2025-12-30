import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_14_model.dart';
import '../../models/bolum_3_model.dart';
import 'bolum_15_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';
import '../../utils/app_assets.dart';

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
    _hesaplaVeAnalizEt();
  }

  void _hesaplaVeAnalizEt() {
    final Bolum3Model? bolum3 = BinaStore.instance.bolum3;
    
    double zeminH = double.tryParse(bolum3?.zeminKatYuksekligi?.toString() ?? "3.5") ?? 3.5;
    double normalH = double.tryParse(bolum3?.normalKatYuksekligi?.toString() ?? "3.0") ?? 3.0;
    double bodrumH = double.tryParse(bolum3?.bodrumKatYuksekligi?.toString() ?? "3.5") ?? 3.5;
    
    int nKat = int.tryParse(bolum3?.normalKatSayisi?.toString() ?? "0") ?? 0;
    int bKat = int.tryParse(bolum3?.bodrumKatSayisi?.toString() ?? "0") ?? 0;

    double hBinaYonetmelik = zeminH + (nKat * normalH);
    double hBodrum = bKat * bodrumH;

    int duvarDk = 60;
    int kapakDk = 30;
    String mesaj = "";

    if (hBinaYonetmelik >= 30.50) {
      duvarDk = 120;
      kapakDk = 90;
      mesaj = Bolum14Content.msgHigh;
    } else if (hBinaYonetmelik >= 21.50) {
      duvarDk = 90;
      kapakDk = 60;
      mesaj = Bolum14Content.msgMid;
    } else if (hBodrum >= 10.00) {
      duvarDk = 90;
      kapakDk = 60;
      mesaj = Bolum14Content.msgDeepBasement;
    } else {
      duvarDk = 60;
      kapakDk = 30;
      mesaj = Bolum14Content.msgStandard;
    }

    setState(() {
      _model = Bolum14Model(
        gerekenDuvarDk: duvarDk,
        gerekenKapakDk: kapakDk,
        raporMesaji: mesaj,
      );
    });
  }

  void _onNextPressed() {
    BinaStore.instance.bolum14 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum15Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: Bolum14Content.title,
            subtitle: "Bina yüksekliğine göre şaft gereksinimleri",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Yönetmelik Analiz Sonucu",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                        ),
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildResultBox("Şaft Duvarı", "${_model.gerekenDuvarDk}", "dakika"),
                            Container(width: 1, height: 50, color: Colors.grey[200]),
                            _buildResultBox("Şaft Kapağı", "${_model.gerekenKapakDk}", "dakika"),
                          ],
                        ),
                        const Divider(height: 40),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.gavel_rounded, color: Color(0xFF1A237E), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _model.raporMesaji ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF34495E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildWarningNote(),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildResultBox(String label, String value, String unit) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1A237E))),
          Text(unit, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildWarningNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "Not: Bu değerler BYKHY Madde 24 ve 25 uyarınca binanızın mimari verilerine göre otomatik hesaplanmıştır.",
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.blueGrey),
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
            child: const Text("ANALİZİ ONAYLA VE DEVAM ET"),
          ),
        ),
      ),
    );
  }
}