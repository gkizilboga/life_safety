import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_14_model.dart';
import '../../models/bolum_3_model.dart';
import '../../utils/app_theme.dart';
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
    if (BinaStore.instance.bolum14 != null) {
      _model = BinaStore.instance.bolum14!;
    } else {
      _hesaplaVeAnalizEt();
    }
  }

  void _hesaplaVeAnalizEt() {
    final Bolum3Model? bolum3 = BinaStore.instance.bolum3;

    double hBinaYonetmelik = bolum3?.hBina ?? 0.0;
    double hBodrum = (bolum3?.hYapi ?? 0.0) - hBinaYonetmelik;

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
    BinaStore.instance.saveToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum15Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Tesisat Şaftları",
      screenType: widget.runtimeType,
      isNextEnabled: true,
      onNext: _onNextPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text("Sonuç", style: AppStyles.questionTitle),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildResultBox(
                      "Şaft Duvarı",
                      "${_model.gerekenDuvarDk}",
                      "dakika",
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFECEFF1),
                    ),
                    _buildResultBox(
                      "Şaft Kapağı / Kapısı ",
                      "${_model.gerekenKapakDk}",
                      "dakika",
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFECEFF1)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.gavel_rounded,
                      color: Color(0xFF1A237E),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _model.raporMesaji ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF455A64),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text("Şaft ve Kapak Detayı", style: AppStyles.questionTitle),
          ),
          SectionImage(assetPath: AppAssets.section14SaftDuvarKapi),
          const SizedBox(height: 12),
          _buildWarningNote(),
        ],
      ),
    );
  }

  Widget _buildResultBox(String label, String value, String unit) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A237E),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningNote() {
    return const CustomInfoNote(
      type: InfoNoteType.info,
      text:
          "Bu değerler binanızın mimari verilerine göre otomatik hesaplanmıştır.",
      icon: Icons.info_outline,
    );
  }
}
