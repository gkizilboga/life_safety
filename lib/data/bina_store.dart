// ignore_for_file: unnecessary_getters_setters
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bolum_1_model.dart';
import '../models/bolum_2_model.dart';
import '../models/bolum_3_model.dart';
import '../models/bolum_4_model.dart';
import '../models/bolum_5_model.dart';
import '../models/bolum_6_model.dart';
import '../models/bolum_7_model.dart';
import '../models/bolum_8_model.dart';
import '../models/bolum_9_model.dart';
import '../models/bolum_10_model.dart';
import '../models/bolum_11_model.dart';
import '../models/bolum_12_model.dart';
import '../models/bolum_13_model.dart';
import '../models/bolum_14_model.dart';
import '../models/bolum_15_model.dart';
import '../models/bolum_16_model.dart';
import '../models/bolum_17_model.dart';
import '../models/bolum_18_model.dart';
import '../models/bolum_19_model.dart';
import '../models/bolum_20_model.dart';
import '../models/bolum_21_model.dart';
import '../models/bolum_22_model.dart';
import '../models/bolum_23_model.dart';
import '../models/bolum_24_model.dart';
import '../models/bolum_25_model.dart';
import '../models/bolum_26_model.dart';
import '../models/bolum_27_model.dart';
import '../models/bolum_28_model.dart';
import '../models/bolum_29_model.dart';
import '../models/bolum_30_model.dart';
import '../models/bolum_31_model.dart';
import '../models/bolum_32_model.dart';
import '../models/bolum_33_model.dart';
import '../models/bolum_34_model.dart';
import '../models/bolum_35_model.dart';
import '../models/bolum_36_model.dart';
import '../models/choice_result.dart';
import '../utils/app_content.dart';

class BinaStore {
  static final BinaStore _instance = BinaStore._internal();
  factory BinaStore() => _instance;
  BinaStore._internal();
  static BinaStore get instance => _instance;

  SharedPreferences? _prefs;

  String? currentBinaId;
  String? currentBinaName;
  String? currentBinaCity;
  String? currentBinaDistrict;
  List<Map<String, dynamic>> archive = [];

  // Kullanıcı Tercihleri
  String get userName => _prefs?.getString('userName') ?? "Analiz Uzmanı";
  set userName(String value) => _prefs?.setString('userName', value);

  String get userProfession =>
      _prefs?.getString('userProfession') ?? "Vatandaş / Diğer";
  set userProfession(String value) =>
      _prefs?.setString('userProfession', value);

  bool get isPremium => true; // FORCE PREMIUM FOR TESTING
  set isPremium(bool value) => _prefs?.setBool('isPremium', value);

  bool get isRegistered => _prefs?.getBool('isRegistered') ?? false;
  set isRegistered(bool value) => _prefs?.setBool('isRegistered', value);

  bool get hapticEnabled => _prefs?.getBool('hapticEnabled') ?? true;
  set hapticEnabled(bool value) => _prefs?.setBool('hapticEnabled', value);

  bool get hasSeenOnboarding => _prefs?.getBool('hasSeenOnboarding') ?? false;
  set hasSeenOnboarding(bool value) =>
      _prefs?.setBool('hasSeenOnboarding', value);

  int get reportCredits => _prefs?.getInt('reportCredits') ?? 0;
  set reportCredits(int value) => _prefs?.setInt('reportCredits', value);

  bool get isProUser => _prefs?.getBool('isProUser') ?? false;
  set isProUser(bool value) => _prefs?.setBool('isProUser', value);

  int _lastActiveSection = 1;
  int get lastActiveSection => _lastActiveSection;
  set lastActiveSection(int value) {
    _lastActiveSection = value;
    _prefs?.setInt(
      'lastActiveSection',
      value,
    ); // Keep global latest as fallback
  }

  void useCredit() {
    if (reportCredits > 0) reportCredits = reportCredits - 1;
  }

  // Private Hafıza Alanları
  Bolum1Model? _bolum1;
  Bolum2Model? _bolum2;
  Bolum3Model? _bolum3;
  Bolum4Model? _bolum4;
  Bolum5Model? _bolum5;
  Bolum6Model? _bolum6;
  Bolum7Model? _bolum7;
  Bolum8Model? _bolum8;
  Bolum9Model? _bolum9;
  Bolum10Model? _bolum10;
  Bolum11Model? _bolum11;
  Bolum12Model? _bolum12;
  Bolum13Model? _bolum13;
  Bolum14Model? _bolum14;
  Bolum15Model? _bolum15;
  Bolum16Model? _bolum16;
  Bolum17Model? _bolum17;
  Bolum18Model? _bolum18;
  Bolum19Model? _bolum19;
  Bolum20Model? _bolum20;
  Bolum21Model? _bolum21;
  Bolum22Model? _bolum22;
  Bolum23Model? _bolum23;
  Bolum24Model? _bolum24;
  Bolum25Model? _bolum25;
  Bolum26Model? _bolum26;
  Bolum27Model? _bolum27;
  Bolum28Model? _bolum28;
  Bolum29Model? _bolum29;
  Bolum30Model? _bolum30;
  Bolum31Model? _bolum31;
  Bolum32Model? _bolum32;
  Bolum33Model? _bolum33;
  Bolum34Model? _bolum34;
  Bolum35Model? _bolum35;
  Bolum36Model? _bolum36;

  // Public Erişimciler
  Bolum1Model? get bolum1 => _bolum1;
  set bolum1(Bolum1Model? v) => _bolum1 = v;
  Bolum2Model? get bolum2 => _bolum2;
  set bolum2(Bolum2Model? v) => _bolum2 = v;
  Bolum3Model? get bolum3 => _bolum3;
  set bolum3(Bolum3Model? v) => _bolum3 = v;
  Bolum4Model? get bolum4 => _bolum4;
  set bolum4(Bolum4Model? v) => _bolum4 = v;
  Bolum5Model? get bolum5 => _bolum5;
  set bolum5(Bolum5Model? v) => _bolum5 = v;
  Bolum6Model? get bolum6 => _bolum6;
  set bolum6(Bolum6Model? v) => _bolum6 = v;
  Bolum7Model? get bolum7 => _bolum7;
  set bolum7(Bolum7Model? v) => _bolum7 = v;
  Bolum8Model? get bolum8 => _bolum8;
  set bolum8(Bolum8Model? v) => _bolum8 = v;
  Bolum9Model? get bolum9 => _bolum9;
  set bolum9(Bolum9Model? v) => _bolum9 = v;
  Bolum10Model? get bolum10 => _bolum10;
  set bolum10(Bolum10Model? v) => _bolum10 = v;
  Bolum11Model? get bolum11 => _bolum11;
  set bolum11(Bolum11Model? v) => _bolum11 = v;
  Bolum12Model? get bolum12 => _bolum12;
  set bolum12(Bolum12Model? v) => _bolum12 = v;
  Bolum13Model? get bolum13 => _bolum13;
  set bolum13(Bolum13Model? v) => _bolum13 = v;
  Bolum14Model? get bolum14 => _bolum14;
  set bolum14(Bolum14Model? v) => _bolum14 = v;
  Bolum15Model? get bolum15 => _bolum15;
  set bolum15(Bolum15Model? v) => _bolum15 = v;
  Bolum16Model? get bolum16 => _bolum16;
  set bolum16(Bolum16Model? v) => _bolum16 = v;
  Bolum17Model? get bolum17 => _bolum17;
  set bolum17(Bolum17Model? v) => _bolum17 = v;
  Bolum18Model? get bolum18 => _bolum18;
  set bolum18(Bolum18Model? v) => _bolum18 = v;
  Bolum19Model? get bolum19 => _bolum19;
  set bolum19(Bolum19Model? v) => _bolum19 = v;
  Bolum20Model? get bolum20 => _bolum20;
  set bolum20(Bolum20Model? v) => _bolum20 = v;
  Bolum21Model? get bolum21 => _bolum21;
  set bolum21(Bolum21Model? v) => _bolum21 = v;
  Bolum22Model? get bolum22 => _bolum22;
  set bolum22(Bolum22Model? v) => _bolum22 = v;
  Bolum23Model? get bolum23 => _bolum23;
  set bolum23(Bolum23Model? v) => _bolum23 = v;
  Bolum24Model? get bolum24 => _bolum24;
  set bolum24(Bolum24Model? v) => _bolum24 = v;
  Bolum25Model? get bolum25 => _bolum25;
  set bolum25(Bolum25Model? v) => _bolum25 = v;
  Bolum26Model? get bolum26 => _bolum26;
  set bolum26(Bolum26Model? v) => _bolum26 = v;
  Bolum27Model? get bolum27 => _bolum27;
  set bolum27(Bolum27Model? v) => _bolum27 = v;
  Bolum28Model? get bolum28 => _bolum28;
  set bolum28(Bolum28Model? v) => _bolum28 = v;
  Bolum29Model? get bolum29 => _bolum29;
  set bolum29(Bolum29Model? v) => _bolum29 = v;
  Bolum30Model? get bolum30 => _bolum30;
  set bolum30(Bolum30Model? v) => _bolum30 = v;
  Bolum31Model? get bolum31 => _bolum31;
  set bolum31(Bolum31Model? v) => _bolum31 = v;
  Bolum32Model? get bolum32 => _bolum32;
  set bolum32(Bolum32Model? v) => _bolum32 = v;
  Bolum33Model? get bolum33 => _bolum33;
  set bolum33(Bolum33Model? v) => _bolum33 = v;
  Bolum34Model? get bolum34 => _bolum34;
  set bolum34(Bolum34Model? v) => _bolum34 = v;
  Bolum35Model? get bolum35 => _bolum35;
  set bolum35(Bolum35Model? v) => _bolum35 = v;
  Bolum36Model? get bolum36 => _bolum36;
  set bolum36(Bolum36Model? v) => _bolum36 = v;

  /// Checks if all 36 sections (or at least the critical ones) are completed.
  bool isTestCompleted() {
    // The final section (36) is the definitive marker of completion
    if (_bolum36 == null) return false;

    // Verify critical sections are also present
    if (_bolum3 == null) return false;
    if (_bolum5 == null) return false;
    if (_bolum33 == null) return false;

    return true;
  }

  Future<void> loadFromDisk() async {
    _prefs = await SharedPreferences.getInstance();
    final archiveRaw = _prefs?.getString('bina_archive');
    final activeId = _prefs?.getString('active_bina_id');
    if (archiveRaw != null) {
      try {
        archive = List<Map<String, dynamic>>.from(json.decode(archiveRaw));
        if (activeId != null && activeId.isNotEmpty) {
          final activeData = archive.firstWhere(
            (e) => e['id'] == activeId,
            orElse: () => {},
          );
          if (activeData.isNotEmpty) _loadBuildingFromMap(activeData);
        }
      } catch (e) {
        // Recover from corrupted disk data
        archive = [];
        reset();
        _prefs?.remove('bina_archive');
        _prefs?.remove('active_bina_id');
      }
    }
  }

  void saveToDisk() {
    currentBinaId ??= DateTime.now().millisecondsSinceEpoch.toString();
    final currentData = {
      'id': currentBinaId,
      'name': currentBinaName ?? "İsimsiz Bina",
      'city': currentBinaCity ?? "",
      'district': currentBinaDistrict ?? "",
      'date': DateTime.now().toIso8601String(),
      'lastActiveSection': _lastActiveSection,
      'isPremium': isPremium,
      // User said "Update BinaStore to track purchase status".
      // Usually purchase is per user/lifetime or per building.
      // Given the flow, let's assuming per building might refer to "is this analysis premium unlocked?".
      // BUT, checking line 66: "bool get isPremium => _prefs?.getBool('isPremium') ?? false;"
      // It seems it is ALREADY using SharedPreferences GLOBALLY for the user.
      // So 'saveToDisk' (which saves the building archive) doesn't strictly need it if it's a global user setting.
      // Wait, if it's a global setting "isPremium", line 67 already saves it to prefs: `set isPremium(bool value) => _prefs?.setBool('isPremium', value);`
      // So separate persistence in `saveToDisk` (which saves the building JSON) is redundant/confusing if it's a global "Pro User" thing.
      // HOWEVER, if the "Premium Module" is a per-analysis unlock (like "Unlock ONE Report"), then it should be in the building data.
      // The current implementation at line 66 suggests GLOBAL premium.
      // `_prefs?.setBool('isPremium', value)` saves it immediately to disk.
      // So Persistence for GLOBAL status is ALREADY THERE via the setter.

      // Let's re-read the plan: "Update `toJson`: Add `isPremium` field."
      // If I want to tie it to the specific building analysis, I should add it here.
      // Let's add it to the building data too, just in case we switch to per-building unlock later,
      // OR to remember that THIS building was analyzed with premium features.
      // But for now, the getter/setter at 66/67 handles GLOBAL persistence.
      // I will trust the getter/setter for now as it uses SharedPreferences directly.

      // Let's implement the `isTestCompleted()` method requested in the plan instead in this step.
      'sections': {
        'bolum1': _bolum1?.toMap(),
        'bolum2': _bolum2?.toMap(),
        'bolum3': _bolum3?.toMap(),
        'bolum4': _bolum4?.toMap(),
        'bolum5': _bolum5?.toMap(),
        'bolum6': _bolum6?.toMap(),
        'bolum7': _bolum7?.toMap(),
        'bolum8': _bolum8?.toMap(),
        'bolum9': _bolum9?.toMap(),
        'bolum10': _bolum10?.toMap(),
        'bolum11': _bolum11?.toMap(),
        'bolum12': _bolum12?.toMap(),
        'bolum13': _bolum13?.toMap(),
        'bolum14': _bolum14?.toMap(),
        'bolum15': _bolum15?.toMap(),
        'bolum16': _bolum16?.toMap(),
        'bolum17': _bolum17?.toMap(),
        'bolum18': _bolum18?.toMap(),
        'bolum19': _bolum19?.toMap(),
        'bolum20': _bolum20?.toMap(),
        'bolum21': _bolum21?.toMap(),
        'bolum22': _bolum22?.toMap(),
        'bolum23': _bolum23?.toMap(),
        'bolum24': _bolum24?.toMap(),
        'bolum25': _bolum25?.toMap(),
        'bolum26': _bolum26?.toMap(),
        'bolum27': _bolum27?.toMap(),
        'bolum28': _bolum28?.toMap(),
        'bolum29': _bolum29?.toMap(),
        'bolum30': _bolum30?.toMap(),
        'bolum31': _bolum31?.toMap(),
        'bolum32': _bolum32?.toMap(),
        'bolum33': _bolum33?.toMap(),
        'bolum34': _bolum34?.toMap(),
        'bolum35': _bolum35?.toMap(),
        'bolum36': _bolum36?.toMap(),
      },
    };
    int index = archive.indexWhere((element) => element['id'] == currentBinaId);
    if (index != -1)
      archive[index] = currentData;
    else
      archive.add(currentData);
    _prefs?.setString('bina_archive', json.encode(archive));
    if (currentBinaId != null)
      _prefs?.setString('active_bina_id', currentBinaId!);
  }

  void _loadBuildingFromMap(Map<String, dynamic> data) {
    currentBinaId = data['id'];
    currentBinaName = data['name'];
    currentBinaCity = data['city'];
    currentBinaDistrict = data['district'];
    _lastActiveSection = data['lastActiveSection'] ?? 1;
    final s = data['sections'];
    if (s['bolum1'] != null) _bolum1 = Bolum1Model.fromMap(s['bolum1']);
    if (s['bolum2'] != null) _bolum2 = Bolum2Model.fromMap(s['bolum2']);
    if (s['bolum3'] != null) _bolum3 = Bolum3Model.fromMap(s['bolum3']);
    if (s['bolum4'] != null) _bolum4 = Bolum4Model.fromMap(s['bolum4']);
    if (s['bolum5'] != null) _bolum5 = Bolum5Model.fromMap(s['bolum5']);
    if (s['bolum6'] != null) _bolum6 = Bolum6Model.fromMap(s['bolum6']);
    if (s['bolum7'] != null) _bolum7 = Bolum7Model.fromMap(s['bolum7']);
    if (s['bolum8'] != null) _bolum8 = Bolum8Model.fromMap(s['bolum8']);
    if (s['bolum9'] != null) _bolum9 = Bolum9Model.fromMap(s['bolum9']);
    if (s['bolum10'] != null) _bolum10 = Bolum10Model.fromMap(s['bolum10']);
    if (s['bolum11'] != null) _bolum11 = Bolum11Model.fromMap(s['bolum11']);
    if (s['bolum12'] != null) _bolum12 = Bolum12Model.fromMap(s['bolum12']);
    if (s['bolum13'] != null) _bolum13 = Bolum13Model.fromMap(s['bolum13']);
    if (s['bolum14'] != null) _bolum14 = Bolum14Model.fromMap(s['bolum14']);
    if (s['bolum15'] != null) _bolum15 = Bolum15Model.fromMap(s['bolum15']);
    if (s['bolum16'] != null) _bolum16 = Bolum16Model.fromMap(s['bolum16']);
    if (s['bolum17'] != null) _bolum17 = Bolum17Model.fromMap(s['bolum17']);
    if (s['bolum18'] != null) _bolum18 = Bolum18Model.fromMap(s['bolum18']);
    if (s['bolum19'] != null) _bolum19 = Bolum19Model.fromMap(s['bolum19']);
    if (s['bolum20'] != null) _bolum20 = Bolum20Model.fromMap(s['bolum20']);
    if (s['bolum21'] != null) _bolum21 = Bolum21Model.fromMap(s['bolum21']);
    if (s['bolum22'] != null) _bolum22 = Bolum22Model.fromMap(s['bolum22']);
    if (s['bolum23'] != null) _bolum23 = Bolum23Model.fromMap(s['bolum23']);
    if (s['bolum24'] != null) _bolum24 = Bolum24Model.fromMap(s['bolum24']);
    if (s['bolum25'] != null) _bolum25 = Bolum25Model.fromMap(s['bolum25']);
    if (s['bolum26'] != null) _bolum26 = Bolum26Model.fromMap(s['bolum26']);
    if (s['bolum27'] != null) _bolum27 = Bolum27Model.fromMap(s['bolum27']);
    if (s['bolum28'] != null) _bolum28 = Bolum28Model.fromMap(s['bolum28']);
    if (s['bolum29'] != null) _bolum29 = Bolum29Model.fromMap(s['bolum29']);
    if (s['bolum30'] != null) _bolum30 = Bolum30Model.fromMap(s['bolum30']);
    if (s['bolum31'] != null) _bolum31 = Bolum31Model.fromMap(s['bolum31']);
    if (s['bolum32'] != null) _bolum32 = Bolum32Model.fromMap(s['bolum32']);
    if (s['bolum33'] != null) _bolum33 = Bolum33Model.fromMap(s['bolum33']);
    if (s['bolum34'] != null) _bolum34 = Bolum34Model.fromMap(s['bolum34']);
    if (s['bolum35'] != null) _bolum35 = Bolum35Model.fromMap(s['bolum35']);
    if (s['bolum36'] != null) _bolum36 = Bolum36Model.fromMap(s['bolum36']);
  }

  void createNewBuilding({
    required String name,
    required String city,
    required String district,
  }) {
    reset();
    currentBinaId = DateTime.now().millisecondsSinceEpoch.toString();
    currentBinaName = name;
    currentBinaCity = city;
    currentBinaDistrict = district;
    saveToDisk();
  }

  void clearCurrentAnalysis() {
    reset();
    _prefs?.remove('active_bina_id');
  }

  void reset() {
    currentBinaId = null;
    currentBinaName = null;
    currentBinaCity = null;
    currentBinaDistrict = null;
    _lastActiveSection = 1;
    _bolum1 = null;
    _bolum2 = null;
    _bolum3 = null;
    _bolum4 = null;
    _bolum5 = null;
    _bolum6 = null;
    _bolum7 = null;
    _bolum8 = null;
    _bolum9 = null;
    _bolum10 = null;
    _bolum11 = null;
    _bolum12 = null;
    _bolum13 = null;
    _bolum14 = null;
    _bolum15 = null;
    _bolum16 = null;
    _bolum17 = null;
    _bolum18 = null;
    _bolum19 = null;
    _bolum20 = null;
    _bolum21 = null;
    _bolum22 = null;
    _bolum23 = null;
    _bolum24 = null;
    _bolum25 = null;
    _bolum26 = null;
    _bolum27 = null;
    _bolum28 = null;
    _bolum29 = null;
    _bolum30 = null;
    _bolum31 = null;
    _bolum32 = null;
    _bolum33 = null;
    _bolum34 = null;
    _bolum35 = null;
    _bolum36 = null;
  }

  void loadBuildingFromArchive(String id) {
    final data = archive.firstWhere((e) => e['id'] == id, orElse: () => {});
    if (data.isNotEmpty) {
      reset();
      _loadBuildingFromMap(data);
      saveToDisk();
    }
  }

  void deleteFromArchive(String id) {
    archive.removeWhere((element) => element['id'] == id);
    if (currentBinaId == id) reset();
    _prefs?.setString('bina_archive', json.encode(archive));
    _prefs?.remove('active_bina_id');
  }

  ChoiceResult? getResultForSection(int id) {
    switch (id) {
      case 1:
        return _bolum1?.secim;
      case 2:
        return _bolum2?.secim;
      case 3:
        if (_bolum3 == null) return null;
        return ChoiceResult(
          label: "3",
          uiTitle:
              "hBina: ${_bolum3?.hBina?.toStringAsFixed(2)}m | hYapi: ${_bolum3?.hYapi?.toStringAsFixed(2)}m",
          uiSubtitle: "",
          reportText:
              "Bina Yüksekliği (hBina): ${_bolum3?.hBina?.toStringAsFixed(2)} m, Yapı Yüksekliği (hYapi): ${_bolum3?.hYapi?.toStringAsFixed(2)} m.",
        );
      case 4:
        return _bolum4?.binaYukseklikSinifi;
      case 5:
        if (_bolum5 == null) return null;
        final m = _bolum5!;
        String report = "";
        if (m.tabanAlani != null)
          report +=
              "${Bolum5Content.oturumAlani.reportText}${m.tabanAlani} m²\n";
        if (m.normalKatAlani != null)
          report +=
              "${Bolum5Content.normalKatAlani.reportText}${m.normalKatAlani} m²\n";
        if (m.bodrumKatAlani != null && m.bodrumKatAlani! > 0)
          report +=
              "${Bolum5Content.bodrumKatAlani.reportText}${m.bodrumKatAlani} m²\n";
        report +=
            "${Bolum5Content.toplamInsaat.reportText}${m.toplamInsaatAlani} m²";

        return ChoiceResult(
          label: "5",
          uiTitle: "${m.toplamInsaatAlani} m²",
          uiSubtitle: "",
          reportText: report.trim(),
        );
      case 6:
        return _bolum6?.isSadeceKonut == true
            ? Bolum6Content.sadeceKonut
            : Bolum6Content.ticariVar;
      case 7:
        if (_bolum7 == null) return null;
        final m7 = _bolum7!;
        final b6 = _bolum6;

        // Otopark Tipini Belirle
        String otoparkText = "Otopark bulunmamaktadır.";
        if (b6?.hasOtopark == true) {
          if (b6?.otoparkTipi?.label.contains("Kapalı") == true) {
            otoparkText = "Binada Kapalı Otopark mevcuttur.";
          } else if (b6?.otoparkTipi?.label.contains("Yarı") == true) {
            otoparkText = "Binada Yarı Açık Otopark mevcuttur.";
          } else {
            otoparkText = "Binada Açık Otopark mevcuttur.";
          }
        }

        // Mevcut diğer riskleri topla
        List<String> riskler = [];
        if (m7.hasKazan) riskler.add("Kazan Dairesi");
        if (m7.hasAsansor) riskler.add("Asansör");
        if (m7.hasCati) riskler.add("Çatı Arası");
        if (m7.hasJenerator) riskler.add("Jeneratör Odası");
        if (m7.hasElektrik) riskler.add("Elektrik/Pano Odası");
        if (m7.hasTrafo) riskler.add("Trafo Merkezi");
        if (m7.hasDepo) riskler.add("Depo Alanı");
        if (m7.hasCop) riskler.add("Çöp Odası");
        if (m7.hasSiginak) riskler.add("Sığınak");
        if (m7.hasDuvar) riskler.add("Ortak Duvar");

        String fullReport = "ℹ️ BİLGİ: $otoparkText";
        if (riskler.isNotEmpty) {
          fullReport +=
              " Ayrıca binada tespit edilen diğer teknik hacimler: ${riskler.join(', ')}.";
        } else {
          if (b6?.hasOtopark == true) {
            fullReport +=
                " Otopark haricinde binada başka bir özel teknik hacim veya riskli alan tespit edilmemiştir.";
          } else {
            fullReport =
                "✅ OLUMLU: Binada otopark dahil herhangi bir özel teknik hacim veya riskli alan (kazan, jeneratör vb.) tespit edilmemiştir.";
          }
        }

        return ChoiceResult(
          label: "7",
          uiTitle: "Teknik Hacimler ve Riskler",
          uiSubtitle: "",
          reportText: fullReport,
        );
      case 8:
        return _bolum8?.secim;
      case 9:
        return _bolum9?.secim;
      case 10:
        if (_bolum10 == null) return null;
        final m10 = _bolum10!;
        final b3 = _bolum3;

        String fullReport = "";

        // Zemin Kat
        if (m10.zemin != null) {
          fullReport += "Zemin Kat Kullanımı: ${m10.zemin!.uiTitle}\n";
        }

        // Bodrum Katlar
        int bodrumCount =
            int.tryParse(b3?.bodrumKatSayisi?.toString() ?? "0") ?? 0;
        if (bodrumCount > 0) {
          fullReport += "Bodrum Katlar: ";
          if (m10.bodrumlarAyni) {
            if (m10.bodrumlar.isNotEmpty && m10.bodrumlar[0] != null) {
              fullReport +=
                  "Tüm bodrum katlar ${m10.bodrumlar[0]!.uiTitle} olarak kullanılmaktadır.\n";
            } else {
              fullReport += "Bodrum kat kullanım bilgisi eksik.\n";
            }
          } else {
            List<String> bUsages = [];
            for (int i = 0; i < m10.bodrumlar.length; i++) {
              if (m10.bodrumlar[i] != null) {
                bUsages.add("${i + 1}.Bodrum: ${m10.bodrumlar[i]!.uiTitle}");
              }
            }
            fullReport += "${bUsages.join(', ')}.\n";
          }
        }

        // Normal Katlar
        int normalCount =
            int.tryParse(b3?.normalKatSayisi?.toString() ?? "0") ?? 0;
        if (normalCount > 0) {
          fullReport += "Normal Katlar: ";
          if (m10.normallerAyni) {
            if (m10.normaller.isNotEmpty && m10.normaller[0] != null) {
              fullReport +=
                  "Tüm normal katlar ${m10.normaller[0]!.uiTitle} olarak kullanılmaktadır.\n";
            } else {
              fullReport += "Normal kat kullanım bilgisi eksik.\n";
            }
          } else {
            List<String> nUsages = [];
            for (int i = 0; i < m10.normaller.length; i++) {
              if (m10.normaller[i] != null) {
                nUsages.add(
                  "${i + 1}.Normal Kat: ${m10.normaller[i]!.uiTitle}",
                );
              }
            }
            fullReport += "${nUsages.join(', ')}.\n";
          }
        }

        return ChoiceResult(
          label: "10",
          uiTitle: "Kat Kullanım Amaçları",
          uiSubtitle: "",
          reportText: "ℹ️ BİLGİ:\n${fullReport.trim()}",
        );
      case 11:
        return _bolum11?.mesafe;
      case 12:
        return _bolum12?.secim;
      case 13:
        final m = _bolum13;
        return m?.kazanKapi ??
            m?.otoparkKapi ??
            m?.asansorKapi ??
            m?.ticariKapi;
      case 14:
        return _bolum14?.secim;
      case 15:
        return _bolum15?.kaplama;
      case 16:
        return _bolum16?.mantolama;
      case 17:
        final m17 = _bolum17;
        if (m17 == null) return null;

        // Temel kaplama yanıtı
        String reportText = m17.kaplama?.reportText ?? "";
        String statusPrefix = "ℹ️ BİLGİ: ";

        // Işıklık malzemesi ekleme
        if (m17.isiklik != null && m17.isiklik!.label.contains("17-4-A")) {
          // Işıklık var
          if (m17.isiklikMalzemesi == "cam") {
            reportText +=
                "\n✅ OLUMLU: Işıklık kapağı temperli cam malzemeden yapılmıştır. Yangın güvenliği açısından uygundur.";
            statusPrefix = "✅ OLUMLU: ";
          } else if (m17.isiklikMalzemesi == "plastik") {
            reportText +=
                "\n⚠️ UYARI: Işıklık kapağı plastik malzemeden yapılmıştır. Yangın durumunda eriyen plastik, yangın yayılımını hızlandırabilir.";
            statusPrefix = "⚠️ UYARI: ";
          }
        }

        return ChoiceResult(
          label: m17.kaplama?.label ?? "17",
          uiTitle: m17.kaplama?.uiTitle ?? "Çatı Bilgileri",
          uiSubtitle: m17.isiklikMalzemesi != null
              ? "Işıklık: ${m17.isiklikMalzemesi == 'cam' ? 'Temperli Cam' : 'Plastik'}"
              : "",
          reportText: reportText.isEmpty
              ? "$statusPrefixÇatı bilgileri girilmiştir."
              : reportText,
        );
      case 18:
        return _bolum18?.boruTipi ?? _bolum18?.duvarKaplama;
      case 19:
        return _bolum19?.levha;
      case 20:
        final m = _bolum20;
        if (m == null) return null;
        if (m.tekKatCikis != null) return m.tekKatCikis;
        return ChoiceResult(
          label: "20",
          uiTitle: "Merdiven Analizi",
          uiSubtitle: "",
          reportText: "Binada merdiven sayıları ve tipleri belirlenmiştir.",
        );
      case 21:
        return _bolum21?.varlik;
      case 22:
        return _bolum22?.varlik;
      case 23:
        return _bolum23?.yanginModu;
      case 24:
        return _bolum24?.tip;
      case 25:
        return _bolum25?.genislik;
      case 26:
        return _bolum26?.varlik;
      case 27:
        return _bolum27?.boyut;
      case 28:
        return _bolum28?.mesafe;
      case 29:
        final m = _bolum29;
        return m?.kazan ?? m?.otopark ?? m?.asansor ?? m?.pano;
      case 30:
        return _bolum30?.konum;
      case 31:
        return _bolum31?.yapi;
      case 32:
        return _bolum32?.yapi;
      case 33:
        if (_bolum33 == null) return null;
        return ChoiceResult(
          label: "33",
          uiTitle: "Kullanıcı Yükü ve Çıkışlar",
          uiSubtitle: "",
          reportText: _bolum33!.combinedReportText,
        );
      case 34:
        return _bolum34?.zemin;
      case 35:
        return _bolum35?.tekYon ?? _bolum35?.ciftYon;
      case 36:
        final m = _bolum36;
        if (m == null) return null;
        return ChoiceResult(
          label: "36",
          uiTitle: "Genel Değerlendirme",
          uiSubtitle: "",
          reportText: m.merdivenDegerlendirme ?? "Değerlendirme yapılamadı.",
        );
      default:
        return null;
    }
  }
}
