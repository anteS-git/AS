import 'package:flutter/material.dart';
import 'package:asmart_chef/theme/app_theme.dart';
import 'package:asmart_chef/services/favorites_service.dart';
import 'package:asmart_chef/screens/ingredients_screen.dart';
import 'package:asmart_chef/screens/recipe_screen.dart';
import 'package:asmart_chef/screens/admin_screen.dart';
import 'package:asmart_chef/screens/favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final FavoritesService favoritesService;

  const HomeScreen({
    super.key,
    required this.themeNotifier,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeNotifier, favoritesService]),
      builder: (context, _) {
        final color = themeNotifier.buttonColor;
        final brojFavorita = favoritesService.favoriti.length;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant_menu,
                    size: 80,
                    color: Color(0xFF6A1B9A),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ASmart Chef',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vaš pametni kuhar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 60),
                  _HomeButton(
                    label: 'Unesi namirnice',
                    icon: Icons.add_shopping_cart,
                    color: color,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IngredientsScreen(
                          themeNotifier: themeNotifier,
                          favoritesService: favoritesService,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _HomeButton(
                    label: 'Predloži recept',
                    icon: Icons.menu_book,
                    color: color,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeScreen(themeNotifier: themeNotifier),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FavoritiBadgeButton(
                    label: 'Favoriti',
                    icon: Icons.favorite,
                    color: color,
                    badge: brojFavorita,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FavoritesScreen(
                          themeNotifier: themeNotifier,
                          favoritesService: favoritesService,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _HomeButton(
                    label: 'Admin',
                    icon: Icons.admin_panel_settings,
                    color: color,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AdminScreen(themeNotifier: themeNotifier),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _HomeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

class _FavoritiBadgeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int badge;
  final VoidCallback onPressed;

  const _FavoritiBadgeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.badge,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 280,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 24),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 4,
              ),
            ),
          ),
          if (badge > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                ),
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
