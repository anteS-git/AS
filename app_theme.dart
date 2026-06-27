import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  Color _buttonColor = const Color(0xFF6A1B9A);
  String? _backgroundImage;

  Color get buttonColor => _buttonColor;
  String? get backgroundImage => _backgroundImage;

  void setButtonColor(Color color) {
    _buttonColor = color;
    notifyListeners();
  }

  void setBackgroundImage(String? path) {
    _backgroundImage = path;
    notifyListeners();
  }

  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _buttonColor,
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
}
