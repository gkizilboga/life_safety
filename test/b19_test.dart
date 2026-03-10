import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/models/bolum_19_model.dart';
import 'package:life_safety/utils/app_content.dart';
void main() {
  test('check toMap', () {
    final m = Bolum19Model(
      engeller: [Bolum19Content.engelOptionA], 
      levha: Bolum19Content.levhaOptionA, 
      yanilticiKapi: Bolum19Content.yanilticiOptionA
    );
    print(m.toMap());
  });
}
