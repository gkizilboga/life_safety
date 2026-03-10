import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_19_model.dart';
import 'package:life_safety/utils/app_progress.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  test('Test AppProgress with bolum 19', () {
    BinaStore.instance.reset(); // Clear state
    BinaStore.instance.bolum19 = Bolum19Model(
      engeller: [Bolum19Content.engelOptionA],
      levha: Bolum19Content.levhaOptionA,
      yanilticiKapi: Bolum19Content.yanilticiOptionA,
    );
    
    try {
      final progress = AppProgress.getAnalysisProgress(BinaStore.instance);
      print("Progress calculation successful: ${progress.percentage}%");
      
      // Also try saving to disk simulation
      final map = BinaStore.instance.bolum19!.toMap();
      print("To map works: $map");
    } catch(e) {
      print("Error: $e");
    }
  });
}
