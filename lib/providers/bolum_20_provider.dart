import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/bolum_20_model.dart';
import '../models/choice_result.dart';
import '../utils/input_validator.dart';

class Bolum20Provider extends ChangeNotifier {
  Bolum20Model _model = Bolum20Model();
  Bolum20Model get model => _model;

  bool _isTekKatli = false;
  bool _hasBodrum = false;
  bool _showBasinclandirma = false;
  bool _isBodrumIndependent = false;

  bool get isTekKatli => _isTekKatli;
  bool get hasBodrum => _hasBodrum;
  bool get showBasinclandirma => _showBasinclandirma;
  bool get isBodrumIndependent => _isBodrumIndependent;

  // Upper/Main Stair Controllers
  final normalCtrl = TextEditingController();
  final icKapaliCtrl = TextEditingController();
  final disKapaliCtrl = TextEditingController();
  final disAcikCtrl = TextEditingController();
  final donerCtrl = TextEditingController();
  final sahanliksizCtrl = TextEditingController();
  final dengelenmisCtrl = TextEditingController();

  // Basement Independent Stair Controllers
  final bodNormalCtrl = TextEditingController();
  final bodIcKapaliCtrl = TextEditingController();
  final bodDisKapaliCtrl = TextEditingController();
  final bodDisAcikCtrl = TextEditingController();
  final bodDonerCtrl = TextEditingController();
  final bodSahanliksizCtrl = TextEditingController();
  final bodDengelenmisCtrl = TextEditingController();

  // Direct Exit Controllers
  final toplamDirectCtrl = TextEditingController();
  ChoiceResult? _lobiMesafeDurumu;
  ChoiceResult? get lobiMesafeDurumu => _lobiMesafeDurumu;

  final bodToplamDirectCtrl = TextEditingController();
  ChoiceResult? _bodLobiMesafeDurumu;
  ChoiceResult? get bodLobiMesafeDurumu => _bodLobiMesafeDurumu;

  // Errors for Main
  String? normalErr;
  String? icKapaliErr;
  String? disKapaliErr;
  String? disAcikErr;
  String? donerErr;
  String? sahanliksizErr;
  String? dengelenmisErr;

  // Errors for Basement
  String? bodNormalErr;
  String? bodIcKapaliErr;
  String? bodDisKapaliErr;
  String? bodDisAcikErr;
  String? bodDonerErr;
  String? bodSahanliksizErr;
  String? bodDengelenmisErr;

  String? toplamDirectErr;
  String? bodToplamDirectErr;

  Bolum20Provider() {
    _init();
  }

  void _init() {
    _loadBuildingInfo();
    _loadSavedData();
  }

  void _loadBuildingInfo() {
    final bolum3 = BinaStore.instance.bolum3;
    int nKat = bolum3?.normalKatSayisi ?? 0;
    int bKat = bolum3?.bodrumKatSayisi ?? 0;
    int toplamKat = nKat + bKat + 1;

    _isTekKatli = (toplamKat == 1);
    _hasBodrum = (bKat > 0);
    // Don't notify listeners here, as it's called in constructor
  }

  void _loadSavedData() {
    final saved = BinaStore.instance.bolum20;
    if (saved != null) {
      _model = saved;

      // Map model fields to controllers
      // Main
      if (saved.normalMerdivenSayisi > 0)
        normalCtrl.text = saved.normalMerdivenSayisi.toString();
      if (saved.binaIciYanginMerdiveniSayisi > 0)
        icKapaliCtrl.text = saved.binaIciYanginMerdiveniSayisi.toString();
      if (saved.binaDisiKapaliYanginMerdiveniSayisi > 0)
        disKapaliCtrl.text = saved.binaDisiKapaliYanginMerdiveniSayisi
            .toString();
      if (saved.binaDisiAcikYanginMerdiveniSayisi > 0)
        disAcikCtrl.text = saved.binaDisiAcikYanginMerdiveniSayisi.toString();
      if (saved.donerMerdivenSayisi > 0)
        donerCtrl.text = saved.donerMerdivenSayisi.toString();
      if (saved.sahanliksizMerdivenSayisi > 0)
        sahanliksizCtrl.text = saved.sahanliksizMerdivenSayisi.toString();
      if (saved.dengelenmisMerdivenSayisi > 0)
        dengelenmisCtrl.text = saved.dengelenmisMerdivenSayisi.toString();

      if (saved.toplamDisariAcilanMerdivenSayisi > 0)
        toplamDirectCtrl.text = saved.toplamDisariAcilanMerdivenSayisi
            .toString();
      _lobiMesafeDurumu = saved.lobiTahliyeMesafeDurumu;

      // Basement
      _isBodrumIndependent = saved.isBodrumIndependent;
      if (_isBodrumIndependent) {
        if (saved.bodrumNormalMerdivenSayisi > 0)
          bodNormalCtrl.text = saved.bodrumNormalMerdivenSayisi.toString();
        if (saved.bodrumBinaIciYanginMerdiveniSayisi > 0)
          bodIcKapaliCtrl.text = saved.bodrumBinaIciYanginMerdiveniSayisi
              .toString();
        if (saved.bodrumBinaDisiKapaliYanginMerdiveniSayisi > 0)
          bodDisKapaliCtrl.text = saved
              .bodrumBinaDisiKapaliYanginMerdiveniSayisi
              .toString();
        if (saved.bodrumBinaDisiAcikYanginMerdiveniSayisi > 0)
          bodDisAcikCtrl.text = saved.bodrumBinaDisiAcikYanginMerdiveniSayisi
              .toString();
        if (saved.bodrumDonerMerdivenSayisi > 0)
          bodDonerCtrl.text = saved.bodrumDonerMerdivenSayisi.toString();
        if (saved.bodrumSahanliksizMerdivenSayisi > 0)
          bodSahanliksizCtrl.text = saved.bodrumSahanliksizMerdivenSayisi
              .toString();
        if (saved.bodrumDengelenmisMerdivenSayisi > 0)
          bodDengelenmisCtrl.text = saved.bodrumDengelenmisMerdivenSayisi
              .toString();

        if (saved.bodrumToplamDisariAcilanMerdivenSayisi > 0)
          bodToplamDirectCtrl.text = saved
              .bodrumToplamDisariAcilanMerdivenSayisi
              .toString();
        _bodLobiMesafeDurumu = saved.bodrumLobiTahliyeMesafeDurumu;
      }

      // Calculate derived state
      _calculateDynamicState();
    }
  }

  void updateController(String key, String value) {
    String? error = InputValidator.validateNumber(
      value,
      min: 0,
      max: 6,
      unit: "adet",
      isRequired: false,
    );

    int numericVal = int.tryParse(value) ?? 0;

    switch (key) {
      case 'normal':
        normalErr = error;
        _model = _model.copyWith(normalMerdivenSayisi: numericVal);
        break;
      case 'icKapali':
        icKapaliErr = error;
        _model = _model.copyWith(binaIciYanginMerdiveniSayisi: numericVal);
        break;
      case 'disKapali':
        disKapaliErr = error;
        _model = _model.copyWith(
          binaDisiKapaliYanginMerdiveniSayisi: numericVal,
        );
        break;
      case 'disAcik':
        disAcikErr = error;
        _model = _model.copyWith(binaDisiAcikYanginMerdiveniSayisi: numericVal);
        break;
      case 'doner':
        donerErr = error;
        _model = _model.copyWith(donerMerdivenSayisi: numericVal);
        break;
      case 'sahanliksiz':
        sahanliksizErr = error;
        _model = _model.copyWith(sahanliksizMerdivenSayisi: numericVal);
        break;
      case 'dengelenmis':
        dengelenmisErr = error;
        _model = _model.copyWith(dengelenmisMerdivenSayisi: numericVal);
        break;
      case 'bodNormal':
        bodNormalErr = error;
        _model = _model.copyWith(bodrumNormalMerdivenSayisi: numericVal);
        break;
      case 'bodIcKapali':
        bodIcKapaliErr = error;
        _model = _model.copyWith(
          bodrumBinaIciYanginMerdiveniSayisi: numericVal,
        );
        break;
      case 'bodDisKapali':
        bodDisKapaliErr = error;
        _model = _model.copyWith(
          bodrumBinaDisiKapaliYanginMerdiveniSayisi: numericVal,
        );
        break;
      case 'bodDisAcik':
        bodDisAcikErr = error;
        _model = _model.copyWith(
          bodrumBinaDisiAcikYanginMerdiveniSayisi: numericVal,
        );
        break;
      case 'bodDoner':
        bodDonerErr = error;
        _model = _model.copyWith(bodrumDonerMerdivenSayisi: numericVal);
        break;
      case 'bodSahanliksiz':
        bodSahanliksizErr = error;
        _model = _model.copyWith(bodrumSahanliksizMerdivenSayisi: numericVal);
        break;
      case 'bodDengelenmis':
        bodDengelenmisErr = error;
        _model = _model.copyWith(bodrumDengelenmisMerdivenSayisi: numericVal);
        break;
      case 'toplamDirect':
        toplamDirectErr = _validateDirectCount(numericVal, totalMainStairs);
        _model = _model.copyWith(toplamDisariAcilanMerdivenSayisi: numericVal);
        break;
      case 'bodToplamDirect':
        bodToplamDirectErr = _validateDirectCount(
          numericVal,
          totalBasementStairs,
        );
        _model = _model.copyWith(
          bodrumToplamDisariAcilanMerdivenSayisi: numericVal,
        );
        break;
    }
    _calculateDynamicState();
  }

  // --- Stored Getters for UI and Logic (DRY) ---

  int get totalMainStairs =>
      (int.tryParse(normalCtrl.text) ?? 0) +
      (int.tryParse(icKapaliCtrl.text) ?? 0) +
      (int.tryParse(disKapaliCtrl.text) ?? 0) +
      (int.tryParse(disAcikCtrl.text) ?? 0) +
      (int.tryParse(donerCtrl.text) ?? 0) +
      (int.tryParse(sahanliksizCtrl.text) ?? 0) +
      (int.tryParse(dengelenmisCtrl.text) ?? 0);

  int get korunumluMainStairs =>
      (int.tryParse(icKapaliCtrl.text) ?? 0) +
      (int.tryParse(disKapaliCtrl.text) ?? 0);

  int get korunumsuzMainStairs =>
      (int.tryParse(normalCtrl.text) ?? 0) +
      (int.tryParse(disAcikCtrl.text) ?? 0) +
      (int.tryParse(donerCtrl.text) ?? 0) +
      (int.tryParse(sahanliksizCtrl.text) ?? 0) +
      (int.tryParse(dengelenmisCtrl.text) ?? 0);

  int get totalBasementStairs =>
      (int.tryParse(bodNormalCtrl.text) ?? 0) +
      (int.tryParse(bodIcKapaliCtrl.text) ?? 0) +
      (int.tryParse(bodDisKapaliCtrl.text) ?? 0) +
      (int.tryParse(bodDisAcikCtrl.text) ?? 0) +
      (int.tryParse(bodDonerCtrl.text) ?? 0) +
      (int.tryParse(bodSahanliksizCtrl.text) ?? 0) +
      (int.tryParse(bodDengelenmisCtrl.text) ?? 0);

  void _calculateDynamicState() {
    int ic = int.tryParse(icKapaliCtrl.text) ?? 0;
    int dis = int.tryParse(disKapaliCtrl.text) ?? 0;
    int bIc = int.tryParse(bodIcKapaliCtrl.text) ?? 0;
    int bDis = int.tryParse(bodDisKapaliCtrl.text) ?? 0;

    bool newShowBasinclandirma = (ic >= 1 || dis >= 1 || bIc >= 1 || bDis >= 1);

    if (_showBasinclandirma != newShowBasinclandirma) {
      _showBasinclandirma = newShowBasinclandirma;
      if (!_showBasinclandirma) {
        _model = _model.copyWith(basinclandirma: null);
      }
      notifyListeners();
    } else {
      // Also re-validate direct exit counts when stair totals change
      toplamDirectErr = _validateDirectCount(
        int.tryParse(toplamDirectCtrl.text) ?? 0,
        totalMainStairs,
      );
      if (_isBodrumIndependent) {
        bodToplamDirectErr = _validateDirectCount(
          int.tryParse(bodToplamDirectCtrl.text) ?? 0,
          totalBasementStairs,
        );
      }
      notifyListeners(); // Also notify for error state changes
    }

    // Reset relevance-based fields if they are no longer shown
    if (!shouldShowLobbyDistanceQuestion && _lobiMesafeDurumu != null) {
      _lobiMesafeDurumu = null;
      _model = _model.copyWith(lobiTahliyeMesafeDurumu: null);
    }
    if (!shouldShowBasementLobbyDistanceQuestion &&
        _bodLobiMesafeDurumu != null) {
      _bodLobiMesafeDurumu = null;
      _model = _model.copyWith(bodrumLobiTahliyeMesafeDurumu: null);
    }
  }

  bool get shouldShowLobbyDistanceQuestion {
    int total = totalMainStairs;
    int direct = int.tryParse(toplamDirectCtrl.text) ?? 0;
    return total > 0 && direct < total;
  }

  bool get shouldShowBasementLobbyDistanceQuestion {
    if (!_isBodrumIndependent) return false;
    int total = totalBasementStairs;
    int direct = int.tryParse(bodToplamDirectCtrl.text) ?? 0;
    return total > 0 && direct < total;
  }

  String? _validateDirectCount(int direct, int total) {
    if (direct > total) {
      if (total == 0)
        return "Önce yukarıdaki merdivenlerden en az birini giriniz.";
      return "Dışarı açılan sayı ($direct), toplam merdiven sayısından ($total) fazla olamaz.";
    }
    return null;
  }

  bool get isLimitValid {
    if (_isTekKatli) {
      return _model.tekKatCikis != null && _model.tekKatRampa != null;
    }

    bool mainValid =
        normalErr == null &&
        icKapaliErr == null &&
        disKapaliErr == null &&
        disAcikErr == null &&
        donerErr == null &&
        sahanliksizErr == null &&
        dengelenmisErr == null &&
        toplamDirectErr == null &&
        totalMainStairs > 0;

    if (!_isBodrumIndependent) return mainValid;

    bool bodrumValid =
        bodNormalErr == null &&
        bodIcKapaliErr == null &&
        bodDisKapaliErr == null &&
        bodDisAcikErr == null &&
        bodDonerErr == null &&
        bodSahanliksizErr == null &&
        bodDengelenmisErr == null &&
        bodToplamDirectErr == null &&
        totalBasementStairs > 0;

    return mainValid && bodrumValid;
  }

  void setIsBodrumIndependent(bool val, ChoiceResult choice) {
    if (_isBodrumIndependent != val) {
      _isBodrumIndependent = val;
      _model = _model.copyWith(
        bodrumMerdivenDevami: choice,
        isBodrumIndependent: val,
      );

      if (!val) {
        bodNormalCtrl.clear();
        bodIcKapaliCtrl.clear();
        bodDisKapaliCtrl.clear();
        bodDisAcikCtrl.clear();
        bodDonerCtrl.clear();
        bodSahanliksizCtrl.clear();
        bodDengelenmisCtrl.clear();
        bodToplamDirectCtrl.clear();
      }
      _calculateDynamicState();
    }
  }

  void handleSelection(String type, ChoiceResult choice) {
    if (type == 'tekKatCikis') _model = _model.copyWith(tekKatCikis: choice);
    if (type == 'tekKatRampa') _model = _model.copyWith(tekKatRampa: choice);
    if (type == 'basinclandirma')
      _model = _model.copyWith(basinclandirma: choice);
    if (type == 'havalandirma') _model = _model.copyWith(havalandirma: choice);
    if (type == 'lobiMesafeDurumu') {
      _lobiMesafeDurumu = choice;
      _model = _model.copyWith(lobiTahliyeMesafeDurumu: choice);
    }
    if (type == 'bodLobiMesafeDurumu') {
      _bodLobiMesafeDurumu = choice;
      _model = _model.copyWith(bodrumLobiTahliyeMesafeDurumu: choice);
    }
    notifyListeners();
  }

  bool validateAndSave(BuildContext context) {
    if (_isTekKatli) {
      if (_model.tekKatCikis == null || _model.tekKatRampa == null)
        return false;
    } else {
      int totalStairs = totalMainStairs;
      int totalDirect = int.tryParse(toplamDirectCtrl.text) ?? 0;

      if (totalDirect > totalStairs) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Dışarı açılan merdiven sayısı toplam merdiven sayısından fazla olamaz.",
            ),
          ),
        );
        return false;
      }

      if (totalStairs == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lütfen en az bir merdiven tipi giriniz."),
          ),
        );
        return false;
      }

      // Basement Validation...
      int bNormal = 0,
          bIc = 0,
          bDisK = 0,
          bDisA = 0,
          bDoner = 0,
          bSahan = 0,
          bDengelenmis = 0;
      if (_isBodrumIndependent) {
        bNormal = int.tryParse(bodNormalCtrl.text) ?? 0;
        bIc = int.tryParse(bodIcKapaliCtrl.text) ?? 0;
        bDisK = int.tryParse(bodDisKapaliCtrl.text) ?? 0;
        bDisA = int.tryParse(bodDisAcikCtrl.text) ?? 0;
        bDoner = int.tryParse(bodDonerCtrl.text) ?? 0;
        bSahan = int.tryParse(bodSahanliksizCtrl.text) ?? 0;
        bDengelenmis = int.tryParse(bodDengelenmisCtrl.text) ?? 0;

        int totalBasement = totalBasementStairs;

        if (totalBasement == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Bodrum kat için en az bir merdiven tipi girmelisiniz.",
              ),
            ),
          );
          return false;
        }

        int bTotalDirect = int.tryParse(bodToplamDirectCtrl.text) ?? 0;
        if (bTotalDirect > totalBasement) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Bodrum kat: Dışarı açılan merdiven sayısı toplam sayıdan fazla olamaz.",
              ),
            ),
          );
          return false;
        }
      }

      if (_showBasinclandirma && _model.basinclandirma == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lütfen basınçlandırma durumunu seçiniz."),
          ),
        );
        return false;
      }

      if (shouldShowLobbyDistanceQuestion && _lobiMesafeDurumu == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Lütfen merdiven-dış kapı arası tahliye mesafesini belirtiniz.",
            ),
          ),
        );
        return false;
      }

      if (shouldShowBasementLobbyDistanceQuestion &&
          _bodLobiMesafeDurumu == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lütfen bodrum kat tahliye mesafesini belirtiniz."),
          ),
        );
        return false;
      }

      if (_model.havalandirma == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lütfen havalandırma durumunu seçiniz."),
          ),
        );
        return false;
      }

      _model = _model.copyWith(
        normalMerdivenSayisi: int.tryParse(normalCtrl.text) ?? 0,
        binaIciYanginMerdiveniSayisi: int.tryParse(icKapaliCtrl.text) ?? 0,
        binaDisiKapaliYanginMerdiveniSayisi:
            int.tryParse(disKapaliCtrl.text) ?? 0,
        binaDisiAcikYanginMerdiveniSayisi: int.tryParse(disAcikCtrl.text) ?? 0,
        donerMerdivenSayisi: int.tryParse(donerCtrl.text) ?? 0,
        sahanliksizMerdivenSayisi: int.tryParse(sahanliksizCtrl.text) ?? 0,
        dengelenmisMerdivenSayisi: int.tryParse(dengelenmisCtrl.text) ?? 0,
        toplamDisariAcilanMerdivenSayisi: totalDirect,
        lobiTahliyeMesafeDurumu: _lobiMesafeDurumu,
        isBodrumIndependent: _isBodrumIndependent,
        bodrumNormalMerdivenSayisi: bNormal,
        bodrumBinaIciYanginMerdiveniSayisi: bIc,
        bodrumBinaDisiKapaliYanginMerdiveniSayisi: bDisK,
        bodrumBinaDisiAcikYanginMerdiveniSayisi: bDisA,
        bodrumDonerMerdivenSayisi: bDoner,
        bodrumSahanliksizMerdivenSayisi: bSahan,
        bodrumDengelenmisMerdivenSayisi: bDengelenmis,
        bodrumToplamDisariAcilanMerdivenSayisi:
            int.tryParse(bodToplamDirectCtrl.text) ?? 0,
        bodrumLobiTahliyeMesafeDurumu: _bodLobiMesafeDurumu,
      );
    }

    if (_hasBodrum && _model.bodrumMerdivenDevami == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bodrum merdiveni devam durumu seçilmelidir."),
        ),
      );
      return false;
    }

    BinaStore.instance.bolum20 = _model;
    BinaStore.instance.saveToDisk();
    return true;
  }

  @override
  void dispose() {
    normalCtrl.dispose();
    icKapaliCtrl.dispose();
    disKapaliCtrl.dispose();
    disAcikCtrl.dispose();
    donerCtrl.dispose();
    sahanliksizCtrl.dispose();
    dengelenmisCtrl.dispose();

    bodNormalCtrl.dispose();
    bodIcKapaliCtrl.dispose();
    bodDisKapaliCtrl.dispose();
    bodDisAcikCtrl.dispose();
    bodDonerCtrl.dispose();
    bodSahanliksizCtrl.dispose();
    bodDengelenmisCtrl.dispose();

    toplamDirectCtrl.dispose();
    bodToplamDirectCtrl.dispose();
    super.dispose();
  }
}
