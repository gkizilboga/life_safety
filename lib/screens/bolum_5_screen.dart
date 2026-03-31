import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _Bolum5ScreenState extends State<Bolum5Screen>
    with SingleTickerProviderStateMixin {
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

    if (tAlani > 0 &&
        (_nKat == 0 || nAlani > 0) &&
        (_bKat == 0 || bAlani > 0)) {
      double toplam = tAlani + (_nKat * nAlani) + (_bKat * bAlani);
      setState(() {
        _toplamCtrl.text = toplam.toStringAsFixed(2).replaceAll('.', ',');
        _isCalculated = true;
      });
    } else {
      String msg =
          "Lütfen tüm kat alan bilgilerini girdikten sonra tıklayınız.";
      if (tAlani <= 0)
        msg = "Lütfen zemin kat alanını giriniz.";
      else if (_nKat > 0 && nAlani <= 0)
        msg = "Lütfen normal kat alanını giriniz.";
      else if (_bKat > 0 && bAlani <= 0)
        msg = "Lütfen bodrum kat alanını giriniz.";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.warningOrange),
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
    BinaStore.instance.saveToDisk();
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
    if (_bKat > 0 && _bodrumCtrl.text.isEmpty) return false;
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
      customWarningText:
          "Lütfen kat alanlarını giriniz ve 'Toplam Alanı Hesaplayınız' butonuna basarak onaylayınız.",
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
                        _buildNumberInput(
                          _tabanCtrl,
                          Bolum5Content.oturumAlani,
                          onCalculatorTap: () =>
                              _showCalculatorPopup(_tabanCtrl, "Zemin Kat"),
                          error: _tabanError,
                        ),

                        if (_nKat > 0) ...[
                          _buildNumberInput(
                            _normalCtrl,
                            Bolum5Content.normalKatAlani,
                            onCalculatorTap: () => _showCalculatorPopup(
                              _normalCtrl,
                              "Normal Katlar",
                            ),
                            error: _normalError,
                          ),
                        ],

                        if (_bKat > 0) ...[
                          _buildNumberInput(
                            _bodrumCtrl,
                            Bolum5Content.bodrumKatAlani,
                            onCalculatorTap: () => _showCalculatorPopup(
                              _bodrumCtrl,
                              "Bodrum Katlar",
                            ),
                            error: _bodrumError,
                          ),
                        ],

                        const SizedBox(height: 12),
                        ScaleTransition(
                          scale:
                              (!_isCalculated &&
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
                                "Toplam Alanı Hesaplayınız. ",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
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

                        _buildNumberInput(
                          _toplamCtrl,
                          Bolum5Content.toplamInsaat,
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



  void _showCalculatorPopup(
    TextEditingController targetController,
    String title,
  ) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    final daireSayisiCtrl = TextEditingController();
    final daireAlaniCtrl = TextEditingController();

    showCustomDialog<bool>(
      context: context,
      title: "Alan hesaplayıcı",
      contentWidget: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: daireSayisiCtrl,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Kattaki daire adedi",
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(
                  Icons.numbers,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: daireAlaniCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [InputValidator.flexDecimal],
              decoration: InputDecoration(
                labelText: "Bir dairenin alanı (m²)",
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(
                  Icons.square_foot,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
      confirmText: "HESAPLA",
      cancelText: "İPTAL",
      icon: Icons.calculate_outlined,
      iconColor: AppColors.primaryBlue,
    ).then((result) {
      if (!mounted) return;
      if (result == true) {
        double sayi = double.tryParse(daireSayisiCtrl.text) ?? 0;
        double alan = InputValidator.parseFlex(daireAlaniCtrl.text) ?? 0;

        if (sayi > 0 && alan > 0) {
          double toplam = sayi * alan;
          setState(() {
            // Tam sayi ise .00 gosterme, değilse ondalık goster
            if (toplam == toplam.truncateToDouble()) {
              targetController.text = toplam.toInt().toString();
            } else {
              targetController.text = toplam
                  .toStringAsFixed(2)
                  .replaceAll('.', ',');
            }
          });
          _validate();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Lütfen geçerli sayılar giriniz."),
              backgroundColor: AppColors.warningOrange,
            ),
          );
        }
      }
    });
  }

  Widget _buildNumberInput(
    TextEditingController controller,
    ChoiceResult choice, {
    VoidCallback? onCalculatorTap,
    bool isBold = false,
    bool readOnly = false,
    String? error,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [InputValidator.flexDecimal],
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.bold,
          fontSize: 18,
          color: AppColors.primaryBlue,
        ),
        decoration: InputDecoration(
          labelText: choice.uiTitle,
          labelStyle: const TextStyle(fontSize: 14, color: AppColors.textLabel),
          helperText: choice.uiSubtitle.isNotEmpty ? choice.uiSubtitle : null,
          helperStyle: const TextStyle(fontSize: 11, color: Colors.blueGrey),
          hintText: "0",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          errorText: error,
          suffixText: "m²",
          suffixStyle: const TextStyle(fontWeight: FontWeight.bold),
          suffixIcon: onCalculatorTap != null
              ? IconButton(
                  icon: const Icon(Icons.calculate_outlined, color: AppColors.primaryBlue),
                  onPressed: onCalculatorTap,
                  tooltip: 'Hesapla',
                )
              : null,
          filled: true,
          fillColor: isBold ? const Color(0xFFECEFF1) : Colors.white,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        ),
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
          Text("HESAPLAMA DETAYI", style: AppStyles.questionTitle),
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
