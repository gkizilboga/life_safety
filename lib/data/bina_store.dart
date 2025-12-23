import 'dart:convert';
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

  int get normalKatSayisi => bolum3?.normalKatSayisi ?? 0;
  int get bodrumKatSayisi => bolum3?.bodrumKatSayisi ?? 0;
  String? get otoparkStatus => bolum6?.otoparkStatus;

  Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'bolum3': bolum3?.toMap(),
      'bolum5': bolum5?.toMap(),
      // Diğer bölümler için de toMap/fromMap eklenecek
    };
    await prefs.setString('bina_data', json.encode(data));
    print("Veriler Diske Kaydedildi");
  }

  Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString('bina_data');
    if (rawData != null) {
      final data = json.decode(rawData);
      if (data['bolum3'] != null) bolum3 = Bolum3Model.fromMap(data['bolum3']);
      print("Veriler Diskten Yüklendi");
    }
  }

  void reset() {
    bolum1 = null; bolum2 = null; bolum3 = null; bolum4 = null;
    bolum5 = null; bolum6 = null; bolum7 = null; bolum8 = null;
    bolum9 = null; bolum10 = null; bolum11 = null; bolum12 = null;
    bolum13 = null;
    bolum14 = null;
    bolum15 = null;
    bolum16 = null;
    bolum17 = null;
    bolum18 = null;
    bolum19 = null;
    bolum20 = null;
    bolum21 = null;
    bolum22 = null;
    bolum23 = null;
    bolum24 = null; 
    bolum25 = null; 
    bolum26 = null; 
    bolum27 = null; 
    bolum28 = null; 
    bolum29 = null; 
    bolum30 = null; 
    bolum31 = null; 
    bolum32 = null; 
    bolum33 = null; 
    bolum34 = null; 
    bolum35 = null; 
    bolum36 = null; 
   

  }
}