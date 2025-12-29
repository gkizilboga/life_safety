import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_7_model.dart';
import 'bolum_8_screen.dart'; 
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
    final hasOtoparkFromBolum6 = BinaStore.instance.bolum6?.hasOtopark ?? false;
    if (hasOtoparkFromBolum6) {
      setState(() {
        _model = _model.copyWith(hasOtopark: true, isHicbiri: false);
      });
    }
  }

  void _toggleOption(String key) {
    setState(() {
      bool newVal = false;
      bool clearHicbiri = true;

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
    if (!_model.hasOtopark && !_model.hasKazan && !_model.hasAsansor && 
        !_model.hasCati && !_model.hasJenerator && !_model.hasElektrik &&
        !_model.hasTrafo && !_model.hasDepo && !_model.hasCop && 
        !_model.hasSiginak && !_model.hasDuvar && !_model.isHicbiri) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen riskli alanları işaretleyiniz veya 'Hiçbiri'ni seçiniz.")),
      );
      return;
    }

    BinaStore.instance.bolum7 = _model;
    BinaStore.instance.saveToDisk(); // VERİYİ DİSKE YAZ
    Navigator.push(context, MaterialPageRoute(builder: (context) => const 
    Bolum8Screen()));
  }

  @override
  Widget build(BuildContext context) {
    final bool isOtoparkLocked = BinaStore.instance.bolum6?.hasOtopark ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-7: Özel Riskli Alanlar",
            subtitle: "Teknik hacimler ve riskli bölgeler.",
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

                  // --- OTOPARK KİLİTLİ ALAN VE NOT ---
                  if (isOtoparkLocked) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade800, size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Binada kapalı otopark olup olmadığı bilgisi bir önceki bölümden alınarak sisteme işlenmiştir.",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        SelectableCard(
                          choice: Bolum7Content.otopark,
                          isSelected: true,
                          onTap: () {}, // Kilitli olduğu için işlem yapmaz
                        ),
                        Positioned(
                          right: 15,
                          top: 15,
                          child: Icon(Icons.lock, color: Colors.blue.shade900.withValues(alpha: 0.5), size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ] else 
                    SelectableCard(
                      choice: Bolum7Content.otopark,
                      isSelected: _model.hasOtopark,
                      onTap: () => _toggleOption('otopark'),
                    ),

                  // --- DİĞER SEÇENEKLER ---
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

                  const Divider(thickness: 2, height: 30),
                  
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