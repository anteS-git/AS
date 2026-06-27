import 'package:flutter/material.dart';
import 'package:asmart_chef/theme/app_theme.dart';
import 'package:asmart_chef/models/recipe_model.dart';

class RecipeScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  const RecipeScreen({super.key, required this.themeNotifier});

  static const List<Map<String, String>> _dorucak = [
    {'naziv': 'Kajgana s povrćem', 'opis': 'Lagana kajgana s paprikom, rajčicom i svježim začinima.'},
    {'naziv': 'Zobene pahuljice s bananom', 'opis': 'Kremaste zobene pahuljice kuhane u mlijeku s kriškama banane i medom.'},
    {'naziv': 'Tost s avokadom i jajetom', 'opis': 'Hrskavi tost prekriven kremastim avokadom i poširenim jajetom.'},
    {'naziv': 'Palačinke s džemom', 'opis': 'Tanke palačinke punjene šumskim voćem i šlagom.'},
    {'naziv': 'Jogurt s granolom', 'opis': 'Svježi jogurt posut hrskavom granolom i svježim voćem.'},
    {'naziv': 'Omlet sa sirom', 'opis': 'Pjenušavi omlet punjen topljenim sirom i začinskim biljem.'},
    {'naziv': 'Smoothie zdjela', 'opis': 'Glatki smoothie od jagoda i banane ukrašen sjemenkama i kokosom.'},
  ];

  static const List<Map<String, String>> _rucak = [
    {'naziv': 'Pileća juha s rezancima', 'opis': 'Bogata domaća pileća juha s domaćim rezancima i povrćem.'},
    {'naziv': 'Punjene paprike', 'opis': 'Sočne paprike punjene mljevenim mesom i rižom u gustom umaku od rajčice.'},
    {'naziv': 'Riba na žaru s blitvom', 'opis': 'Svježa riba pečena na žaru servirana s blitivom i krumpirom.'},
    {'naziv': 'Goveđi gulaš', 'opis': 'Tradicionalni gulaš od goveđeg mesa s krumpirom i paprom.'},
    {'naziv': 'Pašticada', 'opis': 'Dalmatinska pašticada - govedina marinirana u vinu sa šljivama.'},
    {'naziv': 'Špinat lazanje', 'opis': 'Kremaste lazanje s bešamel umakom, špinatom i sirom.'},
    {'naziv': 'Rižoto od gljiva', 'opis': 'Kremasti rižoto s miješanim gljivama i parmezanom.'},
  ];

  static const List<Map<String, String>> _vecera = [
    {'naziv': 'Salata s tunom', 'opis': 'Svježa miješana salata s tunom, maslinama i kaprama.'},
    {'naziv': 'Pileće grudi s povrćem', 'opis': 'Pečene pileće grudi s pečenim mediteranskim povrćem.'},
    {'naziv': 'Tjestenina s umakom od rajčice', 'opis': 'Al dente tjestenina u domaćem umaku od rajčice s bosiljkom.'},
    {'naziv': 'Kremasta juha od bundeve', 'opis': 'Topla kremasta juha od bundeve s đumbirom i kremom.'},
    {'naziv': 'Šaran na rašljama', 'opis': 'Svježi šaran pečen na otvorenoj vatri s lukom i paprom.'},
    {'naziv': 'Tofuov wok', 'opis': 'Prženi tofu s povrćem, sojinim umakom i rižom.'},
    {'naziv': 'Brokula s češnjakom', 'opis': 'Lagano pirjana brokula s češnjakom, maslinovim uljem i limunom.'},
  ];

  List<DailyMeal> _getDnevniObroci() {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final di = seed % _dorucak.length;
    final ri = (seed * 3 + 7) % _rucak.length;
    final vi = (seed * 5 + 13) % _vecera.length;

    return [
      DailyMeal(
        naziv: _dorucak[di]['naziv']!,
        opis: _dorucak[di]['opis']!,
        kategorija: 'Doručak',
      ),
      DailyMeal(
        naziv: _rucak[ri]['naziv']!,
        opis: _rucak[ri]['opis']!,
        kategorija: 'Ručak',
      ),
      DailyMeal(
        naziv: _vecera[vi]['naziv']!,
        opis: _vecera[vi]['opis']!,
        kategorija: 'Večera',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final obroci = _getDnevniObroci();
    final now = DateTime.now();
    final datumString =
        '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}.';

    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          appBar: AppBar(
            title: const Text('Prijedlog recepta'),
            backgroundColor: themeNotifier.buttonColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: themeNotifier.buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: themeNotifier.buttonColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: themeNotifier.buttonColor),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dnevni jelovnik',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            datumString,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: obroci.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final obrok = obroci[index];
                      final icons = [
                        Icons.wb_sunny_outlined,
                        Icons.lunch_dining,
                        Icons.nights_stay_outlined,
                      ];
                      return _ObrokKartica(
                        obrok: obrok,
                        icon: icons[index],
                        color: themeNotifier.buttonColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ObrokKartica extends StatelessWidget {
  final DailyMeal obrok;
  final IconData icon;
  final Color color;

  const _ObrokKartica({
    required this.obrok,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obrok.kategorija,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    obrok.naziv,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    obrok.opis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
