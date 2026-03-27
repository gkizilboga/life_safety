import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/handlers/section_36_handler.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';

void main() {
  final store = BinaStore.instance;
  store.bolum20 = Bolum20Model();
  store.bolum36 = Bolum36Model();
  final h = Section36Handler(store);
  
  try {
    print('Summary...');
    h.getSummaryReport();
    print('Summary OK');
  } catch (e, st) {
    print('Summary Crash: $e\n$st');
  }

  try {
    print('Detailed...');
    h.getDetailedReport();
    print('Detailed OK');
  } catch (e, st) {
    print('Detailed Crash: $e\n$st');
  }
}
