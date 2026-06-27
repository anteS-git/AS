import 'package:flutter/material.dart';
import 'package:asmart_chef/theme/app_theme.dart';
import 'package:asmart_chef/services/favorites_service.dart';
import 'package:asmart_chef/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KuharskiAsistentApp());
}

class KuharskiAsistentApp extends StatefulWidget {
  const KuharskiAsistentApp({super.key});

  @override
  State<KuharskiAsistentApp> createState() => _KuharskiAsistentAppState();
}

class _KuharskiAsistentAppState extends State<KuharskiAsistentApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier();
  final FavoritesService _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _favoritesService.ucitaj();
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    _favoritesService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'ASmart Chef',
          debugShowCheckedModeBanner: false,
          theme: _themeNotifier.themeData,
          locale: const Locale('hr', 'HR'),
          home: HomeScreen(
            themeNotifier: _themeNotifier,
            favoritesService: _favoritesService,
          ),
        );
      },
    );
  }
}
