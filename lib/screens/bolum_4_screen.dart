import 'package:flutter/material.dart';
import 'package:life_safety/models/choice_result.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_4_model.dart';
import 'bolum_5_screen.dart';
import '../../utils/app_content.dart';

class Bolum4Screen extends StatefulWidget {
  const Bolum4Screen({super.key});

  @override
  State<Bolum4Screen> createState() => _Bolum4ScreenState();
}

class _Bolum4ScreenState extends State<Bolum4Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hesaplaVeGec());
  }

  void _hesaplaVeGec() {
    final Bolum3Model? b3 = BinaStore.instance.bolum3;
    double hBina = b3?.hBina ?? 0.0;
    double hYapi = b3?.hYapi ?? 0.0;

    // Yükseklik Sınıflandırması (hYapi öncelikli)
    var secilenSinif = Bolum4Content.yukseklikSinifiDusuk;
    if (hYapi >= 51.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiMaksimum;
    } else if (hYapi >= 30.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiCokYuksek;
    } else if (hBina >= 21.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiYuksek;
    }

    Bolum4Model model = Bolum4Model(
      binaYukseklikSinifi: secilenSinif,
      hesaplananBinaYuksekligi: hBina,
      hesaplananYapiYuksekligi: hYapi,
    );

    BinaStore.instance.bolum4 = model;
    BinaStore.instance.saveToDisk();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Bolum5Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xFF1A237E))),
    );
  }
}
