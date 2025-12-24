import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum10Model {
  final ChoiceResult? secim;

  Bolum10Model({this.secim});

  Bolum10Model copyWith({ChoiceResult? secim}) {
    return Bolum10Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim_label': secim?.label};
  }

  factory Bolum10Model.fromMap(Map<String, dynamic> map) {
    final label = map['secim_label'];
    if (label == Bolum10Content.konut.label) return Bolum10Model(secim: Bolum10Content.konut);
    if (label == Bolum10Content.azYogunTicari.label) return Bolum10Model(secim: Bolum10Content.azYogunTicari);
    if (label == Bolum10Content.ortaYogunTicari.label) return Bolum10Model(secim: Bolum10Content.ortaYogunTicari);
    if (label == Bolum10Content.yuksekYogunTicari.label) return Bolum10Model(secim: Bolum10Content.yuksekYogunTicari);
    if (label == Bolum10Content.teknikDepo.label) return Bolum10Model(secim: Bolum10Content.teknikDepo);
    
    return Bolum10Model();
  }
}