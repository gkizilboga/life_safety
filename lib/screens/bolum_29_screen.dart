import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_29_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_30_screen.dart';

class Bolum29Screen extends StatefulWidget {
  const Bolum29Screen({super.key});

  @override
  State<Bolum29Screen> createState() => _Bolum29ScreenState();
}

class _Bolum29ScreenState extends State<Bolum29Screen> {
  Bolum29Model _model = Bolum29Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum29 != null) {
      _model = BinaStore.instance.bolum29!;
    }
  }

  void _onNextPressed() {
    if (!_isFormValid()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ EKSİK SEÇİM"),
          content: const Text("Lütfen ekranda görünen tüm alanlar için bir seçim yapınız."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))],
        ),
      );
      return;
    }

    BinaStore.instance.bolum29 = _model;
    print("Bölüm 29 Kaydedildi.");
    
    // VERİ GİRİŞİ BİTTİ - RAPOR EKRANINA GİDİŞ
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum30Screen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tebrikler! Tüm veri girişi tamamlandı.")));
  }

  @override
  Widget build(BuildContext context) {
    final b7 = BinaStore.instance.bolum7;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Depolama ve Temizlik",
            subtitle: "Bölüm 29: İşletme Güvenliği",
            currentStep: 29,
            totalSteps: 30, // Tahmini
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DEPOLAMA VE TEMİZLİK DENETİMİ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Binanızda var olduğunu belirttiğiniz teknik alanların temizlik ve depolama durumunu inceleyelim.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 25),

                  // 1. KAPALI OTOPARK
                  if (b7?.hasKapaliOtopark == true)
                    _buildSection(
                      title: "1. KAPALI OTOPARK",
                      question: "Otoparkın köşelerinde, kolon aralarında veya araç park yerlerinde eski lastikler, koltuklar, koli veya yanıcı eşyalar yığılı mı?",
                      currentValue: _model.resTemizlikOtopark,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikOtopark: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 RİSK. Otoparklar sadece araç parkı içindir. Eşya yığınları yangını büyütür."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Otoparkın temizlik durumu bilinmiyor. Lütfen kontrol ediniz."),
                      ],
                    ),

                  // 2. KAZAN DAİRESİ
                  if (b7?.hasKazanDairesi == true)
                    _buildSection(
                      title: "2. KAZAN DAİRESİ / ISI MERKEZİ",
                      question: "Kazan dairesinin içinde veya yakıt tankının çevresinde eski eşya, odun, kömür çuvalı veya kağıt/karton saklanıyor mu?",
                      currentValue: _model.resTemizlikKazan,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikKazan: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Kazan daireleri depo değildir!"),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Kazan dairesinin içi bilinmiyor. Burası binanın kalbidir ve en yüksek yangın riskini taşır."),
                      ],
                    ),

                  // 3. ÇATI ARASI
                  if (b7?.hasCatiArasi == true)
                    _buildSection(
                      title: "3. ÇATI ARASI",
                      question: "Çatı arasında eski eşyalar, ahşap malzemeler veya arşiv kutuları saklanıyor mu?",
                      currentValue: _model.resTemizlikCati,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikCati: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 RİSK. Çatı araları elektrik kontağından en çok yangın çıkan yerlerdir."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Çatı arasının durumu bilinmiyor. Kontrol edilmesi hayati önem taşır."),
                      ],
                    ),

                  // 4. ASANSÖR MAKİNE DAİRESİ
                  if (b7?.hasAsansorDairesi == true)
                    _buildSection(
                      title: "4. ASANSÖR MAKİNE DAİRESİ",
                      question: "Çatıdaki asansör motorunun olduğu odada yağ tenekeleri, temizlik malzemeleri veya eski parçalar var mı?",
                      currentValue: _model.resTemizlikAsansor,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikAsansor: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 RİSK. Asansör motorları ısınır. Yanındaki yağlı bezler tutuşabilir."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Asansör makine dairesinin durumu bilinmiyor."),
                      ],
                    ),

                  // 5. JENERATÖR ODASI
                  if (b7?.hasJeneratorOdasi == true)
                    _buildSection(
                      title: "5. JENERATÖR ODASI",
                      question: "Jeneratör odasında yedek yakıt bidonları veya jeneratörle ilgisiz başka malzemeler depolanıyor mu?",
                      currentValue: _model.resTemizlikJenerator,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikJenerator: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Jeneratör odasında sadece günlük yakıt tankı bulunabilir."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Jeneratör odasının durumu bilinmiyor. Uzman kontrolü önerilir."),
                      ],
                    ),

                  // 6. ELEKTRİK PANO ODASI
                  if (b7?.hasElektrikOdasi == true)
                    _buildSection(
                      title: "6. ELEKTRİK PANO ODASI",
                      question: "Elektrik panolarının olduğu odada veya dolapta temizlik malzemesi veya kağıt saklanıyor mu?",
                      currentValue: _model.resTemizlikPano,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikPano: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 RİSK. Pano odaları kesinlikle boş olmalıdır."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Elektrik odasının içi bilinmiyor. Pano odaları yangınların en sık başladığı yerlerdir."),
                      ],
                    ),

                  // 7. TRAFO ODASI
                  if (b7?.hasTrafoOdasi == true)
                    _buildSection(
                      title: "7. YAĞLI TİP TRAFO ODASI",
                      question: "Trafo odasının havalandırma menfezleri açık mı ve içerisi temiz mi?",
                      currentValue: _model.resTemizlikTrafo,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikTrafo: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 KRİTİK RİSK. Trafo odaları ısınır ve patlama riski taşır."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Trafo odasının durumu bilinmiyor. Acilen kontrol edilmelidir."),
                      ],
                    ),

                  // 8. ORTAK DEPO
                  if (b7?.hasDepo == true)
                    _buildSection(
                      title: "8. ORTAK DEPO / ARDİYE",
                      question: "Bu depolarda yanıcı, parlayıcı maddeler (Tiner, Boya, Benzin, Tüp) saklanıyor mu?",
                      currentValue: _model.resTemizlikDepo,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikDepo: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "⚠️ UYARI. Apartman altındaki depolarda parlayıcı madde saklamak yasaktır."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Depolarda ne saklandığı bilinmiyor. Depo denetimi yapılmalıdır."),
                      ],
                    ),

                  // 9. ÇÖP ODASI
                  if (b7?.hasCopOdasi == true)
                    _buildSection(
                      title: "9. ÇÖP ODASI / ŞUT ODASI",
                      question: "Çöp odası düzenli temizleniyor mu, yoksa çöpler birikip koku/gaz yapıyor mu?",
                      currentValue: _model.resTemizlikCop,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikCop: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "🚨 RİSK. Biriken çöpler metan gazı oluşturur ve kendiliğinden yanabilir."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Çöp odasının hijyen durumu bilinmiyor."),
                      ],
                    ),

                  // 10. SIĞINAK
                  if (b7?.hasSiginak == true)
                    _buildSection(
                      title: "10. SIĞINAK",
                      question: "Sığınağınızda yanıcı/patlayıcı maddeler (boya, tiner, tüp, lastik) depolanıyor mu?",
                      currentValue: _model.resTemizlikSiginak,
                      onChanged: (val) => setState(() => _model = _model.copyWith(resTemizlikSiginak: val)),
                      options: [
                        ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                        ChoiceResult(label: "B", reportText: "⚠️ UYARI. Sığınaklar barış zamanında depo olarak kullanılabilir ANCAK yanıcı madde konulamaz."),
                        ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR. Sığınağın kullanım durumu bilinmiyor."),
                      ],
                    ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String question,
    required ChoiceResult? currentValue,
    required ValueChanged<ChoiceResult?> onChanged,
    required List<ChoiceResult> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        QuestionCard(
          child: Column(
            children: options.map((opt) => SelectableCard<ChoiceResult>(
              title: opt.label == "A" ? "Hayır / Temiz" : (opt.label == "B" ? "Evet / Kirli" : "Bilmiyorum"),
              subtitle: opt.reportText,
              value: opt,
              groupValue: currentValue,
              onChanged: onChanged,
            )).toList(),
          ),
        ),
        const Divider(height: 40),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid() ? _onNextPressed : null,
            child: const Text("ANALİZİ TAMAMLA"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    final b7 = BinaStore.instance.bolum7;
    if (b7?.hasKapaliOtopark == true && _model.resTemizlikOtopark == null) return false;
    if (b7?.hasKazanDairesi == true && _model.resTemizlikKazan == null) return false;
    if (b7?.hasCatiArasi == true && _model.resTemizlikCati == null) return false;
    if (b7?.hasAsansorDairesi == true && _model.resTemizlikAsansor == null) return false;
    if (b7?.hasJeneratorOdasi == true && _model.resTemizlikJenerator == null) return false;
    if (b7?.hasElektrikOdasi == true && _model.resTemizlikPano == null) return false;
    if (b7?.hasTrafoOdasi == true && _model.resTemizlikTrafo == null) return false;
    if (b7?.hasDepo == true && _model.resTemizlikDepo == null) return false;
    if (b7?.hasCopOdasi == true && _model.resTemizlikCop == null) return false;
    if (b7?.hasSiginak == true && _model.resTemizlikSiginak == null) return false;
    return true;
  }
}