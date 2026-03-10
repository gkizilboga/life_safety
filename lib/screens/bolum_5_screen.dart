import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_4_model.dart';
import '../../models/bolum_5_model.dart';
import 'bolum_6_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';
import '../../utils/input_validator.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum5Screen extends StatefulWidget {
  const Bolum5Screen({super.key});

  @override
  State<Bolum5Screen> createState() => _Bolum5ScreenState();
}

class _Bolum5ScreenState extends State<Bolum5Screen> with SingleTickerProviderStateMixin {
  Bolum5Model _model = Bolum5Model();
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _tabanCtrl = TextEditingController();
  final TextEditingController _normalCtrl = TextEditingController();
  final TextEditingController _bodrumCtrl = TextEditingController();
  final TextEditingController _toplamCtrl = TextEditingController();

  int _nKat = 0;
  int _bKat = 0;
  bool _isCalculated = false;
  bool _isConfirmed = false;

  String? _tabanError;
  String? _normalError;
  String? _bodrumError;
  String? _toplamError;

  @override
  void initState() {
    super.initState();
    final Bolum3Model? b3 = BinaStore.instance.bolum3;
    _nKat = b3?.normalKatSayisi ?? 0;
    _bKat = b3?.bodrumKatSayisi ?? 0;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Load existing data
    final existing = BinaStore.instance.bolum5;
    if (existing != null) {
      _model = existing;
      if (existing.tabanAlani != null) {
        _tabanCtrl.text = existing.tabanAlani!
            .toStringAsFixed(2)
            .replaceAll('.', ',');
      }
      if (existing.normalKatAlani != null) {
        _normalCtrl.text = existing.normalKatAlani!
            .toStringAsFixed(2)
            .replaceAll('.', ',');
      }
      if (existing.bodrumKatAlani != null) {
        _bodrumCtrl.text = existing.bodrumKatAlani!
            .toStringAsFixed(2)
            .replaceAll('.', ',');
      }
      if (existing.toplamInsaatAlani != null) {
        _toplamCtrl.text = existing.toplamInsaatAlani!
            .toStringAsFixed(2)
            .replaceAll('.', ',');
        _isCalculated = true;
      }
      _isConfirmed = true; // If we have data, they confirmed before
    }

    _tabanCtrl.addListener(_validate);
    _normalCtrl.addListener(_validate);
    _bodrumCtrl.addListener(_validate);
    _toplamCtrl.addListener(_validate);
  }

  void _validate() {
    setState(() {
      // Kullanıcı giriş alanlarını değiştirdiğinde hesaplama geçersiz olur
      // Toplam alanı yeniden hesaplatması gerekir
      _isCalculated = false;
      _isConfirmed = false;

      // Zemin kat validasyonu (min: 5, max: 2500)
      double? taban = double.tryParse(_tabanCtrl.text.replaceAll(',', '.'));
      if (_tabanCtrl.text.isNotEmpty && taban != null) {
        if (taban < 5 || taban > 2500) {
          _tabanError = "Değer 5 ile 2500 m² arasında olmalıdır.";
        } else {
          _tabanError = null;
        }
      } else {
        _tabanError = null;
      }

      // Normal kat validasyonu (min: 5, max: 2500)
      double? normal = double.tryParse(_normalCtrl.text.replaceAll(',', '.'));
      if (_normalCtrl.text.isNotEmpty && normal != null) {
        if (normal < 5 || normal > 2500) {
          _normalError = "Değer 5 ile 2500 m² arasında olmalıdır.";
        } else {
          _normalError = null;
        }
      } else {
        _normalError = null;
      }

      // Normal kat sayısı 0 ise hata yok say
      if (_nKat == 0) _normalError = null;

      // Bodrum kat validasyonu (min: 5, max: 20000)
      double? bodrum = double.tryParse(_bodrumCtrl.text.replaceAll(',', '.'));
      if (_bodrumCtrl.text.isNotEmpty && bodrum != null) {
        if (bodrum < 5 || bodrum > 20000) {
          _bodrumError = "Değer 5 ile 20000 m² arasında olmalıdır.";
        } else {
          _bodrumError = null;
        }
      } else {
        _bodrumError = null;
      }

      // Toplam inşaat alanı validasyonu
      double? tot = double.tryParse(_toplamCtrl.text.replaceAll(',', '.'));
      if (_toplamCtrl.text.isNotEmpty && tot != null && tot > 250000) {
        _toplamError = "Toplam inşaat alanı 250.000 m²'den büyük olamaz.";
      } else {
        _toplamError = null;
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tabanCtrl.dispose();
    _normalCtrl.dispose();
    _bodrumCtrl.dispose();
    _toplamCtrl.dispose();
    super.dispose();
  }

  void _otomatikHesapla() {
    FocusScope.of(context).unfocus();

    // Önce validasyonları kontrol et
    if (_tabanError != null || _normalError != null || _bodrumError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen geçerli alan değerleri giriniz.")),
      );
      return;
    }

    double tAlani = InputValidator.parseFlex(_tabanCtrl.text) ?? 0.0;
    double nAlani = InputValidator.parseFlex(_normalCtrl.text) ?? 0.0;
    double bAlani = InputValidator.parseFlex(_bodrumCtrl.text) ?? 0.0;

    if (tAlani > 0 && (nAlani > 0 || _nKat == 0)) {
      double toplam = tAlani + (_nKat * nAlani) + (_bKat * bAlani);
      setState(() {
        _toplamCtrl.text = toplam.toStringAsFixed(2);
        _isCalculated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen katlara ait alan bilgilerini giriniz."),
        ),
      );
    }
  }

  void _onNextPressed() {
    _model = _model.copyWith(
      tabanAlani: InputValidator.parseFlex(_tabanCtrl.text),
      normalKatAlani: InputValidator.parseFlex(_normalCtrl.text),
      bodrumKatAlani: InputValidator.parseFlex(_bodrumCtrl.text),
      toplamInsaatAlani: InputValidator.parseFlex(_toplamCtrl.text),
    );
    BinaStore.instance.bolum5 = _model;
    BinaStore.instance.saveToDisk(immediate: true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum6Screen()),
    );
  }

  bool _isFormValid() {
    if (!_isConfirmed) return false;
    if (!_isCalculated) return false;
    if (_tabanCtrl.text.isEmpty) return false;
    if (_nKat > 0 && _normalCtrl.text.isEmpty) return false;
    if (_toplamCtrl.text.isEmpty) return false;
    return _tabanError == null &&
        _normalError == null &&
        _bodrumError == null &&
        _toplamError == null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = BinaStore.instance.bolum11 != null;

    return AnalysisPageLayout(
      title: "Kat Alan Bilgileri",
      screenType: widget.runtimeType,
      isNextEnabled: _isFormValid() || isLocked,
      onNext: () {
        if (!isLocked)
          _onNextPressed();
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Bolum6Screen()),
          );
        }
      },
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: isLocked,
            child: Opacity(
              opacity: isLocked ? 0.6 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      "Brüt Alan Girişi (m²)",
                      style: AppStyles.questionTitle,
                    ),
                  ),
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel(Bolum5Content.oturumAlani),
                        _buildNumberInput(
                          _tabanCtrl,
                          "Örn: 500",
                          error: _tabanError,
                        ),

                        if (_nKat > 0) ...[
                          const SizedBox(height: 16),
                          _buildInputLabel(Bolum5Content.normalKatAlani),
                          _buildNumberInput(
                            _normalCtrl,
                            "Örn: 500",
                            error: _normalError,
                          ),
                        ],

                        if (_bKat > 0) ...[
                          const SizedBox(height: 16),
                          _buildInputLabel(Bolum5Content.bodrumKatAlani),
                          _buildNumberInput(
                            _bodrumCtrl,
                            "Örn: 500",
                            error: _bodrumError,
                          ),
                        ],

                        const SizedBox(height: 12),
                        ScaleTransition(
                          scale: (!_isCalculated &&
                                  _tabanCtrl.text.isNotEmpty &&
                                  (_nKat == 0 || _normalCtrl.text.isNotEmpty))
                              ? _scaleAnimation
                              : const AlwaysStoppedAnimation(1.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _otomatikHesapla,
                              icon: const Icon(
                                Icons.calculate_outlined,
                                size: 20,
                              ),
                              label: const Text(
                                "TOPLAM BRÜT ALANI HESAPLA",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.warningOrange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFFECEFF1),
                          ),
                        ),

                        _buildInputLabel(Bolum5Content.toplamInsaat),
                        _buildNumberInput(
                          _toplamCtrl,
                          "Toplam m²",
                          isBold: true,
                          readOnly: true,
                          error: _toplamError,
                        ),

                        if (_isCalculated) _buildSummaryCard(),

                        const SizedBox(height: 12),
                        ConfirmationCheckbox(
                          value: _isConfirmed,
                          onChanged: (val) =>
                              setState(() => _isConfirmed = val ?? false),
                          text:
                              "Yukarıdaki bilgilerin doğruluğunu teyit ediyorum.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLocked)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomInfoNote(
              type: InfoNoteType.warning,
              text:
                  "Temel veriler kilitlenmiştir. İleriki bölümlerdeki hesaplamaların bozulmaması için bu aşamadan sonra alan bilgisi değiştirilemez. Değiştirmek isterseniz yeni bir analiz başlatmalısınız.",
              icon: Icons.lock_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(ChoiceResult content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.uiTitle,
          style: AppStyles.questionTitle,
        ),
        if (content.uiSubtitle.isNotEmpty)
          Text(
            content.uiSubtitle,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildNumberInput(
    TextEditingController controller,
    String hint, {
    bool isBold = false,
    bool readOnly = false,
    String? error,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [InputValidator.flexDecimal],
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint,
        errorText: error,
        suffixText: "m²",
        filled: true,
        fillColor: isBold ? const Color(0xFFECEFF1) : Colors.white,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HESAPLAMA DETAYI",
            style: AppStyles.questionTitle,
          ),
          const SizedBox(height: 12),
          // Toplam Kat Adedi (Bölüm 3'ten gelen veri)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Toplam Kat Adedi:",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32), // Dark green
                ),
              ),
              Text(
                "${_nKat + _bKat + 1} Kat",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, thickness: 0.5),
          ),
          _buildSummaryRow("Zemin Kat:", "${_tabanCtrl.text} m²"),
          if (_nKat > 0)
            _buildSummaryRow(
              "Normal Katlar ($_nKat adet):",
              "${((InputValidator.parseFlex(_normalCtrl.text) ?? 0) * _nKat).toStringAsFixed(2)} m²",
            ),
          if (_bKat > 0)
            _buildSummaryRow(
              "Bodrum Katlar ($_bKat adet):",
              "${((InputValidator.parseFlex(_bodrumCtrl.text) ?? 0) * _bKat).toStringAsFixed(2)} m²",
            ),
          const Divider(),
          _buildSummaryRow(
            "Toplam İnşaat Alanı:",
            "${_toplamCtrl.text} m²",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
