import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_11_model.dart';
import 'bolum_12_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum11Screen extends StatefulWidget {
  const Bolum11Screen({super.key});

  @override
  State<Bolum11Screen> createState() => _Bolum11ScreenState();
}

class _Bolum11ScreenState extends State<Bolum11Screen> {
  Bolum11Model _model = Bolum11Model();

  // 1. ADIM: Kaydırma kontrolcüsünü tanımlıyoruz
  final ScrollController _scrollController = ScrollController();

  // 2. ADIM: Otomatik kaydırma fonksiyonu
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mesafe') {
        _model = _model.copyWith(mesafe: choice);
        if (choice.label != Bolum11Content.mesafeOptionB.label) {
          _model = _model.copyWith(engel: null, zayifNokta: null);
        } else {
          // Eğer 45m aşıldıysa alt soru açılacak, kaydır
          _scrollToBottom();
        }
      } 
      else if (type == 'engel') {
        _model = _model.copyWith(engel: choice);
        if (choice.label != Bolum11Content.engelOptionB.label) {
          _model = _model.copyWith(zayifNokta: null);
        } else {
          // Eğer engel varsa alt soru açılacak, kaydır
          _scrollToBottom();
        }
      } 
      else if (type == 'zayifNokta') {
        _model = _model.copyWith(zayifNokta: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.mesafe == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen itfaiye yaklaşım mesafesi sorusunu yanıtlayınız.")),
      );
      return;
    }

    if (_model.mesafe?.label == Bolum11Content.mesafeOptionB.label) {
      if (_model.engel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen engel durumu sorusunu yanıtlayınız.")),
        );
        return;
      }
      
      if (_model.engel?.label == Bolum11Content.engelOptionB.label) {
        if (_model.zayifNokta == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lütfen zayıf geçiş noktası sorusunu yanıtlayınız.")),
          );
          return;
        }
      }
    }

    BinaStore.instance.bolum11 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum12Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-11: İtfaiye Erişimi",
            subtitle: "İtfaiye araçlarının binaya yaklaşım analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController, // 3. ADIM: Kontrolcüyü bağladık
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // SORU 1: MESAFE
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "1. İtfaiye aracının binaya yaklaşım mesafesi 45 metreyi aşıyor mu?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SelectableCard(
                          choice: Bolum11Content.mesafeOptionA,
                          isSelected: _model.mesafe?.label == Bolum11Content.mesafeOptionA.label,
                          onTap: () => _handleSelection('mesafe', Bolum11Content.mesafeOptionA),
                        ),
                        SelectableCard(
                          choice: Bolum11Content.mesafeOptionB,
                          isSelected: _model.mesafe?.label == Bolum11Content.mesafeOptionB.label,
                          onTap: () => _handleSelection('mesafe', Bolum11Content.mesafeOptionB),
                        ),
                        SelectableCard(
                          choice: Bolum11Content.mesafeOptionC,
                          isSelected: _model.mesafe?.label == Bolum11Content.mesafeOptionC.label,
                          onTap: () => _handleSelection('mesafe', Bolum11Content.mesafeOptionC),
                        ),
                      ],
                    ),
                  ),

                  // 4. ADIM: Alt Soru Bilgi Notu (Mesafe > 45m ise çıkar)
                  if (_model.mesafe?.label == Bolum11Content.mesafeOptionB.label)
                    _buildInfoNote("Mesafe 45m'yi aştığı için ek güvenlik soruları açılmıştır."),

                  // SORU 2: ENGEL
                  if (_model.mesafe?.label == Bolum11Content.mesafeOptionB.label) ...[
                    QuestionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "2. İtfaiye aracının binaya yanaşmasını engelleyen bir bahçe duvarı veya kilitli kapılar var mı?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          SelectableCard(
                            choice: Bolum11Content.engelOptionA,
                            isSelected: _model.engel?.label == Bolum11Content.engelOptionA.label,
                            onTap: () => _handleSelection('engel', Bolum11Content.engelOptionA),
                          ),
                          SelectableCard(
                            choice: Bolum11Content.engelOptionB,
                            isSelected: _model.engel?.label == Bolum11Content.engelOptionB.label,
                            onTap: () => _handleSelection('engel', Bolum11Content.engelOptionB),
                          ),
                          SelectableCard(
                            choice: Bolum11Content.engelOptionC,
                            isSelected: _model.engel?.label == Bolum11Content.engelOptionC.label,
                            onTap: () => _handleSelection('engel', Bolum11Content.engelOptionC),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 5. ADIM: Zayıf Nokta Bilgi Notu (Engel varsa çıkar)
                  if (_model.engel?.label == Bolum11Content.engelOptionB.label)
                    _buildInfoNote("Engel bulunduğu için zayıf geçiş noktası tespiti gereklidir."),

                  // SORU 3: ZAYIF NOKTA
                  if (_model.engel?.label == Bolum11Content.engelOptionB.label) ...[
                    QuestionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "3. Bu duvarda 'Kırmızı Çarpı (X)' ile işaretlenmiş VEYA itfaiyenin kolayca yıkıp geçebileceği zayıf duvar, tel, çit vb. (en az 8 metre genişliğinde) var mı?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          SelectableCard(
                            choice: Bolum11Content.zayifNoktaOptionA,
                            isSelected: _model.zayifNokta?.label == Bolum11Content.zayifNoktaOptionA.label,
                            onTap: () => _handleSelection('zayifNokta', Bolum11Content.zayifNoktaOptionA),
                          ),
                          SelectableCard(
                            choice: Bolum11Content.zayifNoktaOptionB,
                            isSelected: _model.zayifNokta?.label == Bolum11Content.zayifNoktaOptionB.label,
                            onTap: () => _handleSelection('zayifNokta', Bolum11Content.zayifNoktaOptionB),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
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
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bilgi Notu Tasarımı
  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE65100),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}