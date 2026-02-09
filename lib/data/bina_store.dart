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
  bool _isCompleted = false;
  int get lastActiveSection => _lastActiveSection;
  set lastActiveSection(int value) {
    if (_lastActiveSection != value) {
      _lastActiveSection = value;
      _prefs?.setInt('lastActiveSection', value);
      _isDirty = true;
    }
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
  set bolum1(Bolum1Model? v) {
    _bolum1 = v;
    _isDirty = true;
  }

  Bolum2Model? get bolum2 => _bolum2;
  set bolum2(Bolum2Model? v) {
    _bolum2 = v;
    _isDirty = true;
  }

  Bolum3Model? get bolum3 => _bolum3;
  set bolum3(Bolum3Model? v) {
    _bolum3 = v;
    _isDirty = true;
  }

  Bolum4Model? get bolum4 => _bolum4;
  set bolum4(Bolum4Model? v) {
    _bolum4 = v;
    _isDirty = true;
  }

  Bolum5Model? get bolum5 => _bolum5;
  set bolum5(Bolum5Model? v) {
    _bolum5 = v;
    _isDirty = true;
  }

  Bolum6Model? get bolum6 => _bolum6;
  set bolum6(Bolum6Model? v) {
    _bolum6 = v;
    _isDirty = true;
  }

  Bolum7Model? get bolum7 => _bolum7;
  set bolum7(Bolum7Model? v) {
    _bolum7 = v;
    _isDirty = true;
  }

  Bolum8Model? get bolum8 => _bolum8;
  set bolum8(Bolum8Model? v) {
    _bolum8 = v;
    _isDirty = true;
  }

  Bolum9Model? get bolum9 => _bolum9;
  set bolum9(Bolum9Model? v) {
    _bolum9 = v;
    _isDirty = true;
  }

  Bolum10Model? get bolum10 => _bolum10;
  set bolum10(Bolum10Model? v) {
    _bolum10 = v;
    _isDirty = true;
  }

  Bolum11Model? get bolum11 => _bolum11;
  set bolum11(Bolum11Model? v) {
    _bolum11 = v;
    _isDirty = true;
  }

  Bolum12Model? get bolum12 => _bolum12;
  set bolum12(Bolum12Model? v) {
    _bolum12 = v;
    _isDirty = true;
  }

  Bolum13Model? get bolum13 => _bolum13;
  set bolum13(Bolum13Model? v) {
    _bolum13 = v;
    _isDirty = true;
  }

  Bolum14Model? get bolum14 => _bolum14;
  set bolum14(Bolum14Model? v) {
    _bolum14 = v;
    _isDirty = true;
  }

  Bolum15Model? get bolum15 => _bolum15;
  set bolum15(Bolum15Model? v) {
    _bolum15 = v;
    _isDirty = true;
  }

  Bolum16Model? get bolum16 => _bolum16;
  set bolum16(Bolum16Model? v) {
    _bolum16 = v;
    _isDirty = true;
  }

  Bolum17Model? get bolum17 => _bolum17;
  set bolum17(Bolum17Model? v) {
    _bolum17 = v;
    _isDirty = true;
  }

  Bolum18Model? get bolum18 => _bolum18;
  set bolum18(Bolum18Model? v) {
    _bolum18 = v;
    _isDirty = true;
  }

  Bolum19Model? get bolum19 => _bolum19;
  set bolum19(Bolum19Model? v) {
    _bolum19 = v;
    _isDirty = true;
  }

  Bolum20Model? get bolum20 => _bolum20;
  set bolum20(Bolum20Model? v) {
    _bolum20 = v;
    _isDirty = true;
  }

  Bolum21Model? get bolum21 => _bolum21;
  set bolum21(Bolum21Model? v) {
    _bolum21 = v;
    _isDirty = true;
  }

  Bolum22Model? get bolum22 => _bolum22;
  set bolum22(Bolum22Model? v) {
    _bolum22 = v;
    _isDirty = true;
  }

  Bolum23Model? get bolum23 => _bolum23;
  set bolum23(Bolum23Model? v) {
    _bolum23 = v;
    _isDirty = true;
  }

  Bolum24Model? get bolum24 => _bolum24;
  set bolum24(Bolum24Model? v) {
    _bolum24 = v;
    _isDirty = true;
  }

  Bolum25Model? get bolum25 => _bolum25;
  set bolum25(Bolum25Model? v) {
    _bolum25 = v;
    _isDirty = true;
  }

  Bolum26Model? get bolum26 => _bolum26;
  set bolum26(Bolum26Model? v) {
    _bolum26 = v;
    _isDirty = true;
  }

  Bolum27Model? get bolum27 => _bolum27;
  set bolum27(Bolum27Model? v) {
    _bolum27 = v;
    _isDirty = true;
  }

  Bolum28Model? get bolum28 => _bolum28;
  set bolum28(Bolum28Model? v) {
    _bolum28 = v;
    _isDirty = true;
  }

  Bolum29Model? get bolum29 => _bolum29;
  set bolum29(Bolum29Model? v) {
    _bolum29 = v;
    _isDirty = true;
  }

  Bolum30Model? get bolum30 => _bolum30;
  set bolum30(Bolum30Model? v) {
    _bolum30 = v;
    _isDirty = true;
  }

  Bolum31Model? get bolum31 => _bolum31;
  set bolum31(Bolum31Model? v) {
    _bolum31 = v;
    _isDirty = true;
  }

  Bolum32Model? get bolum32 => _bolum32;
  set bolum32(Bolum32Model? v) {
    _bolum32 = v;
    _isDirty = true;
  }

  Bolum33Model? get bolum33 => _bolum33;
  set bolum33(Bolum33Model? v) {
    _bolum33 = v;
    _isDirty = true;
  }

  Bolum34Model? get bolum34 => _bolum34;
  set bolum34(Bolum34Model? v) {
    _bolum34 = v;
    _isDirty = true;
  }

  Bolum35Model? get bolum35 => _bolum35;
  set bolum35(Bolum35Model? v) {
    _bolum35 = v;
    _isDirty = true;
  }

  Bolum36Model? get bolum36 => _bolum36;
  set bolum36(Bolum36Model? v) {
    _bolum36 = v;
    _isDirty = true;
  }

  bool isTestCompleted() => _isCompleted;

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
        archive = [];
        reset();
        _prefs?.remove('bina_archive');
        _prefs?.remove('active_bina_id');
      }
    }
  }

  bool _isDirty = false;

  void saveToDisk() {
    if (!_isDirty && currentBinaId != null) return;

    currentBinaId ??= DateTime.now().millisecondsSinceEpoch.toString();
    final currentData = {
      'id': currentBinaId,
      'name': currentBinaName ?? "İsimsiz Bina",
      'city': currentBinaCity ?? "",
      'district': currentBinaDistrict ?? "",
      'date': DateTime.now().toIso8601String(),
      'lastActiveSection': _lastActiveSection,
      'isCompleted': _isCompleted,
      'isPremium': isPremium,
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

    _isDirty = false;
  }

  void markAsCompleted() {
    _isCompleted = true;
    _isDirty =
        true; // Critical: mark dirty so saveToDisk() actually writes to disk
    saveToDisk();
  }

  void _loadBuildingFromMap(Map<String, dynamic> data) {
    currentBinaId = data['id'];
    currentBinaName = data['name'];
    currentBinaCity = data['city'];
    currentBinaDistrict = data['district'];
    _isCompleted = data['isCompleted'] ?? false;
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
    _isCompleted = false;
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
        final m3 = _bolum3!;
        String report;
        if (m3.yukseklikBilinmiyor) {
          report = Bolum3Content.bilinmiyor.reportText;
        } else {
          String katBilgisi =
              "Zemin: ${m3.zeminYuksekligi}m, Normal: ${m3.normalYuksekligi}m";
          if ((m3.bodrumKatSayisi ?? 0) > 0) {
            katBilgisi += ", Bodrum: ${m3.bodrumYuksekligi}m";
          }
          report =
              "BİLGİ: Bina yükseklik analizi beyan edilen değerler üzerinden yapılmıştır. ($katBilgisi)";
        }

        // Add calculated totals as a clear summary
        report +=
            "\n\nBina Yüksekliği (hBina): ${m3.hBina?.toStringAsFixed(2)} m\n"
            "Yapı Yüksekliği (hYapi): ${m3.hYapi?.toStringAsFixed(2)} m";

        return ChoiceResult(
          label: "3",
          uiTitle: "Bina ve Yapı Yüksekliği",
          uiSubtitle:
              "hBina: ${m3.hBina?.toStringAsFixed(2)}m | hYapi: ${m3.hYapi?.toStringAsFixed(2)}m",
          reportText: report,
        );
      case 4:
        return _bolum4?.binaYukseklikSinifi;
      case 5:
        if (_bolum5 == null) return null;
        final m = _bolum5!;
        List<String> parts = [];
        if (m.tabanAlani != null)
          parts.add("Zemin Kat (Taban) Alanı: ${m.tabanAlani} m²");
        if (m.normalKatAlani != null)
          parts.add("Normal Kat Alanı: ${m.normalKatAlani} m²");
        if (m.bodrumKatAlani != null && m.bodrumKatAlani! > 0)
          parts.add("Bodrum Kat Alanı: ${m.bodrumKatAlani} m²");
        parts.add("Toplam İnşaat Alanı: ${m.toplamInsaatAlani} m²");

        return ChoiceResult(
          label: "5",
          uiTitle: "${m.toplamInsaatAlani} m²",
          uiSubtitle: "",
          reportText: "BİLGİ: ${parts.join('\n')}",
        );
      case 6:
        return _bolum6?.isSadeceKonut == true
            ? Bolum6Content.sadeceKonut
            : Bolum6Content.ticariVar;
      case 7:
        if (_bolum7 == null) return null;
        final m7 = _bolum7!;
        final b6 = _bolum6;

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

        String fullReport = " BİLGİ: $otoparkText";
        if (riskler.isNotEmpty) {
          fullReport +=
              " Ayrıca binada tespit edilen diğer teknik hacimler: ${riskler.join(', ')}.";
        } else {
          if (b6?.hasOtopark == true) {
            fullReport +=
                " Otopark haricinde binada başka bir özel teknik hacim veya riskli alan tespit edilmemiştir.";
          } else {
            fullReport =
                "OLUMLU: Binada otopark dahil herhangi bir özel teknik hacim veya riskli alan (kazan, jeneratör vb.) tespit edilmemiştir.";
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
        List<String> reportParts = [];
        final m10 = _bolum10!;

        // Zemin Kat
        if (m10.zemin != null) {
          reportParts.add("Zemin Kat Kullanımı: ${m10.zemin!.uiTitle}");
        }

        // Normal Katlar
        if (m10.normaller.isNotEmpty) {
          final nUsages = m10.normaller
              .where((c) => c != null)
              .map((c) => c!.uiTitle)
              .toList();
          if (nUsages.isNotEmpty) {
            if (nUsages.toSet().length == 1) {
              // Tüm normal katlar aynı kullanım amacına sahip
              reportParts.add(
                "Normal Katlar (${nUsages.length} adet): ${nUsages[0]}",
              );
            } else {
              // Farklı kullanım amaçları var, her birini tek tek yaz
              for (int i = 0; i < m10.normaller.length; i++) {
                if (m10.normaller[i] != null) {
                  reportParts.add(
                    "${i + 1}. Normal Kat: ${m10.normaller[i]!.uiTitle}",
                  );
                }
              }
            }
          }
        }

        // Bodrum Katlar
        if (m10.bodrumlar.isNotEmpty) {
          final bUsages = m10.bodrumlar
              .where((c) => c != null)
              .map((c) => c!.uiTitle)
              .toList();
          if (bUsages.isNotEmpty) {
            if (bUsages.toSet().length == 1) {
              // Tüm bodrum katlar aynı kullanım amacına sahip
              reportParts.add(
                "Bodrum Katlar (${bUsages.length} adet): ${bUsages[0]}",
              );
            } else {
              // Farklı kullanım amaçları var, her birini tek tek yaz
              for (int i = 0; i < m10.bodrumlar.length; i++) {
                if (m10.bodrumlar[i] != null) {
                  reportParts.add(
                    "${i + 1}. Bodrum Kat: ${m10.bodrumlar[i]!.uiTitle}",
                  );
                }
              }
            }
          }
        }

        return ChoiceResult(
          label: "10",
          uiTitle: "Kat Kullanım Amaçları",
          uiSubtitle: "",
          reportText: "BİLGİ: ${reportParts.join('\n')}",
          adviceText: _joinAdvice([
            m10.zemin,
            ...m10.normaller,
            ...m10.bodrumlar,
          ]),
        );
      case 11:
        if (_bolum11 == null) return null;
        return ChoiceResult(
          label: "11",
          uiTitle: "İtfaiye Yaklaşım Mesafesi",
          uiSubtitle: "",
          reportText: _bolum11!.mesafe?.reportText ?? "",
          adviceText: _joinAdvice([
            _bolum11!.mesafe,
            _bolum11!.engel,
            _bolum11!.zayifNokta,
          ]),
        );
      case 12:
        return _bolum12?.secim;
      case 13:
        if (_bolum13 == null) return null;
        final m13 = _bolum13!;
        List<String> parts = [];

        // Kapı Dayanımları
        if (m13.otoparkKapi != null)
          parts.add("Otopark Kapısı: ${m13.otoparkKapi!.reportText}");
        if (m13.kazanKapi != null)
          parts.add("Kazan Dairesi Kapısı: ${m13.kazanKapi!.reportText}");
        if (m13.asansorKapi != null)
          parts.add(
            "Asansör Makine Dairesi Kapısı: ${m13.asansorKapi!.reportText}",
          );
        if (m13.jeneratorKapi != null)
          parts.add("Jeneratör Odası Kapısı: ${m13.jeneratorKapi!.reportText}");
        if (m13.elektrikKapi != null)
          parts.add(
            "Elektrik/Pano Odası Kapısı: ${m13.elektrikKapi!.reportText}",
          );
        if (m13.trafoKapi != null)
          parts.add("Trafo Merkezi Kapısı: ${m13.trafoKapi!.reportText}");
        if (m13.depoKapi != null)
          parts.add("Depo Alanı Kapısı: ${m13.depoKapi!.reportText}");
        if (m13.copKapi != null)
          parts.add("Çöp Odası Kapısı: ${m13.copKapi!.reportText}");
        if (m13.ortakDuvar != null)
          parts.add(
            "Ortak Duvar Yangın Dayanımı: ${m13.ortakDuvar!.reportText}",
          );
        if (m13.ticariKapi != null)
          parts.add("Ticari Alan Kapısı: ${m13.ticariKapi!.reportText}");

        // Duman Tahliye Sistemleri
        if (m13.otoparkAlan != null)
          parts.add("Otopark Duman Tahliyesi: ${m13.otoparkAlan!.reportText}");
        if (m13.kazanAlan != null)
          parts.add(
            "Kazan Dairesi Duman Tahliyesi: ${m13.kazanAlan!.reportText}",
          );
        if (m13.siginakAlan != null)
          parts.add("Sığınak Duman Tahliyesi: ${m13.siginakAlan!.reportText}");

        if (parts.isEmpty) {
          return ChoiceResult(
            label: "13",
            uiTitle: "Yangın Kompartımanları",
            uiSubtitle: "",
            reportText:
                "BİLGİ: Binada özel teknik hacim bulunmadığından bu bölüm değerlendirme kapsamı dışındadır.",
          );
        }

        return ChoiceResult(
          label: "13",
          uiTitle: "Yangın Kompartımanları ve Kapı Dayanımları",
          uiSubtitle: "",
          reportText: parts.join('\n\n'),
          adviceText: _joinAdvice([
            m13.otoparkKapi,
            m13.kazanKapi,
            m13.asansorKapi,
            m13.jeneratorKapi,
            m13.elektrikKapi,
            m13.trafoKapi,
            m13.depoKapi,
            m13.copKapi,
            m13.ortakDuvar,
            m13.ticariKapi,
            m13.otoparkAlan,
            m13.kazanAlan,
            m13.siginakAlan,
          ]),
        );
      case 14:
        return _bolum14?.secim;
      case 15:
        if (_bolum15 == null) return null;
        return ChoiceResult(
          label: "15",
          uiTitle: "İç Kaplama Özellikleri",
          uiSubtitle: "",
          reportText: "Döşeme, yalıtım ve tavan analizleri.",
          adviceText: _joinAdvice([
            _bolum15!.kaplama,
            _bolum15!.yalitim,
            _bolum15!.yalitimSap,
            _bolum15!.tavan,
            _bolum15!.tavanMalzeme,
            _bolum15!.tesisat,
          ]),
        );
      case 16:
        if (_bolum16 == null) return null;
        return ChoiceResult(
          label: "16",
          uiTitle: "Dış Cephe Özellikleri",
          uiSubtitle: "",
          reportText: "Mantolama ve cephe güvenliği analizi.",
          adviceText: _joinAdvice([
            _bolum16!.mantolama,
            _bolum16!.sagirYuzey,
            _bolum16!.bitisikNizam,
          ]),
        );
      case 17:
        if (_bolum17 == null) return null;
        return ChoiceResult(
          label: "17",
          uiTitle: "Çatı Güvenliği",
          uiSubtitle: "",
          reportText: "Çatı kaplama ve iskelet analizi.",
          adviceText: _joinAdvice([
            _bolum17!.kaplama,
            _bolum17!.iskelet,
            _bolum17!.bitisikDuvar,
            _bolum17!.isiklik,
          ]),
        );
      case 18:
        if (_bolum18 == null) return null;
        return ChoiceResult(
          label: "18",
          uiTitle: "Koridor Kaplamaları",
          uiSubtitle: "",
          reportText: "Kaçış yolu koridor analizi.",
          adviceText: _joinAdvice([_bolum18!.duvarKaplama, _bolum18!.boruTipi]),
        );
      case 19:
        if (_bolum19 == null) return null;
        return ChoiceResult(
          label: "19",
          uiTitle: "Kaçış Yolu Engelleri",
          uiSubtitle: "",
          reportText: "Kaçış yolu ve yönlendirme analizi.",
          adviceText: _joinAdvice([
            ..._bolum19!.engeller,
            _bolum19!.levha,
            _bolum19!.yanilticiKapi,
            _bolum19!.yanilticiEtiket,
          ]),
        );
      case 20:
        if (_bolum20 == null) return null;
        return ChoiceResult(
          label: "20",
          uiTitle: "Merdiven Analizi",
          uiSubtitle: "",
          reportText: "Binada merdiven sayıları ve tipleri belirlenmiştir.",
          adviceText: _joinAdvice([
            _bolum20!.tekKatCikis,
            _bolum20!.tekKatRampa,
            _bolum20!.bodrumMerdivenDevami,
            _bolum20!.basinclandirma,
            _bolum20!.daireselMerdivenYuksekligi,
          ]),
        );
      case 21:
        if (_bolum21 == null) return null;
        return ChoiceResult(
          label: "21",
          uiTitle: "Yangın Güvenlik Holleri",
          uiSubtitle: "",
          reportText: "YGH zorunluluk ve varlık analizi.",
          adviceText: _joinAdvice([
            _bolum21!.varlik,
            _bolum21!.malzeme,
            _bolum21!.kapi,
            _bolum21!.esya,
          ]),
        );
      case 22:
        if (_bolum22 == null) return null;
        return ChoiceResult(
          label: "22",
          uiTitle: "İtfaiye Asansörü Analizi",
          uiSubtitle: "",
          reportText: _bolum22!.varlik?.reportText ?? "",
          adviceText: _joinAdvice([
            _bolum22!.varlik,
            _bolum22!.konum,
            _bolum22!.boyut,
            _bolum22!.kabin,
            _bolum22!.enerji,
            _bolum22!.basinc,
          ]),
        );
      case 23:
        if (_bolum23 == null) return null;
        return ChoiceResult(
          label: "23",
          uiTitle: "Normal Asansör Analizi",
          uiSubtitle: "",
          reportText: _bolum23!.yanginModu?.reportText ?? "",
          adviceText: _joinAdvice([
            _bolum23!.bodrum,
            _bolum23!.yanginModu,
            _bolum23!.konum,
            _bolum23!.levha,
            _bolum23!.havalandirma,
          ]),
        );
      case 24:
        if (_bolum24 == null) return null;
        return ChoiceResult(
          label: "24",
          uiTitle: "Dış Kaçış Geçitleri",
          uiSubtitle: "",
          reportText: _bolum24!.tip?.reportText ?? "",
          adviceText: _joinAdvice([
            _bolum24!.tip,
            _bolum24!.pencere,
            _bolum24!.kapi,
          ]),
        );
      case 25:
        if (_bolum25 == null) return null;
        return ChoiceResult(
          label: "25",
          uiTitle: "Dairesel Merdiven Analizi",
          uiSubtitle: "",
          reportText: _bolum25!.genislik?.reportText ?? "",
          adviceText: _joinAdvice([
            _bolum25!.genislik,
            _bolum25!.basamak,
            _bolum25!.basKurtarma,
          ]),
        );
      case 26:
        if (_bolum26 == null) return null;
        return ChoiceResult(
          label: "26",
          uiTitle: "Rampalar",
          uiSubtitle: "",
          reportText: "Kaçış rampaları analizi.",
          adviceText: _joinAdvice([
            _bolum26!.varlik,
            _bolum26!.egim,
            _bolum26!.sahanlik,
            _bolum26!.otopark,
          ]),
        );
      case 27:
        if (_bolum27 == null) return null;
        return ChoiceResult(
          label: "27",
          uiTitle: "Kapı Özellikleri",
          uiSubtitle: "",
          reportText: "Kapı özellikleri analizi yapılmıştır.",
          adviceText: _joinAdvice([
            _bolum27!.boyut,
            _bolum27!.yon,
            _bolum27!.kilit,
            _bolum27!.dayanim,
          ]),
        );
      case 28:
        if (_bolum28 == null) return null;
        return ChoiceResult(
          label: "28",
          uiTitle: "Daire İçi Mesafeler",
          uiSubtitle: "",
          reportText: _bolum28!.mesafe?.reportText ?? "",
          adviceText: _joinAdvice([
            _bolum28!.mesafe,
            _bolum28!.dubleks,
            _bolum28!.alan,
            _bolum28!.cikis,
            _bolum28!.muafiyet,
          ]),
        );
      case 29:
        if (_bolum29 == null) return null;
        return ChoiceResult(
          label: "29",
          uiTitle: "Genel Yanlış Uygulamalar",
          uiSubtitle: "",
          reportText: "Depolama ve yerleşim hataları analizi.",
          adviceText: _joinAdvice([
            _bolum29!.otopark,
            _bolum29!.kazan,
            _bolum29!.cati,
            _bolum29!.asansor,
            _bolum29!.jenerator,
            _bolum29!.pano,
            _bolum29!.trafo,
            _bolum29!.depo,
            _bolum29!.cop,
            _bolum29!.siginak,
          ]),
        );
      case 30:
        if (_bolum30 == null) return null;
        return ChoiceResult(
          label: "30",
          uiTitle: "Kazan Dairesi",
          uiSubtitle: "",
          reportText: "Kazan dairesi güvenlik analizi.",
          adviceText: _joinAdvice([
            _bolum30!.konum,
            _bolum30!.kapi,
            _bolum30!.yakit,
            _bolum30!.hava,
            _bolum30!.drenaj,
            _bolum30!.tup,
          ]),
        );
      case 31:
        if (_bolum31 == null) return null;
        return ChoiceResult(
          label: "31",
          uiTitle: "Trafo Odası Analizi",
          uiSubtitle: "",
          reportText: "Trafo odası güvenlik analizi.",
          adviceText: _joinAdvice([
            _bolum31!.yapi,
            _bolum31!.tip,
            _bolum31!.cukur,
            _bolum31!.sondurme,
            _bolum31!.cevre,
          ]),
        );
      case 32:
        if (_bolum32 == null) return null;
        return ChoiceResult(
          label: "32",
          uiTitle: "Jeneratör Odası",
          uiSubtitle: "",
          reportText: "Jeneratör odası güvenlik analizi.",
          adviceText: _joinAdvice([
            _bolum32!.yapi,
            _bolum32!.yakit,
            _bolum32!.cevre,
            _bolum32!.egzoz,
          ]),
        );
      case 33:
        if (_bolum33 == null) return null;
        return ChoiceResult(
          label: "33",
          uiTitle: "Kullanıcı Yükü ve Çıkışlar",
          uiSubtitle: "",
          reportText: _bolum33!.combinedReportText,
          adviceText: _joinAdvice([
            _bolum33!.normalKatSonuc,
            _bolum33!.zeminKatSonuc,
            _bolum33!.bodrumKatSonuc,
          ]),
        );
      case 34:
        if (_bolum34 == null) return null;
        return ChoiceResult(
          label: "34",
          uiTitle: "Kat Karakteristikleri",
          uiSubtitle: "",
          reportText: "Zemin ve bodrum kat çıkış karakteristikleri.",
          adviceText: _joinAdvice([
            _bolum34!.zemin,
            _bolum34!.bodrum,
            _bolum34!.normal,
          ]),
        );
      case 35:
        if (_bolum35 == null) return null;
        return ChoiceResult(
          label: "35",
          uiTitle: "Çıkış Koridoru Genişlikleri",
          uiSubtitle: "",
          reportText: "Kat bazlı genişlik analizleri.",
          adviceText: _joinAdvice([
            _bolum35!.tekYon,
            _bolum35!.ciftYon,
            _bolum35!.cikmaz,
            _bolum35!.cikmazMesafe,
          ]),
        );
      case 36:
        final m = _bolum36;
        if (m == null) return null;
        return ChoiceResult(
          label: "36",
          uiTitle: "Genel Değerlendirme",
          uiSubtitle: "",
          reportText: m.merdivenDegerlendirme ?? "Değerlendirme yapılamadı.",
          adviceText: _joinAdvice([
            m.cikisKati,
            m.disMerd,
            m.konum,
            m.kapiTipi,
            m.gorunurluk,
          ]),
        );
      default:
        return null;
    }
  }
}

String _joinAdvice(List<ChoiceResult?> results) {
  return results
      .where(
        (r) =>
            r != null &&
            r.adviceText != null &&
            r.adviceText!.trim().isNotEmpty,
      )
      .map((r) => r!.adviceText!.trim())
      .toSet() // Duplicate onerileri onle
      .join('\n\n');
}
