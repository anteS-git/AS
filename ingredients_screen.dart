import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:asmart_chef/theme/app_theme.dart';
import 'package:asmart_chef/services/favorites_service.dart';
import 'package:asmart_chef/models/recipe_model.dart';

class IngredientsScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final FavoritesService favoritesService;

  const IngredientsScreen({
    super.key,
    required this.themeNotifier,
    required this.favoritesService,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _namirnice = [];
  List<Recipe> _recepti = [];
  bool _ucitavanje = false;
  String? _greska;

  static const String _apiKey = 'H9x9fkJ4XEkTsFt8JNOGyA6XEP2vh0hBbOhPTn5y';
  static const String _apiUrl = 'https://api.api-ninjas.com/v1/recipe?query=';

  void _dodajNamjrnicu() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _namirnice.add(text);
      _controller.clear();
    });
  }

  void _ukloniNamjrnicu(int index) {
    setState(() {
      _namirnice.removeAt(index);
    });
  }

  Future<void> _traziRecepte() async {
    if (_namirnice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Molimo dodajte barem jednu namirnicu.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _ucitavanje = true;
      _greska = null;
      _recepti = [];
    });

    try {
      final query = _namirnice.join(' ');
      final uri = Uri.parse('$_apiUrl${Uri.encodeComponent(query)}');
      final response = await http.get(
        uri,
        headers: {'X-Api-Key': _apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _recepti = data.map((e) => Recipe.fromJson(e)).toList();
          if (_recepti.isEmpty) {
            _greska = 'Nema pronađenih recepata za zadane namirnice.';
          }
        });
      } else {
        setState(() {
          _greska =
              'Greška pri dohvaćanju recepata (${response.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        _greska = 'Mrežna greška. Provjerite internetsku vezu.';
      });
    } finally {
      setState(() {
        _ucitavanje = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(
          [widget.themeNotifier, widget.favoritesService]),
      builder: (context, _) {
        final color = widget.themeNotifier.buttonColor;
        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          appBar: AppBar(
            title: const Text('Unesi namirnice'),
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _dodajNamjrnicu(),
                        decoration: InputDecoration(
                          hintText: 'Npr. piletina, rajčica, luk...',
                          labelText: 'Dodaj namirnicu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: color, width: 2),
                          ),
                          prefixIcon: const Icon(Icons.food_bank_outlined),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _dodajNamjrnicu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_namirnice.isNotEmpty) ...[
                  const Text(
                    'Moje namirnice:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _namirnice.asMap().entries.map((entry) {
                      return Chip(
                        label: Text(entry.value),
                        backgroundColor: color.withOpacity(0.15),
                        deleteIconColor: color,
                        onDeleted: () => _ukloniNamjrnicu(entry.key),
                        labelStyle: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _ucitavanje ? null : _traziRecepte,
                    icon: _ucitavanje
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(_ucitavanje
                        ? 'Pretraživanje...'
                        : 'Pronađi recepte'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_greska != null)
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Colors.orange, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          _greska!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                if (_recepti.isNotEmpty) ...[
                  Text(
                    'Pronađeni recepti (${_recepti.length}):',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _recepti.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _ReceptKartica(
                          recept: _recepti[index],
                          color: color,
                          favoritesService: widget.favoritesService,
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReceptKartica extends StatelessWidget {
  final Recipe recept;
  final Color color;
  final FavoritesService favoritesService;

  const _ReceptKartica({
    required this.recept,
    required this.color,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    final jeFavorit = favoritesService.jeFavorit(recept);

    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
              icon: Icon(
                jeFavorit ? Icons.favorite : Icons.favorite_border,
                color: jeFavorit ? Colors.red : Colors.grey,
              ),
              tooltip: jeFavorit ? 'Ukloni iz favorita' : 'Spremi u favorite',
              onPressed: () async {
                await favoritesService.preklopi(recept);
                if (context.mounted) {
                  final poruka = favoritesService.jeFavorit(recept)
                      ? '"${recept.title}" spremljen u favorite!'
                      : '"${recept.title}" uklonjen iz favorita.';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(poruka),
                      backgroundColor: favoritesService.jeFavorit(recept)
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
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
                  style: const TextStyle(fontSize: 13, height: 1.5),
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
