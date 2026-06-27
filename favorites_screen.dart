import 'package:flutter/material.dart';
import 'package:asmart_chef/theme/app_theme.dart';
import 'package:asmart_chef/services/favorites_service.dart';
import 'package:asmart_chef/models/recipe_model.dart';

class FavoritesScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final FavoritesService favoritesService;

  const FavoritesScreen({
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
        final lista = favoritesService.favoriti;

        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          appBar: AppBar(
            title: const Text('Moji favoriti'),
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              if (lista.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Obriši sve favorite',
                  onPressed: () async {
                    final potvrda = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Obriši sve favorite'),
                        content: const Text(
                            'Jeste li sigurni da želite obrisati sve spremljene recepte?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Odustani'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text(
                              'Obriši',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (potvrda == true) {
                      for (final r in List.from(lista)) {
                        await favoritesService.ukloniFavorit(r);
                      }
                    }
                  },
                ),
            ],
          ),
          body: lista.isEmpty
              ? _PrazanPopis(color: color)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Spremljeni recepti (${lista.length}):',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: lista.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _FavoritKartica(
                            recept: lista[index],
                            color: color,
                            favoritesService: favoritesService,
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _PrazanPopis extends StatelessWidget {
  final Color color;

  const _PrazanPopis({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: color.withOpacity(0.35),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nema spremljenih recepata',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Pretražite recepte u sekciji "Unesi namirnice" i pritisnite srce za spremanje.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritKartica extends StatelessWidget {
  final Recipe recept;
  final Color color;
  final FavoritesService favoritesService;

  const _FavoritKartica({
    required this.recept,
    required this.color,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(Icons.restaurant, color: color),
        ),
        title: Text(
          recept.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text('Za ${recept.servings} osoba'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              tooltip: 'Ukloni iz favorita',
              onPressed: () async {
                await favoritesService.ukloniFavorit(recept);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '"${recept.title}" uklonjen iz favorita.'),
                      backgroundColor: Colors.grey.shade700,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text(
                  'Sastojci:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  recept.ingredients,
                  style:
                      const TextStyle(fontSize: 13, height: 1.5),
                ),
                if (recept.instructions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Upute za pripremu:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recept.instructions,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
