import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_7_model.dart';
import 'bolum_8_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';

class Bolum7Screen extends StatefulWidget {
  const Bolum7Screen({super.key});

  @override
  State<Bolum7Screen> createState() => _Bolum7ScreenState();
}

class _Bolum7ScreenState extends State<Bolum7Screen> {
  Bolum7Model _model = Bolum7Model();

  @override
  void initState() {
    super.initState();
    _checkPreviousData();
  }

  void _checkPreviousData() {
    // Bölüm 6'dan otopark verisini kontrol et
    final hasOtoparkFromBolum6 = BinaStore.instance.bolum6?.hasOtopark ?? false;
    
    // Eğer otopark varsa modele işle
    if (hasOtoparkFromBolum6) {
      setState(() {
        _model = _model.copyWith(hasOtopark: true, isHicbiri: false);
      });
    }
  }

  void _toggleOption(String key) {
    setState(() {
      bool newVal = false;
      bool clearHicbiri = true; // "Hiçbiri" seçeneğini kaldıralım mı?

      switch (key) {
        case 'kazan':
          newVal = !_model.hasKazan;
          _model = _model.copyWith(hasKazan: newVal);
          break;
        case 'asansor':
          newVal = !_model.hasAsansor;
          _model = _model.copyWith(hasAsansor: newVal);
          break;
        case 'cati':
          newVal = !_model.hasCati;
          _model = _model.copyWith(hasCati: newVal);
          break;
        case 'jenerator':
          newVal = !_model.hasJenerator;
          _model = _model.copyWith(hasJenerator: newVal);
          break;
        case 'elektrik':
          newVal = !_model.hasElektrik;
          _model = _model.copyWith(hasElektrik: newVal);
          break;
        case 'trafo':
          newVal = !_model.hasTrafo;
          _model = _model.copyWith(hasTrafo: newVal);
          break;
        case 'depo':
          newVal = !_model.hasDepo;
          _model = _model.copyWith(hasDepo: newVal);
          break;
        case 'cop':
          newVal = !_model.hasCop;
          _model = _model.copyWith(hasCop: newVal);
          break;
        case 'siginak':
          newVal = !_model.hasSiginak;
          _model = _model.copyWith(hasSiginak: newVal);
          break;
        case 'duvar':
          newVal = !_model.hasDuvar;
          _model = _model.copyWith(hasDuvar: newVal);
          break;
        case 'hicbiri':
          // Hiçbiri seçilirse her şeyi sıfırla (Otopark hariç, o sistemden geliyor)
          bool otoparkKalsin = BinaStore.instance.bolum6?.hasOtopark ?? false;
          _model = Bolum7Model(
            isHicbiri: !_model.isHicbiri, 
            hasOtopark: otoparkKalsin
          );
          clearHicbiri = false;
          break;
      }

      if (clearHicbiri) {
        _model = _model.copyWith(isHicbiri: false);
      }
    });
  }

  void _onNextPressed() {
    // Hiçbir şey seçilmediyse uyarı ver (Otopark dahil hepsi false ise)
    if (!_model.hasOtopark && !_model.hasKazan && !_model.hasAsansor && 
        !_model.hasCati && !_model.hasJenerator && !_model.hasElektrik &&
        !_model.hasTrafo && !_model.hasDepo && !_model.hasCop && 
        !_model.hasSiginak && !_model.hasDuvar && !_model.isHicbiri) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen binanızdaki teknik hacimleri, riskli alanları işaretleyiniz veya 'Hiçbiri'ni seçiniz.")),
      );
      return;
    }

    BinaStore.instance.bolum7 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum8Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Otopark sistemden geliyorsa elle değiştirmeyi engellemek için
    final bool isOtoparkLocked = BinaStore.instance.bolum6?.hasOtopark ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-7: Özel Riskli Alanlar ve Teknik Hacimler",
            subtitle: "...",
            screenType: widget.runtimeType,
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

                  // OTOPARK (ÖZEL DURUM)
                  Opacity(
                    opacity: isOtoparkLocked ? 0.6 : 1.0,
                    child: SelectableCard(
                      choice: Bolum7Content.otopark,
                      isSelected: _model.hasOtopark,
                      onTap: () {
                        if (!isOtoparkLocked) {
                          // Eğer Bölüm 6'da seçilmediyse buradan manuel seçebilir (Opsiyonel)
                          // Ama genelde kilitli kalması daha mantıklı.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Otopark bilgisi önceki bölümden alınmıştır.")),
                          );
                        }
                      },
                    ),
                  ),

                  SelectableCard(
                    choice: Bolum7Content.kazan,
                    isSelected: _model.hasKazan,
                    onTap: () => _toggleOption('kazan'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.asansor,
                    isSelected: _model.hasAsansor,
                    onTap: () => _toggleOption('asansor'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.cati,
                    isSelected: _model.hasCati,
                    onTap: () => _toggleOption('cati'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.jenerator,
                    isSelected: _model.hasJenerator,
                    onTap: () => _toggleOption('jenerator'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.elektrik,
                    isSelected: _model.hasElektrik,
                    onTap: () => _toggleOption('elektrik'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.trafo,
                    isSelected: _model.hasTrafo,
                    onTap: () => _toggleOption('trafo'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.depo,
                    isSelected: _model.hasDepo,
                    onTap: () => _toggleOption('depo'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.cop,
                    isSelected: _model.hasCop,
                    onTap: () => _toggleOption('cop'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.siginak,
                    isSelected: _model.hasSiginak,
                    onTap: () => _toggleOption('siginak'),
                  ),
                  SelectableCard(
                    choice: Bolum7Content.duvar,
                    isSelected: _model.hasDuvar,
                    onTap: () => _toggleOption('duvar'),
                  ),

                  const Divider(thickness: 2),
                  
                  SelectableCard(
                    choice: Bolum7Content.hicbiri,
                    isSelected: _model.isHicbiri,
                    onTap: () => _toggleOption('hicbiri'),
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
}