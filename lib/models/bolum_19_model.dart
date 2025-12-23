import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum19Model {
  final List<ChoiceResult> resKacisEngeller; // Çoklu Seçim
  final ChoiceResult? resYonlendirme;
  final ChoiceResult? resYanilticiKapi;
  final ChoiceResult? resKapiEtiket; // Alt Soru

  Bolum19Model({
    this.resKacisEngeller = const [],
    this.resYonlendirme,
    this.resYanilticiKapi,
    this.resKapiEtiket,
  });

  Bolum19Model copyWith({
    List<ChoiceResult>? resKacisEngeller,
    ChoiceResult? resYonlendirme,
    ChoiceResult? resYanilticiKapi,
    ChoiceResult? resKapiEtiket,
  }) {
    return Bolum19Model(
      resKacisEngeller: resKacisEngeller ?? this.resKacisEngeller,
      resYonlendirme: resYonlendirme ?? this.resYonlendirme,
      resYanilticiKapi: resYanilticiKapi ?? this.resYanilticiKapi,
      resKapiEtiket: resKapiEtiket ?? this.resKapiEtiket,
    );
  }
}