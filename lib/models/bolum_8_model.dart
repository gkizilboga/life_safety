import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum8Model {
  final ChoiceResult? secim;

  Bolum8Model({this.secim});

  Bolum8Model copyWith({ChoiceResult? secim}) {
    return Bolum8Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim_label': secim?.label};
  }

  factory Bolum8Model.fromMap(Map<String, dynamic> map) {
    final label = map['secim_label'];
    if (label == Bolum8Content.ayrikNizam.label) return Bolum8Model(secim: Bolum8Content.ayrikNizam);
    if (label == Bolum8Content.bitisikNizam.label) return Bolum8Model(secim: Bolum8Content.bitisikNizam);
    return Bolum8Model();
  }
}