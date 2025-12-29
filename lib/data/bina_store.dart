import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/models/bolum_1_model.dart';
import 'package:life_safety/models/bolum_2_model.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/models/bolum_7_model.dart';
import 'package:life_safety/models/bolum_8_model.dart';
import 'package:life_safety/models/bolum_9_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/models/bolum_11_model.dart';
import 'package:life_safety/models/bolum_12_model.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_14_model.dart';
import 'package:life_safety/models/bolum_15_model.dart';
import 'package:life_safety/models/bolum_16_model.dart';
import 'package:life_safety/models/bolum_17_model.dart';
import 'package:life_safety/models/bolum_18_model.dart';
import 'package:life_safety/models/bolum_19_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/models/bolum_22_model.dart';
import 'package:life_safety/models/bolum_23_model.dart';
import 'package:life_safety/models/bolum_24_model.dart';
import 'package:life_safety/models/bolum_25_model.dart';
import 'package:life_safety/models/bolum_26_model.dart';
import 'package:life_safety/models/bolum_27_model.dart';
import 'package:life_safety/models/bolum_28_model.dart';
import 'package:life_safety/models/bolum_29_model.dart';
import 'package:life_safety/models/bolum_30_model.dart';
import 'package:life_safety/models/bolum_31_model.dart';
import 'package:life_safety/models/bolum_32_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_34_model.dart';
import 'package:life_safety/models/bolum_35_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/models/choice_result.dart'; // Tip dönüşümü için gerekli olabilir

class BinaStore {
  static final BinaStore _instance = BinaStore._internal();
  factory BinaStore() => _instance;
  BinaStore._internal();
  static BinaStore get instance => _instance;

  Bolum1Model? bolum1;
  Bolum2Model? bolum2;
  Bolum3Model? bolum3;
  Bolum4Model? bolum4;
  Bolum5Model? bolum5;
  Bolum6Model? bolum6;
  Bolum7Model? bolum7;
  Bolum8Model? bolum8;
  Bolum9Model? bolum9;
  Bolum10Model? bolum10;
  Bolum11Model? bolum11;
  Bolum12Model? bolum12;
  Bolum13Model? bolum13;
  Bolum14Model? bolum14;
  Bolum15Model? bolum15;
  Bolum16Model? bolum16;
  Bolum17Model? bolum17;
  Bolum18Model? bolum18;
  Bolum19Model? bolum19;
  Bolum20Model? bolum20;
  Bolum21Model? bolum21;
  Bolum22Model? bolum22;
  Bolum23Model? bolum23;
  Bolum24Model? bolum24;
  Bolum25Model? bolum25;
  Bolum26Model? bolum26;
  Bolum27Model? bolum27;
  Bolum28Model? bolum28;
  Bolum29Model? bolum29;
  Bolum30Model? bolum30;
  Bolum31Model? bolum31;
  Bolum32Model? bolum32;
  Bolum33Model? bolum33;
  Bolum34Model? bolum34;
  Bolum35Model? bolum35;
  Bolum36Model? bolum36;

  // GETTERLAR (Erişim Kolaylığı İçin)
  int get normalKatSayisi => bolum3?.normalKatSayisi ?? 0;
  int get bodrumKatSayisi => bolum3?.bodrumKatSayisi ?? 0;
  // HATA DÜZELTİLDİ: otoparkStatus yerine otoparkTipi
  ChoiceResult? get otoparkTipi => bolum6?.otoparkTipi;

  // SAVE (KAYIT)
  Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'bolum1': bolum1?.toMap(),
      'bolum2': bolum2?.toMap(),
      'bolum3': bolum3?.toMap(),
      'bolum4': bolum4?.toMap(),
      'bolum5': bolum5?.toMap(),
      'bolum6': bolum6?.toMap(),
      'bolum7': bolum7?.toMap(),
      'bolum8': bolum8?.toMap(),
      'bolum9': bolum9?.toMap(),
      'bolum10': bolum10?.toMap(),
      'bolum11': bolum11?.toMap(),
      'bolum12': bolum12?.toMap(),
      'bolum13': bolum13?.toMap(),
      'bolum14': bolum14?.toMap(),
      'bolum15': bolum15?.toMap(),
      'bolum16': bolum16?.toMap(),
      'bolum17': bolum17?.toMap(),
      'bolum18': bolum18?.toMap(),
      'bolum19': bolum19?.toMap(),
      'bolum20': bolum20?.toMap(),
      'bolum21': bolum21?.toMap(),
      'bolum22': bolum22?.toMap(),
      'bolum23': bolum23?.toMap(),
      'bolum24': bolum24?.toMap(),
      'bolum25': bolum25?.toMap(),
      'bolum26': bolum26?.toMap(),
      'bolum27': bolum27?.toMap(),
      'bolum28': bolum28?.toMap(),
      'bolum29': bolum29?.toMap(),
      'bolum30': bolum30?.toMap(),
      'bolum31': bolum31?.toMap(),
      'bolum32': bolum32?.toMap(),
      'bolum33': bolum33?.toMap(),
      'bolum34': bolum34?.toMap(),
      'bolum35': bolum35?.toMap(),
      'bolum36': bolum36?.toMap(),
    };
    await prefs.setString('bina_data', json.encode(data));
    debugPrint("Tüm Veriler Diske Kaydedildi");
  }

  // LOAD (YÜKLEME)
  Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString('bina_data');
    if (rawData != null) {
      final data = json.decode(rawData);
      
      if (data['bolum1'] != null) bolum1 = Bolum1Model.fromMap(data['bolum1']);
      if (data['bolum2'] != null) bolum2 = Bolum2Model.fromMap(data['bolum2']);
      if (data['bolum3'] != null) bolum3 = Bolum3Model.fromMap(data['bolum3']);
      if (data['bolum4'] != null) bolum4 = Bolum4Model.fromMap(data['bolum4']);
      if (data['bolum5'] != null) bolum5 = Bolum5Model.fromMap(data['bolum5']);
      if (data['bolum6'] != null) bolum6 = Bolum6Model.fromMap(data['bolum6']);
      if (data['bolum7'] != null) bolum7 = Bolum7Model.fromMap(data['bolum7']);
      if (data['bolum8'] != null) bolum8 = Bolum8Model.fromMap(data['bolum8']);
      if (data['bolum9'] != null) bolum9 = Bolum9Model.fromMap(data['bolum9']);
      if (data['bolum10'] != null) bolum10 = Bolum10Model.fromMap(data['bolum10']);
      if (data['bolum11'] != null) bolum11 = Bolum11Model.fromMap(data['bolum11']);
      if (data['bolum12'] != null) bolum12 = Bolum12Model.fromMap(data['bolum12']);
      if (data['bolum13'] != null) bolum13 = Bolum13Model.fromMap(data['bolum13']);
      if (data['bolum14'] != null) bolum14 = Bolum14Model.fromMap(data['bolum14']);
      if (data['bolum15'] != null) bolum15 = Bolum15Model.fromMap(data['bolum15']);
      if (data['bolum16'] != null) bolum16 = Bolum16Model.fromMap(data['bolum16']);
      if (data['bolum17'] != null) bolum17 = Bolum17Model.fromMap(data['bolum17']);
      if (data['bolum18'] != null) bolum18 = Bolum18Model.fromMap(data['bolum18']);
      if (data['bolum19'] != null) bolum19 = Bolum19Model.fromMap(data['bolum19']);
      if (data['bolum20'] != null) bolum20 = Bolum20Model.fromMap(data['bolum20']);
      if (data['bolum21'] != null) bolum21 = Bolum21Model.fromMap(data['bolum21']);
      if (data['bolum22'] != null) bolum22 = Bolum22Model.fromMap(data['bolum22']);
      if (data['bolum23'] != null) bolum23 = Bolum23Model.fromMap(data['bolum23']);
      if (data['bolum24'] != null) bolum24 = Bolum24Model.fromMap(data['bolum24']);
      if (data['bolum25'] != null) bolum25 = Bolum25Model.fromMap(data['bolum25']);
      if (data['bolum26'] != null) bolum26 = Bolum26Model.fromMap(data['bolum26']);
      if (data['bolum27'] != null) bolum27 = Bolum27Model.fromMap(data['bolum27']);
      if (data['bolum28'] != null) bolum28 = Bolum28Model.fromMap(data['bolum28']);
      if (data['bolum29'] != null) bolum29 = Bolum29Model.fromMap(data['bolum29']);
      if (data['bolum30'] != null) bolum30 = Bolum30Model.fromMap(data['bolum30']);
      if (data['bolum31'] != null) bolum31 = Bolum31Model.fromMap(data['bolum31']);
      if (data['bolum32'] != null) bolum32 = Bolum32Model.fromMap(data['bolum32']);
      if (data['bolum33'] != null) bolum33 = Bolum33Model.fromMap(data['bolum33']);
      if (data['bolum34'] != null) bolum34 = Bolum34Model.fromMap(data['bolum34']);
      if (data['bolum35'] != null) bolum35 = Bolum35Model.fromMap(data['bolum35']);
      if (data['bolum36'] != null) bolum36 = Bolum36Model.fromMap(data['bolum36']);

      debugPrint("Veriler Diskten Yüklendi");
    }
  }
  void clearAfter(int sectionNumber) {
    if (sectionNumber <= 1) bolum1 = null; // Örnek: 1 değişirse hepsi gider
    if (sectionNumber <= 3) {
      bolum4 = null; bolum5 = null; bolum14 = null; bolum33 = null;
    }
    if (sectionNumber <= 6) {
      bolum10 = null; bolum13 = null; bolum34 = null;
    }
    // İhtiyaca göre genişletilebilir...
    saveToDisk();
    debugPrint("Bölüm $sectionNumber sonrası bağımlı veriler temizlendi.");
  }
  void reset() {
    bolum1 = null; bolum2 = null; bolum3 = null; bolum4 = null;
    bolum5 = null; bolum6 = null; bolum7 = null; bolum8 = null;
    bolum9 = null; bolum10 = null; bolum11 = null; bolum12 = null;
    bolum13 = null; bolum14 = null; bolum15 = null; bolum16 = null;
    bolum17 = null; bolum18 = null; bolum19 = null; bolum20 = null;
    bolum21 = null; bolum22 = null; bolum23 = null; bolum24 = null;
    bolum25 = null; bolum26 = null; bolum27 = null; bolum28 = null;
    bolum29 = null; bolum30 = null; bolum31 = null; bolum32 = null;
    bolum33 = null; bolum34 = null; bolum35 = null; bolum36 = null;
  }
}
