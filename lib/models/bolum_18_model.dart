import 'package:life_safety/models/bolum_13_model.dart';

class Bolum18Model {
  ChoiceResult? resDuvarKaplama;
  ChoiceResult? resTesisatBoru;

  Bolum18Model({
    this.resDuvarKaplama,
    this.resTesisatBoru,
  });

  Bolum18Model copyWith({
    ChoiceResult? resDuvarKaplama,
    ChoiceResult? resTesisatBoru,
  }) {
    return Bolum18Model(
      resDuvarKaplama: resDuvarKaplama ?? this.resDuvarKaplama,
      resTesisatBoru: resTesisatBoru ?? this.resTesisatBoru,
    );
  }
}