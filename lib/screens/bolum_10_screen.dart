import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart'; // EKLENDİ
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/screens/bolum_11_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart'; // ModernHeader

class Bolum10Screen extends StatefulWidget {
  // Constructor'dan parametreler kaldırıldı
  const Bolum10Screen({super.key});

  @override
  State<Bolum10Screen> createState() => _Bolum10ScreenState();
}

class _Bolum10ScreenState extends State<Bolum10Screen> {
  late Bolum10Model _model;
  bool _areAllBodrumSame = true;
  bool _areAllNormalSame = true;
  
  // Yerel değişkenler (Store'dan gelecek)
  int _normalKatSayisi = 0;
  int _bodrumKatSayisi = 0;

  @override
  void initState() {
    super.initState();
    // VERİLERİ DEPODAN ÇEK
    _normalKatSayisi = BinaStore.instance.normalKatSayisi;
    _bodrumKatSayisi = BinaStore.instance.bodrumKatSayisi;

    // HAFIZA: Eğer daha önce kaydedilmiş veri varsa onu yükle
    if (BinaStore.instance.bolum10 != null) {
      _model = BinaStore.instance.bolum10!;
    } else {
      // Yoksa boş model oluştur
      _model = Bolum10Model(
        kullanimBodrum: List.filled(_bodrumKatSayisi, null),
        kullanimNormal: List.filled(_normalKatSayisi, null),
      );
    }
  }

  void _updateZemin(KullanimAmaci? value) {
    setState(() {
      _model = _model.copyWith(kullanimZemin: value);
    });
  }

  void _updateBodrum(int index, KullanimAmaci? value) {
    setState(() {
      List<KullanimAmaci?> newList = List.from(_model.kullanimBodrum);
      
      if (_areAllBodrumSame && index == 0) {
        for (int i = 0; i < newList.length; i++) {
          newList[i] = value;
        }
      } else {
        newList[index] = value;
      }
      
      _model = _model.copyWith(kullanimBodrum: newList);
    });
  }

  void _toggleBodrumSame(bool value) {
    setState(() {
      _areAllBodrumSame = value;
      if (value && _model.kullanimBodrum.isNotEmpty) {
        KullanimAmaci? firstVal = _model.kullanimBodrum[0];
        List<KullanimAmaci?> newList = List.filled(_bodrumKatSayisi, firstVal);
        _model = _model.copyWith(kullanimBodrum: newList);
      }
    });
  }

  void _updateNormal(int index, KullanimAmaci? value) {
    setState(() {
      List<KullanimAmaci?> newList = List.from(_model.kullanimNormal);
      
      if (_areAllNormalSame && index == 0) {
        for (int i = 0; i < newList.length; i++) {
          newList[i] = value;
        }
      } else {
        newList[index] = value;
      }
      
      _model = _model.copyWith(kullanimNormal: newList);
    });
  }

  void _toggleNormalSame(bool value) {
    setState(() {
      _areAllNormalSame = value;
      if (value && _model.kullanimNormal.isNotEmpty) {
        KullanimAmaci? firstVal = _model.kullanimNormal[0];
        List<KullanimAmaci?> newList = List.filled(_normalKatSayisi, firstVal);
        _model = _model.copyWith(kullanimNormal: newList);
      }
    });
  }

  void _onNextPressed() {
    if (!_model.isFormValid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ EKSİK KAT BİLGİSİ"),
          content: const Text(
              "Binanızdaki tüm katların kullanım amacını belirlemeden analize devam edilemez. Lütfen listeyi kontrol edip boş bıraktığınız katları tamamlayınız."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tamam"),
            ),
          ],
        ),
      );
      return;
    }

    _showSummaryDialog();
  }

  Future<void> _showSummaryDialog() async {
    bool isConfirmed = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("BİNA KAT KULLANIM TABLOSU"),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("(En Üstten En Alta Sıralı)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 10),
                      
                      for (int i = _normalKatSayisi - 1; i >= 0; i--)
                        _buildSummaryItem("[${i + 1}]. Normal Kat", _model.kullanimNormal[i]),
                      
                      _buildSummaryItem("ZEMİN KAT", _model.kullanimZemin, isBold: true),
                      
                      for (int i = 0; i < _bodrumKatSayisi; i++)
                        _buildSummaryItem("[${i + 1}]. Bodrum", _model.kullanimBodrum[i]),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: isConfirmed,
                            onChanged: (val) {
                              setStateDialog(() {
                                isConfirmed = val ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text("Yukarıdaki kat kullanım listesini kontrol ettim, bilgileri teyit ediyorum.", style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Hata Var, Düzenle"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  onPressed: isConfirmed ? () {
                    Navigator.of(context).pop();
                    _navigateToNext();
                  } : null,
                  child: const Text("Kaydet ve Devam Et"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, KullanimAmaci? val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• $label: ", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Expanded(
            child: Text(
              val?.aciklama.split(')')[1].trim() ?? "Seçilmedi",
              style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNext() {
    BinaStore.instance.bolum10 = _model;
    print("Bölüm 10 Kaydedildi.");
    
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const Bolum11Screen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. MODERN BAŞLIK
          ModernHeader(
            title: "Kat Kullanım Amacı",
            subtitle: "Bölüm 10: Katların Fonksiyonları",
            currentStep: 10,
            totalSteps: 21,
            onBack: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "KAT KULLANIM AMACI",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("ZEMİN KAT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    label: "Zemin katın kullanım amacı nedir?",
                    value: _model.kullanimZemin,
                    onChanged: _updateZemin,
                  ),
                  const Divider(height: 40),

                  if (_bodrumKatSayisi > 0) ...[
                    const Text("BODRUM KATLAR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    if (_bodrumKatSayisi > 1)
                      SwitchListTile(
                        title: const Text("Tüm bodrum katlar aynı amaca mı hizmet ediyor?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: const Text("Evet derseniz 1. bodrum seçimi diğerlerine kopyalanır."),
                        value: _areAllBodrumSame,
                        onChanged: _toggleBodrumSame,
                        contentPadding: EdgeInsets.zero,
                        activeColor: const Color(0xFF1A237E),
                      ),
                    const SizedBox(height: 10),
                    
                    _buildDropdown(
                      label: "1. Bodrum Katın kullanım amacı?",
                      value: _model.kullanimBodrum[0],
                      onChanged: (v) => _updateBodrum(0, v),
                    ),

                    if (!_areAllBodrumSame)
                      for (int i = 1; i < _bodrumKatSayisi; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _buildDropdown(
                            label: "${i + 1}. Bodrum Katın kullanım amacı?",
                            value: _model.kullanimBodrum[i],
                            onChanged: (v) => _updateBodrum(i, v),
                          ),
                        ),
                    const Divider(height: 40),
                  ],

                  if (_normalKatSayisi > 0) ...[
                    const Text("NORMAL KATLAR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    if (_normalKatSayisi > 1)
                      SwitchListTile(
                        title: const Text("Tüm normal katlar aynı amaca mı hizmet ediyor?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: const Text("Evet derseniz 1. normal kat seçimi diğerlerine kopyalanır."),
                        value: _areAllNormalSame,
                        onChanged: _toggleNormalSame,
                        contentPadding: EdgeInsets.zero,
                        activeColor: const Color(0xFF1A237E),
                      ),
                    const SizedBox(height: 10),

                    _buildDropdown(
                      label: "1. Normal Katın kullanım amacı?",
                      value: _model.kullanimNormal[0],
                      onChanged: (v) => _updateNormal(0, v),
                    ),

                    if (!_areAllNormalSame)
                      for (int i = 1; i < _normalKatSayisi; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _buildDropdown(
                            label: "${i + 1}. Normal Katın kullanım amacı?",
                            value: _model.kullanimNormal[i],
                            onChanged: (v) => _updateNormal(i, v),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ),

          // SABİT BUTON ALANI
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

  Widget _buildDropdown({
    required String label,
    required KullanimAmaci? value,
    required Function(KullanimAmaci?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<KullanimAmaci>(
          value: value, // initialValue yerine value kullanıldı (State yönetimi için)
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          hint: const Text("Seçiniz..."),
          items: KullanimAmaci.values.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.aciklama, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}