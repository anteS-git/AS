import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asmart_chef/models/recipe_model.dart';

class FavoritesService extends ChangeNotifier {
  static const String _kljuc = 'favoriti_recepti';

  final List<Recipe> _favoriti = [];
  bool _ucitan = false;

  List<Recipe> get favoriti => List.unmodifiable(_favoriti);
  bool get ucitan => _ucitan;

  Future<void> ucitaj() async {
    if (_ucitan) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kljuc);
    if (raw != null) {
      final List<dynamic> lista = json.decode(raw);
      _favoriti.clear();
      _favoriti.addAll(lista.map((e) => Recipe.fromJson(e as Map<String, dynamic>)));
    }
    _ucitan = true;
    notifyListeners();
  }

  bool jeFavorit(Recipe recept) {
    return _favoriti.any((f) => f.uniqueKey == recept.uniqueKey);
  }

  Future<void> dodajFavorit(Recipe recept) async {
    if (jeFavorit(recept)) return;
    _favoriti.add(recept);
    await _spremi();
    notifyListeners();
  }

  Future<void> ukloniFavorit(Recipe recept) async {
    _favoriti.removeWhere((f) => f.uniqueKey == recept.uniqueKey);
    await _spremi();
    notifyListeners();
  }

  Future<void> preklopi(Recipe recept) async {
    if (jeFavorit(recept)) {
      await ukloniFavorit(recept);
    } else {
      await dodajFavorit(recept);
    }
  }

  Future<void> _spremi() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_favoriti.map((r) => r.toJson()).toList());
    await prefs.setString(_kljuc, encoded);
  }
}
