import '../screens/bolum_1_screen.dart';
import '../screens/bolum_2_screen.dart';
import '../screens/bolum_3_screen.dart';
import '../screens/bolum_4_screen.dart';
import '../screens/bolum_5_screen.dart';
import '../screens/bolum_6_screen.dart';
import '../screens/bolum_7_screen.dart';
import '../screens/bolum_8_screen.dart';
import '../screens/bolum_9_screen.dart';
import '../screens/bolum_10_screen.dart';
import '../screens/bolum_11_screen.dart';
import '../screens/bolum_12_screen.dart';
import '../screens/bolum_13_screen.dart';
import '../screens/bolum_14_screen.dart';
import '../screens/bolum_15_screen.dart';
import '../screens/bolum_16_screen.dart';
import '../screens/bolum_17_screen.dart';
import '../screens/bolum_18_screen.dart';
import '../screens/bolum_19_screen.dart';
import '../screens/bolum_20_screen.dart';
import '../screens/bolum_21_screen.dart';
import '../screens/bolum_22_screen.dart';
import '../screens/bolum_23_screen.dart';
import '../screens/bolum_24_screen.dart';
import '../screens/bolum_25_screen.dart';
import '../screens/bolum_26_screen.dart';
import '../screens/bolum_27_screen.dart';
import '../screens/bolum_28_screen.dart';
import '../screens/bolum_29_screen.dart';
import '../screens/bolum_30_screen.dart';
import '../screens/bolum_31_screen.dart';
import '../screens/bolum_32_screen.dart';
import '../screens/bolum_33_screen.dart';
import '../screens/bolum_34_screen.dart';
import '../screens/bolum_35_screen.dart';
import '../screens/bolum_36_screen.dart';
import '../logic/report_engine.dart';
import '../data/bina_store.dart';

class ProgressResult {
  final int percentage;
  final String stepString;
  ProgressResult(this.percentage, this.stepString);
}

class AppProgress {
  static final List<Type> _order = [
    Bolum1Screen,
    Bolum2Screen,
    Bolum3Screen,
    Bolum4Screen,
    Bolum5Screen,
    Bolum6Screen,
    Bolum7Screen,
    Bolum8Screen,
    Bolum9Screen,
    Bolum10Screen,
    Bolum11Screen,
    Bolum12Screen,
    Bolum13Screen,
    Bolum14Screen,
    Bolum15Screen,
    Bolum16Screen,
    Bolum17Screen,
    Bolum18Screen,
    Bolum19Screen,
    Bolum20Screen,
    Bolum21Screen,
    Bolum22Screen,
    Bolum23Screen,
    Bolum24Screen,
    Bolum25Screen,
    Bolum26Screen,
    Bolum27Screen,
    Bolum28Screen,
    Bolum29Screen,
    Bolum30Screen,
    Bolum31Screen,
    Bolum32Screen,
    Bolum33Screen,
    Bolum34Screen,
    Bolum35Screen,
    Bolum36Screen,
  ];

  static int currentStep(Type screenType) => _order.indexOf(screenType) + 1;
  static int get totalSteps => _order.length;

  static bool isEndOfModule(int sectionId) {
    return [10, 15, 20, 25, 30, 36].contains(sectionId);
  }

  static bool isSectionActive(int i, BinaStore store) {
    if (i == 22 || i == 23) return store.bolum7?.hasAsansor != false;
    if (i == 25) return (store.bolum20?.donerMerdivenSayisi ?? 0) > 0;
    if (i == 30) return store.bolum7?.hasKazan != false;
    if (i == 31) return store.bolum7?.hasTrafo != false;
    if (i == 32) return store.bolum7?.hasJenerator != false;
    if (i == 34) return store.bolum6?.hasTicari != false;
    return true;
  }

  static ProgressResult getAnalysisProgress(BinaStore store,
      [Type? currentScreen]) {
    int totalActive = 0;
    int filledActive = 0;

    for (int i = 1; i <= 36; i++) {
      if (isSectionActive(i, store)) {
        totalActive++;
        if (store.getResultForSection(i) != null) {
          filledActive++;
        }
      }
    }

    int percentage =
        totalActive == 0
            ? 0
            : (filledActive / totalActive * 100).toInt().clamp(0, 100);

    // Special case: if Section 36 is filled, it's 100%
    if (store.bolum36 != null) percentage = 100;

    String stepStr = "";
    if (currentScreen != null) {
      int rawStep = currentStep(currentScreen);
      stepStr = "Bölüm $rawStep";
    }

    return ProgressResult(percentage, stepStr);
  }

  static ReportModule getModuleForSection(int sectionId) {
    if (sectionId <= 10) return ReportModule.binaBilgileri;
    if (sectionId <= 15) return ReportModule.modul1;
    if (sectionId <= 20) return ReportModule.modul2;
    if (sectionId <= 25) return ReportModule.modul3;
    if (sectionId <= 30) return ReportModule.modul4;
    return ReportModule.modul5;
  }
}
