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

class AppProgress {
  // Uygulamanın tam akış sırası burasıdır.
  // Araya yeni bir sayfa eklersen sadece buraya eklemen yeterli.
  static final List<Type> _order = [
    Bolum1Screen, Bolum2Screen, Bolum3Screen, Bolum4Screen, Bolum5Screen,
    Bolum6Screen, Bolum7Screen, Bolum8Screen, Bolum9Screen, Bolum10Screen,
    Bolum11Screen, Bolum12Screen, Bolum13Screen, Bolum14Screen, Bolum15Screen,
    Bolum16Screen, Bolum17Screen, Bolum18Screen, Bolum19Screen, Bolum20Screen,
    Bolum21Screen, Bolum22Screen, Bolum23Screen, Bolum24Screen, Bolum25Screen,
    Bolum26Screen, Bolum27Screen, Bolum28Screen, Bolum29Screen, Bolum30Screen,
    Bolum31Screen, Bolum32Screen, Bolum33Screen, Bolum34Screen, Bolum35Screen,
    Bolum36Screen,
  ];

static int currentStep(Type screenType) => _order.indexOf(screenType) + 1;  static int get totalSteps => _order.length;
}