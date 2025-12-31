import 'dart:convert';
import 'package:flutter/foundation.dart';
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

class BinaStore {
  static final BinaStore _instance = BinaStore._internal();
  factory BinaStore() => _instance;
  BinaStore._internal();
  static BinaStore get instance => _instance;

  String? currentBinaId;
  String? currentBinaName;
  List<Map<String, dynamic>> archive = [];

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

  Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    
    final currentData = {
      'id': currentBinaId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'name': currentBinaName ?? "İsimsiz Bina",
      'date': DateTime.now().toIso8601String(),
      'sections': {
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
      }
    };

    int index = archive.indexWhere((element) => element['id'] == currentData['id']);
    if (index != -1) {
      archive[index] = currentData;
    } else {
      archive.add(currentData);
    }

    await prefs.setString('bina_archive', json.encode(archive));
    await prefs.setString('active_bina_id', currentBinaId ?? "");
  }

  Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final archiveRaw = prefs.getString('bina_archive');
    final activeId = prefs.getString('active_bina_id');

    if (archiveRaw != null) {
      archive = List<Map<String, dynamic>>.from(json.decode(archiveRaw));
      if (activeId != null && activeId.isNotEmpty) {
        final activeData = archive.firstWhere((e) => e['id'] == activeId, orElse: () => {});
        if (activeData.isNotEmpty) {
          _loadBuildingFromMap(activeData);
        }
      }
    }
  }

  void _loadBuildingFromMap(Map<String, dynamic> data) {
        
    currentBinaId = data['id'];
    currentBinaName = data['name'];
    final s = data['sections'];
    if (s['bolum1'] != null) bolum1 = Bolum1Model.fromMap(s['bolum1']);
    if (s['bolum2'] != null) bolum2 = Bolum2Model.fromMap(s['bolum2']);
    if (s['bolum3'] != null) bolum3 = Bolum3Model.fromMap(s['bolum3']);
    if (s['bolum4'] != null) bolum4 = Bolum4Model.fromMap(s['bolum4']);
    if (s['bolum5'] != null) bolum5 = Bolum5Model.fromMap(s['bolum5']);
    if (s['bolum6'] != null) bolum6 = Bolum6Model.fromMap(s['bolum6']);
    if (s['bolum7'] != null) bolum7 = Bolum7Model.fromMap(s['bolum7']);
    if (s['bolum8'] != null) bolum8 = Bolum8Model.fromMap(s['bolum8']);
    if (s['bolum9'] != null) bolum9 = Bolum9Model.fromMap(s['bolum9']);
    if (s['bolum10'] != null) bolum10 = Bolum10Model.fromMap(s['bolum10']);
    if (s['bolum11'] != null) bolum11 = Bolum11Model.fromMap(s['bolum11']);
    if (s['bolum12'] != null) bolum12 = Bolum12Model.fromMap(s['bolum12']);
    if (s['bolum13'] != null) bolum13 = Bolum13Model.fromMap(s['bolum13']);
    if (s['bolum14'] != null) bolum14 = Bolum14Model.fromMap(s['bolum14']);
    if (s['bolum15'] != null) bolum15 = Bolum15Model.fromMap(s['bolum15']);
    if (s['bolum16'] != null) bolum16 = Bolum16Model.fromMap(s['bolum16']);
    if (s['bolum17'] != null) bolum17 = Bolum17Model.fromMap(s['bolum17']);
    if (s['bolum18'] != null) bolum18 = Bolum18Model.fromMap(s['bolum18']);
    if (s['bolum19'] != null) bolum19 = Bolum19Model.fromMap(s['bolum19']);
    if (s['bolum20'] != null) bolum20 = Bolum20Model.fromMap(s['bolum20']);
    if (s['bolum21'] != null) bolum21 = Bolum21Model.fromMap(s['bolum21']);
    if (s['bolum22'] != null) bolum22 = Bolum22Model.fromMap(s['bolum22']);
    if (s['bolum23'] != null) bolum23 = Bolum23Model.fromMap(s['bolum23']);
    if (s['bolum24'] != null) bolum24 = Bolum24Model.fromMap(s['bolum24']);
    if (s['bolum25'] != null) bolum25 = Bolum25Model.fromMap(s['bolum25']);
    if (s['bolum26'] != null) bolum26 = Bolum26Model.fromMap(s['bolum26']);
    if (s['bolum27'] != null) bolum27 = Bolum27Model.fromMap(s['bolum27']);
    if (s['bolum28'] != null) bolum28 = Bolum28Model.fromMap(s['bolum28']);
    if (s['bolum29'] != null) bolum29 = Bolum29Model.fromMap(s['bolum29']);
    if (s['bolum30'] != null) bolum30 = Bolum30Model.fromMap(s['bolum30']);
    if (s['bolum31'] != null) bolum31 = Bolum31Model.fromMap(s['bolum31']);
    if (s['bolum32'] != null) bolum32 = Bolum32Model.fromMap(s['bolum32']);
    if (s['bolum33'] != null) bolum33 = Bolum33Model.fromMap(s['bolum33']);
    if (s['bolum34'] != null) bolum34 = Bolum34Model.fromMap(s['bolum34']);
    if (s['bolum35'] != null) bolum35 = Bolum35Model.fromMap(s['bolum35']);
    if (s['bolum36'] != null) bolum36 = Bolum36Model.fromMap(s['bolum36']);
  }

  void createNewBuilding(String name) {
    reset();
    currentBinaId = DateTime.now().millisecondsSinceEpoch.toString();
    currentBinaName = name;
    saveToDisk();
  }

  void clearAfter(int sectionNumber) {
    if (sectionNumber <= 3) { bolum4 = null; bolum5 = null; bolum14 = null; bolum33 = null; }
    if (sectionNumber <= 6) { bolum10 = null; bolum13 = null; bolum34 = null; }
    saveToDisk();
  }

  ChoiceResult? getResultForSection(int id) {
    switch (id) {
      case 1: return bolum1?.secim;
      case 2: return bolum2?.secim;
      case 3: return ChoiceResult(label: "3", uiTitle: "Kat Sayısı", uiSubtitle: "H_Bina: ${bolum3?.hBina}m", reportText: "");
      case 4: return bolum4?.binaYukseklikSinifi;
      case 5: return ChoiceResult(label: "5", uiTitle: "Alan Bilgisi", uiSubtitle: "${bolum5?.toplamInsaatAlani} m²", reportText: "");
      case 6: return ChoiceResult(label: "6", uiTitle: "Riskli Alanlar", uiSubtitle: "Tespit Yapıldı", reportText: "");
      case 7: return ChoiceResult(label: "7", uiTitle: "Teknik Hacimler", uiSubtitle: "Beyan Edildi", reportText: "");
      case 8: return bolum8?.secim;
      case 9: return bolum9?.secim;
      case 10: return bolum10?.secim;
      case 11: return bolum11?.mesafe;
      case 12: return bolum12?.secim;
      case 13: return bolum13?.otoparkKapi; // İlk dolu olanı döndürür
      case 14: return bolum14?.secim;
      case 15: return bolum15?.kaplama;
      case 16: return bolum16?.secim;
      case 17: return bolum17?.kaplama;
      case 18: return bolum18?.secim;
      case 19: return bolum19?.levha;
      case 20: return ChoiceResult(label: "20", uiTitle: "Merdiven Tipleri", uiSubtitle: "Sayısal Tespit", reportText: "");
      case 21: return bolum21?.secim;
      case 22: return bolum22?.secim;
      case 23: return bolum23?.secim;
      case 24: return bolum24?.secim;
      case 25: return bolum25?.kapasite;
      case 26: return bolum26?.secim;
      case 27: return bolum27?.boyut;
      case 28: return bolum28?.mesafe;
      case 29: return bolum29?.otopark;
      case 30: return bolum30?.konum;
      case 31: return bolum31?.yapi;
      case 32: return bolum32?.yapi;
      case 33: return bolum33?.zeminKatSonuc;
      case 34: return bolum34?.zemin;
      case 35: return bolum35?.tekYon ?? bolum35?.ciftYon;
      case 36: return bolum36?.gorunurluk;
      default: return null;
    }
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
  void loadBuildingFromArchive(String id) {
    final data = archive.firstWhere((e) => e['id'] == id, orElse: () => {});
    if (data.isNotEmpty) {
      reset(); // Mevcut modelleri temizle
      _loadBuildingFromMap(data); // Arşivdeki veriyi modellere doldur
      saveToDisk(); // Bu binayı "aktif" bina olarak kaydet
    }
  }

  void deleteFromArchive(String id) {
    archive.removeWhere((element) => element['id'] == id);
    if (currentBinaId == id) reset();
    saveToDisk();
  }
}